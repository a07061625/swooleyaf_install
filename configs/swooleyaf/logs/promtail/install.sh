#!/bin/bash
set -o nounset
set -o errexit

mkdir /home/data/promtail
mkdir /usr/local/promtail && mkdir /usr/local/promtail/bin
unzip promtail-linux-amd64.zip -d /usr/local/promtail/bin
chmod a+x /usr/local/promtail/bin/promtail-linux-amd64
mv promtail-local-config.yaml /usr/local/promtail/
mkdir /home/logs/promtail
touch /home/logs/promtail/console.log

nohup /usr/local/promtail/bin/promtail-linux-amd64 -config.file=/usr/local/promtail/promtail-local-config.yaml > /home/logs/promtail/console.log 2>&1 &
