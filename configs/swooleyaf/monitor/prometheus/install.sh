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
