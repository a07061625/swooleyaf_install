#!/bin/bash
set -o nounset

# shellcheck disable=SC2006
YXP_COMMON_SCRIPT_NAME_FULL=`readlink -f "$0"`
# shellcheck disable=SC2086
# shellcheck disable=SC2006
YXP_COMMON_PATH_ROOT=`dirname ${YXP_COMMON_SCRIPT_NAME_FULL}`
YXP_COMMON_SCRIPT_NAME=${YXP_COMMON_SCRIPT_NAME_FULL##*/}

# shellcheck disable=SC2086
source ${YXP_COMMON_PATH_ROOT}/scripts/libs_constants_common.sh
# shellcheck disable=SC2086
source ${YXP_COMMON_PATH_ROOT}/scripts/libs_constants_ops.sh
# shellcheck disable=SC2086
source ${YXP_COMMON_PATH_ROOT}/scripts/libs_methods_common.sh
# shellcheck disable=SC2086
source ${YXP_COMMON_PATH_ROOT}/scripts/libs_methods_ops1.sh
# shellcheck disable=SC2086
source ${YXP_COMMON_PATH_ROOT}/scripts/libs_methods_ops2.sh
# shellcheck disable=SC2086
source ${YXP_COMMON_PATH_ROOT}/scripts/libs_methods_ops3.sh

# shellcheck disable=SC2086
# shellcheck disable=SC2164
cd ${YXP_COMMON_PATH_ROOT}

# shellcheck disable=SC2207
# shellcheck disable=SC2006
# shellcheck disable=SC2116
YXP_COMMON_CLI_PARAMS=(`echo "$*"`)

YXP_COMMON_CLI_OPTION=${1:-''}
case "${YXP_COMMON_CLI_OPTION}" in
    "${YXP_OPS_CLI_OPTION_TYPE1}")
        yxpOpsPatrolInspectionParams
        yxpOpsPatrolInspection
        ;;
    "${YXP_COMMON_CLI_OPTION_TYPE1}")
        YXP_COMMON_HELP=${2:-''}
        yxpCommonHelp
        ;;
    *)
        YXP_COMMON_HELP=""
        yxpCommonHelp
        ;;
esac

# shellcheck disable=SC2086
# shellcheck disable=SC2164
cd ${YXP_COMMON_PATH_ROOT}
