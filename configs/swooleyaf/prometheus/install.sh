#!/bin/bash
set -o nounset
set -o errexit

mkdir /usr/local/prometheus_webhooks
# prometheus-webhook-dingtalk
tar -zxf prometheus-webhook-dingtalk-2.0.0.linux-amd64.tar.gz
mv prometheus-webhook-dingtalk-2.0.0.linux-amd64/ /usr/local/prometheus_webhooks/dingtalk
cd /usr/local/prometheus_webhooks/dingtalk
nohup /usr/local/prometheus_webhooks/dingtalk/prometheus-webhook-dingtalk \
--web.listen-address="192.168.3.168:19080" \
--config.file=config.yml \
--log.level=info \
--log.format=logfmt \
>/home/logs/prometheus/webhook_dingtalk.log 2>&1 &

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
## grafana dashboard id: 7353
mkdir /usr/local/prometheus_exporters/mongodb
nohup /usr/local/prometheus_exporters/mongodb/mongodb_exporter \
--log.level="info" \
--mongodb.uri=mongodb://admin:123456@192.168.3.168:27017/admin \
--web.listen-address="192.168.3.168:19093" \
--web.telemetry-path="/metrics" \
>/home/logs/prometheus/exporter_mongodb.log 2>&1 &

# node_exporter
## grafana dashboard id: 9276
mkdir /usr/local/prometheus_exporters/node
nohup /usr/local/prometheus_exporters/node/node_exporter \
--log.level=info \
--web.listen-address="192.168.3.168:19094" \
--web.telemetry-path="/metrics" \
--web.max-requests=10 \
>/home/logs/prometheus/exporter_node.log 2>&1 &

# mysqld_exporter
## grafana dashboard id: 7362
## 创建导出用户
CREATE user 'exporter'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY '123456';
ALTER user 'exporter'@'127.0.0.1' PASSWORD EXPIRE NEVER;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'127.0.0.1';
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
>/home/logs/prometheus/exporter_mysql.log 2>&1 &

# redis_exporter
## grafana dashboard id: 763
mkdir /usr/local/prometheus_exporters/redis
nohup /usr/local/prometheus_exporters/redis/redis_exporter \
-redis-only-metrics \
-redis.addr="redis://192.168.3.168:6688" \
-redis.password=yjbn15su \
-web.listen-address="192.168.3.168:19096" \
-web.telemetry-path="/metrics" \
>/home/logs/prometheus/exporter_redis.log 2>&1 &

# nginx-vts-exporter
## grafana dashboard id: 2949
mkdir /usr/local/prometheus_exporters/nginx-vts
nohup /usr/local/prometheus_exporters/nginx-vts/nginx-vts-exporter \
-nginx.scrape_uri http://192.168.3.168:8989/status/format/json \
-telemetry.address 192.168.3.168:19097 \
-telemetry.endpoint /metrics \
>/home/logs/prometheus/exporter_nginx_vts.log 2>&1 &
