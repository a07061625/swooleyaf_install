# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyMq:
    @staticmethod
    def install_rabbit_lib(params: dict):
        """安装消息队列rabbit依赖"""
        Tool.check_local_files([
            'resources/mq/rabbit/rabbitmq-c-0.8.0.tar.gz',
        ])

        Tool.upload_file_fabric({
            '/resources/mq/rabbit/rabbitmq-c-0.8.0.tar.gz': 'remote/rabbitmq-c-0.8.0.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir %s' % install_configs['librabbitmq.path.install'])
            run('tar -zxf rabbitmq-c-0.8.0.tar.gz')
            run('cd rabbitmq-c-0.8.0/ && ./configure --prefix=%s && make && make install' % install_configs['librabbitmq.path.install'])
            run('rm -rf rabbitmq-c-0.8.0/ && rm -rf rabbitmq-c-0.8.0.tar.gz')

    @staticmethod
    def install_rabbit_server(params: dict):
        """安装消息队列rabbit"""
        Tool.check_local_files([
            'resources/mq/rabbit/rabbitmq-server-generic-unix-3.7.7.tar.xz',
            'configs/swooleyaf/rabbitmq/rabbitmq.conf',
            'configs/swooleyaf/rabbitmq/rabbitmq-env.conf',
        ])

        Tool.upload_file_fabric({
            '/resources/mq/rabbit/rabbitmq-server-generic-unix-3.7.7.tar.xz': 'remote/rabbitmq-server-generic-unix-3.7.7.tar.xz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -xJf rabbitmq-server-generic-unix-3.7.7.tar.xz')
            run('mv rabbitmq_server-3.7.7/ %s' % install_configs['rabbitmq.path.install'])
            run('rm -rf rabbitmq-server-generic-unix-3.7.7.tar.xz')

        run('echo -e "\n%s rabbit-cluster-01" >> /etc/hosts' % (env.host), False)

        Tool.upload_file_fabric({
            '/configs/swooleyaf/rabbitmq/rabbitmq.conf': ''.join([install_configs['rabbitmq.path.install'], '/etc/rabbitmq/rabbitmq.conf']),
            '/configs/swooleyaf/rabbitmq/rabbitmq-env.conf': ''.join([install_configs['rabbitmq.path.install'], '/etc/rabbitmq/rabbitmq-env.conf']),
        })

        service_remote_rabbit = '/lib/systemd/system/rabbitmq-server.service'
        run('touch %s' % service_remote_rabbit, False)
        run('echo -e "[Unit]" >> %s' % (service_remote_rabbit), False)
        run('echo -e "Description=RabbitMQ broker" >> %s' % (service_remote_rabbit), False)
        run('echo -e "After=syslog.target network.target" >> %s' % (service_remote_rabbit), False)
        run('echo -e "[Service]" >> %s' % (service_remote_rabbit), False)
        run('echo -e "Type=forking" >> %s' % (service_remote_rabbit), False)
        run('echo -e "WorkingDirectory=%s" >> %s' % (install_configs['rabbitmq.path.install'], service_remote_rabbit), False)
        run('echo -e "ExecStart=%s/sbin/rabbitmq-server -detached" >> %s' % (install_configs['rabbitmq.path.install'], service_remote_rabbit), False)
        run('echo -e "ExecStop=%s/sbin/rabbitmqctl stop" >> %s' % (install_configs['rabbitmq.path.install'], service_remote_rabbit), False)
        run('echo -e "PrivateTmp=true" >> %s' % (service_remote_rabbit), False)
        run('echo -e "[Install]" >> %s' % (service_remote_rabbit), False)
        run('echo -e "WantedBy=multi-user.target" >> %s' % (service_remote_rabbit), False)
        run('chmod 754 %s' % service_remote_rabbit)

        # 需在服务器上配置如下内容:
        # vim /usr/local/rabbitmq/sbin/rabbitmq-defaults
        #     ...
        #     ERL_DIR=/usr/erlang/bin/
        #     export HOME=/usr/local/rabbitmq/
        #     ...

    @staticmethod
    def install_mqtt_server(params: dict):
        """安装消息队列mqtt"""
        Tool.check_local_files([
            'resources/mq/mqtt/c-ares-1.14.0.tar.gz',
            'resources/mq/mqtt/mosquitto-1.6.9.tar.gz',
            'configs/swooleyaf/mosquitto/config.mk',
            'configs/swooleyaf/mosquitto/mosquitto.conf',
            'configs/swooleyaf/mosquitto/mosquitto.service',
        ])
        Tool.upload_file_fabric({
            '/resources/mq/mqtt/c-ares-1.14.0.tar.gz': 'remote/c-ares-1.14.0.tar.gz',
            '/resources/mq/mqtt/mosquitto-1.6.9.tar.gz': 'remote/mosquitto-1.6.9.tar.gz',
        })

        with cd(install_configs['path.package.remote']):
            run('yum install -y libuuid-devel')
            run('tar -zxf c-ares-1.14.0.tar.gz')
            run('mv c-ares-1.14.0/ /usr/local/c-ares')
            run('cd /usr/local/c-ares && ./configure && make && make install')
            run('rm -rf c-ares-1.14.0.tar.gz')
            run('mkdir /home/logs/mosquitto && touch /home/logs/mosquitto/mosquitto.log && touch /home/logs/mosquitto/mosquitto.pid')
            run('tar -zxf mosquitto-1.6.9.tar.gz')
            run('mv mosquitto-1.6.9/ /usr/local/mosquitto')
            run('rm -rf /usr/local/mosquitto/config.mk')
            Tool.upload_file_fabric({
                '/configs/swooleyaf/mosquitto/config.mk': '/usr/local/mosquitto/config.mk',
            })
            # 如果/etc/ld.so.conf中没有/usr/local/lib,需要将/usr/local/lib添加进该文件然后再调用命令 ldconfig
            run('cd /usr/local/mosquitto && make && make install && ldconfig')
            run('rm -rf mosquitto-1.6.9.tar.gz')

            service_mosquitto = '/lib/systemd/system/mosquitto.service'
            Tool.upload_file_fabric({
                '/configs/swooleyaf/mosquitto/mosquitto.conf': '/etc/mosquitto/mosquitto.conf',
                '/configs/swooleyaf/mosquitto/mosquitto.service': service_mosquitto,
            })
            run('chmod 754 %s' % service_mosquitto)
            run('systemctl enable mosquitto')
