# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyPython:
    @staticmethod
    def install_python3(params: dict):
        """安装语言python3,因为PaddleHub限制了python版本不能超过3.7"""
        Tool.check_local_files([
            'resources/lang/python/Python-3.7.9.tar.xz',
        ])
        Tool.upload_file_fabric({
            '/resources/lang/python/Python-3.7.9.tar.xz': 'remote/Python-3.7.9.tar.xz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir %s' % install_configs['python3.path.install'])
            # PaddleHub需要
            run('yum install -y sqlite-devel bzip2 bzip2-devel')
            run('tar -Jxf Python-3.7.9.tar.xz')
            run('cd Python-3.7.9/ && ./configure --prefix=%s --enable-optimizations && make && make install && %s/bin/pip3 install fabric3' % (install_configs['python3.path.install'], install_configs['python3.path.install']))

    @staticmethod
    def install_paddlehub(params: dict):
        """安装PaddleHub-AI机器学习框架"""
        Tool.check_local_files([
            'configs/swooleyaf/python/paddlehub.json',
        ])

        run('mkdir %s && mkdir %s && touch %s/info.log' % (install_configs['paddlehub.path.install'], install_configs['paddlehub.path.log'], install_configs['paddlehub.path.log']))
        Tool.upload_file_fabric({
            '/configs/swooleyaf/python/paddlehub.json': ''.join([install_configs['paddlehub.path.install'], '/paddlehub.json']),
        })
        run('%s/bin/python3 -m pip install paddlepaddle -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com' % install_configs['python3.path.install'])
        run('%s/bin/python3 -m pip install paddlehub -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com' % install_configs['python3.path.install'])
