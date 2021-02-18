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
    root soft memlock unlimited
    root hard memlock unlimited

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
curl -u elastic:jw07061625 -X PUT -H 'Content-Type: application/json' -d '{"index.mapping.total_fields.limit" : "200","index.merge.scheduler.max_thread_count" : "1"}' 'http://192.168.96.21:9201/_all/_settings?preserve_existing=true'
# 清除日志
DEL_DATE=`date +%Y-%m-%d -d "-3 days"`
curl -u elastic:jw07061625 -X DELETE http://192.168.96.21:9201/log-$DEL_DATE

# 文档 https://github.com/elastic/built-docs.git
