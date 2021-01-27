#!/bin/bash
set -o nounset
set -o errexit

chown -R root /usr/local/logstash
chgrp -R root /usr/local/logstash
mkdir /home/configs/logstash
mkdir /home/logs/logstash

cd /usr/local/logstash
# 启动
bin/logstash