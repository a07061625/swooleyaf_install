#!/bin/echo
set -o errexit

YXP_COMMON_PATH_TEMP=${YXP_COMMON_PATH_ROOT}/temp
YXP_COMMON_CLI_OPTION_TYPE1="help"
YXP_COMMON_CLI_OPTION_TITLE1="帮助"
YXP_COMMON_DINGDING_URL="https://oapi.dingtalk.com/robot/send?access_token=xxx"
YXP_COMMON_DINGDING_PREFIX='{"msgtype":"text", "at":{"atMobiles":[], "isAtAll": false}, "text":{"content":"YXP告警'
YXP_COMMON_DINGDING_SUFFIX='"}}'
