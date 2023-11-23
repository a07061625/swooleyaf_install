#!/bin/bash
set -o nounset
set -o errexit

# 下载k8s需要的国外镜像
# Kubernetes几乎所有的安装组件和Docker镜像都放在goolge自己的网站上,直接访问可能会有网络问题
# 这里的解决办法是从阿里云镜像仓库下载镜像,拉取到本地以后改回默认的镜像tag
# K8S_IMAGE_URL_ALIYUN为阿里云镜像仓库地址，K8S_VERSION为安装的kubernetes版本

K8S_IMAGE_URL_ALIYUN=registry.cn-hangzhou.aliyuncs.com/google_containers
K8S_VERSION=v1.23.6
# shellcheck disable=SC2207
# shellcheck disable=SC2006
K8S_IMAGES=(`kubeadm config images list --kubernetes-version=${K8S_VERSION} | awk '{print substr($0, 12);}'`)
# shellcheck disable=SC2068
# shellcheck disable=SC2086
for K8S_IMAGE_NAME_ORIGIN in ${K8S_IMAGES[@]} ; do
    # shellcheck disable=SC2006
    K8S_IMAGE_NAME_ALIYUN=`echo ${K8S_IMAGE_NAME_ORIGIN} | awk -F"/" '{print $NF;}'`
    docker pull ${K8S_IMAGE_URL_ALIYUN}/${K8S_IMAGE_NAME_ALIYUN}
    docker tag ${K8S_IMAGE_URL_ALIYUN}/${K8S_IMAGE_NAME_ALIYUN} k8s.gcr.io/${K8S_IMAGE_NAME_ORIGIN}
    docker rmi -f ${K8S_IMAGE_URL_ALIYUN}/${K8S_IMAGE_NAME_ALIYUN}
done
