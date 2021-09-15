#!/bin/bash
set -o nounset
set -o errexit

# shellcheck disable=SC2006
FILE_ROOT_NAME=`readlink -f "$0"`
# shellcheck disable=SC2086
# shellcheck disable=SC2006
PATH_ROOT=`dirname ${FILE_ROOT_NAME}`
PATH_LOGS=/home/logs/prometheus
HOST_SERVER="192.168.1.4"
PROMETHEUS_PORT=19090
PUSH_GATEWAY_PORT=19091
ALERT_MANAGER_PORT=19092
REDIS_PORT=6688
REDIS_PASSWORD="yjbn15su"
MONGODB_PORT=27017
MONGODB_USER="admin"
MONGODB_PASSWORD="123456"
MYSQL_CONF=/root/.my.cnf
EXPORTER_MONGODB_PORT=19093
EXPORTER_NODE_PORT=19094
EXPORTER_MYSQL_PORT=19094
EXPORTER_REDIS_PORT=19096

# shellcheck disable=SC2086
cd ${PATH_ROOT}

if [ ! -e ${PATH_LOGS} ]; then
    mkdir -p ${PATH_LOGS}
fi

CLI_OPTION=${1:-''}
case "${CLI_OPTION}" in
    prometheus)
        cd /usr/local/prometheus
        /usr/local/prometheus/promtool check config prometheus.yml
        nohup /usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml --storage.tsdb.path=/home/data/prometheus/data --storage.tsdb.retention=30d --web.listen-address="${HOST_SERVER}:${PROMETHEUS_PORT}" --web.enable-lifecycle --web.enable-admin-api >${PATH_LOGS}/prometheus.log 2>&1 &
        ;;
    pushgateway)
        nohup /usr/local/pushgateway/pushgateway --web.listen-address="${HOST_SERVER}:${PUSH_GATEWAY_PORT}" --web.telemetry-path="/metrics" --persistence.interval=5m --persistence.file="persistence-data" >${PATH_LOGS}/pushgateway.log 2>&1 &
        ;;
    alertmanager)
        cd /usr/local/alertmanager
        /usr/local/alertmanager/amtool check-config alertmanager.yml
        nohup /usr/local/alertmanager/alertmanager --config.file="/usr/local/alertmanager/alertmanager.yml" --storage.path="/home/data/alertmanager/" --data.retention=120h --web.listen-address="${HOST_SERVER}:${ALERT_MANAGER_PORT}" --cluster.listen-address="" --log.level=info >${PATH_LOGS}/alertmanager.log 2>&1 &
        ;;
    exporter-mongodb)
        nohup /usr/local/prometheus_exporters/mongodb/mongodb_exporter --log.level="info" --mongodb.uri=mongodb://${MONGODB_USER}:${MONGODB_PASSWORD}@${HOST_SERVER}:${MONGODB_PORT}/admin --web.listen-address="${HOST_SERVER}:${EXPORTER_MONGODB_PORT}" --web.telemetry-path="/metrics" >${PATH_LOGS}/exporter_mongodb.log 2>&1 &
        ;;
    exporter-node)
        nohup /usr/local/prometheus_exporters/node/node_exporter --log.level=info --web.listen-address="${HOST_SERVER}:${EXPORTER_NODE_PORT}" --web.telemetry-path="/metrics" --web.max-requests=10 >${PATH_LOGS}/exporter_node.log 2>&1 &
        ;;
    exporter-mysql)
        nohup /usr/local/prometheus_exporters/mysql/mysqld_exporter --log.level="info" --web.listen-address="${HOST_SERVER}:${EXPORTER_MYSQL_PORT}" --web.telemetry-path="/metrics" --config.my-cnf="${MYSQL_CONF}" >${PATH_LOGS}/exporter_mysql.log 2>&1 &
        ;;
    exporter-redis)
        nohup /usr/local/prometheus_exporters/redis/redis_exporter -redis-only-metrics -redis.addr="redis://${HOST_SERVER}:${REDIS_PORT}" -redis.password=${REDIS_PASSWORD} -web.listen-address="${HOST_SERVER}:${EXPORTER_REDIS_PORT}" -web.telemetry-path="/metrics" >${PATH_LOGS}/exporter_redis.log 2>&1 &
        ;;
    *)
        echo -e "\e[1;31m 操作类型不支持 \e[0m"
        ;;
esac
