工具详细介绍：https://longyusec.com/longyushoulu/450/

[FeatherScan v4.0 – 适用于Linux的全自动内网信息收集工具-泷羽Sec](https://longyusec.com/longyushoulu/450/)

## 文件介绍

pass.txt ：用于爆破的密码字典，比如横向移动的mysql，ssh密码爆破
user.txt : 爆破时候用的用户字典，脚本中也有默认的账号密码弱口令进行爆破
feather_vuln_db.txt : linux提权exploit-db漏洞库，需要同FeatherScan一起上传到靶机

generate_vuln_db.sh : 在kali上执行，这是一个筛选脚本，用于获取最新的linux提权explod-db漏洞库，kali中更新本地漏洞库使用命令 searchsploit -u ，再执行这个脚本，会生成一个txt漏洞库，也就是 feather_vuln_db.txt

靶机：
wget http://ip:port/FeatherScan_v4_5
wget http://ip:port/feather_vuln_db.txt
chmod +x FeatherScan_v4_5
./FeatherScan_v4_5

执行示例：、
┌──(root㉿kali)-[/data/FeatherScan/FeatherScan_v4_5_]
└─# ./FeatherScan_v4_5

     ███████╗███████╗ █████╗ ████████╗██╗  ██╗███████╗██████╗
     ██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗
     █████╗  █████╗  ███████║   ██║   ███████║█████╗  ██████╔╝
     ██╔══╝  ██╔══╝  ██╔══██║   ██║   ██╔══██║██╔══╝  ██╔══██╗
     ██║     ███████╗██║  ██║   ██║   ██║  ██║███████╗██║  ██║
     ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
    
      高级Linux特权提升扫描工具
      泷羽Sec官网：https://longyusec.com | 作者：白小羽 | v：baibaixiaoyu2024 | v4.5


                  只要还有明天，今天就永远是起跑点，所以不要害怕从零开始！
    
    =================================================== 工具描述 =================================================
    1、linux内网信息收集，全面收集操作系统/内核版本、环境变量、用户信息等关键数据
    2、检测敏感文件权限、容器环境、服务配置等安全风险点,分析历史命令、环境变量、SSH配置等潜在攻击向量
    3、智能主机发现（ARP/Ping/TCP混合扫描）,多协议服务爆破（SSH/MySQL/SMB等）,网络路由分析、DNS配置检测和代理设置审查
    4、SUID/SGID文件扫描与危险程序识别,内核漏洞数据库匹配（脏牛、脏管道等）,Sudo规则审计与配置弱点分析
    5、Docker逃逸路径检测和容器安全评估,隐身扫描模式（避免触发IDS）,自动化痕迹清除机制,敏感信息掩码保护

$
    =================================================== 免责条款 =================================================
  1、在使用本工具之前，请确保您拥有对该机器的测试权限，不得非法入侵除您本人以外的，以及未授权的系统进行扫描或攻击等恶意行为。对于因非法使用本工具而产生的一切法律责任，由用户自行承担，泷羽 Sec 安全团队概不负责。
  2、用户不得对本工具进行反编译、逆向工程、修改源代码、解密等任何试图破解或篡改本工具的行为。
  3、如果需要商业版（源码版），请联系泷羽Sec安全团队的白小羽进行授权，v：baibaixiaoyu2024
  4、本工具创建的初衷就是方便干网安的师傅们学习交流使用，再次强调还请不要进行非法用途，谢谢您————此致，敬礼
    [?] 是否接受本协议?[Y/n]
y
[-] 您已接受该协议！程序即将开始运行。。
[-] 系统信息
[+] 当前用户: root
[+] 主机名: kali
[+] 操作系统: Kali GNU/Linux Rolling
[+] 内核版本: 6.12.25-amd64
[+] 扫描开始时间: Mon Jul 28 04:02:23 AM EDT 2025

[?] 是否执行深入检查?
  普通检查: 快速检测常见提权向量 (SUID, 可写文件, 内核漏洞等)
  深入检查: 包括普通检查 + 服务爆破 + 敏感文件深度扫描 [y/N]
^C                                                                                                                      

## 前言

这是不是最新版！！！！最新版请加入泷羽Sec Freebuf帮会【泷羽Sec资料库】获取。官网 http://longyusec.com

在平时渗透打靶的时候，经常要自己手工输入命令，做各种基本的信息收集，非常的繁琐，所以自研了一款工具，这款工具没有接入AI，因为不合适，接入了AI的话在**一些不能上网的环境下进行信息收集，权限提升的分析，会非常的不方便，这款工具全都在目标机器本地执行（执行速度快，提高渗透测试效率）**，类似于fscan，需要上传到目标靶机上，后期会增加离线的POC和漏洞库对linux系统进行全面的信息收集，和特权提升检测，获取方式见文末

PS：如果有提权需要可以将这些收集到的信息，全部复制给AI分析就可以了，比如`Venice Uncensored`

另外这个工具采用**并行**的执行方式，**而不是同步执行**，这样的话会显著提升脚本的执行速度，不然光一个IP内网扫描，你都够吃一顿肯德基了

没有完美的工具，人也是，不可能做到人人都喜欢，不喜欢或者觉得垃圾，勿喷，您完全有使用别的工具的权力，比如开源的`LinPEAS`、`LinEnum`、`Bashark`等等，但都是英文的，有些师傅们可能看不懂，我也看不懂，可能是我没有文化吧，要手动去翻译很麻烦，而我这个是专为国人打造的linux自动化内网信息收集工具。如果哪里有欠缺或者建议，欢迎师傅们批评和留言。

## 概述

**FeatherScan**是一款专为Linux系统设计的自动化内网渗透与特权提升扫描工具，由泷羽Sec作者**白小羽**开发。该工具旨在简化渗透测试过程中的内网信息收集和提权检测环节，通过自动化扫描显著减少手工操作时间，帮助安全研究人员高效识别系统弱点。

![image-20250710163527207](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101635292.png?imageSlim)

# V4.0

## 主要功能

### 1. 全面系统信息收集

操作系统与内核信息、用户与组权限分析、环境变量深度检查、网络配置与路由信息、敏感文件权限审计、容器环境检测、服务与进程分析等等

![image-20250710162748149](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101627256.png?imageSlim)

![image-20250710162806189](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101628267.png?imageSlim)

![image-20250710162834914](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101628991.png?imageSlim)

![image-20250710162858038](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101628109.png?imageSlim)

![image-20250710162912529](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101629609.png?imageSlim)

![image-20250710162924221](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101629298.png?imageSlim)

简单的内核提权漏洞检测（非常适合用来打靶机学习）

![image-20250710162957955](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101629037.png?imageSlim)

### 2. 内网渗透扫描

- **主机发现**：混合扫描技术**（ICMP Ping + ARP分析 + TCP端口扫描）**，三种网络模式扫描，不忽漏掉每一个内网机器
- **端口扫描**：支持常见服务端口识别
- **服务识别**：自动检测开放服务及版本信息
- **隐身模式**：慢速扫描避免触发IDS/IPS

![image-20250710163205090](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101632162.png?imageSlim)

常见的端口扫描

![image-20250710163305050](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101633122.png?imageSlim)

### 3. 横向移动检测

SSH密钥重用检测、密码爆破（SSH, MySQL, PostgreSQL, SMB等）、SMB共享匿名访问检测、数据库服务爆破等等。

![image-20250710164738762](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101647841.png?imageSlim)

### 4. 特权提升检测

SUID/SGID危险文件检测、sudo权限深度分析、可写路径检查、内核漏洞匹配（脏牛、脏管道等）、密码哈希分析、自动化漏洞利用（**不需要联网**）等等

![image-20250710174615940](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101746002.png?imageSlim)

![image-20250710174630892](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101746945.png?imageSlim)

![image-20250710163439150](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101634209.png?imageSlim)

![image-20250710163635220](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101636268.png?imageSlim)

![image-20250710163623363](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101636409.png?imageSlim)

![image-20250710163643921](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101636982.png?imageSlim)

![image-20250710163702389](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101637471.png?imageSlim)

![image-20250710163843070](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101638138.png?imageSlim)

### 5. 安全痕迹管理

自动备份/恢复修改文件、安全删除临时文件（7次覆盖）、命令历史清除、日志文件清理、内存缓存清除、本地爆破记录删除

![image-20250710163422379](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101634456.png?imageSlim)

![image-20250710164811268](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101648344.png?imageSlim)

## 技术特点

1. **智能交互式扫描**

   动态启用深度检查、按需开启内网渗透扫描、交互式服务爆破确认等等

2. **混合扫描技术**

   ICMP Ping扫描、ARP缓存分析、TCP端口扫描、服务指纹识别等等

3. **权限提升自动化**

   自动添加特权用户、sudo权限自动化配置、定时任务注入、内核漏洞EXP自动下载等等

4. **安全痕迹管理**

   操作全程跟踪记录、多轮覆盖安全删除、服务专用日志清除等等

## 使用示例

```bash
# 基础扫描
chmod +x FeatherScan
./FeatherScan

# 启用深度检查+内网扫描
[?] 是否执行深入检查? y
[?] 是否执行内网渗透扫描? y
[?] 是否启用隐身模式? n
```

## 输出示例

```
 ███████╗███████╗ █████╗ ████████╗██╗  ██╗███████╗██████╗
 ██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║  ██║██╔════╝██╔══██╗
 █████╗  █████╗  ███████║   ██║   ███████║█████╗  ██████╔╝
 ██╔══╝  ██╔══╝  ██╔══██║   ██║   ██╔══██║██╔══╝  ██╔══██╗
 ██║     ███████╗██║  ██║   ██║   ██║  ██║███████╗██║  ██║
 ╚═╝     ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝

        高级Linux特权提升扫描工具
      泷羽Sec安全团队 | 白小羽 | v4.0

=================================================== 工具描述 =================================================
1、linux内网信息收集，全面收集操作系统/内核版本、环境变量、用户信息等关键数据
2、检测敏感文件权限、容器环境、服务配置等安全风险点,分析历史命令、环境变量、SSH配置等潜在攻击向量
3、智能主机发现（ARP/Ping/TCP混合扫描）,多协议服务爆破（SSH/MySQL/SMB等）,网络路由分析、DNS配置检测和代理设置审查
4、SUID/SGID文件扫描与危险程序识别,内核漏洞数据库匹配（脏牛、脏管道等）,Sudo规则审计与配置弱点分析
5、Docker逃逸路径检测和容器安全评估,隐身扫描模式（避免触发IDS）,自动化痕迹清除机制,敏感信息掩码保护

[-] 系统信息
[+] 当前用户: root
[+] 主机名: kali
[+] 操作系统: Kali GNU/Linux Rolling
[+] 内核版本: 6.12.25-amd64
[+] 扫描开始时间: Thu Jul 10 05:42:16 AM EDT 2025

[?] 是否执行深入检查?
  普通检查: 快速检测常见提权向量 (SUID, 可写文件, 内核漏洞等)
  深入检查: 包括普通检查 + 服务爆破 + 敏感文件深度扫描 [y/N]
y
[+] 深入检查已启用

[?] 是否执行内网渗透扫描?
  内网扫描: 主机发现、端口扫描、横向移动检测 [y/N]
n

################ 完整系统信息 ################

[-] 系统信息:
主机名: kali
操作系统: Kali GNU/Linux Rolling
内核版本: 6.12.25-amd64
系统架构: x86_64
运行时间: up 3 days, 22 hours, 52 minutes

[-] 用户信息:
当前用户: root
用户ID: uid=0(root) gid=0(root) groups=0(root)
特权用户: root
test
featheruser
。。。。。。。。。。。。。。。。。。。。。。。
```

## 使用建议

1. **授权测试**：仅在获得明确授权的环境中使用
2. **深度扫描**：对关键系统启用深入检查模式
3. **痕迹管理**：扫描完成后使用内置清理功能
4. **字典定制**：根据目标环境定制pass.txt密码字典

# 2025.7.28 v4.5

继上一篇

本次也算是一个大更新

1、融入了`exploit-db`离线linux内核提权漏洞库，联动searchsploit工具，更方便的简化了渗透测试提权的过程

2、融入了`GTFOBins`常用提权命令共50+个，比如常见的`find，sh，pkexec，sudo，nmap，vim，less，tcpdump，docker，zip，tar`等等命令进行提权

3、新增了常见的`CMS`敏感配置文件扫描，比如django，wordpress，joomla等等，通常用来查看数据库的账号密码

4、新增敏感环境变量提权模块——PATH提权

5、新增相关的免责条款，若不接受，则不能使用该工具

下面来看看更新了哪些内容吧，首先是免责条款

![image-20250728142303250](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250728142303250.png?imageSlim)

## 新增GTFOBins 50+命令提权

新增内置 `GTFOBins` 提权数据库，`无需联网`，GTFOBins中的大部分提权方法皆可以利用！！并且满足一定的条件才会输出给你，比如suid，sudo，可读/可写等等，不满足任何一个条件，都不会告诉你利用方法（命令使用准确率还在优化）

![image-20250727012753547](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250727012753547.png?imageSlim)

新增提权总结，以及使用方法，和成功率告知

![image-20250727012737028](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250727012737028.png?imageSlim)

新增CMS常用配置文件检测

![image-20250727021721589](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250727021721589.png?imageSlim)

## 新增敏感环境变量提权—PATH提权

![image-20250727132436164](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250727132436164.png?imageSlim)

![image-20250727132517631](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250727132517631.png?imageSlim)

提权效果展示

![image-20250727132548129](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250727132548129.png?imageSlim)

以及path提权，也会将提权方法在程序结束前告知

![image-20250727132746737](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250727132746737.png?imageSlim)

## 新增exploit-db漏洞库

新增linux内核提权漏洞库（基于`searchsploit`），这里以`tr0ll`靶机为例子

首先我们需要在kali中创建自己的漏洞数据库（使用脚本的好处就是这个漏洞库 exploit-db 也就是searchsploit漏洞库是会更新的，使用命令`searchsploit -u`更新本地漏洞库），执行`generate_vuln_db.sh`会生成一个漏洞库的txt文件，主要是筛选linux提权的漏洞

![image-20250728130437969](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250728130437969.png?imageSlim)

将这个`txt文件`和`FeatherScan`同时上传到靶机上，使用FeatherScan就会利用内置强大的版本比较算法，进行检测，执行到最后

![image-20250728115951306](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250728115951306.png?imageSlim)

![image-20250728125853176](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250728125853176.png?imageSlim)

我们得知漏洞编号之后，在kali中就直接将使用`searchsploit -m [编号]`复制到当前目录，并使用python开启一个http服务

![image-20250728130008318](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250728130008318.png?imageSlim)

上床到靶机上提权成功！

![image-20250728125936835](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250728125936835.png?imageSlim)

## 其他细节优化

更新了，系统存在bash -p命令提权，但是不出现提权信息问题（因为SUID和SGID同时存在，所以不能使用=4来进行判断）

```python
# 靶机
-bash-5.0$ ls /usr/bin/bash -l
-rwsr-sr-x 1 root root 1183448 Feb 25  2020 /usr/bin/bash

-bash-5.0$ stat -c '%a' "/usr/bin/bash" | cut -c 1
6
```

修改后的执行结果

![3e12917fbcad5443afefb09c2ecab42f](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/3e12917fbcad5443afefb09c2ecab42f.png?imageSlim)

新增手动选择是否尝试进行提权（文件可写的情况下），不然写入会导致一些问题

![image-20250726220108012](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/image-20250726220108012.png?imageSlim)

工具获取加入泷羽Sec帮会即可（长期更新中。。。）单独购买不方便获取最新版本，优惠最后两天，错过只能等国庆节了。。。。

## 获取方式

加入泷羽Sec内部Freebuf帮会即可获取**最新版本**，往期版本会不定期在github上进行更新，在帮会主页中找到**帮会网盘**，即可下载工具啦，这工具没有那么高大上，只是简化了linux内网信息收集，端口扫描，内核漏洞利用，内网探测，痕迹清除等等，理性消费

![image-20250710193311400](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/202507101933487.png?imageSlim)

加入方式扫码即可

![下载](https://md-1312988675.cos.ap-nanjing.myqcloud.com/myImg/%25E4%25B8%258B%25E8%25BD%25BD.png?imageSlim)

更多福利点击查看

https://mp.weixin.qq.com/s/ROMh7U4xj9nXqlKzBFd2WA

> Tips：一天存10块，一个月就是3000，一年就是36w，十年就是3600w，3600w可以干什么？
>
> 上海一套别墅，记得买个带**独立机房**的，防震防溯源！
>
> 一个稳定的家庭，给爸妈在老家盖栋最气派的养老别墅，请最好的管家和医护，医护团队人均 **CISSP+OSEP**，至少也是**OSCP**。
>
> 一台迈巴赫s680，车窗贴膜要用防弹级的，毕竟可能装满了 **0day漏洞报告**！
>
> **打工？还打什么工？老板？哪个老板？10年后你自己就是董事长！**
>
> 所以从现在开始养成一个好习惯，只要10年，从此只挖洞不上班，甲方需求全拉黑，开源项目随便PR！
>
> 看到这里，您觉得这79块钱还贵吗？不过只是您的冰山一角，少买一个吃灰的云服务器，也就您吃的一顿科技料理的外卖，够我吃10顿。
>
> 从现在开始投资自己吧。10年之后咱们顶峰相见、、、、、、
>
> 那时候如果您还觉得贵，请开着您的迈巴赫来嘲讽我这个弱智，我将毫无怨言

## 免责声明

FeatherScan仅限合法安全审计和授权渗透测试使用。使用者应遵守当地法律法规，未经授权使用本工具造成的任何后果由使用者自行承担。

文章首发于：`https://longyusec.com/longyushoulu/450/`

**泷羽Sec安全团队 | 白小羽 | 2025**

## 往期推荐

[Linux内网渗透（2w字超详细）](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247502052&idx=1&sn=a6741f6d10092d3c302a112cb71076b7&scene=21#wechat_redirect)

[AD域内网渗透-三种漏洞利用方式](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247501378&idx=1&sn=d13931a97f131dc1f6743fc16677ab65&scene=21#wechat_redirect)

[【oscp】vulnerable_docker，三种代理方法打入内网](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247498989&idx=1&sn=a860e19fe2d20c9b8aa5cc9ca81ac488&scene=21#wechat_redirect)

[【内网渗透】CobaltStrike与MSF联动互相上线的方式](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247492494&idx=1&sn=3683d677ce1917965f2ad0c4ab848b1d&scene=21#wechat_redirect)

[内网渗透必备，microsocks，一个轻量级的socks代理工具](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247502471&idx=1&sn=84c975ff8c1eaa18fd0f757ba1b3a6ab&scene=21#wechat_redirect)

[【OSCP】 Kioptrix 提权靶机（1-5）全系列教程，Try Harder！绝对干货！](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247496963&idx=1&sn=646e34d7b03cef9741616ea8d7e20968&scene=21#wechat_redirect)

[DC-2综合渗透，rbash逃逸，git提权，wordpress靶场渗透教程](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247489570&idx=1&sn=cb60c97e91776c610be8ee662fb77f21&scene=21#wechat_redirect)

[【渗透测试】12种rbash逃逸方式总结](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247489669&idx=1&sn=64e9bf9674fd0dbb24c16c8100bcebc8&scene=21#wechat_redirect)

[红日靶场5，windows内网渗透，社工提权，多种域内横向移动思路](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247500172&idx=1&sn=8efb51ecf7c5309bd02b784c856f7eda&scene=21#wechat_redirect)

[红日靶场3，joomla渗透，海德拉SMB爆破，域内5台主机横向移动教学](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247500474&idx=1&sn=a06c2d000f2c7d54f16bc551a318cb81&scene=21#wechat_redirect)

[不用MSF？红日靶场4，从外网到域控，手工干永恒之蓝，教科书级渗透教学](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247499647&idx=1&sn=8017ed5d8f1dff3bf0632e91e50a192f&scene=21#wechat_redirect)

[ATK&CK红日靶场二，Weblogic漏洞利用，域渗透攻略](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247495915&idx=1&sn=020b2f604f3c234afc5e660021041671&scene=21#wechat_redirect)

[sql注入中各种waf的绕过方式，狗，盾，神，锁，宝](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247491703&idx=1&sn=07b9a87e94a7ad944b0d1033b69b9177&scene=21#wechat_redirect)

[利用MySQL特性，WAF绕过技巧](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247492213&idx=1&sn=930589375081c5dc497f7c4c4be69b00&scene=21#wechat_redirect)

[SQL注入绕过某狗的waf防火墙，这一篇就够了，6k文案超详细](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247486904&idx=1&sn=554161761fc5d22791168b3da72f25f0&scene=21#wechat_redirect)

[大型翻车现场，十种waf绕过姿势，仅成功一种](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247487301&idx=1&sn=8a8d4cf3f1774112cb2eb1ec92e357b4&scene=21#wechat_redirect)

[喜欢长文吗？1w字图文带你了解sqlmap，从0到1，WAF绕过，高级用法一文通透](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247487170&idx=1&sn=d4d9809aa6219e700566776adc1dae3a&scene=21#wechat_redirect)

[一个永久的渗透知识库](https://mp.weixin.qq.com/s?__biz=Mzg2Nzk0NjA4Mg==&mid=2247502572&idx=1&sn=42a9853381a099fc7c074230c39824a3&scene=21#wechat_redirect)



