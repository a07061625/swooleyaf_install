#!/bin/echo
set -o nounset

#系统配置初始化
function yxpOpsMiscellaneousSysInit() {
    # 安装系统性能分析工具及其他
    yum install gcc make autoconf vim sysstat net-tools iostat iftop iotp wget lrzsz lsof unzip openssh-clients net-tool vim ntpdate -y
    # 设置时区并同步时间
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    # shellcheck disable=SC2006
    YXP_OPS_MISCELLANEOUS_SYS_INIT_CRONTAB=`crontab -l | grep "ntpdate" | awk '{print $0;}'`
    if [ "${YXP_OPS_MISCELLANEOUS_SYS_INIT_CRONTAB}aaa" == "aaa" ]; then
        (echo "0 1 * * * ntpdate time.windows.com >/dev/null 2>&1";crontab -l) | crontab
    fi

    # 禁用selinux
    sed -i '/SELINUX/{s/permissive/disabled/}' /etc/selinux/config

    # 关闭防火墙
    # shellcheck disable=SC2196
    if egrep "7.[0-9]" /etc/redhat-release &>/dev/null; then
        systemctl stop firewalld
        systemctl disable firewalld
    elif egrep "6.[0-9]" /etc/redhat-release &>/dev/null; then
        service iptables stop
        chkconfig iptables off
    fi

    # 历史命令显示操作时间
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_MISCELLANEOUS_SYS_INIT_HIST_TIME=`cat /etc/bashrc | grep "HISTTIMEFORMAT" | awk '{print $0;}'`
    if [ "${YXP_OPS_MISCELLANEOUS_SYS_INIT_HIST_TIME}aaa" == "aaa" ]; then
        # shellcheck disable=SC2016
        echo 'export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S `whoami` "' >> /etc/bashrc
    fi

    # SSH超时时间
    # shellcheck disable=SC2006
    # shellcheck disable=SC2002
    YXP_OPS_MISCELLANEOUS_SYS_INIT_TMOUT=`cat /etc/profile | grep "TMOUT=" | awk '{print $0;}'`
    if [ "${YXP_OPS_MISCELLANEOUS_SYS_INIT_TMOUT}aaa" == "aaa" ]; then
        echo "export TMOUT=3600" >> /etc/profile
    fi

    # 禁止root远程登录 切记给系统添加普通用户，给su到root的权限
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

    # 禁止定时任务向发送邮件
    sed -i 's/^MAILTO=root/MAILTO=""/' /etc/crontab

    # 设置最大打开文件数
    echo "* soft nofile 65535" >> /etc/security/limits.conf
    echo "* hard nofile 65535" >> /etc/security/limits.conf

    # 系统内核优化
    # shellcheck disable=SC2129
    echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_max_tw_buckets = 20480" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_max_syn_backlog = 20480" >> /etc/sysctl.conf
    echo "net.core.netdev_max_backlog = 262144" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_fin_timeout = 20" >> /etc/sysctl.conf

    # 减少SWAP使用
    echo "0" > /proc/sys/vm/swappines
}

#查看网卡的实时流量
function yxpOpsMiscellaneousRealTimeFlow() {
    YXP_OPS_MISCELLANEOUS_FLOW_ETH=${1:-''}
    if [ "${YXP_OPS_MISCELLANEOUS_FLOW_ETH}aaa" == "aaa" ]; then
        echo -e "\e[1;31m网卡不能为空\e[0m"
        exit 0
    fi
    echo -e "入流量--出流量"
    while [ "${YXP_OPS_MISCELLANEOUS_FLOW_ETH}aaa" != "aaa" ]; do
        # shellcheck disable=SC2006
        # shellcheck disable=SC2002
        old_in=`cat /proc/net/dev | grep "${YXP_OPS_MISCELLANEOUS_FLOW_ETH}" | awk '{print $2;}'`
        # shellcheck disable=SC2006
        # shellcheck disable=SC2002
        old_out=`cat /proc/net/dev | grep "${YXP_OPS_MISCELLANEOUS_FLOW_ETH}" | awk '{print $10;}'`
        sleep 1
        # shellcheck disable=SC2006
        # shellcheck disable=SC2002
        new_in=`cat /proc/net/dev | grep "${YXP_OPS_MISCELLANEOUS_FLOW_ETH}" | awk '{print $2;}'`
        # shellcheck disable=SC2006
        # shellcheck disable=SC2002
        new_out=`cat /proc/net/dev | grep "${YXP_OPS_MISCELLANEOUS_FLOW_ETH}" | awk '{print $10;}'`
        # shellcheck disable=SC2004
        # shellcheck disable=SC2006
        flow_in=`printf "%.1f%s" "$(((${new_in}-${old_in})/1024))" "KB/s"`
        # shellcheck disable=SC2004
        # shellcheck disable=SC2006
        flow_out=`printf "%.1f%s" "$(((${new_out}-${old_out})/1024))" "KB/s"`
        echo "${flow_in} ${flow_out}"
    done
}

#检测网站是否异常
function yxpOpsMiscellaneousWebCheck() {
    YXP_OPS_MISCELLANEOUS_WEB_CHECK_NOTIFY_MSG=""
    YXP_OPS_MISCELLANEOUS_WEB_CHECK_FILE=${YXP_COMMON_PATH_TEMP}/miscellaneous/web_check.txt
    # shellcheck disable=SC2086
    # shellcheck disable=SC2162
    while read web_content
    do
        if [ ${#web_content} -eq 0 ]; then
            continue
        fi

        YXP_OPS_MISCELLANEOUS_WEB_CHECK_FAIL_COUNT=0
        for (( i = 1; i <= 3; i++ )); do
            # shellcheck disable=SC2006
            YXP_OPS_MISCELLANEOUS_WEB_CHECK_HTTP_CODE=`curl -o /dev/null --connect-timeout 3 -s -w "%{http_code}" ${web_content}`
            if [ ${YXP_OPS_MISCELLANEOUS_WEB_CHECK_HTTP_CODE} -eq 200 ]; then
                break
            else
                # shellcheck disable=SC2219
                let YXP_OPS_MISCELLANEOUS_WEB_CHECK_FAIL_COUNT++
            fi
        done
        if [ ${YXP_OPS_MISCELLANEOUS_WEB_CHECK_FAIL_COUNT} -eq 3 ]; then
            YXP_OPS_MISCELLANEOUS_WEB_CHECK_NOTIFY_MSG=${YXP_OPS_MISCELLANEOUS_WEB_CHECK_NOTIFY_MSG}"\n  网站地址(${web_content})不可用"
        fi
    done < ${YXP_OPS_MISCELLANEOUS_WEB_CHECK_FILE}

    if [ "${YXP_OPS_MISCELLANEOUS_WEB_CHECK_NOTIFY_MSG}aaa" != "aaa" ]; then
        YXP_COMMON_NOTIFY_MSG_FILE=${YXP_COMMON_PATH_TEMP}/miscellaneous/web_check_notify.json
        # shellcheck disable=SC2086
        echo "${YXP_COMMON_DINGDING_PREFIX}-杂项-网站检测:${YXP_OPS_MISCELLANEOUS_WEB_CHECK_NOTIFY_MSG}${YXP_COMMON_DINGDING_SUFFIX}" > ${YXP_COMMON_NOTIFY_MSG_FILE}
        yxpCommonNotifyDingTalk
    fi
}

#监控MySQL主从同步状态是否异常
function yxpOpsMiscellaneousMysqlSlaveStatus() {
    YXP_OPS_MISCELLANEOUS_MYSQL_HOST=${1:-''}
    if [ "${YXP_OPS_MISCELLANEOUS_MYSQL_HOST}aaa" == "aaa" ]; then
        echo -e "\e[1;31mMySQL主机名不能为空\e[0m"
        exit 0
    fi

    YXP_OPS_MISCELLANEOUS_MYSQL_USER=${2:-''}
    if [ "${YXP_OPS_MISCELLANEOUS_MYSQL_USER}aaa" == "aaa" ]; then
        echo -e "\e[1;31mMySQL用户名不能为空\e[0m"
        exit 0
    fi

    YXP_OPS_MISCELLANEOUS_MYSQL_PASSWORD=${3:-''}
    if [ "${YXP_OPS_MISCELLANEOUS_MYSQL_PASSWORD}aaa" == "aaa" ]; then
        echo -e "\e[1;31mMySQL密码不能为空\e[0m"
        exit 0
    fi
    YXP_OPS_MISCELLANEOUS_MYSQL_PORT=${4:-'3306'}

    YXP_OPS_MISCELLANEOUS_MYSQL_SLAVE_NOTIFY_MSG=""
    # shellcheck disable=SC2086
    # shellcheck disable=SC2006
    YXP_OPS_MISCELLANEOUS_MYSQL_SLAVE_STATUS=`mysql -h${YXP_OPS_MISCELLANEOUS_MYSQL_HOST} -u${YXP_OPS_MISCELLANEOUS_MYSQL_USER} -p${YXP_OPS_MISCELLANEOUS_MYSQL_PASSWORD} -P${YXP_OPS_MISCELLANEOUS_MYSQL_PORT} -e 'show slave status\G' 2>/dev/null | awk '/Slave_.*_Running:/{print $1$2;}'`
    for slaveStatus in ${YXP_OPS_MISCELLANEOUS_MYSQL_SLAVE_STATUS} ; do
        THREAD_STATUS=${slaveStatus#*:}
        if [ "${THREAD_STATUS}" != "Yes" ]; then
            THREAD_STATUS_NAME=${slaveStatus%:*}
            YXP_OPS_MISCELLANEOUS_MYSQL_SLAVE_NOTIFY_MSG=${YXP_OPS_MISCELLANEOUS_MYSQL_SLAVE_NOTIFY_MSG}"\n  节点名:${THREAD_STATUS_NAME} 状态:${THREAD_STATUS}"
        fi
    done

    if [ "${YXP_OPS_MISCELLANEOUS_MYSQL_SLAVE_NOTIFY_MSG}aaa" != "aaa" ]; then
        YXP_COMMON_NOTIFY_MSG_FILE=${YXP_COMMON_PATH_TEMP}/miscellaneous/mysql_slave_notify.json
        # shellcheck disable=SC2086
        echo "${YXP_COMMON_DINGDING_PREFIX}-杂项-MySQL主从同步异常:${YXP_OPS_MISCELLANEOUS_MYSQL_SLAVE_NOTIFY_MSG}${YXP_COMMON_DINGDING_SUFFIX}" > ${YXP_COMMON_NOTIFY_MSG_FILE}
        yxpCommonNotifyDingTalk
    fi
}
