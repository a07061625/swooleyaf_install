# -*- coding:utf-8 -*-
import os

from jinstall.centos7.swooleyaf import *


def __sy_common(tag, params):
    sy_dict = sy_dict_get(tag)
    sy_dict['params'] = params
    sy_dict['params']['step1'] = int(params['step1'])
    sy_dict['params']['step2'] = int(params['step2'])
    sy_dict['params']['init'] = int(params['init'])
    const_project.PATH_ROOT = os.path.abspath('.')
    install_configs['path.package.local'] = const_project.PATH_ROOT
    role = sy_dict['role']
    env.roledefs[role] = ''
    return sy_dict


def sy_front(**params):
    sy_dict = __sy_common('front', params)
    sy_func = sy_dict['func']
    sy_func(sy_dict['params'])


def sy_backend(**params):
    sy_dict = __sy_common('backend', params)
    sy_func = sy_dict['func']
    sy_func(sy_dict['params'])


def sy_fb(**params):
    sy_dict = __sy_common('frontbackend', params)
    sy_func = sy_dict['func']
    sy_func(sy_dict['params'])
