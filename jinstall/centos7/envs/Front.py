# -*- coding:utf-8 -*-
from jinstall.centos7.tools.SyCache import *
from jinstall.centos7.tools.SyJava import *
from jinstall.centos7.tools.SyJs import *
from jinstall.centos7.tools.SyLinux import *
from jinstall.centos7.tools.SyMq import *
from jinstall.centos7.tools.SyNginx import *
from jinstall.centos7.tools.SyPhp import *
from jinstall.centos7.tools.SyVersionControl import *
from jinstall.envs.SyBase import SyBase


class Front(SyBase):
    def __init__(self):
        super(Front, self).__init__()
        self._configs_profile = [
            '',
            "export CPPFLAGS='-I/usr/include -I/usr/local/libjpeg/include -I/usr/local/freetype/include -I/usr/local/zlib/include -I/usr/local/pcre/include -I/usr/local/jemalloc/include -I/usr/local/openssl/include -I/usr/local/openresty/luajit/include/luajit-2.1'",
            "export LDFLAGS='-L/usr/lib64 -L/usr/local/libjpeg/lib -L/usr/local/freetype/lib -L/usr/local/zlib/lib -L/usr/local/pcre/lib -L/usr/local/jemalloc/lib -L/usr/local/openssl/lib -L/usr/local/openresty/luajit/lib'",
            'export OPENSSL_ROOT_DIR=/usr/local/openssl',
            'export OPENSSL_CRYPTO_LIBRARY=/usr/local/openssl/lib',
            'export OPENSSL_INCLUDE_DIR=/usr/local/openssl/include',
            'export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/lib:/usr/lib64',
            'export NODE_HOME=/usr/local/nodejs',
            'export JAVA_HOME=/usr/java/jdk1.8.0',
            'export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar',
            'export PATH=\$PATH:/usr/local/bin:/usr/local/gcc/bin:/usr/local/git/bin:/usr/local/openresty/bin:\$NODE_HOME/bin:\$JAVA_HOME/bin:\$JAVA_HOME/jre/bin',
        ]
        self._ports = [
            '21/tcp',
            '22/tcp',
            '80/tcp',
            '443/tcp',
            '8983/tcp',
        ]
        self._steps = {
            1: SyLinux.init_system,
            2: SyLinux.install_oniguruma,
            3: SyLinux.install_openssl,
            4: SyLinux.install_cmake,
            5: SyLinux.install_denyhosts,
            6: SyVersionControl.install_git,
            7: SyLinux.install_zlib,
            8: SyLinux.install_nghttp2,
            9: SyLinux.install_jpeg,
            10: SyLinux.install_imagemagick,
            11: SyLinux.install_freetype,
            12: SyLinux.install_jemalloc,
            13: SyLinux.install_libmaxminddb,
            14: SyNginx.install_openresty,
            15: SyCache.install_memcache_server,
            16: SyCache.install_memcache_lib,
            17: SyMq.install_rabbit_lib,
            18: SyPhp.install_php7,
            19: SyJava.install_java,
            20: SyJs.install_nodejs
        }
