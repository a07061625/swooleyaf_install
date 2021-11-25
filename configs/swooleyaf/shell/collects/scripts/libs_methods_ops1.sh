#!/bin/echo
set -o nounset

function yxpOpsHelp1() {
    echo -e "\e[1;31m${YXP_OPS_CLI_OPTION_TITLE1}\e[0m\n"
    echo -e "\e[1;36m命令格式:\e[0m"
    echo -e "\e[1;32m  ./${YXP_COMMON_SCRIPT_NAME} ${YXP_OPS_CLI_OPTION_TYPE1} -server_ip=aaa"
    echo -e "\e[1;36m参数说明:\e[0m"
    echo -e "  ${YXP_OPS_CLI_OPTION_TYPE1}:\e[1;32m 必填 \e[0m固定"
    echo -e "  -server_ip=aaa:\e[1;32m 必填 \e[0m服务器IP"
    echo -e "\n\e[1;36m命令示例:\e[0m"
    echo -e "\e[1;32m  ./${YXP_COMMON_SCRIPT_NAME} ${YXP_OPS_CLI_OPTION_TYPE1} -server_ip=192.168.3.111\e[0m"
}
