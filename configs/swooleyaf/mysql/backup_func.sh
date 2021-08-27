#!/bin/bash
set -o nounset
set -o errexit

function backupParseCliParam() {
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

function backupHelper() {
    echo "命令格式:"
    echo "./backup.sh -host=127.0.0.1 -port=3306 -user=root -password=123456"
    echo "命令参数:"
    echo "    -host: 必填,mysql主机名"
    echo "    -port: 选填,mysql端口,默认为3306"
    echo "    -user: 必填,mysql用户名"
    echo "    -password: 必填,mysql密码"
}

function backupLogStart() {
    # shellcheck disable=SC2086
    echo "############################################################################" >> ${BACKUP_FILE_LOG}
}

function backupLogEnd() {
    # shellcheck disable=SC2086
    echo "############################################################################" >> ${BACKUP_FILE_LOG}
    # shellcheck disable=SC2086
    echo -e "\n\n" >> ${BACKUP_FILE_LOG}
}

function backupFull() {
    backupLogStart
    # shellcheck disable=SC2086
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    echo `date +"%F %T %A"` full backup starting >> ${BACKUP_FILE_LOG}
    # shellcheck disable=SC2086
    ${BACKUP_FILE_EXEC} --host=${MYSQL_HOST} --port=${MYSQL_PORT} --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --backup --target-dir=${BACKUP_DIR_FULL} &>> ${BACKUP_FILE_LOG}
    # shellcheck disable=SC2086
    find ${BACKUP_DIR_ROOT} -maxdepth 1 ! -path ${BACKUP_DIR_ROOT} -mtime +9 -type d -exec rm -rf {} \;
    # shellcheck disable=SC2086
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    echo `date +"%F %T %A"` full backup success >> ${BACKUP_FILE_LOG}
    backupLogEnd
}

function backupIncremental() {
    # shellcheck disable=SC2004
    BACKUP_DIR_TARGET=${BACKUP_DIR_CURRENT}/incremental_$(( ${BACKUP_WEEK_DAY_NUM} - 1 ))
    if [[ -e ${BACKUP_DIR_TARGET} ]]; then
        echo -e "\e[1;31m 备份目标目录已存在 \e[0m"
        exit 0
    fi

    backupLogStart
    # shellcheck disable=SC2086
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    echo `date +"%F %T %A"` incremental backup starting >> ${BACKUP_FILE_LOG}

    if [[ ${BACKUP_WEEK_DAY_NUM} -eq 2 ]]; then
        BACKUP_DIR_INCREMENTAL_BASE=${BACKUP_DIR_CURRENT}/base
    else
        # shellcheck disable=SC2004
        BACKUP_DIR_INCREMENTAL_BASE=${BACKUP_DIR_CURRENT}/incremental_$(( ${BACKUP_WEEK_DAY_NUM} - 2 ))
        # shellcheck disable=SC2086
        if [ ! -d $BACKUP_DIR_INCREMENTAL_BASE ]; then
            BACKUP_DIR_INCREMENTAL_BASE=${BACKUP_DIR_CURRENT}/base
        fi
    fi

    # shellcheck disable=SC2086
    ${BACKUP_FILE_EXEC} --host=${MYSQL_HOST} --port=${MYSQL_PORT} --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --backup --target-dir=${BACKUP_DIR_TARGET} --incremental-basedir=${BACKUP_DIR_INCREMENTAL_BASE} &>> ${BACKUP_FILE_LOG}
    # shellcheck disable=SC2086
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    echo `date +"%F %T %A"` incremental backup success >> ${BACKUP_FILE_LOG}
    backupLogEnd
}
