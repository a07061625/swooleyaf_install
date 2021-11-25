#!/bin/echo
set -o nounset

function yxpOpsPatrolInspectionPreHandle() {
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_UID=`id -u`
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_UID} -gt 0 ]; then
        echo -e "\e[1;31m请用root用户执行此脚本\e[0m"
        exit 0
    fi

    # shellcheck disable=SC2086
    if [ ! -d ${YXP_COMMON_PATH_TEMP}/ops ]; then
        mkdir -p ${YXP_COMMON_PATH_TEMP}/ops
    fi

    #当前时间
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_DATETIME=""
    #主机名
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_HOSTNAME=""
    #发行版本
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_RELEASE=""
    #系统内核
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_KERNEL=""
    #语言/编码
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_LANG=""
    #最近启动时间
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_REBOOT_LAST=""
    #运行时间
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_UPTIME=""
    #SELinux
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_SELINUX=""
    #物理CPU个数
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_PHYSICAL_NUM=""
    #逻辑CPU个数
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_VIRT_NUM=""
    #CPU核心数
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_KERNEL_NUM=""
    #CPU型号
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_TYPE=""
    #CPU架构
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_ARCH=""
    #内存总容量
    YXP_OPS_PATROL_INSPECTION_REPORT_MEM_TOTAL=""
    #内存剩余容量
    YXP_OPS_PATROL_INSPECTION_REPORT_MEM_FREE=""
    #内存使用率
    YXP_OPS_PATROL_INSPECTION_REPORT_MEM_USED_PERCENT=""
    #硬盘总容量
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_TOTAL=""
    #硬盘剩余容量
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_FREE=""
    #硬盘使用率
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_USED_PERCENT=""
    #Inode总量
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_TOTAL=""
    #Inode剩余量
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_FREE=""
    #Inode使用率
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_USED_PERCENT=""
    #自启动服务数
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_INIT=""
    #运行中服务数
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_RUNNING=""
    #自启动程序数
    YXP_OPS_PATROL_INSPECTION_REPORT_PROGRAM_INIT=""
    #IP地址
    YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_IP=""
    #MAC地址
    YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_MAC=""
    #默认网关
    YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_GATEWAY=""
    #DNS
    YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_DNS=""
    #Socket-TCP监听总数
    YXP_OPS_PATROL_INSPECTION_REPORT_LISTEN_SOCKET_TCP=""
    #计划任务总数
    YXP_OPS_PATROL_INSPECTION_REPORT_CRON_NUM=""
    #僵尸进程数
    YXP_OPS_PATROL_INSPECTION_REPORT_PROCESS_DEFUNCT=""
    #用户总数
    YXP_OPS_PATROL_INSPECTION_REPORT_USER_NUM=""
    #空密码用户
    YXP_OPS_PATROL_INSPECTION_REPORT_USER_EMPTY_PWD=""
    #相同ID用户
    YXP_OPS_PATROL_INSPECTION_REPORT_USER_SAME_UID=""
    #root用户
    YXP_OPS_PATROL_INSPECTION_REPORT_USER_ROOT=""
    #密码过期
    YXP_OPS_PATROL_INSPECTION_REPORT_PASSWORD_EXPIRE=""
    #sudo授权用户数
    YXP_OPS_PATROL_INSPECTION_REPORT_SUDOERS_NUM=""
    #JDK版本
    YXP_OPS_PATROL_INSPECTION_REPORT_JDK_VERSION=""
    #防火墙状态
    YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS=""
    #系统日志状态
    YXP_OPS_PATROL_INSPECTION_REPORT_SYSLOG_STATUS=""
    #网络管理状态
    YXP_OPS_PATROL_INSPECTION_REPORT_SNMP_STATUS=""
    #时钟同步状态
    YXP_OPS_PATROL_INSPECTION_REPORT_NTP_STATUS=""
    #SSH状态
    YXP_OPS_PATROL_INSPECTION_REPORT_SSH_STATUS=""
    #SSH协议版本
    YXP_OPS_PATROL_INSPECTION_REPORT_SSH_PROTOCOL_VERSION=""
    #SSH允许ROOT远程登录
    YXP_OPS_PATROL_INSPECTION_REPORT_SSH_ROOT_LOGIN=""
    #SSH信任主机数
    YXP_OPS_PATROL_INSPECTION_REPORT_SSH_AUTHORIZE_HOST=""
}

function yxpOpsPatrolInspectionServiceStatus(){
    YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_TAG=${1:-''}
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_OS_VERSION_NUM} -lt 7 ]; then
        if [ -e "/etc/init.d/${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_TAG}" ]; then
            # shellcheck disable=SC2126
            # shellcheck disable=SC2006
            YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_RUNNING_NUM=`/etc/init.d/${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_TAG} status 2>/dev/null | awk '{print $0;}' | grep -E "is running|正在运行" | wc -l`
            if [ ${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_RUNNING_NUM} -ge 1 ]; then
                YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME="active"
            else
                YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME="inactive"
            fi
        else
            YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME="unknown"
        fi
    else
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME=`systemctl is-active ${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_TAG} 2>&1 | awk '{print $0;}'`
    fi
}

function yxpOpsPatrolInspectionParams() {
    YXP_OPS_PATROL_INSPECTION_SERVER_IP=""

    # shellcheck disable=SC2068
    for param in ${YXP_COMMON_CLI_PARAMS[@]} ; do
        # shellcheck disable=SC2086
        yxpCommonParseCliParam ${param}
        if [ ${#YXP_COMMON_CLI_PARAM_VALUE} -eq 0 ]; then
            continue
        fi
        if [ "${YXP_COMMON_CLI_PARAM_KEY}" == "-server_ip" ]; then
            YXP_OPS_PATROL_INSPECTION_SERVER_IP="${YXP_COMMON_CLI_PARAM_VALUE}"
        fi
    done

    if [ "${YXP_OPS_PATROL_INSPECTION_SERVER_IP}aaa" == "aaa" ]; then
        echo -e "\e[1;31m服务器IP不能为空\e[0m"
        exit 0
    fi

    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_SERVER_IP_TAG=`echo ".${YXP_OPS_PATROL_INSPECTION_SERVER_IP}" | grep -E "^(\.[0-9]+){4}$" | awk '{print $0;}'`
    if [ "${YXP_OPS_PATROL_INSPECTION_SERVER_IP_TAG}aaa" == "aaa" ]; then
        echo -e "\e[1;31m服务器IP不合法\e[0m"
        exit 0
    fi

    # shellcheck disable=SC2021
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_OS_TYPE=`cat /etc/redhat-release | awk '{print $1;}' | tr '[A-Z]' '[a-z]'`
    if [ "${YXP_OPS_PATROL_INSPECTION_OS_TYPE}" != "centos" ]; then
        echo -e "\e[1;31m操作系统类型不支持\e[0m"
        exit 0
    fi

    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_OS_VERSION_NUM=`cat /etc/redhat-release | awk '{print $(NF-1);}' | awk -F"." '{print $1;}'`
}

function yxpOpsPatrolInspectionCheckServer(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始系统检查] \e[0m"
    if [ -e /etc/sysconfig/i18n ]; then
        # shellcheck disable=SC2006
        # shellcheck disable=SC2002
        YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_LANG=`cat /etc/sysconfig/i18n | grep "LANG=" | grep -v "^#" | awk -F'"' '{print $2}'`
    else
        YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_LANG=${LANG}
    fi
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_RELEASE=`cat /etc/redhat-release 2>/dev/null`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_KERNEL=`uname -r`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_HOSTNAME=`uname -n`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_SELINUX=`/usr/sbin/sestatus | grep "SELinux status: " | awk '{print $3;}'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_REBOOT_LAST=`who -b | awk '{print $3,$4;}'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_UPTIME=`uptime | sed 's/.*up \([^,]*\), .*/\1/'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_DATETIME=`date +"%F %T"`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_SERVER_OS=`uname -o`
    echo -e "\e[1;36m系统: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_SERVER_OS} \e[0m"
    echo -e "\e[1;36m发行版本: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_RELEASE} \e[0m"
    echo -e "\e[1;36m系统内核: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_KERNEL} \e[0m"
    echo -e "\e[1;36m主机名: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_HOSTNAME} \e[0m"
    echo -e "\e[1;36mSELinux: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_SELINUX} \e[0m"
    echo -e "\e[1;36m语言/编码: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_LANG} \e[0m"
    echo -e "\e[1;36m当前时间: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_DATETIME} \e[0m"
    echo -e "\e[1;36m最近启动时间: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_REBOOT_LAST} \e[0m"
    echo -e "\e[1;36m运行时间: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_UPTIME} \e[0m"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成系统检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckCpu(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始CPU检查] \e[0m"
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_PHYSICAL_NUM=`cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l`
    # shellcheck disable=SC2126
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_VIRT_NUM=`cat /proc/cpuinfo | grep "processor" | wc -l`
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_KERNEL_NUM=`cat /proc/cpuinfo | grep "cores" | uniq | awk -F": " '{print $2}'`
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_TYPE=`cat /proc/cpuinfo | grep "model name" | awk -F": " '{print $2}' | sort | uniq`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_CPU_ARCH=`uname -m`
    echo -e "\e[1;36m物理CPU个数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_PHYSICAL_NUM} \e[0m"
    echo -e "\e[1;36m逻辑CPU个数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_VIRT_NUM} \e[0m"
    echo -e "\e[1;36mCPU核心数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_KERNEL_NUM} \e[0m"
    echo -e "\e[1;36mCPU型号: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_TYPE} \e[0m"
    echo -e "\e[1;36mCPU架构: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_ARCH} \e[0m"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成CPU检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckMem(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始内存检查] \e[0m"
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_OS_VERSION_NUM} -lt 7 ]; then
        free -mo > /dev/null
    else
        free -h > /dev/null
    fi

    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_MEM_TOTAL=`cat /proc/meminfo | grep "MemTotal" | awk '{print $2;}'`
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_MEM_FREE=`cat /proc/meminfo | grep "MemFree" | awk '{print $2;}'`
    YXP_OPS_PATROL_INSPECTION_REPORT_MEM_TOTAL="$((YXP_OPS_PATROL_INSPECTION_MEM_TOTAL/1024))MB"
    YXP_OPS_PATROL_INSPECTION_REPORT_MEM_FREE="$((YXP_OPS_PATROL_INSPECTION_MEM_FREE/1024))MB"
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_MEM_TOTAL} -eq 0 ]; then
        YXP_OPS_PATROL_INSPECTION_REPORT_MEM_USED_PERCENT="100"
    else
        # shellcheck disable=SC2219
        let YXP_OPS_PATROL_INSPECTION_CHECK_MEM_USED=YXP_OPS_PATROL_INSPECTION_MEM_TOTAL-YXP_OPS_PATROL_INSPECTION_MEM_FREE
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_REPORT_MEM_USED_PERCENT=`echo "${YXP_OPS_PATROL_INSPECTION_MEM_TOTAL} ${YXP_OPS_PATROL_INSPECTION_CHECK_MEM_USED}" | awk '{printf "%.2f",$2*100/$1;}'`
    fi
    echo -e "\e[1;36m内存总容量: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_TOTAL} \e[0m"
    echo -e "\e[1;36m内存剩余容量: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_FREE} \e[0m"
    echo -e "\e[1;36m内存使用率: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_USED_PERCENT}% \e[0m"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成内存检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckDisk(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始磁盘检查] \e[0m"
    df -hiP | sed 's/Mounted on/Mounted/' > /tmp/inode
    df -hTP | sed 's/Mounted on/Mounted/' > /tmp/disk
    join /tmp/disk /tmp/inode | awk '{print $1,$2,"|",$3,$4,$5,$6,"|",$8,$9,$10,$11,"|",$12}'| column -t > /dev/null
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_DISK_DATA=`df -TP | sed '1d' | awk '$2!="tmpfs"{print $0;}'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_DISK_TOTAL=`echo "${YXP_OPS_PATROL_INSPECTION_DISK_DATA}" | awk '{total+=$3}END{print total;}'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_DISK_USED=`echo "${YXP_OPS_PATROL_INSPECTION_DISK_DATA}" | awk '{total+=$4}END{print total;}'`
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_DISK_TOTAL} -eq 0 ]; then
        YXP_OPS_PATROL_INSPECTION_REPORT_DISK_USED_PERCENT="100"
    else
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_REPORT_DISK_USED_PERCENT=`echo "${YXP_OPS_PATROL_INSPECTION_DISK_TOTAL} ${YXP_OPS_PATROL_INSPECTION_DISK_USED}" | awk '{printf "%.2f",$2*100/$1;}'`
    fi
    # shellcheck disable=SC2219
    let YXP_OPS_PATROL_INSPECTION_CHECK_DISK_FREE=YXP_OPS_PATROL_INSPECTION_DISK_TOTAL-YXP_OPS_PATROL_INSPECTION_DISK_USED
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_TOTAL="$((YXP_OPS_PATROL_INSPECTION_DISK_TOTAL/1024/1024))GB"
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_FREE="$((YXP_OPS_PATROL_INSPECTION_CHECK_DISK_FREE/1024/1024))GB"
    echo -e "\e[1;36m硬盘总容量: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_TOTAL} \e[0m"
    echo -e "\e[1;36m硬盘剩余容量: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_FREE} \e[0m"
    echo -e "\e[1;36m硬盘使用率: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_USED_PERCENT}% \e[0m"

    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_DISK_INODE_DATA=`df -iTP | sed '1d' | awk '$2!="tmpfs"{print;}'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_DISK_INODE_TOTAL=`echo "${YXP_OPS_PATROL_INSPECTION_DISK_INODE_DATA}" | awk '{total+=$3}END{print total;}'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_DISK_INODE_USED=`echo "${YXP_OPS_PATROL_INSPECTION_DISK_INODE_DATA}" | awk '{total+=$4}END{print total;}'`
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_DISK_INODE_TOTAL} -eq 0 ]; then
        YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_USED_PERCENT="100"
    else
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_USED_PERCENT=`echo "${YXP_OPS_PATROL_INSPECTION_DISK_INODE_TOTAL} ${YXP_OPS_PATROL_INSPECTION_DISK_INODE_USED}" | awk '{printf "%.2f",$2*100/$1;}'`
    fi
    # shellcheck disable=SC2219
    let YXP_OPS_PATROL_INSPECTION_CHECK_DISK_INODE_FREE=YXP_OPS_PATROL_INSPECTION_DISK_INODE_TOTAL-YXP_OPS_PATROL_INSPECTION_DISK_INODE_USED
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_TOTAL="$((YXP_OPS_PATROL_INSPECTION_DISK_INODE_TOTAL/1000))K"
    YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_FREE="$((YXP_OPS_PATROL_INSPECTION_CHECK_DISK_INODE_FREE/1000))K"
    echo -e "\e[1;36mInode总量: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_TOTAL} \e[0m"
    echo -e "\e[1;36mInode剩余量: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_FREE} \e[0m"
    echo -e "\e[1;36mInode使用率: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_USED_PERCENT}% \e[0m"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成磁盘检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckService(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始服务检查] \e[0m"
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_OS_VERSION_NUM} -ge 7 ]; then
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_SERVICE_INIT=`systemctl list-unit-files --type=service --state=enabled --no-pager | grep "enabled"`
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_SERVICE_RUNNING=`systemctl list-units --type=service --state=running --no-pager | grep ".service"`
    else
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_SERVICE_INIT=`/sbin/chkconfig | grep -E ":on|:启用"`
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_SERVICE_RUNNING=`/sbin/service --status-all 2>/dev/null | grep -E "is running|正在运行"`
    fi
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_INIT=`echo "${YXP_OPS_PATROL_INSPECTION_SERVICE_INIT}" | wc -l`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_RUNNING=`echo "${YXP_OPS_PATROL_INSPECTION_SERVICE_RUNNING}" | wc -l`
    echo -e "\e[1;36m自启动服务数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_INIT} \e[0m"
    echo -e "\e[1;36m自启动服务: \e[0m"
    echo "${YXP_OPS_PATROL_INSPECTION_SERVICE_INIT}" | column -t
    echo -e "\e[1;36m运行中服务数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_RUNNING} \e[0m"
    echo -e "\e[1;36m运行中服务: \e[0m"
    echo "${YXP_OPS_PATROL_INSPECTION_SERVICE_RUNNING}"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成服务检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckProgram(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始程序检查] \e[0m"
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_PROGRAM_INIT=`cat /etc/rc.d/rc.local | grep -v "^#" | awk '{print $0;}' | sed '/^$/d'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_PROGRAM_INIT=`echo "${YXP_OPS_PATROL_INSPECTION_PROGRAM_INIT}" | wc -l`
    echo -e "\e[1;36m自启动程序数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_PROGRAM_INIT} \e[0m"
    echo -e "\e[1;36m自启动程序: \e[0m"
    echo "${YXP_OPS_PATROL_INSPECTION_PROGRAM_INIT}"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成程序检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckLogin(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始登录检查] \e[0m"
    last | head
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成登录检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckNetwork(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始网络检查] \e[0m"
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_OS_VERSION_NUM} -lt 7 ]; then
        /sbin/ifconfig -a | grep -v "packets" | grep -v "collisions" | grep -v "inet6" | awk '{print $0;}'
    else
        echo -e "\e[1;36m网卡: \e[0m"
        for linkName in $(ip link | grep "BROADCAST" | awk -F":" '{print $2;}'); do
            ip add show ${linkName} | grep -E "BROADCAST|global"| awk '{print $2;}' | tr '\n' ' '
        done
        echo ""
    fi
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_GATEWAY=`ip route | grep "default" | awk '{print $3;}'`
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_DNS=`cat /etc/resolv.conf | grep "nameserver"| grep -v "#" | awk '{print $2;}' | tr '\n' ',' | sed 's/,$//'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_IP=`ip -f inet addr | grep -v "127.0.0.1" | grep "inet" | awk '{print $NF,$2;}' | tr '\n' ',' | sed 's/,$//'`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_MAC=`ip link | grep -v "LOOPBACK\|loopback" | awk '{print $2;}' | sed 'N;s/\:\n/ /' | tr '\n' ',' | sed 's/,$//'`
    echo -e "\e[1;36m默认网关: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_GATEWAY} \e[0m"
    echo -e "\e[1;36mDNS: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_DNS} \e[0m"
    echo -e "\e[1;36mIP地址: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_IP} \e[0m"
    echo -e "\e[1;36mMAC地址: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_MAC} \e[0m"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成网络检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckListen(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始监听检查] \e[0m"
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_LISTEN_SOCKET=`ss -ntul | column -t`
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_LISTEN_SOCKET_TCP=`echo "${YXP_OPS_PATROL_INSPECTION_LISTEN_SOCKET}" | sed '1d' | awk '/tcp/ {print $5;}' | awk -F: '{print $NF;}' | sort | uniq | wc -l`
    echo -e "\e[1;36mSocket-TCP监听总数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_LISTEN_SOCKET_TCP} \e[0m"
    echo -e "\e[1;36mSocket监听: \e[0m"
    echo "${YXP_OPS_PATROL_INSPECTION_LISTEN_SOCKET}"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成监听检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckCron(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始计划任务检查] \e[0m"
    YXP_OPS_PATROL_INSPECTION_REPORT_CRON_NUM=0
    # shellcheck disable=SC2013
    # shellcheck disable=SC2002
    for shellName in $(cat /etc/shells | grep -v "/sbin/nologin" | awk '{print $0;}'); do
        # shellcheck disable=SC2086
        # shellcheck disable=SC2013
        for userName in $(cat /etc/passwd | grep "${shellName}" | awk -F":" '{print $1;}'); do
            # shellcheck disable=SC2006
            YXP_OPS_PATROL_INSPECTION_CRON_USER_NUM=`crontab -l -u ${userName} 2>/dev/null | awk '{print $0;}' | wc -l`
            if [ ${YXP_OPS_PATROL_INSPECTION_CRON_USER_NUM} -eq 0 ]; then
                continue
            fi
            echo -e "\e[1;36m用户-${userName}计划任务数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_CRON_USER_NUM} \e[0m"
            echo -e "\e[1;36m用户-${userName}计划任务: \e[0m"
            crontab -l -u ${userName}
            # shellcheck disable=SC2219
            let YXP_OPS_PATROL_INSPECTION_REPORT_CRON_NUM=YXP_OPS_PATROL_INSPECTION_REPORT_CRON_NUM+YXP_OPS_PATROL_INSPECTION_CRON_USER_NUM
            echo ""
        done
    done
    echo -e "\e[1;36m计划任务总数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_CRON_NUM} \e[0m"
    echo -e "\e[1;36m周期计划任务文件: \e[0m"
    # shellcheck disable=SC2038
    find /etc/cron* -type f | xargs -i ls -l {} | column -t
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成计划任务检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckProcess(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始进程检查] \e[0m"
    # shellcheck disable=SC2126
    # shellcheck disable=SC2009
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_PROCESS_DEFUNCT=`ps -ef | grep "defunct" | grep -v "grep" | wc -l`
    echo -e "\e[1;36m僵尸进程数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_PROCESS_DEFUNCT} \e[0m"
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_REPORT_PROCESS_DEFUNCT} -ge 1 ]; then
        echo -e "\e[1;36m僵尸进程: \e[0m"
        ps -ef | head -n1
        # shellcheck disable=SC2009
        ps -ef | grep "defunct" | grep -v "grep"
    fi
    echo ""
    echo -e "\e[1;36m内存占用TOP10进程: \e[0m"
    echo -e " PID  %MEM RSS COMMAND"
    ps -eo pid,pmem,rss,cmd | sort -k3rn | head -n 10
    echo ""
    echo -e "\e[1;36mCPU占用TOP10进程: \e[0m"
    echo -e " PID  %CPU COMMAND"
    ps -eo pid,pcpu,cmd | sort -k2rn | head -n 10
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成进程检查] \e[0m"
}

function yxpOpsPatrolInspectionUserLoginLast(){
    YXP_OPS_PATROL_INSPECTION_USER_LOGIN_TIP=""
    YXP_OPS_PATROL_INSPECTION_USER_LOGIN_CURRENT=${1:-''}
    if [ "${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_CURRENT}aaa" == "aaa" ]; then
        return
    fi

    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_USER_LOGIN_YEAR_NOW=`date +%Y`
    # shellcheck disable=SC2086
    # shellcheck disable=SC2126
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_USER_LOGIN_TIMES=`last ${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_CURRENT} -t "${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_YEAR_NOW}1231000000" | grep "${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_CURRENT:0:8}" | wc -l`
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_TIMES} -eq 0 ]; then
        YXP_OPS_PATROL_INSPECTION_USER_LOGIN_TIP="今年从未登录过"
    else
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_USER_LOGIN_DATETIME=`last -i ${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_CURRENT} | head -n1 | awk '{for(i=4;i<(NF-2);i++){printf "%s ",$i;}}'`
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_USER_LOGIN_TIP=`date "+%Y/%m/%d-%H:%M:%S" -d "${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_DATETIME}${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_YEAR_NOW}"`
    fi
}

function yxpOpsPatrolInspectionCheckUser(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始用户检查] \e[0m"
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_USER_PASSWORD_MODIFY=`stat /etc/passwd | grep "Modify" | tr '.' ' ' | awk '{print $2,$3}'`
    # shellcheck disable=SC2086
    yxpCommonTimeAgo ${YXP_OPS_PATROL_INSPECTION_USER_PASSWORD_MODIFY}
    echo -e "\e[1;36m/etc/passwd最新修改时间: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_USER_PASSWORD_MODIFY}(${YXP_COMMON_TIME_AGO_DIFF_TIP}) \e[0m"

    YXP_OPS_PATROL_INSPECTION_USER_ROOT=""
    # shellcheck disable=SC2086
    # shellcheck disable=SC2013
    # shellcheck disable=SC2002
    for userName in $(cat /etc/passwd | awk -F":" '{print $1;}'); do
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_CHECK_USER_ID=`id -u ${userName}`
        if [ ${YXP_OPS_PATROL_INSPECTION_CHECK_USER_ID} -eq 0 ]; then
            YXP_OPS_PATROL_INSPECTION_USER_ROOT="${YXP_OPS_PATROL_INSPECTION_USER_ROOT},${userName}"
        fi
    done
    # shellcheck disable=SC2001
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_USER_ROOT=`echo "${YXP_OPS_PATROL_INSPECTION_USER_ROOT}" | sed 's/^,//'`
    echo -e "\e[1;36mroot用户: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_USER_ROOT} \e[0m"

    YXP_OPS_PATROL_INSPECTION_REPORT_USER_NUM=0
    YXP_OPS_PATROL_INSPECTION_USER_EMPTY_PWD=""
    YXP_OPS_PATROL_INSPECTION_USER_LIST_FILE=${YXP_COMMON_PATH_TEMP}/ops/patrol_inspection_user_list.txt
    # shellcheck disable=SC2086
    echo "用户名 UID GID HOME SHELL 最新登录时间" > ${YXP_OPS_PATROL_INSPECTION_USER_LIST_FILE}
    # shellcheck disable=SC2013
    # shellcheck disable=SC2002
    for shellName in $(cat /etc/shells | grep -v "/sbin/nologin" | awk '{print $0;}'); do
        # shellcheck disable=SC2086
        for userLine in $(cat /etc/passwd | grep "${shellName}" | awk '{print $0;}'); do
            # shellcheck disable=SC2004
            YXP_OPS_PATROL_INSPECTION_REPORT_USER_NUM=$((${YXP_OPS_PATROL_INSPECTION_REPORT_USER_NUM}+1))
            # shellcheck disable=SC2006
            YXP_OPS_PATROL_INSPECTION_USER_NAME=`echo "${userLine}" | awk -F":" '{print $1;}'`
            yxpOpsPatrolInspectionUserLoginLast ${YXP_OPS_PATROL_INSPECTION_USER_NAME}
            echo "${userLine}" | awk -F":" -v lastlogin="${YXP_OPS_PATROL_INSPECTION_USER_LOGIN_TIP}" '{print $1,$3,$4,$6,$7,lastlogin;}' >> ${YXP_OPS_PATROL_INSPECTION_USER_LIST_FILE}
            # shellcheck disable=SC2006
            YXP_OPS_PATROL_INSPECTION_USER_EMPTY_PWD=`cat /etc/shadow | awk -F":" '$2=="!!"{print $1;}' | grep -w "${YXP_OPS_PATROL_INSPECTION_USER_NAME}" | awk '{print $0;}'`
            if [ "${YXP_OPS_PATROL_INSPECTION_USER_EMPTY_PWD}aaa" != "aaa" ]; then
                YXP_OPS_PATROL_INSPECTION_USER_EMPTY_PWD="${YXP_OPS_PATROL_INSPECTION_USER_EMPTY_PWD},${YXP_OPS_PATROL_INSPECTION_USER_EMPTY_PWD}"
            fi
        done
    done
    echo -e "\e[1;36m用户总数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_USER_NUM} \e[0m"
    echo -e "\e[1;36m用户列表: \e[0m"
    # shellcheck disable=SC2086
    # shellcheck disable=SC2002
    cat ${YXP_OPS_PATROL_INSPECTION_USER_LIST_FILE} | column -t

    # shellcheck disable=SC2001
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_USER_EMPTY_PWD=`echo "${YXP_OPS_PATROL_INSPECTION_USER_EMPTY_PWD}" | sed 's/^,//'`
    echo -e "\e[1;36m空密码用户: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_USER_EMPTY_PWD} \e[0m"

    YXP_OPS_PATROL_INSPECTION_USER_SAME_UID=""
    # shellcheck disable=SC2002
    for sameUserId in $(cat /etc/passwd | awk -F":" '{print $3;}' | sort | uniq -c | awk '$1>1{print $2;}'); do
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_USER_SAME_UID=`cat /etc/passwd | awk -F":" '$3=='"${sameUserId}"'{print $1;}' | tr '\n' ','`
        YXP_OPS_PATROL_INSPECTION_USER_SAME_UID="${YXP_OPS_PATROL_INSPECTION_USER_SAME_UID}${sameUserId} ${YXP_OPS_PATROL_INSPECTION_USER_SAME_UID};"
    done
    # shellcheck disable=SC2001
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_USER_SAME_UID=`echo "${YXP_OPS_PATROL_INSPECTION_USER_SAME_UID}" | sed 's/\;$//'`
    echo -e "\e[1;36m相同ID用户: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_USER_SAME_UID} \e[0m"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成用户检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckPassword {
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始密码检查] \e[0m"
    YXP_OPS_PATROL_INSPECTION_PASSWORD_EXPIRE=""
    # shellcheck disable=SC2013
    # shellcheck disable=SC2002
    for shellName in $(cat /etc/shells | grep -v "/sbin/nologin" | awk '{print $0;}'); do
        # shellcheck disable=SC2086
        # shellcheck disable=SC2013
        # shellcheck disable=SC2002
        for userName in $(cat /etc/passwd | grep "${shellName}" | awk -F":" '{print $1;}'); do
            # shellcheck disable=SC2006
            YXP_OPS_PATROL_INSPECTION_PASSWORD_DAYS_EXPIRE=`/usr/bin/chage -l ${userName} | grep 'Password expires' | awk -F":" '{print $2;}' | awk '{gsub(/^\s+/, "");print $0;}'`
            if [ "${YXP_OPS_PATROL_INSPECTION_PASSWORD_DAYS_EXPIRE}" == "never" ]; then
                echo -e "\e[1;36m用户-${userName}: \e[0m \e[1;33m \t密码永不过期 \e[0m"
                YXP_OPS_PATROL_INSPECTION_PASSWORD_EXPIRE="${YXP_OPS_PATROL_INSPECTION_PASSWORD_EXPIRE},${userName}:never"
            else
                # shellcheck disable=SC2006
                YXP_OPS_PATROL_INSPECTION_PASSWORD_DATE_EXPIRE=`date -d "${YXP_OPS_PATROL_INSPECTION_PASSWORD_DAYS_EXPIRE}" "+%s"`
                # shellcheck disable=SC2006
                YXP_OPS_PATROL_INSPECTION_PASSWORD_DATE_CURRENT=`date "+%s"`
                # shellcheck disable=SC2004
                YXP_OPS_PATROL_INSPECTION_PASSWORD_DATE_DIFF=$((${YXP_OPS_PATROL_INSPECTION_PASSWORD_DATE_EXPIRE}-${YXP_OPS_PATROL_INSPECTION_PASSWORD_DATE_CURRENT}))
                # shellcheck disable=SC2004
                # shellcheck disable=SC2219
                let YXP_OPS_PATROL_INSPECTION_PASSWORD_DAYS_DIFF=$((${YXP_OPS_PATROL_INSPECTION_PASSWORD_DATE_DIFF}/(60*60*24)))
                echo -e "\e[1;36m用户-${userName}: \e[0m \e[1;33m \t密码${YXP_OPS_PATROL_INSPECTION_PASSWORD_DAYS_DIFF}天后过期 \e[0m"
                YXP_OPS_PATROL_INSPECTION_PASSWORD_EXPIRE="${YXP_OPS_PATROL_INSPECTION_PASSWORD_EXPIRE},${userName}:${YXP_OPS_PATROL_INSPECTION_PASSWORD_DAYS_DIFF} days"
            fi
        done
    done
    # shellcheck disable=SC2001
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_PASSWORD_EXPIRE=`echo "${YXP_OPS_PATROL_INSPECTION_PASSWORD_EXPIRE}" | sed 's/^,//'`
    echo -e "\e[1;36m密码过期: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_PASSWORD_EXPIRE} \e[0m"
    echo -e "\e[1;36m密码检查策略: \e[0m"
    # shellcheck disable=SC2002
    cat /etc/login.defs | grep -v "#" | grep -E "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE" | awk '{print $0;}'
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成密码检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckSudoers(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始Sudoers检查] \e[0m"
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_REPORT_SUDOERS_NUM=`cat /etc/sudoers | grep -v "^#" | grep -v "^Defaults" | grep -v "%" | sed '/^$/d' | wc -l`
    echo -e "\e[1;36msudo授权用户数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SUDOERS_NUM} \e[0m"
    echo -e "\e[1;36msudo授权用户: \e[0m"
    # shellcheck disable=SC2002
    cat /etc/sudoers | grep -v "^#" | grep -v "^Defaults" | grep -v "%" | sed '/^$/d' | column -t
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成Sudoers检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckJdk(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始JDK检查] \e[0m"
    # shellcheck disable=SC2006
    YXP_OPS_PATROL_INSPECTION_REPORT_JDK_VERSION=`java -version 2>&1 | awk '{print $0;}' | grep "version" | awk '{print $1,$3}' | tr -d '"'`
    if [ "${YXP_OPS_PATROL_INSPECTION_REPORT_JDK_VERSION}aaa" == "aaa" ]; then
        echo -e "\e[1;36mJDK版本: \e[0m \e[1;33m \t不存在 \e[0m"
    else
        echo -e "\e[1;36mJDK版本: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_JDK_VERSION} \e[0m"
    fi
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成JDK检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckInstalled(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始新装软件检查] \e[0m"
    rpm -qa --last | head | column -t
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成新装软件检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckFirewall(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始防火墙检查] \e[0m"
    # shellcheck disable=SC2086
    if [ ${YXP_OPS_PATROL_INSPECTION_OS_VERSION_NUM} -lt 7 ]; then
        /etc/init.d/iptables status >/dev/null 2>&1
        YXP_OPS_PATROL_INSPECTION_FIREWALL_STATUS=$?
        if [ ${YXP_OPS_PATROL_INSPECTION_FIREWALL_STATUS} -eq 0 ]; then
            YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS="active"
        elif [ ${YXP_OPS_PATROL_INSPECTION_FIREWALL_STATUS} -eq 3 ]; then
            YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS="inactive"
        elif [ ${YXP_OPS_PATROL_INSPECTION_FIREWALL_STATUS} -eq 4 ]; then
            YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS="permission denied"
        else
            YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS="unknown"
        fi
    else
        yxpOpsPatrolInspectionServiceStatus iptables
        YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS=${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME}
    fi
    echo -e "\e[1;36m防火墙状态: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS} \e[0m"
    if [ -f /etc/sysconfig/iptables ]; then
        echo -e "\e[1;36m防火墙策略: \e[0m"
        cat /etc/sysconfig/iptables 2>/dev/null
    fi
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成防火墙检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckSyslog(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始系统日志检查] \e[0m"
    yxpOpsPatrolInspectionServiceStatus rsyslog
    YXP_OPS_PATROL_INSPECTION_REPORT_SYSLOG_STATUS=${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME}
    echo -e "\e[1;36m系统日志状态: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SYSLOG_STATUS} \e[0m"
    echo -e "\e[1;36m系统日志配置: \e[0m"
    # shellcheck disable=SC2002
    cat /etc/rsyslog.conf 2>/dev/null | grep -v "^#" | grep -v "^\\$" | sed '/^$/d' | column -t
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成系统日志检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckSnmp(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始网络管理检查] \e[0m"
    yxpOpsPatrolInspectionServiceStatus snmpd
    YXP_OPS_PATROL_INSPECTION_REPORT_SNMP_STATUS=${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME}
    echo -e "\e[1;36m网络管理状态: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SNMP_STATUS} \e[0m"
    if [ -e /etc/snmp/snmpd.conf ]; then
        echo -e "\e[1;36m网络管理配置: \e[0m"
        # shellcheck disable=SC2002
        cat /etc/snmp/snmpd.conf 2>/dev/null | grep -v "^#" | sed '/^$/d' | sed 's/\s\s*/ /g'
    fi
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成网络管理检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckNtp(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始时钟同步检查] \e[0m"
    yxpOpsPatrolInspectionServiceStatus ntpd
    YXP_OPS_PATROL_INSPECTION_REPORT_NTP_STATUS=${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME}
    echo -e "\e[1;36m时钟同步状态: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_NTP_STATUS} \e[0m"
    if [ -e /etc/ntp.conf ]; then
        echo -e "\e[1;36m时钟同步配置: \e[0m"
        # shellcheck disable=SC2002
        cat /etc/ntp.conf 2>/dev/null | grep -v "^#" | sed '/^$/d' | sed 's/\s\s*/ /g'
    fi
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成时钟同步检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckSsh(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始SSH检查] \e[0m"
    yxpOpsPatrolInspectionServiceStatus sshd
    YXP_OPS_PATROL_INSPECTION_REPORT_SSH_STATUS=${YXP_OPS_PATROL_INSPECTION_SERVICE_STATUS_NAME}
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_REPORT_SSH_PROTOCOL_VERSION=`cat /etc/ssh/sshd_config | grep "Protocol" | awk '{print $2;}'`
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_PATROL_INSPECTION_SSH_ROOT_LOGIN=`cat /etc/ssh/sshd_config | grep "PermitRootLogin" | awk '{print $0;}'`
    if [ "${YXP_OPS_PATROL_INSPECTION_SSH_ROOT_LOGIN:0:1}" == "#" ]; then
        YXP_OPS_PATROL_INSPECTION_REPORT_SSH_ROOT_LOGIN="yes"
    else
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_REPORT_SSH_ROOT_LOGIN=`echo "${YXP_OPS_PATROL_INSPECTION_SSH_ROOT_LOGIN}" | awk '{print $2;}'`
    fi
    echo -e "\e[1;36mSSH状态: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_STATUS} \e[0m"
    echo -e "\e[1;36mSSH协议版本: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_PROTOCOL_VERSION} \e[0m"
    echo -e "\e[1;36mSSH允许ROOT远程登录: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_ROOT_LOGIN} \e[0m"
    echo -e "\e[1;36mSSH配置: \e[0m"
    # shellcheck disable=SC2002
    cat /etc/ssh/sshd_config | grep -v "^#" | sed '/^$/d' | sed 's/\s\s*/ /g'

    YXP_OPS_PATROL_INSPECTION_REPORT_SSH_AUTHORIZE_HOST=0
    echo -e "\e[1;36mSSH信任主机列表: \e[0m"
    # shellcheck disable=SC2086
    # shellcheck disable=SC2013
    # shellcheck disable=SC2002
    for userName in $(cat /etc/passwd | grep "/bin/bash" | awk -F":" '{print $1;}'); do
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_SSH_AUTHORIZE_FILE=`cat /etc/passwd | grep -w "${userName}" | awk -F":" '{printf $6"/.ssh/authorized_keys"}'`
        # shellcheck disable=SC2006
        # shellcheck disable=SC2002
        YXP_OPS_PATROL_INSPECTION_SSH_AUTHORIZE_HOST=`cat ${YXP_OPS_PATROL_INSPECTION_SSH_AUTHORIZE_FILE} 2>/dev/null | grep -v "^#" | sed '/^$/d' | awk '{print $3;}' | tr '\n' ',' | sed 's/[\,]*$//'`
        if [ "${YXP_OPS_PATROL_INSPECTION_SSH_AUTHORIZE_HOST}aaa" != "aaa" ]; then
            echo "${userName} 授权 ${YXP_OPS_PATROL_INSPECTION_SSH_AUTHORIZE_HOST} 无密码访问"
        fi
        # shellcheck disable=SC2006
        YXP_OPS_PATROL_INSPECTION_SSH_AUTHORIZE_HOST=`cat ${YXP_OPS_PATROL_INSPECTION_SSH_AUTHORIZE_FILE} 2>/dev/null | grep -v "^#" | sed '/^$/d' | awk '{print $3;}' | wc -l`
        # shellcheck disable=SC2004
        YXP_OPS_PATROL_INSPECTION_REPORT_SSH_AUTHORIZE_HOST=$((${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_AUTHORIZE_HOST}+${YXP_OPS_PATROL_INSPECTION_SSH_AUTHORIZE_HOST}))
    done
    echo -e "\e[1;36mSSH信任主机数: \e[0m \e[1;33m \t${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_AUTHORIZE_HOST} \e[0m"
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成SSH检查] \e[0m"
}

function yxpOpsPatrolInspectionCheckFile(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始文件检查] \e[0m"
    echo -e "\e[1;36m系统命令替换列表: \e[0m"
    # shellcheck disable=SC2012
    ls -alt /usr/bin | awk 'NF>9{print $0;}' | head -10
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成文件检查] \e[0m"
}

function yxpOpsPatrolInspectionReport(){
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;35m \t[开始检查结果上报] \e[0m"
    YXP_OPS_PATROL_INSPECTION_REPORT_FILE=${YXP_COMMON_PATH_TEMP}/ops/patrol_inspection_report.json
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT="-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}巡检结果:"
    # shellcheck disable=SC2086
    echo "{" > ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    # shellcheck disable=SC2086
    echo "  \"server_datetime\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_DATETIME}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  当前时间:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_DATETIME}"
    # shellcheck disable=SC2086
    echo "  \"server_hostname\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_HOSTNAME}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  主机名:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_HOSTNAME}"
    # shellcheck disable=SC2086
    echo "  \"server_os_release\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_RELEASE}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  发行版本:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_RELEASE}"
    # shellcheck disable=SC2086
    echo "  \"server_os_kernel\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_KERNEL}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  系统内核:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_OS_KERNEL}"
    # shellcheck disable=SC2086
    echo "  \"server_lang\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_LANG}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  语言/编码:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_LANG}"
    # shellcheck disable=SC2086
    echo "  \"server_reboot_last\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_REBOOT_LAST}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  最近启动时间:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_REBOOT_LAST}"
    # shellcheck disable=SC2086
    echo "  \"server_uptime\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_UPTIME}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  运行时间:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_UPTIME}"
    # shellcheck disable=SC2086
    echo "  \"server_selinux\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_SELINUX}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  SELinux:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVER_SELINUX}"
    # shellcheck disable=SC2086
    echo "  \"cpu_physical_num\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_PHYSICAL_NUM}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  物理CPU个数:${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_PHYSICAL_NUM}"
    # shellcheck disable=SC2086
    echo "  \"cpu_virt_num\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_VIRT_NUM}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  逻辑CPU个数:${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_VIRT_NUM}"
    # shellcheck disable=SC2086
    echo "  \"cpu_kernel_num\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_KERNEL_NUM}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  CPU核心数:${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_KERNEL_NUM}"
    # shellcheck disable=SC2086
    echo "  \"cpu_type\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_TYPE}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  CPU型号:${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_TYPE}"
    # shellcheck disable=SC2086
    echo "  \"cpu_arch\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_ARCH}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  CPU架构:${YXP_OPS_PATROL_INSPECTION_REPORT_CPU_ARCH}"
    # shellcheck disable=SC2086
    echo "  \"mem_total\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_TOTAL}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  内存总容量:${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_TOTAL}"
    # shellcheck disable=SC2086
    echo "  \"mem_free\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_FREE}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  内存剩余容量:${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_FREE}"
    # shellcheck disable=SC2086
    echo "  \"mem_used_percent\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_USED_PERCENT}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  内存使用率:${YXP_OPS_PATROL_INSPECTION_REPORT_MEM_USED_PERCENT}"
    # shellcheck disable=SC2086
    echo "  \"disk_total\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_TOTAL}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  硬盘总容量:${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_TOTAL}"
    # shellcheck disable=SC2086
    echo "  \"disk_free\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_FREE}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  硬盘剩余容量:${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_FREE}"
    # shellcheck disable=SC2086
    echo "  \"disk_used_percent\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_USED_PERCENT}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  硬盘使用率:${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_USED_PERCENT}"
    # shellcheck disable=SC2086
    echo "  \"disk_inode_total\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_TOTAL}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  Inode总量:${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_TOTAL}"
    # shellcheck disable=SC2086
    echo "  \"disk_inode_free\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_FREE}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  Inode剩余量:${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_FREE}"
    # shellcheck disable=SC2086
    echo "  \"disk_inode_used_percent\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_USED_PERCENT}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  Inode使用率:${YXP_OPS_PATROL_INSPECTION_REPORT_DISK_INODE_USED_PERCENT}"
    # shellcheck disable=SC2086
    echo "  \"service_init\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_INIT}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  自启动服务数:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_INIT}"
    # shellcheck disable=SC2086
    echo "  \"service_running\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_RUNNING}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  运行中服务数:${YXP_OPS_PATROL_INSPECTION_REPORT_SERVICE_RUNNING}"
    # shellcheck disable=SC2086
    echo "  \"program_init\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_PROGRAM_INIT}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  自启动程序数:${YXP_OPS_PATROL_INSPECTION_REPORT_PROGRAM_INIT}"
    # shellcheck disable=SC2086
    echo "  \"network_ip\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_IP}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  IP地址:${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_IP}"
    # shellcheck disable=SC2086
    echo "  \"network_mac\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_MAC}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  MAC地址:${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_MAC}"
    # shellcheck disable=SC2086
    echo "  \"network_gateway\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_GATEWAY}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  默认网关:${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_GATEWAY}"
    # shellcheck disable=SC2086
    echo "  \"network_dns\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_DNS}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  DNS:${YXP_OPS_PATROL_INSPECTION_REPORT_NETWORK_DNS}"
    # shellcheck disable=SC2086
    echo "  \"listen_socket_tcp\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_LISTEN_SOCKET_TCP}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  Socket-TCP监听总数:${YXP_OPS_PATROL_INSPECTION_REPORT_LISTEN_SOCKET_TCP}"
    # shellcheck disable=SC2086
    echo "  \"cron_num\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_CRON_NUM}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  计划任务总数:${YXP_OPS_PATROL_INSPECTION_REPORT_CRON_NUM}"
    # shellcheck disable=SC2086
    echo "  \"process_defunct\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_PROCESS_DEFUNCT}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  僵尸进程数:${YXP_OPS_PATROL_INSPECTION_REPORT_PROCESS_DEFUNCT}"
    # shellcheck disable=SC2086
    echo "  \"user_num\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_USER_NUM}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  用户总数:${YXP_OPS_PATROL_INSPECTION_REPORT_USER_NUM}"
    # shellcheck disable=SC2086
    echo "  \"user_empty_pwd\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_USER_EMPTY_PWD}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  空密码用户:${YXP_OPS_PATROL_INSPECTION_REPORT_USER_EMPTY_PWD}"
    # shellcheck disable=SC2086
    echo "  \"user_same_uid\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_USER_SAME_UID}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  相同ID用户:${YXP_OPS_PATROL_INSPECTION_REPORT_USER_SAME_UID}"
    # shellcheck disable=SC2086
    echo "  \"user_root\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_USER_ROOT}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  root用户:${YXP_OPS_PATROL_INSPECTION_REPORT_USER_ROOT}"
    # shellcheck disable=SC2086
    echo "  \"password_expire\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_PASSWORD_EXPIRE}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  密码过期:${YXP_OPS_PATROL_INSPECTION_REPORT_PASSWORD_EXPIRE}"
    # shellcheck disable=SC2086
    echo "  \"sudoers_num\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SUDOERS_NUM}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  sudo授权用户数:${YXP_OPS_PATROL_INSPECTION_REPORT_SUDOERS_NUM}"
    # shellcheck disable=SC2086
    echo "  \"jdk_version\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_JDK_VERSION}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  JDK版本:${YXP_OPS_PATROL_INSPECTION_REPORT_JDK_VERSION}"
    # shellcheck disable=SC2086
    echo "  \"firewall_status\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  防火墙状态:${YXP_OPS_PATROL_INSPECTION_REPORT_FIREWALL_STATUS}"
    # shellcheck disable=SC2086
    echo "  \"syslog_status\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SYSLOG_STATUS}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  系统日志状态:${YXP_OPS_PATROL_INSPECTION_REPORT_SYSLOG_STATUS}"
    # shellcheck disable=SC2086
    echo "  \"snmp_status\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SNMP_STATUS}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  网络管理状态:${YXP_OPS_PATROL_INSPECTION_REPORT_SNMP_STATUS}"
    # shellcheck disable=SC2086
    echo "  \"ntp_status\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_NTP_STATUS}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  时钟同步状态:${YXP_OPS_PATROL_INSPECTION_REPORT_NTP_STATUS}"
    # shellcheck disable=SC2086
    echo "  \"ssh_status\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_STATUS}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  SSH状态:${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_STATUS}"
    # shellcheck disable=SC2086
    echo "  \"ssh_protocol_version\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_PROTOCOL_VERSION}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  SSH协议版本:${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_PROTOCOL_VERSION}"
    # shellcheck disable=SC2086
    echo "  \"ssh_root_login\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_ROOT_LOGIN}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  SSH允许ROOT远程登录:${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_ROOT_LOGIN}"
    # shellcheck disable=SC2086
    echo "  \"ssh_authorize_host\": \"${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_AUTHORIZE_HOST}\"," >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT=${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}"\n  SSH信任主机数:${YXP_OPS_PATROL_INSPECTION_REPORT_SSH_AUTHORIZE_HOST}"
    # shellcheck disable=SC2086
    echo "  \"ip\": \"${YXP_OPS_PATROL_INSPECTION_SERVER_IP}\"" >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    # shellcheck disable=SC2086
    echo "}" >> ${YXP_OPS_PATROL_INSPECTION_REPORT_FILE}
    YXP_COMMON_NOTIFY_MSG_FILE=${YXP_COMMON_PATH_TEMP}/ops/patrol_inspection_notify.json
    # shellcheck disable=SC2086
    echo "${YXP_COMMON_DINGDING_PREFIX}${YXP_OPS_PATROL_INSPECTION_NOTIFY_MSG_CONTENT}${YXP_COMMON_DINGDING_SUFFIX}" > ${YXP_COMMON_NOTIFY_MSG_FILE}
    yxpCommonNotifyDingTalk
    echo -e "\e[1;36m服务器-${YXP_OPS_PATROL_INSPECTION_SERVER_IP}每日巡检: \e[0m \e[1;32m \t[完成检查结果上报] \e[0m"
}

function yxpOpsPatrolInspection() {
    yxpOpsPatrolInspectionPreHandle
    yxpOpsPatrolInspectionCheckServer
    yxpOpsPatrolInspectionCheckCpu
    yxpOpsPatrolInspectionCheckMem
    yxpOpsPatrolInspectionCheckDisk
    yxpOpsPatrolInspectionCheckService
    yxpOpsPatrolInspectionCheckProgram
    yxpOpsPatrolInspectionCheckLogin
    yxpOpsPatrolInspectionCheckNetwork
    yxpOpsPatrolInspectionCheckListen
    yxpOpsPatrolInspectionCheckCron
    yxpOpsPatrolInspectionCheckProcess
    yxpOpsPatrolInspectionCheckUser
    yxpOpsPatrolInspectionCheckPassword
    yxpOpsPatrolInspectionCheckSudoers
    yxpOpsPatrolInspectionCheckJdk
    yxpOpsPatrolInspectionCheckInstalled
    yxpOpsPatrolInspectionCheckFirewall
    yxpOpsPatrolInspectionCheckSyslog
    yxpOpsPatrolInspectionCheckSnmp
    yxpOpsPatrolInspectionCheckNtp
    yxpOpsPatrolInspectionCheckSsh
    yxpOpsPatrolInspectionCheckFile
    yxpOpsPatrolInspectionReport
}
