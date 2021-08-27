#!/bin/bash
set -o nounset
set -o errexit

# mysql8备份
# create user xtrabackup@127.0.0.1 identified by 'cruces';
# grant backup_admin,process,reload,lock tables,replication client,replication slave on *.* to xtrabackup@127.0.0.1;
# flush privilges;

# Prepare
# xtrabackup --prepare --apply-log-only --target-dir=/data/backup/base
# xtrabackup --prepare --apply-log-only --target-dir=/data/backup/base --incremental-dir=/data/backup/incremental_1
# xtrabackup --prepare --target-dir=/data/backup/base --incremental-dir=/data/backup/incremental_2

# Restoring
# xtrabackup --copy-back --datadir=/backup/copy-back --target-dir=/data/mysql

# shellcheck disable=SC2006
FILE_ROOT_NAME=`readlink -f "$0"`
# shellcheck disable=SC2086
# shellcheck disable=SC2006
PATH_ROOT=`dirname ${FILE_ROOT_NAME}`

# 以下shell脚本均需拥有可执行权限
# shellcheck disable=SC2086
. ${PATH_ROOT}/env.sh
# shellcheck disable=SC2086
. ${PATH_ROOT}/backup_func.sh

MYSQL_HOST=""
MYSQL_USER=""
MYSQL_PASSWORD=""
MYSQL_PORT=3306
# shellcheck disable=SC2207
# shellcheck disable=SC2006
# shellcheck disable=SC2116
CLI_PARAMS=(`echo "$*"`)
# shellcheck disable=SC2068
for param in ${CLI_PARAMS[@]} ; do
    # shellcheck disable=SC2086
    backupParseCliParam ${param}
    # shellcheck disable=SC2166
    if [ "${CLI_PARAM_KEY}" == "-h" -o "${CLI_PARAM_KEY}" == "--help" ]; then
        backupHelper
        exit 0
    fi

    if [ "${CLI_PARAM_KEY}" == "-host" ]; then
        MYSQL_HOST=${CLI_PARAM_VALUE}
    elif [ "${CLI_PARAM_KEY}" == "-user" ]; then
        MYSQL_USER=${CLI_PARAM_VALUE}
    elif [ "${CLI_PARAM_KEY}" == "-password" ]; then
        MYSQL_PASSWORD=${CLI_PARAM_VALUE}
    elif [ "${CLI_PARAM_KEY}" == "-port" ]; then
        MYSQL_PORT=${CLI_PARAM_VALUE}
    fi
done

if [ "${MYSQL_HOST}aaa" == "aaa" ]; then
    echo -e "\e[1;31m mysql主机名不能为空 \e[0m"
    exit 0
fi
if [ "${MYSQL_USER}aaa" == "aaa" ]; then
    echo -e "\e[1;31m mysql用户名不能为空 \e[0m"
    exit 0
fi
if [ "${MYSQL_PASSWORD}aaa" == "aaa" ]; then
    echo -e "\e[1;31m mysql密码不能为空 \e[0m"
    exit 0
fi
# shellcheck disable=SC2086
if [ ${MYSQL_PORT} -le 0 ]; then
    echo -e "\e[1;31m mysql端口不合法 \e[0m"
    exit 0
fi

BACKUP_FILE_LOG=${PATH_ROOT}/logs/xtrabackup-${MYSQL_HOST}-${MYSQL_PORT}.log

# shellcheck disable=SC2006
BACKUP_WEEK_DAY_NUM=`date +%u`
# shellcheck disable=SC2086
if [ ${BACKUP_WEEK_DAY_NUM} -eq 1 ]; then
    # shellcheck disable=SC2006
    BACKUP_WEEK_DAY=`date +%F`
else
    # shellcheck disable=SC2006
    BACKUP_WEEK_DAY=`date -d 'last monday' +%F`
fi
BACKUP_DIR_CURRENT=${BACKUP_DIR_ROOT}/${MYSQL_HOST}_${MYSQL_PORT}/${BACKUP_WEEK_DAY}
BACKUP_DIR_FULL=${BACKUP_DIR_CURRENT}/base
# shellcheck disable=SC2086
if [ ! -d ${BACKUP_DIR_FULL} ]; then
    mkdir -p ${BACKUP_DIR_FULL}
    backupFull
else
    backupIncremental
fi
