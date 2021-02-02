# -*- coding:utf-8 -*-
import os


"""
获取隐藏的进程
如果输出两行提示信息则正常,这两个进程分别是ls -lh /proc和awk进程的ID,否则代表存在隐藏进程
"""
pid_all = {}
output_pid_all = os.popen("ls -lh /proc | awk '{if ($9 ~ /^[0-9]+$/) print $9}'")
outlines_pid_all = output_pid_all.readlines()
for j in outlines_pid_all:
    pid_exist = int(j.strip())
    pid_all[pid_exist] = 1

output_pid_list = os.popen("ps -ef|grep -v 'ps -ef'|awk '{if (NR > 1) print $2}'")
outlines_pid_list = output_pid_list.readlines()
for i in outlines_pid_list:
    pid_now = int(i.strip())
    pid_all[pid_now] = 0

for pid in pid_all:
    if pid_all[pid] > 0:
        print('process %s is hide' % pid)
