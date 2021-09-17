#!/bin/bash
set -o nounset
set -o errexit

mkdir /home/data/loki
mkdir /usr/local/loki && mkdir /usr/local/loki/bin
unzip loki-linux-amd64.zip -d /usr/local/loki/bin
chmod a+x /usr/local/loki/bin/loki-linux-amd64
mv loki-local-config.yaml /usr/local/loki/
mkdir /home/logs/loki
touch /home/logs/loki/console.log

# 启动
nohup /usr/local/loki/bin/loki-linux-amd64 -config.file=/usr/local/loki/loki-local-config.yaml > /home/logs/loki/console.log 2>&1 &

## grafana dashboard id: 13198
