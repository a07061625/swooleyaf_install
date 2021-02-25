#!/bin/bash
set -o nounset
set -o errexit

# prometheus
nohup /usr/local/prometheus/prometheus \
--config.file=/usr/local/prometheus/prometheus.yml \
--storage.tsdb.path=/home/data/prometheus/data \
--storage.tsdb.retention=30d \
--web.listen-address="192.168.3.168:19090" \
--web.enable-lifecycle \
--web.enable-admin-api \
>/home/logs/prometheus/prometheus.log 2>&1 &

# pushgateway
nohup /usr/local/pushgateway/pushgateway \
--web.listen-address="192.168.3.168:19091" \
--web.telemetry-path="/metrics" \
--persistence.interval=5m \
--persistence.file="persistence-data" \
>/home/logs/prometheus/pushgateway.log 2>&1 &

# alertmanager
## 检查配置
/usr/local/alertmanager/amtool check-config alertmanager.yml

cd /usr/local/alertmanager
nohup /usr/local/alertmanager/alertmanager \
--config.file="/usr/local/alertmanager/alertmanager.yml" \
--storage.path="/home/data/alertmanager/" \
--data.retention=120h \
--web.listen-address="192.168.3.168:19092" \
--cluster.listen-address="" \
--log.level=info \
>/home/logs/alertmanager/alertmanager.log 2>&1 &

mkdir /usr/local/prometheus_exporters
# mongodb_exporter
mkdir /usr/local/prometheus_exporters/mongodb
nohup /usr/local/prometheus_exporters/mongodb/mongodb_exporter \
--log.level="info" \
--mongodb.uri=mongodb://admin:123456@192.168.3.168:27017/admin \
--web.listen-address="192.168.3.168:19093" \
--web.telemetry-path="/metrics" \
>/home/logs/prometheus/mongodb.log 2>&1 &

# node_exporter
## grafana dashboard id: 9276
mkdir /usr/local/prometheus_exporters/node
nohup /usr/local/prometheus_exporters/node/node_exporter \
--log.level=info \
--web.listen-address="192.168.3.168:19094" \
--web.telemetry-path="/metrics" \
--web.max-requests=10 \
>/home/logs/prometheus/node.log 2>&1 &

# mysqld_exporter
## grafana dashboard id: 7362
## 创建导出用户
CREATE user 'exporter'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';
ALTER user 'exporter'@'localhost' PASSWORD EXPIRE NEVER;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
flush privileges;

touch /root/.my.cnf
vim /root/.my.cnf
    [client]
    host=localhost
    port=3306
    user=exporter
    password=123456

mkdir /usr/local/prometheus_exporters/mysql
nohup /usr/local/prometheus_exporters/mysql/mysqld_exporter \
--log.level="info" \
--web.listen-address="192.168.3.168:19095" \
--web.telemetry-path="/metrics" \
--config.my-cnf="/root/.my.cnf" \
>/home/logs/prometheus/mysql.log 2>&1 &

# redis_exporter
## grafana dashboard id: 763
mkdir /usr/local/prometheus_exporters/redis
nohup /usr/local/prometheus_exporters/redis/redis_exporter \
-redis-only-metrics \
-redis.addr="redis://192.168.3.168:6688" \
-redis.password yjbn15su \
-web.listen-address="192.168.3.168:19096" \
-web.telemetry-path="/metrics" \
>/home/logs/prometheus/redis.log 2>&1 &
