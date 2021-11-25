#!/bin/echo
set -o nounset
set -o errexit

function yxpCommonHelp1() {
    echo -e "\e[1;36m查询具体命令的用法:\e[0m\e[1;32m ./${YXP_COMMON_SCRIPT_NAME} ${YXP_COMMON_CLI_OPTION_TYPE1} 命令名\e[0m"
    echo "当前脚本支持的命令如下:"
    echo "  命令名:命令描述"
    echo "  ${YXP_OPS_CLI_OPTION_TYPE1}:${YXP_OPS_CLI_OPTION_TITLE1}"
}

function yxpCommonHelp() {
    if [ "${YXP_COMMON_HELP}" == "${YXP_OPS_CLI_OPTION_TYPE1}" ]; then
        yxpOpsHelp1
    else
        yxpCommonHelp1
    fi
}

# 请求参数解析
function yxpCommonParseCliParam() {
    YXP_COMMON_CLI_PARAM=${1:-''}
    if [ ${#YXP_COMMON_CLI_PARAM} -eq 0 ]; then
        YXP_COMMON_CLI_PARAM_KEY=""
        YXP_COMMON_CLI_PARAM_VALUE=""
    else
        # shellcheck disable=SC2034
        # shellcheck disable=SC2006
        YXP_COMMON_CLI_PARAM_KEY=`echo "${YXP_COMMON_CLI_PARAM}"|awk -F= '{print $1}'`
        # shellcheck disable=SC2034
        # shellcheck disable=SC2006
        YXP_COMMON_CLI_PARAM_VALUE=`echo "${YXP_COMMON_CLI_PARAM}"|awk -F= '{print $2}'`
    fi
}

function yxpCommonTimeAgo(){
    YXP_COMMON_TIME_AGO_DIFF_TIP=""
    YXP_COMMON_TIME_AGO_COMPARE_DATE=${1:-''}
    YXP_COMMON_TIME_AGO_COMPARE_TIME=${2:-''}
    if [ "${YXP_COMMON_TIME_AGO_COMPARE_TIME}aaa" == "aaa" ]; then
        return
    fi

    # shellcheck disable=SC2006
    YXP_COMMON_TIME_AGO_COMPARE_TIMESTAMP=`date +%s -d "${YXP_COMMON_TIME_AGO_COMPARE_DATE} ${YXP_COMMON_TIME_AGO_COMPARE_TIME}"`
    # shellcheck disable=SC2006
    YXP_COMMON_TIME_AGO_NOW_TIMESTAMP=`date +%s`
    # shellcheck disable=SC2004
    YXP_COMMON_TIME_AGO_DIFF_TIMESTAMP=$((${YXP_COMMON_TIME_AGO_NOW_TIMESTAMP}-${YXP_COMMON_TIME_AGO_COMPARE_TIMESTAMP}))
    # shellcheck disable=SC2004
    # shellcheck disable=SC2006
    # shellcheck disable=SC2003
    YXP_COMMON_TIME_AGO_DIFF_DAYS=`expr $((${YXP_COMMON_TIME_AGO_DIFF_TIMESTAMP}/86400))`
    # shellcheck disable=SC2004
    # shellcheck disable=SC2006
    # shellcheck disable=SC2003
    YXP_COMMON_TIME_AGO_DIFF_HOURS=`expr $((${YXP_COMMON_TIME_AGO_DIFF_TIMESTAMP}/3600))`
    # shellcheck disable=SC2004
    # shellcheck disable=SC2006
    # shellcheck disable=SC2003
    YXP_COMMON_TIME_AGO_DIFF_MINUTES=`expr $((${YXP_COMMON_TIME_AGO_DIFF_TIMESTAMP}/60))`
    # shellcheck disable=SC2086
    if [ ${YXP_COMMON_TIME_AGO_DIFF_DAYS} -gt 0 ]; then
        YXP_COMMON_TIME_AGO_DIFF_TIP="${YXP_COMMON_TIME_AGO_DIFF_DAYS}天前"
    elif [ "${YXP_COMMON_TIME_AGO_DIFF_HOURS}" -gt 0 ]; then
        YXP_COMMON_TIME_AGO_DIFF_TIP="${YXP_COMMON_TIME_AGO_DIFF_HOURS}小时前"
    elif [ ${YXP_COMMON_TIME_AGO_DIFF_MINUTES} -gt 0 ]; then
        YXP_COMMON_TIME_AGO_DIFF_TIP="${YXP_COMMON_TIME_AGO_DIFF_MINUTES}分钟前"
    elif [ ${YXP_COMMON_TIME_AGO_DIFF_TIMESTAMP} -gt 0 ]; then
        YXP_COMMON_TIME_AGO_DIFF_TIP="${YXP_COMMON_TIME_AGO_DIFF_TIMESTAMP}秒前"
    fi
}

function yxpCommonNotifyDingTalk() {
    echo -e "\e[1;36m钉钉通知: \e[0m \e[1;35m \t[开始发送消息] \e[0m"
    # shellcheck disable=SC2086
    # shellcheck disable=SC2006
    YXP_COMMON_NOTIFY_RES=`curl "${YXP_COMMON_DINGDING_URL}" -H 'Content-Type:application/json;charset=utf-8' -X POST -d @${YXP_COMMON_NOTIFY_MSG_FILE}`
    echo -e "\e[1;36m钉钉通知: \e[0m \e[1;32m \t[完成发送消息,发送结果: ${YXP_COMMON_NOTIFY_RES}] \e[0m"
}
