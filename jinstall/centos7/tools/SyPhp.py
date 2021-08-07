# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *
from jinstall.configs.base import *


class SyPhp:
    @staticmethod
    def install_php7(params: dict):
        """安装语言php7"""
        php_extension_dir = ''.join([install_configs['php7.path.install'], '/lib/php/extensions/no-debug-non-zts-20190902'])
        Tool.check_local_files([
            'configs/swooleyaf/php7/php-cli.ini',
            'configs/swooleyaf/php7/php-fpm-fcgi.ini',
            'configs/swooleyaf/php7/www.conf',
            'configs/swooleyaf/php7/php7-fpm.service',
            'resources/lang/php7/php-7.4.22.tar.gz',
            'resources/lang/php7/msgpack-2.1.2.tgz',
            'resources/lang/php7/redis-5.3.4.tgz',
            'resources/lang/php7/memcached-3.1.5.tgz',
            'resources/lang/php7/imagick-3.5.1.tgz',
            'resources/lang/php7/SeasLog-2.2.0.tgz',
            'resources/lang/php7/mongodb-1.10.0.tgz',
            'resources/lang/php7/yac-2.3.0.tgz',
            'resources/lang/php7/yaconf-1.1.0.tgz',
            'resources/lang/php7/yaf-3.3.3.tgz',
            'resources/lang/php7/swoole-4.6.2.tgz',
            'resources/lang/php7/runkit7-4.0.0a2.tgz',
            'resources/lang/php7/amqp-1.10.2.tgz',
            'resources/lang/php7/screw-plus.tgz',
            'resources/lang/php7/xdebug-3.0.2.tgz',
            'resources/lang/php7/swoole-tracker.tar.gz',
        ])
        run('yum -y install libxslt libxml2 libxml2-devel mysql-devel openldap openldap-devel gmp-devel')

        Tool.upload_file_fabric({
            '/resources/lang/php7/php-7.4.22.tar.gz': 'remote/php-7.4.22.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /tmp/swooleyaf && chmod 777 /tmp/swooleyaf')
            run('mkdir /tmp/xhprof && chmod 777 /tmp/xhprof')
            run('mkdir /home/configs/yaconf-cli')
            run('mkdir /home/configs/yaconf-fpm')
            run('mkdir /home/logs/seaslog-cli')
            run('mkdir /home/logs/seaslog-fpm')
            run('mkdir /home/logs/swoole')
            run('touch /home/logs/swoole/swoole.log')
            run('mkdir %s' % install_configs['php7.path.install'])
            run('tar -zxf php-7.4.22.tar.gz')
            run('cd php-7.4.22/ && ./configure --prefix=%s --exec-prefix=%s --bindir=%s/bin --sbindir=%s/sbin --includedir=%s/include --libdir=%s/lib/php --mandir=%s/php/man --with-config-file-path=%s/etc --with-mysql-sock=/usr/local/mysql/mysql.sock --with-zlib=/usr/local/zlib --with-mhash --with-openssl=/usr/local/openssl --with-iconv --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-xml --enable-pcntl --enable-bcmath --enable-mysqlnd --enable-sysvsem --with-mysqli --with-pdo-mysql --enable-shmop --enable-mbregex --enable-mbstring --enable-ftp --enable-sockets --with-xmlrpc --enable-soap --without-pear --without-sqlite3 --without-pdo-sqlite --without-gdbm --with-gettext --enable-session --with-curl --enable-opcache --enable-fpm --enable-fileinfo --with-gmp && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install'], install_configs['php7.path.install'], install_configs['php7.path.install'], install_configs['php7.path.install'], install_configs['php7.path.install'], install_configs['php7.path.install'], install_configs['php7.path.install']))

        php7_cli_ini_remote = ''.join([install_configs['php7.path.install'], '/etc/php-cli.ini'])
        php7_fpm_ini_remote = ''.join([install_configs['php7.path.install'], '/etc/php-fpm-fcgi.ini'])
        Tool.upload_file_fabric({
            '/configs/swooleyaf/php7/php-cli.ini': php7_cli_ini_remote,
            '/configs/swooleyaf/php7/php-fpm-fcgi.ini': php7_fpm_ini_remote,
        })
        run('echo -e "\nzend_extension=%s/opcache.so" >> %s' % (php_extension_dir, php7_cli_ini_remote), False)
        run('echo -e "\nzend_extension=%s/opcache.so" >> %s' % (php_extension_dir, php7_fpm_ini_remote), False)
        Tool.upload_file_fabric({
            '/configs/swooleyaf/php7/www.conf': ''.join([install_configs['php7.path.install'], '/etc/php-fpm.d/www.conf']),
            '/configs/swooleyaf/php7/php7-fpm.service': '/lib/systemd/system/php7-fpm.service',
        })
        run('chmod 754 /lib/systemd/system/php7-fpm.service')
        run('systemctl enable php7-fpm.service')

        php7_dir_remote = ''.join([install_configs['path.package.remote'], '/php-7.4.22'])
        with cd(php7_dir_remote):
            run('groupadd www')
            run('useradd -g www www -s /sbin/nologin')
            run('chown -R www /home/logs/seaslog-fpm')
            run('chgrp -R www /home/logs/seaslog-fpm')
            run('cp sapi/fpm/init.d.php-fpm /etc/init.d/php7-fpm')
            run('chmod +x /etc/init.d/php7-fpm')
            run('cp %s/etc/php-fpm.conf.default %s/etc/php-fpm.conf' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('cp -frp /usr/lib64/libldap* /usr/lib/')
            run('cd ext/ldap/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('cd ext/gd/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config --with-freetype --with-jpeg --disable-gd-jis-conv && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))

        # 扩展msgpack
        Tool.upload_file_fabric({
            '/resources/lang/php7/msgpack-2.1.2.tgz': 'remote/msgpack-2.1.2.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf msgpack-2.1.2.tgz')
            run('cd msgpack-2.1.2/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf msgpack-2.1.2/ && rm -rf msgpack-2.1.2.tgz')

        # 扩展redis
        Tool.upload_file_fabric({
            '/resources/lang/php7/redis-5.3.4.tgz': 'remote/redis-5.3.4.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/phpredis')
            run('tar -zxf redis-5.3.4.tgz')
            run('cd redis-5.3.4/ && %s/bin/phpize && ./configure --prefix=/usr/local/phpredis --with-php-config=%s/bin/php-config --enable-redis-msgpack && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf redis-5.3.4/ && rm -rf redis-5.3.4.tgz')

        # 扩展memcached
        Tool.upload_file_fabric({
            '/resources/lang/php7/memcached-3.1.5.tgz': 'remote/memcached-3.1.5.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf memcached-3.1.5.tgz')
            run('cd memcached-3.1.5/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config --enable-memcached --with-libmemcached-dir=/usr/local/libmemcached --enable-memcached-msgpack --disable-memcached-sasl && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf memcached-3.1.5/ && rm -rf memcached-3.1.5.tgz')

        # 扩展imgick
        Tool.upload_file_fabric({
            '/resources/lang/php7/imagick-3.5.1.tgz': 'remote/imagick-3.5.1.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/imagick')
            run('tar -zxf imagick-3.5.1.tgz')
            run('cd imagick-3.5.1/ && %s/bin/phpize && ./configure --prefix=/usr/local/imagick --with-php-config=%s/bin/php-config --with-imagick=/usr/local/imagemagick && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf imagick-3.5.1/ && rm -rf imagick-3.5.1.tgz')

        # 扩展SeasLog
        Tool.upload_file_fabric({
            '/resources/lang/php7/SeasLog-2.2.0.tgz': 'remote/SeasLog-2.2.0.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf SeasLog-2.2.0.tgz')
            run('cd SeasLog-2.2.0/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf SeasLog-2.2.0/ && rm -rf SeasLog-2.2.0.tgz')

        # 扩展mongodb
        Tool.upload_file_fabric({
            '/resources/lang/php7/mongodb-1.10.0.tgz': 'remote/mongodb-1.10.0.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf mongodb-1.10.0.tgz')
            run('cd mongodb-1.10.0/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf mongodb-1.10.0/ && rm -rf mongodb-1.10.0.tgz')

        # 扩展yac
        Tool.upload_file_fabric({
            '/resources/lang/php7/yac-2.3.0.tgz': 'remote/yac-2.3.0.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf yac-2.3.0.tgz')
            run('cd yac-2.3.0/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config --enable-msgpack && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf yac-2.3.0/ && rm -rf yac-2.3.0.tgz')

        # 扩展yaconf
        Tool.upload_file_fabric({
            '/resources/lang/php7/yaconf-1.1.0.tgz': 'remote/yaconf-1.1.0.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf yaconf-1.1.0.tgz')
            run('cd yaconf-1.1.0/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf yaconf-1.1.0/ && rm -rf yaconf-1.1.0.tgz')

        # 扩展yaf
        Tool.upload_file_fabric({
            '/resources/lang/php7/yaf-3.3.3.tgz': 'remote/yaf-3.3.3.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf yaf-3.3.3.tgz')
            run('cd yaf-3.3.3/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf yaf-3.3.3/ && rm -rf yaf-3.3.3.tgz')

        # 扩展swoole
        Tool.upload_file_fabric({
            '/resources/lang/php7/swoole-4.6.2.tgz': 'remote/swoole-4.6.2.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf swoole-4.6.2.tgz')
            run('cd swoole-4.6.2/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config --with-jemalloc-dir=/usr/local/jemalloc --enable-openssl --enable-http2 --enable-sockets && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf swoole-4.6.2/ && rm -rf swoole-4.6.2.tgz')

        # 扩展runkit7
        Tool.upload_file_fabric({
            '/resources/lang/php7/runkit7-4.0.0a2.tgz': 'remote/runkit7-4.0.0a2.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf runkit7-4.0.0a2.tgz')
            run('cd runkit7-4.0.0a2/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf runkit7-4.0.0a2/ && rm -rf runkit7-4.0.0a2.tgz')

        # 扩展amqp
        Tool.upload_file_fabric({
            '/resources/lang/php7/amqp-1.10.2.tgz': 'remote/amqp-1.10.2.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf amqp-1.10.2.tgz')
            run('cd amqp-1.10.2/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config --with-amqp --with-librabbitmq-dir=/usr/local/librabbitmq && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            run('rm -rf amqp-1.10.2/ && rm -rf amqp-1.10.2.tgz')

        # 扩展screw-plus(代码加密)
        Tool.upload_file_fabric({
            '/resources/lang/php7/screw-plus.tgz': 'remote/screw-plus.tgz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf screw-plus.tgz')
            run('cd screw-plus/ && %s/bin/phpize && ./configure --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
            if install_configs['php7.screw.tool'] == '1':
                run('cd screw-plus/tools && make && mv screw %s/bin/' % install_configs['php7.path.install'])
            run('rm -rf screw-plus/ && rm -rf screw-plus.tgz')

        # # 扩展xdebug
        # Tool.upload_file_fabric({
        #     '/resources/lang/php7/xdebug-3.0.2.tgz': 'remote/xdebug-3.0.2.tgz',
        # })
        # with cd(install_configs['path.package.remote']):
        #     run('tar -zxf xdebug-3.0.2.tgz')
        #     run('cd xdebug-3.0.2/ && %s/bin/phpize && ./configure --enable-xdebug --with-php-config=%s/bin/php-config && make && make install' % (install_configs['php7.path.install'], install_configs['php7.path.install']))
        #     run('rm -rf xdebug-3.0.2/ && rm -rf xdebug-3.0.2.tgz')
        # # 扩展swoole_tracker
        # Tool.upload_file_fabric({
        #     '/resources/lang/php7/swoole-tracker.tar.gz': 'remote/swoole-tracker.tar.gz',
        # })
        # with cd(install_configs['path.package.remote']):
        #     run('tar -zxf swoole-tracker.tar.gz && mv swoole-tracker/swoole_tracker72.so %s/swoole_tracker.so' % php_extension_dir, False)
        #     run('rm -rf swoole-tracker/ && rm -rf swoole-tracker.tar.gz')
