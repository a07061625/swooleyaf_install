# -*- coding:utf-8 -*-
from jinstall.centos7.tools.SyCache import *
from jinstall.centos7.tools.SyCpp import *
from jinstall.centos7.tools.SyDb import *
from jinstall.centos7.tools.SyErlang import *
from jinstall.centos7.tools.SyJava import *
from jinstall.centos7.tools.SyJs import *
from jinstall.centos7.tools.SyLinux import *
from jinstall.centos7.tools.SyMq import *
from jinstall.centos7.tools.SyNginx import *
from jinstall.centos7.tools.SyPhp import *
from jinstall.centos7.tools.SyVersionControl import *
from jinstall.envs.SyBase import SyBase


class FrontBackend(SyBase):
    def __init__(self):
        super(FrontBackend, self).__init__()
        self._configs_profile = [
            '',
            'ulimit -t unlimited',
            'ulimit -v unlimited',
            'ulimit -m unlimited',
            "export CPPFLAGS='-I/usr/include -I/usr/local/libjpeg/include -I/usr/local/freetype/include -I/usr/local/zlib/include -I/usr/local/pcre/include -I/usr/local/jemalloc/include -I/usr/local/openssl/include -I/usr/local/openresty/luajit/include/luajit-2.1'",
            "export LDFLAGS='-L/usr/lib64 -L/usr/local/libjpeg/lib -L/usr/local/freetype/lib -L/usr/local/zlib/lib -L/usr/local/pcre/lib -L/usr/local/jemalloc/lib -L/usr/local/openssl/lib -L/usr/local/openresty/luajit/lib'",
            'export OPENSSL_ROOT_DIR=/usr/local/openssl',
            'export OPENSSL_CRYPTO_LIBRARY=/usr/local/openssl/lib',
            'export OPENSSL_INCLUDE_DIR=/usr/local/openssl/include',
            'export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib:/usr/lib64',
            'export ETCDCTL_API=3',
            'export NODE_HOME=/usr/local/nodejs',
            'export JAVA_HOME=/usr/java/jdk1.8.0',
            'export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar',
            'export ER_LANG=/usr/erlang',
            'export PATH=\$PATH:/usr/local/bin:/usr/local/gcc/bin:/usr/local/git/bin:/usr/local/openresty/bin:\$ER_LANG/bin:\$NODE_HOME/bin:\$JAVA_HOME/bin:\$JAVA_HOME/jre/bin',
        ]
        self._ports = [
            '21/tcp',
            '22/tcp',
            '80/tcp',
            '443/tcp',
            '2379/tcp',
            '3306/tcp',
            '8983/tcp',
            ''.join([install_configs['redis.port'], '/tcp']),
            ''.join([install_configs['mongodb.port'], '/tcp']),
        ]
        self._steps = {
            1: SyLinux.init_system,
            2: SyLinux.install_oniguruma,
            3: SyLinux.install_openssl,
            4: SyLinux.install_cmake,
            5: SyLinux.install_gcc,
            6: SyLinux.install_libtool,
            7: SyLinux.install_denyhosts,
            8: SyErlang.install_erlang,
            9: SyVersionControl.install_git,
            10: SyLinux.install_zlib,
            11: SyLinux.install_nghttp2,
            12: SyLinux.install_jpeg,
            13: SyLinux.install_imagemagick,
            14: SyLinux.install_freetype,
            15: SyLinux.install_jemalloc,
            16: SyLinux.install_libmaxminddb,
            17: SyNginx.install_openresty,
            18: SyCache.install_memcache_server,
            19: SyCache.install_memcache_lib,
            20: SyMq.install_rabbit_lib,
            21: SyPhp.install_php7,
            22: SyCache.install_redis,
            23: SyJava.install_java,
            24: SyLinux.install_inotify,
            25: SyLinux.install_etcd,
            26: SyJs.install_nodejs,
            27: SyDb.install_mongodb,
            28: SyCpp.install_boost,
            29: SyDb.install_mysql
        }
