# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyJs:
    @staticmethod
    def install_nodejs(params: dict):
        """安装nodejs"""
        Tool.check_local_files([
            'resources/lang/js/node-v14.15.4-linux-x64.tar.xz',
        ])
        Tool.upload_file_fabric({
            '/resources/lang/js/node-v14.15.4-linux-x64.tar.xz': 'remote/node-v14.15.4-linux-x64.tar.xz',
        })

        with settings(warn_only=True):
            run('mkdir %s && mkdir %s' % (install_configs['node.path.log'], install_configs['node.forever.path.log']))

        with cd(install_configs['path.package.remote']):
            run('tar -xJf node-v14.15.4-linux-x64.tar.xz')
            run('mv node-v14.15.4-linux-x64/ /usr/local/nodejs')
            run('rm -rf node-v14.15.4-linux-x64.tar.xz')
            run('npm install -g nodemon forever && npm install -g cnpm --registry=https://registry.npm.taobao.org')
            run('npm config set registry https://registry.npm.taobao.org --global')
            run('npm config set disturl https://npm.taobao.org/dist --global')
