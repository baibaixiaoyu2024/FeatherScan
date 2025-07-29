#!/bin/bash
# 精准漏洞数据库生成脚本
# 增强元数据提取和过滤

OUTPUT_FILE="feather_vuln_db.txt"
EXPLOIT_DIR="/usr/share/exploitdb/exploits/linux/local"
DB_PATH="/usr/share/exploitdb/files_exploits.csv"

# 检查必要文件
if [ ! -f "$DB_PATH" ]; then
    echo "错误: exploit数据库文件不存在 $DB_PATH"
    exit 1
fi

# 清空旧文件
> "$OUTPUT_FILE"

# 处理CSV文件
tail -n +2 "$DB_PATH" | while IFS=, read -r id file_path description date author type platform port; do
    # 只处理Linux本地提权漏洞
    if [[ "$file_path" == *"/linux/local/"* ]]; then
        # 提取文件名
        filename=$(basename "$file_path")
        
        # 提取CVE编号
        cve=$(echo "$description" | grep -io 'CVE-[0-9]\+-[0-9]\+' | head -1)
        
        # 分类漏洞类型（更精确）
        vuln_type="other"
        
        # 内核漏洞检测
        if [[ "$description" =~ [Kk]ernel|[Ll]inux ]] && 
           [[ "$description" =~ [Pp]rivilege|[Ee]scalation|[Ee]xploit ]]; then
            vuln_type="kernel"
        # 容器漏洞检测
        elif [[ "$description" =~ [Cc]ontainer|[Dd]ocker|[Kk]ubernetes ]] && 
             [[ "$description" =~ [Ee]scape ]]; then
            vuln_type="container"
        # 服务漏洞检测
        elif [[ "$description" =~ [Ss]ervice|[Aa]pplication|[Pp]rotocol|[Dd]aemon ]] && 
             [[ "$description" =~ [Pp]rivilege|[Ee]scalation ]]; then
            vuln_type="service"
        fi
        
        # 提取影响版本
        kernel_range=""
        if [[ "$vuln_type" == "kernel" ]]; then
            # 尝试提取版本范围
            if [[ "$description" =~ [0-9]+\.[0-9]+\.[0-9]+\ to\ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
                kernel_range="${BASH_REMATCH[0]}"
            elif [[ "$description" =~ [0-9]+\.[0-9]+\.[0-9]+\ through\ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
                kernel_range="${BASH_REMATCH[0]}"
            elif [[ "$description" =~ [Uu]p\ to\ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
                kernel_range="${BASH_REMATCH[0]}"
            elif [[ "$description" =~ [Bb]efore\ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
                kernel_range="up to ${BASH_REMATCH[1]}"
            elif [[ "$description" =~ [0-9]+\.[0-9]+\.[0-9]+ ]]; then
                kernel_range="${BASH_REMATCH[0]}"
            fi
        fi
        
        # 过滤低质量漏洞条目
        if [[ "$description" =~ [Gg]ame|[Tt]oy|[Ee]xample|[Tt]est|[Dd]emo ]] || 
           [[ "$file_path" =~ /test/|/demo/|/poc/ ]]; then
            continue
        fi
        
        # 清理描述
        clean_desc=$(echo "$description" | tr '|' ' ' | tr -d '\n' | sed 's/\s\+/ /g')
        
        # 写入数据库
        echo "$vuln_type|$cve|$id|$date|$author|$kernel_range|$file_type|$clean_desc|$filename" \
            >> "$OUTPUT_FILE"
    fi
done

# 排序并去重
sort -u -t'|' -k3n "$OUTPUT_FILE" > "${OUTPUT_FILE}.tmp"
mv "${OUTPUT_FILE}.tmp" "$OUTPUT_FILE"

echo -e "\n\033[32m漏洞数据库生成完成!\033[0m"
echo -e "输出文件: \033[34m$OUTPUT_FILE\033[0m"
echo -e "包含漏洞: \033[33m$(wc -l < "$OUTPUT_FILE")\033[0m"
