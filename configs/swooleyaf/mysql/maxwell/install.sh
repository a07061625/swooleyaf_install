#!/bin/bash
set -o nounset
set -o errexit

tar -zxf maxwell-1.34.1.tar.gz
mv maxwell-1.34.1/ /usr/local/maxwell
cd /usr/local/maxwell
vim bin/maxwell
    #在脚本最前面加上
    export JAVA_HOME=/usr/java/jdk11.0.1
    export PATH=$JAVA_HOME/bin:$PATH

# 启动
nohup bin/maxwell --config=config.properties >/home/logs/mysql/maxwell.log 2>&1 &

# 初始化历史数据(需要重新采集bin日志使用)
bin/maxwell-bootstrap --host mysql地址 --user mysql用户名 --password mysql密码 --database 数据库名 --table 表名
