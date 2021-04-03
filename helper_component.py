# -*- coding:utf-8 -*-
import click

from jcomponent.db.ComponentMysql import *
from jcomponent.notify.DingTalk import *


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


@main.command()
def mysql_inception():
    """审计Mysql"""
    ComponentMysql.inception({})


@main.command()
@click.option('--file', required=True, type=str, help="通知内容文件")
def notify_dingtalk_robot(file):
    """钉钉机器人通知"""
    params = {
        'msg_file': file
    }
    DingTalk.send_robot(params)


if __name__ == '__main__':
    main()
