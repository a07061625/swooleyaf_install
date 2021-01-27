# -*- coding:utf-8 -*-
import os
import sys

import click

from configs_pro import *


def get_version(ctx, param, value):
    if not value or ctx.resilient_parsing:
        return
    click.echo('辅助管理脚本')
    click.echo('Version: 1.1')
    click.echo('Author: 姜伟')
    click.echo('公共依赖: click colorama progressbar')
    click.echo('环境安装依赖: fabric3')
    click.echo('自动化操作依赖: pyautogui')
    ctx.exit()


@click.group()
@click.option('-v', '--version', is_flag=True, callback=get_version, expose_value=False, is_eager=True)
def main():
    pass


def __check_packages(packages):
    total_packages = os.popen(python3Prefix + 'list').read()
    for name in packages:
        if name not in total_packages:
            click.secho('package ' + name + ' not install', fg='red')
            sys.exit()


def __sy_check(checks):
    __check_packages(['click', 'colorama', 'progressbar', 'Fabric3'])
    step1 = checks.get('step1', 0)
    step2 = checks.get('step2', 0)
    err_info = ''
    if step1 <= 0:
        err_info = '开始步骤必须大于0'
    elif step2 <= 0:
        err_info = '结束步骤必须大于0'
    elif step1 > step2:
        err_info = '开始步骤必须小于等于结束步骤'

    if len(err_info) > 0:
        click.secho(err_info, fg='red')
        sys.exit()


def __sy_handler(params):
    __sy_check(params)
    step1 = params.get('step1', 0)
    step2 = params.get('step2', 0)
    init = params.get('init', '-1')
    title = params.get('title', '')
    command = params.get('command', '')
    if init == '0':
        click.secho(f"开始安装{title} 开始步骤:{step1} 结束步骤:{step2} 不初始化系统", fg='green')
    else:
        click.secho(f"开始安装{title} 开始步骤:{step1} 结束步骤:{step2} 初始化系统", fg='green')
    os.system(command)


@main.command()
@click.option('--step1', default=1, type=int, help="开始步骤")
@click.option('--step2', default=9999, type=int, help="结束步骤")
@click.option('--init', default='1', type=click.Choice(['0', '1']), help="系统初始化标识 0:不初始化 1:初始化")
@click.option('--env', required=True, type=click.Choice(['dev', 'product']), help="环境类型 dev:开发环境 product:生产环境")
def sy_front(step1, step2, init, env):
    """安装前端环境"""
    params = {
        'step1': step1,
        'step2': step2,
        'init': init,
        'env': env,
        'title': '前端环境',
        'command': commandInstallPrefix + 'sy_front:step1=' + str(step1) + ',step2=' + str(step2) + ',init=' + init + ',env=' + env
    }
    __sy_handler(params)


@main.command()
@click.option('--step1', default=1, type=int, help="开始步骤")
@click.option('--step2', default=9999, type=int, help="结束步骤")
@click.option('--init', default='1', type=click.Choice(['0', '1']), help="系统初始化标识 0:不初始化 1:初始化")
@click.option('--env', required=True, type=click.Choice(['dev', 'product']), help="环境类型 dev:开发环境 product:生产环境")
def sy_backend(step1, step2, init, env):
    """安装后端环境"""
    params = {
        'step1': step1,
        'step2': step2,
        'init': init,
        'env': env,
        'title': '后端环境',
        'command': commandInstallPrefix + 'sy_backend:step1=' + str(step1) + ',step2=' + str(step2) + ',init=' + init + ',env=' + env
    }
    __sy_handler(params)


@main.command()
@click.option('--step1', default=1, type=int, help="开始步骤")
@click.option('--step2', default=9999, type=int, help="结束步骤")
@click.option('--init', default='1', type=click.Choice(['0', '1']), help="系统初始化标识 0:不初始化 1:初始化")
@click.option('--env', required=True, type=click.Choice(['dev', 'product']), help="环境类型 dev:开发环境 product:生产环境")
def sy_fb(step1, step2, init, env):
    """安装前后端混合环境"""
    params = {
        'step1': step1,
        'step2': step2,
        'init': init,
        'env': env,
        'title': '前后端混合环境',
        'command': commandInstallPrefix + 'sy_fb:step1=' + str(step1) + ',step2=' + str(step2) + ',init=' + init + ',env=' + env
    }
    __sy_handler(params)


if __name__ == '__main__':
    main()
