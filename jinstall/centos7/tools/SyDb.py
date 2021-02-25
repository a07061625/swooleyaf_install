# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyDb:
    @staticmethod
    def install_mysql(params: dict):
        """安装数据库mysql"""
        Tool.check_local_files([
            'resources/db/mysql/mysql-boost-8.0.21.tar.gz',
            'configs/swooleyaf/mysql/my.cnf',
            'configs/swooleyaf/mysql/mysql.service',
        ])
        run('rm -rf /etc/my.cnf')
        run('rpm -qa | grep mariadb | xargs -n1 -I {} rpm -e --nodeps {}')
        run('yum install -y ncurses-devel patchelf')
        run('groupadd mysql && useradd -g mysql mysql -s /sbin/nologin')
        run('mkdir /usr/local/mysql/data && mkdir /home/logs/mysql && touch /home/logs/mysql/error.log && chown -R mysql:mysql /home/logs/mysql')

        Tool.upload_file_fabric({
            '/resources/db/mysql/mysql-boost-8.0.21.tar.gz': 'remote/mysql-boost-8.0.21.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf mysql-boost-8.0.21.tar.gz')
            run('cd mysql-8.0.21/ && cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/usr/local/mysql/data -DSYSCONFDIR=/etc -DMYSQL_UNIX_ADDR=/usr/local/mysql/mysql.sock -DWITH_BOOST=/usr/local/boost_1_72 -DWITH_SSL=/usr/local/openssl -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DFORCE_INSOURCE_BUILD=1 -DDEFAULT_CHARSET=utf8mb4 -DDEFAULT_COLLATION=utf8mb4_general_ci -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 && make && make install')
            run('echo "/usr/local/mysql/lib" > /etc/ld.so.conf.d/mysql.conf && ldconfig && chown -R mysql:mysql /usr/local/mysql')
            run('rm -rf mysql-8.0.21/ && rm -rf mysql-boost-8.0.21.tar.gz')

        mysql_service_remote = '/lib/systemd/system/mysql.service'
        Tool.upload_file_fabric({
            '/configs/swooleyaf/mysql/my.cnf': '/etc/my.cnf',
            '/configs/swooleyaf/mysql/mysql.service': mysql_service_remote,
        })
        run('chmod 754 %s' % mysql_service_remote)
        run('systemctl enable mysql')

        # 后续设置mysql登录帐号和密码以及授权需要登录服务器设置

    @staticmethod
    def install_mongodb(params: dict):
        """安装数据库mongodb"""
        Tool.check_local_files([
            'resources/db/mongodb/mongodb-linux-x86_64-rhel70-3.6.20.tgz',
            'configs/swooleyaf/mongodb/mongodb.conf',
            'configs/swooleyaf/mongodb/crontab.txt',
        ])
        run('echo "never" > /sys/kernel/mm/transparent_hugepage/enabled && echo "never" > /sys/kernel/mm/transparent_hugepage/defrag')

        Tool.upload_file_fabric({
            '/resources/db/mongodb/mongodb-linux-x86_64-rhel70-3.6.20.tgz': 'remote/mongodb-linux-x86_64-rhel70-3.6.20.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf mongodb-linux-x86_64-rhel70-3.6.20.tgz')
            run('mv mongodb-linux-x86_64-rhel70-3.6.20/ %s' % install_configs['mongodb.path.install'])
            run('mkdir %s/data && mkdir %s/data/db && mkdir %s/data/logs' % (install_configs['mongodb.path.install'], install_configs['mongodb.path.install'], install_configs['mongodb.path.install']))
            run('rm -rf mongodb-linux-x86_64-rhel70-3.6.20.tgz')

        mongodb_conf_remote = ''.join([install_configs['mongodb.path.install'], '/mongodb.conf'])
        Tool.upload_file_fabric({
            '/configs/swooleyaf/mongodb/mongodb.conf': mongodb_conf_remote,
        })
        run('echo -e "bind_ip = %s" >> %s' % (env.host, mongodb_conf_remote), False)
        run('echo -e "port = %s" >> %s' % (install_configs['mongodb.port'], mongodb_conf_remote), False)
        run('echo -e "dbpath = %s/data/db" >> %s' % (install_configs['mongodb.path.install'], mongodb_conf_remote), False)
        run('echo -e "logpath = %s/data/logs/mongodb.log" >> %s' % (install_configs['mongodb.path.install'], mongodb_conf_remote), False)

        # crontab任务对应的txt文件结束必须按回车键另起一行
        mongo_cron_remote = ''.join([install_configs['path.package.remote'], '/crontab.txt'])
        Tool.upload_file_fabric({
            '/configs/swooleyaf/mongodb/crontab.txt': mongo_cron_remote,
        })
        run('crontab %s' % mongo_cron_remote)
        run('rm -rf %s' % mongo_cron_remote)

    @staticmethod
    def install_cassandra(params: dict):
        """安装数据库cassandra"""
        Tool.check_local_files([
            'resources/db/cassandra/apache-cassandra-3.11.4-bin.tar.gz',
            'configs/swooleyaf/cassandra/cassandra.yaml',
        ])
        cassandra_remote = ''.join([install_configs['path.package.remote'], '/apache-cassandra-3.11.4-bin.tar.gz'])
        Tool.upload_file_fabric({
            '/resources/db/cassandra/apache-cassandra-3.11.4-bin.tar.gz': cassandra_remote,
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir %s' % install_configs['cassandra.path.log'])
            run('tar -zxf apache-cassandra-3.11.4-bin.tar.gz')
            run('mv apache-cassandra-3.11.4/ %s' % install_configs['cassandra.path.install'])
            run('rm -rf %s' % cassandra_remote)

        cassandra_config_remote = ''.join([install_configs['path.package.remote'], '/cassandra.yaml'])
        Tool.upload_file_fabric({
            '/configs/swooleyaf/cassandra/cassandra.yaml': cassandra_config_remote,
        })
        with cd(install_configs['path.package.remote']):
            run('rm -rf %s/conf/cassandra.yaml' % install_configs['cassandra.path.install'])
            run('mv %s %s/conf/' % (cassandra_config_remote, install_configs['cassandra.path.install']))

    @staticmethod
    def install_goinception(params: dict):
        """安装mysql审计工具goInception"""
        Tool.check_local_files([
            'resources/db/mysql/audit/goInception-linux-amd64-v1.2.3.tar.gz',
            'configs/swooleyaf/mysql/goinception.toml',
        ])
        Tool.upload_file_fabric({
            '/resources/db/mysql/audit/goInception-linux-amd64-v1.2.3.tar.gz': 'remote/goInception-linux-amd64-v1.2.3.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir %s && mkdir %s && touch %s/goinception.log' % (install_configs['goinception.path.install'], install_configs['goinception.path.log'], install_configs['goinception.path.log']))
            run('tar -zxf goInception-linux-amd64-v1.2.3.tar.gz -C %s' % install_configs['goinception.path.install'])
            run('rm -rf goInception-linux-amd64-v1.2.3.tar.gz')
            Tool.upload_file_fabric({
                '/configs/swooleyaf/mysql/goinception.toml': ''.join([install_configs['goinception.path.install'], '/config/config.toml']),
            })

    @staticmethod
    def install_prometheus(params: dict):
        """安装数据库prometheus"""
        Tool.check_local_files([
            'resources/db/cassandra/apache-cassandra-3.11.4-bin.tar.gz',
            'configs/swooleyaf/cassandra/cassandra.yaml',
        ])
        cassandra_remote = ''.join([install_configs['path.package.remote'], '/apache-cassandra-3.11.4-bin.tar.gz'])
        Tool.upload_file_fabric({
            '/resources/db/cassandra/apache-cassandra-3.11.4-bin.tar.gz': cassandra_remote,
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir %s' % install_configs['cassandra.path.log'])
            run('tar -zxf apache-cassandra-3.11.4-bin.tar.gz')
            run('mv apache-cassandra-3.11.4/ %s' % install_configs['cassandra.path.install'])
            run('rm -rf %s' % cassandra_remote)
