#!/bin/bash
set -o nounset
set -o errexit

# https证书自动续期

PATH_ROOT=/home/download
PATH_ACME=/root/.acme.sh
PATH_NGINX_CERT=/home/configs/nginx/cert
PATH_NGINX_BIN=/usr/local/openresty/nginx/sbin/nginx
# 待处理的证书信息文本文件,其内每一行的格式为 api.docs.huijia520.cn|huijia520cn_docs_api
PATH_DOMAINS=/xxx/domains.txt

cd ${PATH_ROOT}
# shellcheck disable=SC2013
for name in $(cat ${PATH_DOMAINS}); do
    # shellcheck disable=SC2006
    DOMAIN_NAME=`echo "${name}" | awk -F"|" '{print $1}'`
    # shellcheck disable=SC2006
    DOMAIN_TAG=`echo "${name}" | awk -F"|" '{print $2}'`
    # shellcheck disable=SC2086
    acme.sh --renew -d ${DOMAIN_NAME} --force
    # shellcheck disable=SC2086
    mv -y ${PATH_ACME}/${DOMAIN_NAME}/${DOMAIN_NAME}.cer ${PATH_NGINX_CERT}/${DOMAIN_TAG}.cer
    # shellcheck disable=SC2086
    mv -y ${PATH_ACME}/${DOMAIN_NAME}/${DOMAIN_NAME}.key ${PATH_NGINX_CERT}/${DOMAIN_TAG}.key
    # shellcheck disable=SC2086
    mv -y ${PATH_ACME}/${DOMAIN_NAME}/fullchain.cer ${PATH_NGINX_CERT}/${DOMAIN_TAG}.chain.cer
done

${PATH_NGINX_BIN} -s reload
