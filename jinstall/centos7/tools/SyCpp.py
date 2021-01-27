# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyCpp:
    # 配置boost环境
    @staticmethod
    def install_boost(params: dict):
        """安装boost"""
        Tool.check_local_files([
            'resources/lang/cpp/boost_1_72_0.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/lang/cpp/boost_1_72_0.tar.gz': 'remote/boost_1_72_0.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/boost')
            run('tar -zxf boost_1_72_0.tar.gz')
            run('mv boost_1_72_0/ /usr/local/boost_1_72')
            run('cd /usr/local/boost_1_72 && ./bootstrap.sh --prefix=/usr/local/boost && ./b2 install && echo "/usr/local/boost/lib" >> /etc/ld.so.conf && ldconfig')
            run('rm -rf boost_1_72_0.tar.gz')
