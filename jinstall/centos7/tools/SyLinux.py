# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyLinux:
    @staticmethod
    def init_system(params: dict):
        """初始化操作系统"""
        # 添加环境配置
        for system_env in iter(params['envs']):
            run('echo "%s" >> /etc/profile' % system_env, False)
        run('source /etc/profile')

        if params['init'] == 1:
            run('yum -y install lrzsz bison bison-devel gdb vim zip nss gcc gcc-c++ net-tools wget lsof unzip bzip2 curl-devel libcurl-devel patch zlib-devel epel-release perl-ExtUtils-MakeMaker expat-devel gettext-devel openssl-devel iproute autoconf automake make cmake libtool libtool-ltdl libtool-ltdl-devel libpng freetype libjpeg-turbo libjpeg-turbo-devel libjpeg-turbo-utils libpng-devel freetype-devel')
            run('wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo')
            run('yum -y update')
            run('yum -y install re2c htop')
            run('systemctl enable firewalld')
            run('systemctl start firewalld')
            run('systemctl enable crond')
            run('systemctl start crond')
            with settings(warn_only=True):
                run('mkdir /home/configs')
                run('mkdir /home/logs')
                run('mkdir /usr/local/mysql')
                run('mkdir %s' % install_configs['path.package.remote'])

        # 开放防火墙端口
        for system_port in iter(params['ports']):
            run('firewall-cmd --zone=public --add-port=%s --permanent' % system_port, False)
        run('firewall-cmd --reload')

    @staticmethod
    def install_libstdc(params: dict):
        """安装libstdc"""
        Tool.check_local_files([
            'resources/linux/libstdc++.so.6.0.26',
        ])

        stdc_remote = '/usr/lib64/libstdc++.so.6.0.26'
        Tool.upload_file_fabric({
            '/resources/linux/libstdc++.so.6.0.26': stdc_remote,
        })
        with cd(install_configs['path.package.remote']):
            run('chmod a+x %s' % stdc_remote)
            run('mv /usr/lib64/libstdc++.so.6 /usr/lib64/libstdc++.so.6.bak')
            run('ln -s %s /usr/lib64/libstdc++.so.6' % stdc_remote)

    @staticmethod
    def install_pcre(params: dict):
        """安装pcre"""
        Tool.check_local_files([
            'resources/linux/pcre-8.44.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/pcre-8.44.tar.gz': 'remote/pcre-8.44.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/pcre')
            run('tar -zxf pcre-8.44.tar.gz')
            run('cd pcre-8.44/ && ./configure --prefix=/usr/local/pcre --enable-utf --enable-unicode-properties --enable-jit --with-gnu-ld && make && make install && echo "/usr/local/pcre/lib" >> /etc/ld.so.conf && ldconfig')
            run('rpm -e --nodeps pcre')
            run('rm -rf pcre-8.44/ && rm -rf pcre-8.44.tar.gz')

    @staticmethod
    def install_zlib(params: dict):
        """安装zlib"""
        Tool.check_local_files([
            'resources/linux/zlib-1.2.11.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/zlib-1.2.11.tar.gz': 'remote/zlib-1.2.11.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/zlib')
            run('tar -zxf zlib-1.2.11.tar.gz')
            run('cd zlib-1.2.11/ && ./configure --prefix=/usr/local/zlib && make && make install && echo "/usr/local/zlib/lib" >> /etc/ld.so.conf && ldconfig')
            run('rm -rf zlib-1.2.11/ && rm -rf zlib-1.2.11.tar.gz')

    @staticmethod
    def install_openssl(params: dict):
        """安装openssl"""
        Tool.check_local_files([
            'resources/linux/openssl-1.1.1f.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/openssl-1.1.1f.tar.gz': 'remote/openssl-1.1.1f.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mv /usr/bin/openssl /usr/bin/openssl.old')
            run('mv /usr/include/openssl /usr/include/openssl.old')
            run('rm -rf /etc/ssl')
            run('mkdir /usr/local/openssl')
            run('tar -zxf openssl-1.1.1f.tar.gz')
            run('cd openssl-1.1.1f/ && ./config shared --prefix=/usr/local/openssl --openssldir=/usr/local/openssl && make && make install')
            run('rm -rf openssl-1.1.1f/ && rm -rf openssl-1.1.1f.tar.gz')
            run('rm -rf /usr/lib64/libcrypto.so && rm -rf /lib64/libcrypto.so && rm -rf /lib64/libssl.so')
            run('ln -s /usr/local/openssl/lib/libcrypto.so /usr/lib64/libcrypto.so')
            run('ln -s /usr/local/openssl/lib/libssl.so /usr/lib64/libssl.so')
            run('ln -s /usr/local/openssl/bin/openssl /usr/local/bin/openssl')
            run('ln -s /usr/local/openssl/include/openssl /usr/include/openssl')
            run('echo "/usr/local/openssl/lib" >> /etc/ld.so.conf && ldconfig')

    @staticmethod
    def install_nghttp2(params: dict):
        """安装nghttp2"""
        Tool.check_local_files([
            'resources/linux/nghttp2-1.26.0.tar.bz2',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/nghttp2-1.26.0.tar.bz2': 'remote/nghttp2-1.26.0.tar.bz2',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -xf nghttp2-1.26.0.tar.bz2')
            run('mv nghttp2-1.26.0/ /usr/local/nghttp2')
            run('cd /usr/local/nghttp2 && ./configure && make && make install')
            run('rm -rf nghttp2-1.26.0.tar.bz2')

    @staticmethod
    def install_jpeg(params: dict):
        """安装jpeg"""
        Tool.check_local_files([
            'resources/linux/jpegsrc.v9.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/jpegsrc.v9.tar.gz': 'remote/jpegsrc.v9.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/libjpeg')
            run('tar -zxf jpegsrc.v9.tar.gz')
            run('cd jpeg-9/ && ./configure --prefix=/usr/local/libjpeg --enable-shared --enable-static && make && make install && echo "/usr/local/libjpeg/lib" >> /etc/ld.so.conf && ldconfig')
            run('rm -rf /lib64/libjpeg.so')
            run('rm -rf jpeg-9/ && rm -rf jpegsrc.v9.tar.gz')

    @staticmethod
    def install_imagemagick(params: dict):
        """安装ImageMagick"""
        Tool.check_local_files([
            'resources/linux/ImageMagick-7.0.8-24.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/ImageMagick-7.0.8-24.tar.gz': 'remote/ImageMagick-7.0.8-24.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/imagemagick')
            run('tar -zxf ImageMagick-7.0.8-24.tar.gz')
            run('cd ImageMagick-7.0.8-24/ && ./configure --prefix=/usr/local/imagemagick --enable-shared --enable-lzw --without-perl --with-modules && make && make install')
            run('rm -rf ImageMagick-7.0.8-24/ && rm -rf ImageMagick-7.0.8-24.tar.gz')

    @staticmethod
    def install_font(params: dict):
        """安装freetype"""
        Tool.check_local_files([
            'resources/linux/fribidi-1.0.9.tar.xz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/fribidi-1.0.9.tar.xz': 'remote/fribidi-1.0.9.tar.xz',
        })
        with cd(install_configs['path.package.remote']):
            run('yum -y install libxml2 libxml2-devel gd-devel')
            run('mkdir /usr/local/fribidi')
            run('xz -d fribidi-1.0.9.tar.xz && tar -xf fribidi-1.0.9.tar')
            run('cd fribidi-1.0.9/ && ./configure --prefix=/usr/local/fribidi && make && make install && echo "/usr/local/fribidi/lib" >> /etc/ld.so.conf && ldconfig')
            run('rm -rf fribidi-1.0.9/ && rm -rf fribidi-1.0.9.tar')

    @staticmethod
    def install_jemalloc(params: dict):
        """安装jemalloc"""
        Tool.check_local_files([
            'resources/linux/jemalloc-4.5.0.tar.bz2',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/jemalloc-4.5.0.tar.bz2': 'remote/jemalloc-4.5.0.tar.bz2',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/jemalloc')
            run('tar -xjf jemalloc-4.5.0.tar.bz2')
            run('cd jemalloc-4.5.0/ && ./configure --prefix=/usr/local/jemalloc --with-jemalloc-prefix=je_ && make -j 4 && make install')
            run('rm -rf jemalloc-4.5.0/ && rm -rf jemalloc-4.5.0.tar.bz2')
            run('echo "/usr/local/jemalloc/lib" > /etc/ld.so.conf.d/usr_local_lib.conf && ldconfig')

    @staticmethod
    def install_cmake(params: dict):
        """安装cmake"""
        Tool.check_local_files([
            'resources/linux/cmake-3.18.5-Linux-x86_64.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/cmake-3.18.5-Linux-x86_64.tar.gz': 'remote/cmake-3.18.5-Linux-x86_64.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('yum -y remove cmake')
            run('tar -zxf cmake-3.18.5-Linux-x86_64.tar.gz')
            run('mv cmake-3.18.5-Linux-x86_64/ /usr/local/cmake')
            run('rm -rf cmake-3.18.5-Linux-x86_64.tar.gz')

    @staticmethod
    def install_gcc(params: dict):
        """安装gcc,需要4G以上的内存,CPU数要多,否则编译时间会比较长"""
        # Tool.check_local_files([
        #     'resources/linux/gcc-9.3.0.tar.gz',
        # ])
        # Tool.upload_file_fabric({
        #     '/resources/linux/gcc-9.3.0.tar.gz': 'remote/gcc-9.3.0.tar.gz',
        # })
        # with cd(install_configs['path.package.remote']):
        #     run('mkdir /usr/local/gcc')
        #     run('tar -zxf gcc-9.3.0.tar.gz')
        #     run('cd gcc-9.3.0/ && ./contrib/download_prerequisites && ./configure --prefix=/usr/local/gcc --enable-bootstrap --enable-checking=release --enable-languages=c,c++ --disable-multilib && make -j4 && make install && yum –y remove gcc')
        #     gcc_gdb_py = str(run('find /usr/lib -maxdepth 1 -name "libstdc*.py"'))
        #     if len(gcc_gdb_py) > 0:
        #         run('rm -rf %s' % gcc_gdb_py)
        #     run('rm -rf /lib64/libstdc++.so*')
        #     run('ln -s /usr/local/gcc/include/ /usr/include/gcc && ln -s /usr/local/gcc/bin/c++ /usr/bin/ && ln -s /usr/local/gcc/bin/gcc /usr/bin/gcc && ln -s /usr/local/gcc/bin/gcc /usr/bin/cc && rm -rf /usr/lib64/libstdc++.so.6 && cp /usr/local/gcc/lib64/libstdc++.so /usr/lib64/ && echo "/usr/local/gcc/lib64" >> /etc/ld.so.conf.d/gcc.conf && ldconfig')
        #     run('rm -rf gcc-9.3.0/ && rm -rf gcc-9.3.0.tar.gz')
        run('yum -y remove gcc')
        run('yum -y install centos-release-scl')
        run('yum -y install devtoolset-9-gcc*')
        run('scl enable devtoolset-9 bash')
        run('echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile')

    @staticmethod
    def install_make(params: dict):
        """安装make"""
        Tool.check_local_files([
            'resources/linux/make-4.2.1.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/make-4.2.1.tar.gz': 'remote/make-4.2.1.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf make-4.2.1.tar.gz')
            run('cd make-4.2.1/ && mkdir build && cd build/ && ../configure --prefix=/usr && sh build.sh && make install')
            run('rm -rf make-4.2.1/ && rm -rf make-4.2.1.tar.gz')

    @staticmethod
    def install_glibc(params: dict):
        """安装glibc"""
        Tool.check_local_files([
            'resources/linux/glibc-2.29.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/glibc-2.29.tar.gz': 'remote/glibc-2.29.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf glibc-2.29.tar.gz')
            run('cd glibc-2.29/ && mkdir build && cd build/ && ../configure --prefix=/usr --disable-profile --enable-add-ons && make')
            # 忽略错误ld: cannot find -lnss_test2
            with settings(warn_only=True):
                run('cd glibc-2.29/build/ && make install')
            run('rm -rf glibc-2.29/ && rm -rf glibc-2.29.tar.gz')

    @staticmethod
    def install_inotify(params: dict):
        """安装inotify"""
        Tool.check_local_files([
            'resources/linux/inotify-tools-3.14.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/inotify-tools-3.14.tar.gz': 'remote/inotify-tools-3.14.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('mkdir /usr/local/inotify')
            run('tar -zxf inotify-tools-3.14.tar.gz')
            run('cd inotify-tools-3.14/ && ./configure --prefix=/usr/local/inotify && make && make install')
            run('rm -rf inotify-tools-3.14/ && rm -rf inotify-tools-3.14.tar.gz')
            run('mkdir /usr/local/inotify/symodules')
            run('touch /usr/local/inotify/symodules/change_service.txt')

    @staticmethod
    def install_etcd(params: dict):
        """安装etcd"""
        Tool.check_local_files([
            'resources/service-discovery/etcd/etcd-v3.2.7-linux-amd64.tar.gz',
        ])
        Tool.upload_file_fabric({
            '/resources/service-discovery/etcd/etcd-v3.2.7-linux-amd64.tar.gz': 'remote/etcd-v3.2.7-linux-amd64.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf etcd-v3.2.7-linux-amd64.tar.gz')
            run('mv etcd-v3.2.7-linux-amd64/ %s' % install_configs['etcd.path.install'])
            run('cp %s/etcd* /usr/local/bin' % install_configs['etcd.path.install'])
            run('rm -rf etcd-v3.2.7-linux-amd64.tar.gz')

    @staticmethod
    def install_ftp(params: dict):
        """安装ftp"""
        Tool.check_local_files([
            'configs/swooleyaf/ftp/vftpuser.txt',
            'configs/swooleyaf/ftp/vsftpd',
            'configs/swooleyaf/ftp/vsftpd.conf',
        ])
        run('yum -y install pam pam-devel db4 de4-devel db4-uitls db4-tcl vsftpd')
        run('useradd vsftpd -s /sbin/nologin')
        ftp_user_remote = '/etc/vsftpd/vftpuser.txt'
        Tool.upload_file_fabric({
            '/configs/swooleyaf/ftp/vftpuser.txt': ftp_user_remote,
        })
        run('echo "" >> %s' % ftp_user_remote, False)
        run('db_load -T -t hash -f %s /etc/vsftpd/vftpuser.db' % ftp_user_remote)
        ftpd_remote = '/etc/pam.d/vsftpd'
        run('mv %s /etc/pam.d/vsftpd.back' % ftpd_remote)
        Tool.upload_file_fabric({
            '/configs/swooleyaf/ftp/vsftpd': ftpd_remote,
        })
        run('touch /etc/vsftpd/chroot_list')
        run('mkdir /etc/vsftpd/vsftpd_user_conf')
        run('echo "local_root=/home/jw" > /etc/vsftpd/vsftpd_user_conf/jw')
        ftp_conf_remote = '/etc/vsftpd/vsftpd.conf'
        run('mv %s /etc/vsftpd/vsftpd.conf.back' % ftp_conf_remote)
        Tool.upload_file_fabric({
            '/configs/swooleyaf/ftp/vsftpd.conf': ftp_conf_remote,
        })
        run('systemctl enable vsftpd')
        run('systemctl restart vsftpd')

    @staticmethod
    def install_denyhosts(params: dict):
        """安装denyhosts"""
        Tool.check_local_files([
            'resources/linux/DenyHosts-2.6.tar.gz',
            'configs/swooleyaf/denyhosts/denyhosts.cfg',
        ])
        Tool.upload_file_fabric({
            '/resources/linux/DenyHosts-2.6.tar.gz': 'remote/DenyHosts-2.6.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf DenyHosts-2.6.tar.gz')
            run('cd DenyHosts-2.6/ && python setup.py install && cd /usr/share/denyhosts/ && cp daemon-control-dist denyhosts && chown root denyhosts && chmod 700 denyhosts && ln -s /usr/share/denyhosts/denyhosts /etc/init.d')
            run('rm -rf DenyHosts-2.6/ && rm -rf DenyHosts-2.6.tar.gz')

        Tool.upload_file_fabric({
            '/configs/swooleyaf/denyhosts/denyhosts.cfg': '/usr/share/denyhosts/denyhosts.cfg',
        })
        run('chkconfig denyhosts on && service denyhosts start')

    @staticmethod
    def install_oniguruma(params: dict):
        """
        安装oniguruma,php7.4的正则表达式依赖库
        """
        Tool.check_local_files([
            'resources/linux/oniguruma-6.9.5.tar.gz',
        ])

        Tool.upload_file_fabric({
            '/resources/linux/oniguruma-6.9.5.tar.gz': 'remote/oniguruma-6.9.5.tar.gz',
        })

        with cd(install_configs['path.package.remote']):
            run('yum -y install libtool')
            run('tar -zxf oniguruma-6.9.5.tar.gz')
            run('cd oniguruma-6.9.5/ && ./autogen.sh && ./configure --prefix=/usr --libdir=/lib64 && make && make install')
            run('rm -rf oniguruma-6.9.5/ && rm -rf oniguruma-6.9.5.tar.gz')

    @staticmethod
    def install_libmaxminddb(params: dict):
        """
        安装libmaxminddb,nginx的geoip2模块需要
        """
        Tool.check_local_files([
            'resources/linux/libmaxminddb-1.5.0.tar.gz',
        ])

        Tool.upload_file_fabric({
            '/resources/linux/libmaxminddb-1.5.0.tar.gz': 'remote/libmaxminddb-1.5.0.tar.gz',
        })

        with cd(install_configs['path.package.remote']):
            run('tar -zxf libmaxminddb-1.5.0.tar.gz')
            run('cd libmaxminddb-1.5.0/ && ./configure && make && make install && echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr_local_lib.conf && ldconfig')
            run('rm -rf libmaxminddb-1.5.0/ && rm -rf libmaxminddb-1.5.0.tar.gz')

    @staticmethod
    def install_libtool(params: dict):
        """
        安装libtool
        """
        Tool.check_local_files([
            'resources/linux/libtool-2.4.6.tar.gz',
        ])

        Tool.upload_file_fabric({
            '/resources/linux/libtool-2.4.6.tar.gz': 'remote/libtool-2.4.6.tar.gz',
        })

        with cd(install_configs['path.package.remote']):
            run('tar -zxf libtool-2.4.6.tar.gz')
            run('cd libtool-2.4.6/ && ./configure --prefix=/usr && make && make install')
            run('rm -rf libtool-2.4.6/ && rm -rf libtool-2.4.6.tar.gz')

    @staticmethod
    def install_goaccess(params: dict):
        """安装goaccess-web日志处理器"""
        Tool.check_local_files([
            'resources/linux/goaccess-1.4.5.tar.gz',
            'configs/swooleyaf/nginx/nginx2goaccess.sh',
        ])

        remote_goaccess = '/usr/local/goaccess'
        Tool.upload_file_fabric({
            '/resources/linux/goaccess-1.4.5.tar.gz': 'remote/goaccess-1.4.5.tar.gz',
            '/configs/swooleyaf/nginx/nginx2goaccess.sh': 'remote/nginx2goaccess.sh',
        })
        with cd(install_configs['path.package.remote']):
            run('yum -y install glib2 glib2-devel ncurses ncurses-devel')
            run('mkdir %s' % remote_goaccess)
            run('tar -zxf goaccess-1.4.5.tar.gz')
            run('cd goaccess-1.4.5/ && ./configure --prefix=/usr/local/goaccess --enable-utf8 --with-getline && make && make install')
            run('rm -rf goaccess-1.4.5/ && rm -rf goaccess-1.4.5.tar.gz')
            run('chmod a+x nginx2goaccess.sh')
            run('mv nginx2goaccess.sh %s/bin/nginx2goaccess.sh' % remote_goaccess)
