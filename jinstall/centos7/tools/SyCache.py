# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyCache:
    @staticmethod
    def install_redis(params: dict):
        """
        安装缓存redis
        注: 默认账号:default 密码:yjbn15su
        """
        Tool.check_local_files([
            'resources/cache/redis/redis-6.2.0.tar.gz',
            'resources/cache/redis/redisearch.so',
            'resources/cache/redis/redisgears.so',
            'resources/cache/redis/redisgraph.so',
            'resources/cache/redis/redistimeseries.so',
            'resources/cache/redis/redisgears-dependencies.linux-centos7-x64.1.0.5.tar',
            'configs/swooleyaf/redis/redis',
            'configs/swooleyaf/redis/redis.conf',
            'configs/swooleyaf/redis/users.acl',
        ])

        Tool.upload_file_fabric({
            '/resources/cache/redis/redis-6.2.0.tar.gz': 'remote/redis-6.2.0.tar.gz',
            '/resources/cache/redis/redisearch.so': 'remote/redisearch.so',
            '/resources/cache/redis/redisgears.so': 'remote/redisgears.so',
            '/resources/cache/redis/redisgraph.so': 'remote/redisgraph.so',
            '/resources/cache/redis/redistimeseries.so': 'remote/redistimeseries.so',
            '/resources/cache/redis/redisgears-dependencies.linux-centos7-x64.1.0.5.tar': 'remote/redisgears-dependencies.linux-centos7-x64.1.0.5.tar',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir %s' % install_configs['redis.path.install'])
            run('mkdir %s/modules' % install_configs['redis.path.install'])
            run('mkdir %s' % install_configs['redis.path.log'])
            run('mkdir /etc/redis')
            run('touch %s/redis.log' % install_configs['redis.path.log'])
            run('chmod a+x redisearch.so && mv redisearch.so %s/modules/' % install_configs['redis.path.install'])
            run('chmod a+x redisgears.so && mv redisgears.so %s/modules/' % install_configs['redis.path.install'])
            run('chmod a+x redisgraph.so && mv redisgraph.so %s/modules/' % install_configs['redis.path.install'])
            run('chmod a+x redistimeseries.so && mv redistimeseries.so %s/modules/' % install_configs['redis.path.install'])
            run('mkdir -p /var/opt/redislabs/modules/rg')
            run('tar --warning=no-timestamp -xf redisgears-dependencies.linux-centos7-x64.1.0.5.tar')
            run('mv python3_1.0.5/ /var/opt/redislabs/modules/rg/')
            run('rm -rf redisgears-dependencies.linux-centos7-x64.1.0.5.tar')
            run('tar -zxf redis-6.2.0.tar.gz')
            run('cd redis-6.2.0/ && make && make PREFIX=/usr/local/redis install')
            run('rm -rf redis-6.2.0/ && rm -rf redis-6.2.0.tar.gz')
            redis_service_remote = '/etc/init.d/redis'
            Tool.upload_file_fabric({
                '/configs/swooleyaf/redis/redis': redis_service_remote,
            })
            run('sed -i "6iREDISPORT=%s" %s' % (install_configs['redis.port'], redis_service_remote), False)
            run('chmod +x %s' % redis_service_remote)
            redis_conf_remote = ''.join(['/etc/redis/', install_configs['redis.port'], '.conf'])
            Tool.upload_file_fabric({
                '/configs/swooleyaf/redis/users.acl': ''.join([install_configs['redis.path.install'], '/users.acl']),
                '/configs/swooleyaf/redis/redis.conf': redis_conf_remote,
            })
            run('echo -e "bind 127.0.0.1 %s" >> %s' % (env.host, redis_conf_remote), False)
            run('echo -e "pidfile /var/run/redis_%s.pid" >> %s' % (install_configs['redis.port'], redis_conf_remote), False)
            run('echo -e "port %s" >> %s' % (install_configs['redis.port'], redis_conf_remote), False)
            run('echo -e "logfile \"%s/redis.log\"" >> %s' % (install_configs['redis.path.log'], redis_conf_remote), False)
            run('echo -e "dir %s" >> %s' % (install_configs['redis.path.log'], redis_conf_remote), False)
            run('systemctl daemon-reload')
            run('chkconfig redis on')

    @staticmethod
    def install_redis_insight(params: dict):
        """安装redis客户端工具-RedisInsight"""
        Tool.check_local_files([
            'resources/cache/redis/redisinsight-linux64-1.6.3',
        ])

        with cd(install_configs['path.package.remote']):
            run('mkdir %s' % install_configs['redis.insight.path.install'])
            run('mkdir %s/data' % install_configs['redis.insight.path.install'])
            run('mkdir %s/bin' % install_configs['redis.insight.path.install'])
            run('mkdir %s' % install_configs['redis.insight.path.log'])
            run('echo "export REDISINSIGHT_HOST=%s" >> /etc/profile' % install_configs['redis.insight.host'], False)
            run('echo "export REDISINSIGHT_PORT=%s" >> /etc/profile' % install_configs['redis.insight.port'], False)
            run('echo "export REDISINSIGHT_HOME_DIR=%s/data" >> /etc/profile' % install_configs['redis.insight.path.install'], False)
            run('echo "export LOG_DIR=%s" >> /etc/profile' % install_configs['redis.insight.path.log'], False)
            redis_insight_remote = ''.join([install_configs['redis.insight.path.install'], '/bin/redisinsight'])
            Tool.upload_file_fabric({
                '/resources/cache/redis/redisinsight-linux64-1.6.3': redis_insight_remote,
            })
            run('chmod +x %s' % redis_insight_remote)

    @staticmethod
    def install_memcache_server(params: dict):
        """安装缓存memcache"""
        Tool.check_local_files([
            'resources/cache/memcache/memcached-1.5.12.tar.gz',
        ])

        Tool.upload_file_fabric({
            '/resources/cache/memcache/memcached-1.5.12.tar.gz': 'remote/memcached-1.5.12.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('yum -y install libevent libevent-devel')
            run('mkdir %s' % install_configs['memcached.path.install'])
            run('tar -zxf memcached-1.5.12.tar.gz')
            run('cd memcached-1.5.12/ && ./configure --prefix=%s && make && make install' % install_configs['memcached.path.install'])
            run('rm -rf memcached-1.5.12/ && rm -rf memcached-1.5.12.tar.gz')

    @staticmethod
    def install_memcache_lib(params: dict):
        """安装缓存memcache依赖"""
        Tool.check_local_files([
            'resources/cache/memcache/libmemcached-1.0.18.tar.gz',
        ])

        Tool.upload_file_fabric({
            '/resources/cache/memcache/libmemcached-1.0.18.tar.gz': 'remote/libmemcached-1.0.18.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir %s' % install_configs['libmemcached.path.install'])
            run('tar -zxf libmemcached-1.0.18.tar.gz')
            run('cd libmemcached-1.0.18/ && ./configure --prefix=%s --with-memcached && make && make install' % install_configs['libmemcached.path.install'])
            run('rm -rf libmemcached-1.0.18/ && rm -rf libmemcached-1.0.18.tar.gz')
