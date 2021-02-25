# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyMonitor:
    @staticmethod
    def install_netdata(params: dict):
        """安装netdata"""
        Tool.check_local_files([
            'resources/monitor/netdata/kickstart-static64.sh',
            'resources/monitor/netdata/netdata-v1.29.3.gz.run',
            'resources/monitor/netdata/sha256sums.txt',
        ])
        Tool.upload_file_fabric({
            '/resources/monitor/netdata/kickstart-static64.sh': 'remote/kickstart-static64.sh',
            '/resources/monitor/netdata/netdata-v1.29.3.gz.run': 'remote/netdata-v1.29.3.gz.run',
            '/resources/monitor/netdata/sha256sums.txt': 'remote/sha256sums.txt',
        })
        with cd(install_configs['path.package.remote']):
            run('chmod a+x kickstart-static64.sh && mv kickstart-static64.sh /tmp/')
            run('mv netdata-v1.29.3.gz.run /tmp/')
            run('mv sha256sums.txt /tmp/')
            # 弹出确认框选YES即可
            run('cd /tmp && bash /tmp/kickstart-static64.sh --local-files /tmp/netdata-v1.29.3.gz.run /tmp/sha256sums.txt')
            run('rm -rf /tmp/kickstart-static64.sh')
            run('rm -rf /tmp/netdata-v1.29.3.gz.run')
            run('rm -rf /tmp/sha256sums.txt')
            run('echo 1 >/sys/kernel/mm/ksm/run')
            run('echo 1000 >/sys/kernel/mm/ksm/sleep_millisecs')
            run('systemctl start netdata')
