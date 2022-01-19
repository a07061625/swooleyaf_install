# -*- coding:utf-8 -*-
from jinstall.centos7.utils.Tool import *


class SyNginx:
    @staticmethod
    def install_openresty(params: dict):
        """安装openresty"""
        Tool.check_local_files([
            'resources/linux/zlib-1.2.11.tar.gz',
            'resources/nginx/libunwind-1.1.tar.gz',
            'resources/nginx/gperftools-2.1.tar.gz',
            'resources/nginx/lualib.zip',
            'resources/nginx/data/geoip2.tar.gz',
            'resources/nginx/modules/module_brotli.tar.gz',
            'resources/nginx/modules/module_cache_purge_2.3.tar.gz',
            'resources/nginx/modules/module_http_flv.zip',
            'resources/nginx/modules/module_iconv.zip',
            'resources/nginx/modules/module_lua_kong_0.0.6.tar.gz',
            'resources/nginx/modules/module_vts_0.1.18.tar.gz',
            'resources/nginx/modules/module_naxsi_1.1a.zip',
            'resources/nginx/modules/module_ct_1.3.2.zip',
            'resources/nginx/modules/module_pagespeed_1.13.35.2.zip',
            'resources/nginx/modules/module_geoip2_3.3.tar.gz',
            'resources/nginx/modules/module_substitutions_filter_0.6.4.tar.gz',
            'resources/nginx/openresty-1.15.8.3.tar.gz',
            'configs/swooleyaf/nginx/context_http/conf.server',
            'configs/swooleyaf/nginx/context_http/default.conf',
            'configs/swooleyaf/nginx/context_http/vts.conf',
            'configs/swooleyaf/nginx/context_http/api.conf_demo',
            'configs/swooleyaf/nginx/context_http/api.server',
            'configs/swooleyaf/nginx/context_http/api.upstream',
            'configs/swooleyaf/nginx/context_http/api_static.conf_demo',
            'configs/swooleyaf/nginx/context_http/front.conf_demo',
            'configs/swooleyaf/nginx/context_http/front.server',
            'configs/swooleyaf/nginx/context_http/front.upstream',
            'configs/swooleyaf/nginx/context_http/front_static.conf_demo',
            'configs/swooleyaf/nginx/context_http/rtmp.conf_demo',
            'configs/swooleyaf/nginx/context_http/rtmp_api.conf_demo',
            'configs/swooleyaf/nginx/context_http/naxsi_core.rules',
            'configs/swooleyaf/nginx/context_http/rtmp_stat.conf',
            'configs/swooleyaf/nginx/context_http/locations/domain_common.location',
            'configs/swooleyaf/nginx/context_http/locations/domain_outer_api.location',
            'configs/swooleyaf/nginx/context_http/locations/domain_outer_common.location',
            'configs/swooleyaf/nginx/context_http/locations/domain_outer_front.location',
            'configs/swooleyaf/nginx/context_http/locations/domain_static_base.location',
            'configs/swooleyaf/nginx/context_http/locations/domain_static_common.location',
            'configs/swooleyaf/nginx/context_http/locations/https_cert.location',
            'configs/swooleyaf/nginx/context_http/locations/mirror_monitor.location',
            'configs/swooleyaf/nginx/context_http/locations/naxsi_config.location',
            'configs/swooleyaf/nginx/context_http/locations/naxsi_forbidden.location',
            'configs/swooleyaf/nginx/context_http/locations/pagespeed_admin.location',
            'configs/swooleyaf/nginx/context_http/locations/pagespeed_admin_global.location',
            'configs/swooleyaf/nginx/context_http/locations/pagespeed_common.location',
            'configs/swooleyaf/nginx/context_http/locations/pagespeed_server.location',
            'configs/swooleyaf/nginx/context_http/locations/proxy_api_common.location',
            'configs/swooleyaf/nginx/context_http/locations/proxy_api_http.location',
            'configs/swooleyaf/nginx/context_http/locations/proxy_api_websocket.location',
            'configs/swooleyaf/nginx/context_http/locations/proxy_common.location',
            'configs/swooleyaf/nginx/context_http/locations/proxy_static.location',
            'configs/swooleyaf/nginx/context_http/locations/server_register.location',
            'configs/swooleyaf/nginx/context_stream/conf.server',
            'configs/swooleyaf/nginx/context_stream/proxy_rpc.server',
            'configs/swooleyaf/nginx/context_stream/a01_order.conf_demo',
            'configs/swooleyaf/nginx/context_stream/a01_services.conf_demo',
            'configs/swooleyaf/nginx/context_stream/a01_user.conf_demo',
            'configs/swooleyaf/nginx/context_stream/a01_api.conf_demo',
            'configs/swooleyaf/nginx/context_stream/a01_content.conf_demo',
            'configs/swooleyaf/nginx/context_rtmp/tv.conf_demo',
            'configs/swooleyaf/nginx/certs/dhparam.pem',
            'configs/swooleyaf/nginx/certs/fake.crt',
            'configs/swooleyaf/nginx/certs/fake.key',
            'configs/swooleyaf/nginx/certs/tls_session_ticket.key',
            'configs/swooleyaf/nginx/passwd/pagespeed',
            'configs/swooleyaf/nginx/nginx.conf',
            'configs/swooleyaf/nginx/nginx.service',
        ])
        run('mkdir %s && mkdir %s/pagespeed' % (install_configs['openresty.path.log'], install_configs['openresty.path.log']))
        run('mkdir %s && mkdir %s/certs && mkdir %s/scts && mkdir %s/modules && mkdir %s/passwd' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'], install_configs['openresty.path.configs'], install_configs['openresty.path.configs'], install_configs['openresty.path.configs']))
        run('mkdir %s/context_http && mkdir %s/context_http/locations && mkdir %s/context_rtmp && mkdir %s/context_stream' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'], install_configs['openresty.path.configs'], install_configs['openresty.path.configs']))
        run('mkdir %s/cache_cgi && mkdir %s/cache && mkdir %s/cache/pagespeed' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'], install_configs['openresty.path.configs']))
        run('mkdir %s/temp_cgi && mkdir %s/temp && mkdir %s/temp/pagespeed' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'], install_configs['openresty.path.configs']))
        run('mkdir %s/data && mkdir %s/data/geoip2' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs']))
        run('yum -y install gd-devel')

        Tool.upload_file_fabric({
            '/resources/nginx/libunwind-1.1.tar.gz': 'remote/libunwind-1.1.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf libunwind-1.1.tar.gz')
            run('cd libunwind-1.1/ && CFLAGS=-fPIC ./configure --prefix=/usr && make CFLAGS=-fPIC && make CFLAGS=-fPIC install')
            run('rm -rf libunwind-1.1/ && rm -rf libunwind-1.1.tar.gz')

        Tool.upload_file_fabric({
            '/resources/nginx/gperftools-2.1.tar.gz': 'remote/gperftools-2.1.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf gperftools-2.1.tar.gz')
            run('cd gperftools-2.1/ && ./configure --prefix=/usr --enable-frame-pointers && make && make install && ldconfig')
            run('rm -rf gperftools-2.1/ && rm -rf gperftools-2.1.tar.gz')
            run('mkdir /tmp/tcmalloc && chmod 0777 /tmp/tcmalloc')

        Tool.upload_file_fabric({
            '/resources/nginx/lualib.zip': 'remote/lualib.zip',
        })
        with cd(install_configs['path.package.remote']):
            run('unzip -q lualib.zip')
            run('mv lualib/ %s/lualib' % install_configs['openresty.path.configs'])
            run('rm -rf lualib.zip')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_cache_purge_2.3.tar.gz': 'remote/module_cache_purge_2.3.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf module_cache_purge_2.3.tar.gz')
            run('mv module_cache_purge_2.3/ %s/modules/cache_purge' % install_configs['openresty.path.configs'])
            run('rm -rf module_cache_purge_2.3.tar.gz')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_brotli.tar.gz': 'remote/module_brotli.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf module_brotli.tar.gz')
            run('mv module_brotli/ %s/modules/brotli' % install_configs['openresty.path.configs'])
            run('rm -rf module_brotli.tar.gz')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_http_flv.zip': 'remote/module_http_flv.zip',
        })
        with cd(install_configs['path.package.remote']):
            run('unzip -q module_http_flv.zip')
            run('mv module_http_flv/ %s/modules/http_flv' % install_configs['openresty.path.configs'])
            run('rm -rf module_http_flv.zip')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_iconv.zip': 'remote/module_iconv.zip',
        })
        with cd(install_configs['path.package.remote']):
            run('unzip -q module_iconv.zip')
            run('mv module_iconv/ %s/modules/iconv' % install_configs['openresty.path.configs'])
            run('rm -rf module_iconv.zip')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_lua_kong_0.0.6.tar.gz': 'remote/module_lua_kong_0.0.6.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf module_lua_kong_0.0.6.tar.gz')
            run('mv module_lua_kong_0.0.6/ %s/modules/lua_kong' % install_configs['openresty.path.configs'])
            run('rm -rf module_lua_kong_0.0.6.tar.gz')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_vts_0.1.18.tar.gz': 'remote/module_vts_0.1.18.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf module_vts_0.1.18.tar.gz')
            run('mv module_vts_0.1.18/ %s/modules/vts' % install_configs['openresty.path.configs'])
            run('rm -rf module_vts_0.1.18.tar.gz')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_naxsi_1.1a.zip': 'remote/module_naxsi_1.1a.zip',
        })
        with cd(install_configs['path.package.remote']):
            run('unzip -q module_naxsi_1.1a.zip')
            run('mv module_naxsi_1.1a/ %s/modules/naxsi' % install_configs['openresty.path.configs'])
            run('rm -rf module_naxsi_1.1a.zip')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_ct_1.3.2.zip': 'remote/module_ct_1.3.2.zip',
        })
        with cd(install_configs['path.package.remote']):
            run('unzip -q module_ct_1.3.2.zip')
            run('mv module_ct_1.3.2/ %s/modules/ct' % install_configs['openresty.path.configs'])
            run('rm -rf module_ct_1.3.2.zip')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_pagespeed_1.13.35.2.zip': 'remote/module_pagespeed_1.13.35.2.zip',
        })
        with cd(install_configs['path.package.remote']):
            run('unzip -q module_pagespeed_1.13.35.2.zip')
            run('mv module_pagespeed_1.13.35.2/ %s/modules/pagespeed' % install_configs['openresty.path.configs'])
            run('chmod a+x %s/modules/pagespeed/scripts/*.sh' % install_configs['openresty.path.configs'])
            run('rm -rf module_pagespeed_1.13.35.2.zip')

        Tool.upload_file_fabric({
            '/resources/nginx/data/geoip2.tar.gz': 'remote/geoip2.tar.gz',
            '/resources/nginx/modules/module_geoip2_3.3.tar.gz': 'remote/module_geoip2_3.3.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf geoip2.tar.gz')
            run('mv city.mmdb %s/data/geoip2/ && mv country.mmdb %s/data/geoip2/' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs']))
            run('tar -zxf module_geoip2_3.3.tar.gz')
            run('mv module_geoip2_3.3/ %s/modules/geoip2' % install_configs['openresty.path.configs'])
            run('rm -rf geoip2.tar.gz && rm -rf module_geoip2_3.3.tar.gz')

        Tool.upload_file_fabric({
            '/resources/nginx/modules/module_substitutions_filter_0.6.4.tar.gz': 'remote/module_substitutions_filter_0.6.4.tar.gz',
        })
        with cd(install_configs['path.package.remote']):
            run('tar -zxf module_substitutions_filter_0.6.4.tar.gz')
            run('mv module_substitutions_filter_0.6.4/ %s/modules/substitutions_filter' % install_configs['openresty.path.configs'])
            run('rm -rf module_substitutions_filter_0.6.4.tar.gz')

        Tool.upload_file_fabric({
            '/resources/linux/zlib-1.2.11.tar.gz': 'remote/zlib-1.2.11.tar.gz',
            '/resources/nginx/openresty-1.15.8.3.tar.gz': 'remote/openresty-1.15.8.3.tar.gz',
        })

        openresty_dir = '/usr/local/openresty'
        with cd(install_configs['path.package.remote']):
            zlib_dir_remote = ''.join([install_configs['path.package.remote'], '/zlib-1.2.11'])
            pcre_include = '/usr/local/pcre/include'
            pcre_lib = '/usr/local/pcre/lib'
            openssl_include = '/usr/local/openssl/include'
            openssl_lib = '/usr/local/openssl/lib'
            run('mkdir %s' % openresty_dir)
            run('tar -zxf openresty-1.15.8.3.tar.gz')
            run('tar -zxf zlib-1.2.11.tar.gz')
            ngx_conf_start = './configure --prefix=%s' % openresty_dir
            ngx_conf_custom1 = '--with-cc-opt="-I%s -I%s" --with-ld-opt="-L%s -L%s -Wl,-rpath,%s:%s"' % (pcre_include, openssl_include, pcre_lib, openssl_lib, pcre_lib, openssl_lib)
            ngx_conf_custom2 = '--with-zlib=%s --with-openssl-opt="enable-tls1_3 enable-weak-ssl-ciphers" --with-luajit --with-luajit-xcflags="-DLUAJIT_NUMMODE=2" --with-pcre-jit' % zlib_dir_remote
            ngx_conf_custom3 = '--with-debug --with-threads --with-file-aio --with-google_perftools_module'
            ngx_conf_without = '--without-http_autoindex_module --without-http_ssi_module'
            ngx_conf_http1 = '--with-http_ssl_module --with-http_realip_module --with-http_stub_status_module --with-http_sub_module'
            ngx_conf_http2 = '--with-http_v2_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_addition_module'
            ngx_conf_stream = '--with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module'
            ngx_conf_modules1 = '--add-module=%s/modules/cache_purge --add-module=%s/modules/lua_kong' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'])
            ngx_conf_modules2 = '--add-module=%s/modules/vts --add-module=%s/modules/http_flv' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'])
            ngx_conf_modules3 = '--add-module=%s/modules/brotli --add-module=%s/modules/iconv' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'])
            ngx_conf_modules4 = '--add-module=%s/modules/naxsi/naxsi_src --add-module=%s/modules/ct' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'])
            ngx_conf_modules5 = '--add-module=%s/modules/pagespeed --add-module=%s/modules/geoip2' % (install_configs['openresty.path.configs'], install_configs['openresty.path.configs'])
            ngx_conf_modules6 = '--add-module=%s/modules/substitutions_filter' % (install_configs['openresty.path.configs'])
            ngx_conf = ' '.join([
                ngx_conf_start,
                ngx_conf_custom1,
                ngx_conf_custom2,
                ngx_conf_custom3,
                ngx_conf_without,
                ngx_conf_http1,
                ngx_conf_http2,
                ngx_conf_stream,
                ngx_conf_modules1,
                ngx_conf_modules2,
                ngx_conf_modules3,
                ngx_conf_modules4,
                ngx_conf_modules5,
                ngx_conf_modules6,
            ])
            # 中间会弹出关于PSOL的选择,选Y即可
            run('cd openresty-1.15.8.3/ && %s && gmake && gmake install' % ngx_conf)
            run('rm -rf openresty-1.15.8.3/ && rm -rf openresty-1.15.8.3.tar.gz')
            run('rm -rf zlib-1.2.11/ && rm -rf zlib-1.2.11.tar.gz')

        conf_remote_nginx = ''.join([openresty_dir, '/nginx/conf/nginx.conf'])
        run('rm -rf %s' % conf_remote_nginx)
        service_remote_nginx = '/lib/systemd/system/nginx.service'
        Tool.upload_file_fabric({
            '/configs/swooleyaf/nginx/context_http/conf.server': ''.join([install_configs['openresty.path.configs'], '/context_http/conf.server']),
            '/configs/swooleyaf/nginx/context_http/default.conf': ''.join([install_configs['openresty.path.configs'], '/context_http/default.conf']),
            '/configs/swooleyaf/nginx/context_http/vts.conf': ''.join([install_configs['openresty.path.configs'], '/context_http/vts.conf']),
            '/configs/swooleyaf/nginx/context_http/api.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_http/api.conf_demo']),
            '/configs/swooleyaf/nginx/context_http/api.server': ''.join([install_configs['openresty.path.configs'], '/context_http/api.server']),
            '/configs/swooleyaf/nginx/context_http/api.upstream': ''.join([install_configs['openresty.path.configs'], '/context_http/api.upstream']),
            '/configs/swooleyaf/nginx/context_http/api_static.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_http/api_static.conf_demo']),
            '/configs/swooleyaf/nginx/context_http/front.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_http/front.conf_demo']),
            '/configs/swooleyaf/nginx/context_http/front.server': ''.join([install_configs['openresty.path.configs'], '/context_http/front.server']),
            '/configs/swooleyaf/nginx/context_http/front.upstream': ''.join([install_configs['openresty.path.configs'], '/context_http/front.upstream']),
            '/configs/swooleyaf/nginx/context_http/front_static.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_http/front_static.conf_demo']),
            '/configs/swooleyaf/nginx/context_http/rtmp.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_http/rtmp.conf_demo']),
            '/configs/swooleyaf/nginx/context_http/rtmp_api.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_http/rtmp_api.conf_demo']),
            '/configs/swooleyaf/nginx/context_http/rtmp_stat.conf': ''.join([install_configs['openresty.path.configs'], '/context_http/rtmp_stat.conf']),
            '/configs/swooleyaf/nginx/context_http/naxsi_core.rules': ''.join([install_configs['openresty.path.configs'], '/context_http/naxsi_core.rules']),
            '/configs/swooleyaf/nginx/context_http/locations/domain_common.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/domain_common.location']),
            '/configs/swooleyaf/nginx/context_http/locations/domain_outer_api.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/domain_outer_api.location']),
            '/configs/swooleyaf/nginx/context_http/locations/domain_outer_common.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/domain_outer_common.location']),
            '/configs/swooleyaf/nginx/context_http/locations/domain_outer_front.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/domain_outer_front.location']),
            '/configs/swooleyaf/nginx/context_http/locations/domain_static_base.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/domain_static_base.location']),
            '/configs/swooleyaf/nginx/context_http/locations/domain_static_common.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/domain_static_common.location']),
            '/configs/swooleyaf/nginx/context_http/locations/https_cert.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/https_cert.location']),
            '/configs/swooleyaf/nginx/context_http/locations/mirror_monitor.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/mirror_monitor.location']),
            '/configs/swooleyaf/nginx/context_http/locations/naxsi_config.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/naxsi_config.location']),
            '/configs/swooleyaf/nginx/context_http/locations/naxsi_forbidden.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/naxsi_forbidden.location']),
            '/configs/swooleyaf/nginx/context_http/locations/pagespeed_admin.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/pagespeed_admin.location']),
            '/configs/swooleyaf/nginx/context_http/locations/pagespeed_admin_global.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/pagespeed_admin_global.location']),
            '/configs/swooleyaf/nginx/context_http/locations/pagespeed_common.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/pagespeed_common.location']),
            '/configs/swooleyaf/nginx/context_http/locations/pagespeed_server.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/pagespeed_server.location']),
            '/configs/swooleyaf/nginx/context_http/locations/proxy_api_common.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/proxy_api_common.location']),
            '/configs/swooleyaf/nginx/context_http/locations/proxy_api_http.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/proxy_api_http.location']),
            '/configs/swooleyaf/nginx/context_http/locations/proxy_api_websocket.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/proxy_api_websocket.location']),
            '/configs/swooleyaf/nginx/context_http/locations/proxy_common.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/proxy_common.location']),
            '/configs/swooleyaf/nginx/context_http/locations/proxy_static.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/proxy_static.location']),
            '/configs/swooleyaf/nginx/context_http/locations/server_register.location': ''.join([install_configs['openresty.path.configs'], '/context_http/locations/server_register.location']),
            '/configs/swooleyaf/nginx/context_stream/conf.server': ''.join([install_configs['openresty.path.configs'], '/context_stream/conf.server']),
            '/configs/swooleyaf/nginx/context_stream/proxy_rpc.server': ''.join([install_configs['openresty.path.configs'], '/context_stream/proxy_rpc.server']),
            '/configs/swooleyaf/nginx/context_stream/a01_order.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_stream/a01_order.conf_demo']),
            '/configs/swooleyaf/nginx/context_stream/a01_services.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_stream/a01_services.conf_demo']),
            '/configs/swooleyaf/nginx/context_stream/a01_user.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_stream/a01_user.conf_demo']),
            '/configs/swooleyaf/nginx/context_stream/a01_api.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_stream/a01_api.conf_demo']),
            '/configs/swooleyaf/nginx/context_stream/a01_content.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_stream/a01_content.conf_demo']),
            '/configs/swooleyaf/nginx/context_rtmp/tv.conf_demo': ''.join([install_configs['openresty.path.configs'], '/context_rtmp/tv.conf_demo']),
            '/configs/swooleyaf/nginx/certs/dhparam.pem': ''.join([install_configs['openresty.path.configs'], '/certs/dhparam.pem']),
            '/configs/swooleyaf/nginx/certs/fake.crt': ''.join([install_configs['openresty.path.configs'], '/certs/fake.crt']),
            '/configs/swooleyaf/nginx/certs/fake.key': ''.join([install_configs['openresty.path.configs'], '/certs/fake.key']),
            '/configs/swooleyaf/nginx/certs/tls_session_ticket.key': ''.join([install_configs['openresty.path.configs'], '/certs/tls_session_ticket.key']),
            '/configs/swooleyaf/nginx/passwd/pagespeed': ''.join([install_configs['openresty.path.configs'], '/passwd/pagespeed']),
            '/configs/swooleyaf/nginx/nginx.conf': conf_remote_nginx,
            '/configs/swooleyaf/nginx/nginx.service': service_remote_nginx,
        })

        run('chmod 754 %s' % service_remote_nginx)
        run('systemctl enable nginx')

    @staticmethod
    def install_kong(params: dict):
        """安装kong,建议通过rpm包安装,未解决源码安装启动报错的问题"""
        Tool.check_local_files([
            'configs/swooleyaf/nginx/kong/kong',
            'configs/swooleyaf/nginx/kong/kong.conf',
            'configs/swooleyaf/nginx/kong/tls.lua',
        ])

        with cd(install_configs['path.package.remote']):
            run('mkdir /home/logs/kong && mkdir /usr/local/kong && mkdir /usr/local/kong/bin && mkdir /etc/kong && mkdir %s/share/lua/5.1/resty/kong' % install_configs['luarocks.path.install'])

            # tls.lua文件在lua-kong-module扩展的lualib目录下有
            kong_bin = '/usr/local/kong/bin/kong'
            Tool.upload_file_fabric({
                '/configs/swooleyaf/nginx/kong/kong': kong_bin,
                '/configs/swooleyaf/nginx/kong/kong.conf': '/etc/kong/kong.conf',
                '/configs/swooleyaf/nginx/kong/tls.lua': ''.join([install_configs['luarocks.path.install'], '/share/lua/5.1/resty/kong/tls.lua']),
            })
            run('chmod a+x %s' % kong_bin)
