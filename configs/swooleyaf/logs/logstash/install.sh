#!/bin/bash
set -o nounset
set -o errexit

chown -R root /usr/local/logstash
chgrp -R root /usr/local/logstash
mkdir /home/configs/logstash
mkdir /home/logs/logstash

cd /usr/local/logstash
# 离线安装插件
bin/logstash-plugin install file:///path/to/logstash-offline-output-loki-1.0.3.zip

# 启动
bin/logstash

# 输出到loki
# 1. 增加logstash-output-loki插件
# 2. 输出配置如下
output {
  loki {
    url => "http://<loki地址>/loki/api/v1/push"
    batch_size => 112640 # 单次push的日志包大小
    retries => 5
    min_delay => 3
    max_delay => 500
    message_field => "<日志消息行的key,改key由logstash传递过来,默认为message>"
  }
}
