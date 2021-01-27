#!/bin/bash
set -o nounset
set -o errexit

mkdir /home/configs/filebeat

cd /usr/local/filebeat
# 启动
./filebeat -e -c /usr/local/filebeat/filebeat.yml
