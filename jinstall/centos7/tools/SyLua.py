# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyLua:
    # 配置lua环境
    @staticmethod
    def install_lua(params: dict):
        """安装语言lua"""
        Tool.check_local_files([
            'resources/lang/lua/LuaJIT-2.1.0-beta3.tar.gz',
        ])

        # 当前语言包已将Makefile中的PREFIX由/usr/local替换成/usr/local/luajit
        Tool.upload_file_fabric({
            '/resources/lang/lua/LuaJIT-2.1.0-beta3.tar.gz': 'remote/LuaJIT-2.1.0-beta3.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir %s' % install_configs['lua.path.install'])
            run('tar -zxf LuaJIT-2.1.0-beta3.tar.gz')
            run('cd LuaJIT-2.1.0-beta3/ && make install && cd %s/bin && ln -s luajit-2.1.0-beta3 luajit && echo "%s/lib" >> /etc/ld.so.conf && ldconfig' % (install_configs['lua.path.install'], install_configs['lua.path.install']))
            run('rm -rf LuaJIT-2.1.0-beta3/ && rm -rf LuaJIT-2.1.0-beta3.tar.gz')

    @staticmethod
    def install_luarocks(params: dict):
        """安装luarocks"""
        Tool.check_local_files([
            'resources/lang/lua/luarocks-3.3.1.tar.gz',
        ])

        Tool.upload_file_fabric({
            '/resources/lang/lua/luarocks-3.3.1.tar.gz': 'remote/luarocks-3.3.1.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('yum -y install libyaml libyaml-devel')
            run('mkdir %s' % install_configs['luarocks.path.install'])
            run('tar -zxf luarocks-3.3.1.tar.gz')
            run('cd luarocks-3.3.1/ && ./configure --prefix=%s --lua-suffix=jit --with-lua=%s --with-lua-include=%s/include/luajit-2.1 && make build && make install' % (install_configs['luarocks.path.install'], install_configs['lua.path.install'], install_configs['lua.path.install']))
            run('rm -rf luarocks-3.3.1/ && rm -rf luarocks-3.3.1.tar.gz')
