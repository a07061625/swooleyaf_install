#!/bin/bash
set -o nounset
set -o errexit

mkdir /home/logs/kibana
touch /home/logs/kibana/kibana.pid
touch /home/logs/kibana/kibana.log
cd /usr/local/kibana
# 启动
bin/kibana --allow-root
