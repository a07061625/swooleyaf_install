# -*- coding:utf-8 -*-
from fabric.api import env

from jinstall.constants.Project import Project

env.hosts = [
]

# 建议账号用root,避免权限问题
env.passwords = {
}

env.roledefs = {
}

const_project = Project()
const_project.ENV_DEV = 'dev'
const_project.ENV_PRODUCT = 'product'

install_configs = {}
