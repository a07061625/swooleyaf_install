# -*- coding:utf-8 -*-
from jinstall.centos7.tools.SyCache import *
from jinstall.centos7.tools.SyCpp import *
from jinstall.centos7.tools.SyDb import *
from jinstall.centos7.tools.SyErlang import *
from jinstall.centos7.tools.SyLinux import *
from jinstall.centos7.tools.SyLua import *
from jinstall.centos7.tools.SyMq import *
from jinstall.centos7.tools.SyNginx import *
from jinstall.centos7.tools.SyPhp import *
from jinstall.centos7.tools.SyVersionControl import *
from jinstall.envs.SyBase import SyBase


class Backend(SyBase):
    def __init__(self):
        super(Backend, self).__init__()
        self._configs_profile = [
            '',
            'ulimit -t unlimited',
            'ulimit -v unlimited',
            'ulimit -m unlimited',
            "export CPPFLAGS='-I/usr/include -I/usr/local/libjpeg/include -I/usr/local/zlib/include -I/usr/local/pcre/include -I/usr/local/jemalloc/include -I/usr/local/openssl/include -I/usr/local/openresty/luajit/include/luajit-2.1'",
            "export LDFLAGS='-L/usr/lib64 -L/usr/local/libjpeg/lib -L/usr/local/zlib/lib -L/usr/local/pcre/lib -L/usr/local/jemalloc/lib -L/usr/local/openssl/lib -L/usr/local/openresty/luajit/lib'",
            'export CRYPTO_DIR=/usr/local/openssl',
            'export OPENSSL_DIR=/usr/local/openssl',
            'export OPENSSL_ROOT_DIR=/usr/local/openssl',
            'export OPENSSL_CRYPTO_LIBRARY=/usr/local/openssl/lib',
            'export OPENSSL_INCLUDE_DIR=/usr/local/openssl/include',
            'export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib:/usr/lib64:/usr/local/glibc/lib',
            'export ETCDCTL_API=3',
            'export ER_LANG=/usr/erlang',
            'export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:/usr/local/lib64/pkgconfig',
            'export PATH=\$PATH:/usr/local/bin:/usr/local/cmake/bin:/usr/local/git/bin:/usr/local/openresty/bin:/usr/local/glibc/bin:\$ER_LANG/bin',
        ]
        self._ports = [
            '21/tcp',
            '22/tcp',
            '80/tcp',
            '443/tcp',
            '2379/tcp',
            '3306/tcp',
            ''.join([install_configs['redis.port'], '/tcp']),
            ''.join([install_configs['mongodb.port'], '/tcp']),
        ]
        self._steps = {
            1: SyLinux.init_system,
            2: SyLinux.install_libstdc,
            3: SyLinux.install_oniguruma,
            4: SyLinux.install_openssl,
            5: SyLinux.install_cmake,
            6: SyLinux.install_gcc,
            7: SyLinux.install_libtool,
            8: SyLinux.install_make,
            9: SyLinux.install_glibc,
            10: SyLinux.install_denyhosts,
            11: SyErlang.install_erlang,
            12: SyVersionControl.install_git,
            13: SyLinux.install_zlib,
            14: SyLinux.install_pcre,
            15: SyLinux.install_libzip,
            16: SyLinux.install_nghttp2,
            17: SyLinux.install_jpeg,
            18: SyLinux.install_imagemagick,
            19: SyLinux.install_font,
            20: SyLinux.install_jemalloc,
            21: SyLinux.install_libmaxminddb,
            22: SyNginx.install_openresty,
            23: SyLua.install_luarocks,
            24: SyCache.install_memcache_server,
            25: SyCache.install_memcache_lib,
            26: SyMq.install_rabbit_lib,
            27: SyPhp.install_php7,
            28: SyCache.install_redis,
            29: SyLinux.install_inotify,
            30: SyLinux.install_etcd,
            31: SyDb.install_mongodb,
            32: SyCpp.install_boost,
            33: SyDb.install_mysql
        }
