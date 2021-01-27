# -*- coding:utf-8 -*-
import click
from progressbar import *


def get_version(ctx, param, value):
    if not value or ctx.resilient_parsing:
        return
    click.echo('Version 1.0')
    ctx.exit()


@click.group()
@click.option('-v', '--version', is_flag=True, callback=get_version, expose_value=False, is_eager=True)
def main():
    pass


@main.command()
@click.option('-u', '--user', required=True, type=str, help="用户名")
@click.option('-p', '--password', required=True, type=str, help="密码")
@click.option('-t', '--type', required=True, default="phone", type=str, help="账户类型", show_default=True)
def add_user(user, password, type):
    click.echo(f"user:{user} password:{password} type:{type}")


@main.command()
@click.option('-t', '--type', required=True, type=click.Choice(['user', 'admin']))
@click.option('-p', '--password', prompt=True, hide_input=True, confirmation_prompt=True)
def set_password(type, password):
    click.echo(f"Your type:{type} password:{password}")


@main.command()
@click.confirmation_option(prompt='Are you sure you want to drop the db?')
def confirm_delete():
    click.echo("Dropped all tables!")

@main.command()
def color_text():
    click.secho('Hello World!', fg='green')
    click.secho('Some more text', bg='blue', fg='white')
    click.secho('ATTENTION', blink=True, bold=True)


all_process = {1: 'a', 2: 'b', 3: 'c', 4: 'd'}


@main.command()
def progress_bar():
    widgets = ['Progress: ', Percentage(), ' ', Bar('#'), ' ', Timer()]
    process_bar = ProgressBar(widgets=widgets, maxval=len(all_process)).start()
    # with click.progressbar(all_process) as bar:
    for key, val in all_process.items():
        time.sleep(key)
        process_bar.update(key)
        print()


if __name__ == '__main__':
    main()
