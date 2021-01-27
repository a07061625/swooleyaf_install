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

mkdir /usr/local/elasticsearch/data
mkdir /home/logs/elasticsearch
chown -R www /usr/local/elasticsearch
chgrp -R www /usr/local/elasticsearch
chown -R www /home/logs/elasticsearch
chgrp -R www /home/logs/elasticsearch

cd /usr/local/elasticsearch
# 插件-在线安装
bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.7.1/elasticsearch-analysis-ik-7.7.1.zip
bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v7.7.1/elasticsearch-analysis-pinyin-7.7.1.zip

# 插件-压缩包安装
cd /usr/local/elasticsearch/plugins
unzip analysis-ik-v7.7.1.zip
unzip analysis-pinyin-v7.7.1.zip
rm -rf analysis-ik-v7.7.1.zip
rm -rf analysis-pinyin-v7.7.1.zip

cd /usr/local/elasticsearch
# 启动
bin/elasticsearch
# 后台启动
bin/elasticsearch -d
# 初始化密码
bin/elasticsearch-setup-passwords interactive
# 清除日志
DEL_DATE=`date +%Y-%m-%d -d "-3 days"`
curl -u elastic:jw07061625 -X DELETE http://192.168.96.21:9201/log-$DEL_DATE

# 文档 https://github.com/elastic/built-docs.git
