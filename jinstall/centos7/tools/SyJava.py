# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyJava:
    # 配置java环境
    @staticmethod
    def install_java(params: dict):
        """安装语言java"""
        Tool.check_local_files([
            'resources/lang/java/jdk-8u131-linux-x64.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/lang/java/jdk-8u131-linux-x64.tar.gz': 'remote/jdk-8u131-linux-x64.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/java')
            run('tar -zxf jdk-8u131-linux-x64.tar.gz')
            run('mv jdk1.8.0_131/ /usr/java/jdk1.8.0')
            run('rm -rf jdk-8u131-linux-x64.tar.gz')
