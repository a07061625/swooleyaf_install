# -*- coding:utf-8 -*-
from jinstall.centos7.envs.Front import *
from jinstall.centos7.envs.Backend import *
from jinstall.centos7.envs.FrontBackend import *


sy_dicts = {
    'front': {
        'role': 'syfront'
    },
    'backend': {
        'role': 'sybackend'
    },
    'frontbackend': {
        'role': 'syfb'
    }
}


@roles(sy_dicts['front']['role'])
def env_front(params):
    obj = Front()
    obj.install(params)


@roles(sy_dicts['backend']['role'])
def env_backend(params):
    obj = Backend()
    obj.install(params)


@roles(sy_dicts['frontbackend']['role'])
def env_front_backend(params):
    obj = FrontBackend()
    obj.install(params)


sy_dicts['front']['func'] = env_front
sy_dicts['backend']['func'] = env_backend
sy_dicts['frontbackend']['func'] = env_front_backend


def sy_dict_get(tag):
    sy_dict = sy_dicts.get(tag, '')
    if not isinstance(sy_dict, dict):
        print('环境标识不存在')
        sys.exit()

    return sy_dict
