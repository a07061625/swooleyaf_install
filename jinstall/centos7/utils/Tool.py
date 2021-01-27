# -*- coding:utf-8 -*-
import os
import sys

from fabric.api import *

from jinstall.configs.swooleyaf_pro import install_configs


class Tool:
    @staticmethod
    def check_local_files(files: list):
        """检测本地文件是否存在"""
        for file_name in iter(files):
            file_path = ''.join([install_configs['path.package.local'], '/', file_name])
            if not os.path.isfile(file_path):
                print(file_name + ' not exist')
                sys.exit()

    @staticmethod
    def upload_file_fabric(files_map: dict):
        """fabric上传文件"""
        for k, v in files_map.items():
            file_local = ''.join([install_configs['path.package.local'], k])
            if v.startswith('remote'):
                file_remote = ''.join([install_configs['path.package.remote'], v.lstrip('remote')])
            else:
                file_remote = v
            put(file_local, file_remote)
