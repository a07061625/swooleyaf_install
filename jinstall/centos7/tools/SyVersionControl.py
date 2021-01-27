# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyVersionControl:
    @staticmethod
    def install_git(params: dict):
        """安装git"""
        Tool.check_local_files([
            'resources/version-control/git/git-2.25.1.tar.gz',
            'resources/version-control/git/git-lfs',
        ])
        run('yum -y remove git')
        with settings(warn_only=True):
            run('mkdir /usr/local/git')

        Tool.upload_file_fabric({
            '/resources/version-control/git/git-2.25.1.tar.gz': 'remote/git-2.25.1.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf git-2.25.1.tar.gz')
            run('cd git-2.25.1/ && ./configure --prefix=/usr/local/git && make all && make install && cd ../ && rm -rf git-2.25.1/ && rm -rf git-2.25.1.tar.gz')
            run('git config --global user.name "%s"' % install_configs['git.user.name'])
            run('git config --global user.email "%s"' % install_configs['git.user.email'])

        Tool.upload_file_fabric({
            '/resources/version-control/git/git-lfs': '/usr/local/git/bin',
        })
        run('chmod a+x /usr/local/git/bin/git-lfs')

    @staticmethod
    def install_gitea(params: dict):
        """安装gitea"""
        Tool.check_local_files([
            'resources/version-control/git/gitea-1.12.4-linux-amd64',
        ])

        run('mkdir %s' % install_configs['gitea.path.install'])
        Tool.upload_file_fabric({
            '/resources/version-control/git/gitea-1.12.4-linux-amd64': ''.join([install_configs['gitea.path.install'], '/gitea']),
        })
        run('chmod a+x %s/gitea' % install_configs['gitea.path.install'])

        service_remote_gitea = '/lib/systemd/system/gitea.service'
        run('touch %s' % service_remote_gitea, False)
        run('echo -e "[Unit]" >> %s' % (service_remote_gitea), False)
        run('echo -e "Description=gitea" >> %s' % (service_remote_gitea), False)
        run('echo -e "[Service]" >> %s' % (service_remote_gitea), False)
        run('echo -e "User=root" >> %s' % (service_remote_gitea), False)
        run('echo -e "ExecStart=%s/gitea web >%s/log/console.log 2>&1" >> %s' % (install_configs['gitea.path.install'], install_configs['gitea.path.install'], service_remote_gitea), False)
        run('echo -e "Restart=on-abort" >> %s' % (service_remote_gitea), False)
        run('echo -e "[Install]" >> %s' % (service_remote_gitea), False)
        run('echo -e "WantedBy=multi-user.target" >> %s' % (service_remote_gitea), False)
        run('chmod 754 %s' % service_remote_gitea)
        run('systemctl enable gitea')
