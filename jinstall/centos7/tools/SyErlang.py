# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyErlang:
    # 配置erlang环境
    @staticmethod
    def install_erlang(params: dict):
        """安装语言erlang"""
        Tool.check_local_files([
            'resources/lang/erlang/otp_src_21.0.tar.gz',
        ])

        # 不要升级pcre,用系统自带的,否则安装报错
        Tool.upload_file_fabric({
            '/resources/lang/erlang/otp_src_21.0.tar.gz': 'remote/otp_src_21.0.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('yum -y install ncurses-devel unixODBC-devel')
            run('mkdir /usr/erlang')
            run('tar -zxf otp_src_21.0.tar.gz')
            run('cd otp_src_21.0/ && ./configure --prefix=/usr/erlang --with-ssl -enable-threads -enable-smmp-support -enable-kernel-poll --enable-hipe --without-javac && make && make install')
