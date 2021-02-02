#!/bin/bash
set -o nounset
set -o errexit

DIR_ROOT=`pwd`
LOG_GATHER=/home/download/gather.log
if [ ! -f ${LOG_GATHER} ]; then
    echo "gather log file not exist"
    exit 1
fi

chmod a+x ${DIR_ROOT}/busybox
chmod a+x ${DIR_ROOT}/chkrootkit
echo > ${LOG_GATHER}

echo "root kit:" >> ${LOG_GATHER}
${DIR_ROOT}/chkrootkit >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

echo "network:" >> ${LOG_GATHER}
netstat -tulnp >> ${LOG_GATHER} 2>&1
netstat -anp >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

echo "process:" >> ${LOG_GATHER}
ps aux >> ${LOG_GATHER} 2>&1
ps auxef >> ${LOG_GATHER} 2>&1
top -n 1 >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

echo "system init:" >> ${LOG_GATHER}
chkconfig --list >> ${LOG_GATHER} 2>&1
ls -alt /etc/init* >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

echo "cron:" >> ${LOG_GATHER}
cat /etc/crontab >> ${LOG_GATHER} 2>&1
cat /etc/anacrontab >> ${LOG_GATHER} 2>&1
crontab -l >> ${LOG_GATHER} 2>&1
cat /etc/cron.d/* >> ${LOG_GATHER} 2>&1
cat /etc/cron.daily/* >> ${LOG_GATHER} 2>&1
cat /etc/cron.hourly/* >> ${LOG_GATHER} 2>&1
cat /etc/cron.monthly/* >> ${LOG_GATHER} 2>&1
cat /etc/cron.weekly/* >> ${LOG_GATHER} 2>&1
cat /var/spool/cron/* >> ${LOG_GATHER} 2>&1
cat /var/spool/anacron/* >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

echo "passwd:" >> ${LOG_GATHER}
cat /etc/passwd | grep -v nologin >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

echo "tmp:" >> ${LOG_GATHER}
ls -alt /tmp >> ${LOG_GATHER} 2>&1
ls -alt /var/tmp >> ${LOG_GATHER} 2>&1
ls -alt /dev/shm >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

echo "preload:" >> ${LOG_GATHER}
echo $LD_PRELOAD >> ${LOG_GATHER} 2>&1
cat /etc/ld.so.preload >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

echo "ssh-root:" >> ${LOG_GATHER}
ls -alt /root/.ssh >> ${LOG_GATHER} 2>&1
cat /root/.ssh/* >> ${LOG_GATHER} 2>&1
echo "" >> ${LOG_GATHER}

for user in /home/*
do
    if test -d ${user};then
        echo "ssh-${user}:" >> ${LOG_GATHER}
        cat /${user}/.ssh/* >> ${LOG_GATHER} 2>&1
        echo "" >> ${LOG_GATHER}
    fi
done
