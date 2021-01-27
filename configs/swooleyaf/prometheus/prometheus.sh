#!/bin/bash
set -o nounset
set -o errexit

/usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml --web.enable-lifecycle &>> /home/logs/prometheus/prometheus.log
