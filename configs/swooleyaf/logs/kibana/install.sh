#!/bin/bash
set -o nounset
set -o errexit

cd /usr/local/kibana
# 启动
bin/kibana --allow-root
