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

BACKUP_DIR_ROOT=/home/data/mysqlbackup
BACKUP_FILE_LOG=${BACKUP_DIR_ROOT}/xtrabackup.log
BACKUP_FILE_CONFIG=/etc/my.cnf
BACKUP_FILE_EXEC=/path/to/xtrabackup
MYSQL_HOST=172.16.10.200
MYSQL_USER=root
MYSQL_PASSWORD=arbitrary0!
MYSQL_PORT=3306

function backupFull() {
    # shellcheck disable=SC2086
    if [ ! -d ${BACKUP_DIR_FULL} ]; then
        mkdir -p ${BACKUP_DIR_FULL}
    fi
    # shellcheck disable=SC2129
    echo -e '\n\n\n\n' >> ${BACKUP_FILE_LOG}
    echo "############################################################################" >> ${BACKUP_FILE_LOG}
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    echo `date +"%F %T %u %A %B %j"` A New Round backup begin!!!!!!!!!!>> ${BACKUP_FILE_LOG}
    echo "############################################################################" >> ${BACKUP_FILE_LOG}
    echo "############################################################################" >> ${BACKUP_FILE_LOG}
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    echo `date +"%F %T %u %A %B %j"` full backup starting >> ${BACKUP_FILE_LOG}
    echo "############################################################################" >> ${BACKUP_FILE_LOG}
    # shellcheck disable=SC2086
    ${BACKUP_FILE_EXEC} --defaults-file=${BACKUP_FILE_CONFIG} --backup --host=${MYSQL_HOST} --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --port=${MYSQL_PORT} --target-dir=${BACKUP_DIR_FULL} &>> ${BACKUP_FILE_LOG}
    find ${BACKUP_DIR_ROOT} -maxdepth 1 ! -path ${BACKUP_DIR_ROOT} -mtime +9 -type d -exec rm -rf {} \;
}

function backupIncremental() {
    # shellcheck disable=SC2129
    echo -e '\n' >> ${BACKUP_FILE_LOG}
    echo "############################################################################" >> ${BACKUP_FILE_LOG}
    # shellcheck disable=SC2046
    # shellcheck disable=SC2006
    echo `date +"%F %T %u %A %B %j"` incremental backup starting >> ${BACKUP_FILE_LOG}
    echo "############################################################################" >> ${BACKUP_FILE_LOG}

    # shellcheck disable=SC2004
    BACKUP_DIR_TARGET=${BACKUP_DIR_ROOT}/${BACKUP_WEEK_DAY_LAST}/incremental_$(( ${BACKUP_WEEK_DAY_NUM} - 1 ))
    if [[ -e ${BACKUP_DIR_TARGET} ]]; then
        # shellcheck disable=SC2129
        echo "############################################################################" >> ${BACKUP_FILE_LOG}
        # shellcheck disable=SC2046
        # shellcheck disable=SC2006
        echo `date +"%F %T %u %A %B %j"` ${BACKUP_DIR_TARGET} already exits!!!!!!!!!!>> ${BACKUP_FILE_LOG}
        echo "############################################################################" >> ${BACKUP_FILE_LOG}
        exit 0
    fi

    if [[ ${BACKUP_WEEK_DAY_NUM} -eq 2 ]]; then
        BACKUP_DIR_INCREMENTAL_BASE=${BACKUP_DIR_ROOT}/${BACKUP_WEEK_DAY_LAST}/base
    else
        # shellcheck disable=SC2004
        BACKUP_DIR_INCREMENTAL_BASE=${BACKUP_DIR_ROOT}/${BACKUP_WEEK_DAY_LAST}/incremental_$(( ${BACKUP_WEEK_DAY_NUM} - 2 ))
        # shellcheck disable=SC2086
        if [ ! -d $BACKUP_DIR_INCREMENTAL_BASE ]; then
            # shellcheck disable=SC2006
            BACKUP_DIR_INCREMENTAL_BASE=${BACKUP_DIR_ROOT}/${BACKUP_WEEK_DAY_LAST}/base
        fi
    fi

    # shellcheck disable=SC2086
    ${BACKUP_FILE_EXEC} --defaults-file=${BACKUP_FILE_CONFIG} --backup --user=${MYSQL_USER} --host=${MYSQL_HOST} --password=${MYSQL_PASSWORD} --port=${MYSQL_PORT} --target-dir=${BACKUP_DIR_TARGET} --incremental-basedir=${BACKUP_DIR_INCREMENTAL_BASE} &>> ${BACKUP_FILE_LOG}
}

# shellcheck disable=SC2006
BACKUP_WEEK_DAY=`date +%F`
# shellcheck disable=SC2006
BACKUP_WEEK_DAY_NUM=`date +%u`
# shellcheck disable=SC2006
BACKUP_WEEK_DAY_LAST=`date -d 'last monday' +%F`

# shellcheck disable=SC2086
if [ ${BACKUP_WEEK_DAY_NUM} -eq 1 ]; then
    BACKUP_DIR_FULL=${BACKUP_DIR_ROOT}/${BACKUP_WEEK_DAY}/base
else
    BACKUP_DIR_FULL=${BACKUP_DIR_ROOT}/${BACKUP_WEEK_DAY_LAST}/base
fi
# shellcheck disable=SC2086
if [ ! -d ${BACKUP_DIR_FULL} ]; then
    backupFull
else
    backupIncremental
fi
