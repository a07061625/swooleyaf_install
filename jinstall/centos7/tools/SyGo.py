# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyGo:
    # 配置go环境
    @staticmethod
    def install_go(params: dict):
        """安装语言golang"""
        Tool.check_local_files([
            'resources/lang/go/go1.14.4.linux-amd64.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/lang/go/go1.14.4.linux-amd64.tar.gz': 'remote/go1.14.4.linux-amd64.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/gopath && mkdir /usr/local/gocache')
            run('tar -zxf go1.14.4.linux-amd64.tar.gz')
            run('mv go/ /usr/local')
            run('rm -rf go1.14.4.linux-amd64.tar.gz')
