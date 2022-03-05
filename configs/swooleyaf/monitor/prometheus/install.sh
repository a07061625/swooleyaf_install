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
