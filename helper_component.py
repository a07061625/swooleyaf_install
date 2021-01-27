# -*- coding:utf-8 -*-
import os
import sys

import click

from configs_pro import *
from jcomponent.db.ComponentMysql import *


def get_version(ctx, param, value):
    if not value or ctx.resilient_parsing:
        return
    click.echo('组件管理脚本')
    click.echo('Version: 1.1')
    click.echo('Author: 姜伟')
    click.echo('公共依赖: click')
    ctx.exit()


@click.group()
@click.option('-v', '--version', is_flag=True, callback=get_version, expose_value=False, is_eager=True)
def main():
    pass


def __check(params):
    total_packages = os.popen(python3Prefix + 'list').read()
    for name in params['packages']:
        if name not in total_packages:
            click.secho('package ' + name + ' not install', fg='red')
            sys.exit()


@main.command()
def mysql_inception():
    """审计Mysql"""
    check_params = {
        'packages': ['click', 'PyMySQL', 'prettytable', 'colorama'],
    }
    __check(check_params)
    ComponentMysql.inception({})


if __name__ == '__main__':
    main()
