#!/bin/bash
set -o nounset
set -o errexit

# 生成https证书
mkdir -p /home/configs/certs
cd /home/configs/certs/
## Common Name后需填写 dockerregistry.huijia520.cn
## dockerregistry.huijia520.cn.crt要配置到对应客户端的docker上,如 /etc/docker/certs.d/dockerregistry.huijia520.cn:5000/ca.cert
openssl req -newkey rsa:4096 -nodes -sha256 -keyout dockerregistry.huijia520.cn.key -x509 -days 3650 -out dockerregistry.huijia520.cn.crt
# 生成访问密钥
yum install -y httpd-tools
mkdir -p /home/configs/passwd
cd /home/configs/passwd/
## 连续输入两次密码,例如 jw112233
htpasswd -c dockerregistry admin

# 启动服务
docker compose up registry-docker -d -f /path/to/docker-compose.yml
