#!/bin/bash
set -o nounset
set -o errexit

mkdir /home/configs/filebeat

cd /usr/local/filebeat
# 启动
mv filebeat.service /lib/systemd/system/filebeat.service
systemctl daemon-reload
systemctl enable filebeat
systemctl start filebeat

# 日志输出样例
#{
#  "@timestamp":"2021-09-28T06:00:17.732Z",
#  "@metadata":{
#    "beat":"filebeat",
#    "type":"_doc",
#    "version":"7.7.1"
#  },
#  "input":{
#    "type":"log"
#  },
#  "server_ip":"10.0.0.224",
#  "log":{
#    "offset":19975860,
#    "file":{
#      "path":"/opt/servers/nginx/logs/error.ssl.ulearning.youxuepai.com.log"
#    }
#  },
#  "redis_key":"yxplogs_nginx_error",
#  "env_type":"product",
#  "log_level":"ERROR",
#  "message":"2021/09/28 14:00:17 [info] 198751#0: *8728904652 client 113.142.25.113 closed keepalive connection",
#  "server_type":"nginx-error"
#}
