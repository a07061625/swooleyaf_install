#!/bin/bash
set -o nounset
set -o errexit

function toolCliParseParam() {
    CLI_PARAM=${1:-''}
    if [ ${#CLI_PARAM} -eq 0 ]; then
        CLI_PARAM_KEY=""
        CLI_PARAM_VALUE=""
    else
        # shellcheck disable=SC2034
        # shellcheck disable=SC2006
        CLI_PARAM_KEY=`echo "${CLI_PARAM}"|awk -F= '{print $1}'`
        # shellcheck disable=SC2034
        # shellcheck disable=SC2006
        CLI_PARAM_VALUE=`echo "${CLI_PARAM}"|awk -F= '{print $2}'`
    fi
}
