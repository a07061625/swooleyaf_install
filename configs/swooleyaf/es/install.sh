#!/bin/bash
set -o nounset
set -o errexit

vim /etc/sysctl.conf
    vm.max_map_count=655360
sysctl -p

# 重启电脑
vim /etc/security/limits.conf
    * soft memlock unlimited
    * hard memlock unlimited
    * soft nproc 120000
    * hard nproc 131072
    * soft nofile 260000
    * hard nofile 262140
    root soft memlock unlimited
    root hard memlock unlimited
    root soft nproc 120000
    root hard nproc 131072
    root soft nofile 260000
    root hard nofile 262140

cd /usr/local/elasticsearch
# 插件
## 在线安装
bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.7.1/elasticsearch-analysis-ik-7.7.1.zip
bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v7.7.1/elasticsearch-analysis-pinyin-7.7.1.zip

## 压缩包安装
cd /usr/local/elasticsearch/plugins
unzip analysis-ik-v7.7.1.zip
unzip analysis-pinyin-v7.7.1.zip
rm -rf analysis-ik-v7.7.1.zip
rm -rf analysis-pinyin-v7.7.1.zip

mkdir /home/data/elasticsearch
mkdir /home/logs/elasticsearch
chown -R www:www /usr/local/elasticsearch
chown -R www:www /home/logs/elasticsearch
chown -R www:www /home/data/elasticsearch

cd /usr/local/elasticsearch
# 证书生成
bin/elasticsearch-certutil ca //输入自定义密码
bin/elasticsearch-certutil cert --ca elastic-stack-ca.p12 //输入自定义密码
mkdir config/certs
mv elastic-stack-ca.p12 config/certs/
mv elastic-certificates.p12 config/certs/
bin/elasticsearch-keystore add xpack.security.transport.ssl.keystore.secure_password //密码为创建证书时设置的密码
bin/elasticsearch-keystore add xpack.security.transport.ssl.truststore.secure_password //密码为创建证书时设置的密码

# 启动
bin/elasticsearch
# 后台启动
bin/elasticsearch -d
# 初始化密码
bin/elasticsearch-setup-passwords interactive
# 索引优化
curl -u elastic:jw07061625 -H "Content-Type: application/json" -X PUT 'http://192.168.96.21:9201/_all/_settings?preserve_existing=true' -d '{"index.mapping.total_fields.limit" : "200","index.merge.scheduler.max_thread_count" : "1"}'
curl -u elastic:jw07061625 -H "Content-Type: application/json" -X PUT 'http://192.168.96.21:9201/_settings' -d '{"index":{"number_of_replicas":0}}'

# 清除日志
DEL_DATE=`date +%Y-%m-%d -d "-3 days"`
curl -u elastic:jw07061625 -X DELETE http://192.168.96.21:9201/log-${DEL_DATE}
# 数据落盘,每半个小时执行一次
NOW_DATE=`date +%Y-%m-%d`
curl -u elastic:jw07061625 -X POST http://192.168.96.21:9201/log-${NOW_DATE}/_flush

# 调整es的索引的写入参数,牺牲持久性来换取高写入性能,在新索引创建完成后执行
curl -s -H Content-Type:application/json  -u elastic:jw07061625 -d '{
  "index.translog.durability" : "async",
  "index.translog.flush_threshold_size" : "512mb",
  "index.translog.sync_interval" : "60s",
  "index.refresh_interval" : "60s"
}' -X PUT http://192.168.96.21:9201/_all/_settings?preserve_existing=true

# 文档 https://github.com/elastic/built-docs.git
