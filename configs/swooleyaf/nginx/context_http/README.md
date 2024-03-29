# 介绍
- api.conf_demo: 接口项目配置样例,如需使用将后缀改成.conf即可
- api.server: 接口项目server块配置
- api.upstream: 接口项目反向代理配置
- api_static.conf_demo: 接口项目静态资源样例配置,如需使用将后缀改成.conf即可
- conf.server: http块公共配置
- default.conf: 默认域名配置
- front.conf_demo: 前端项目配置样例,如需使用将后缀改成.conf即可
- front.server: 前端项目server块配置
- front.upstream: 前端项目反向代理配置
- front_static.conf_demo: 前端项目静态资源样例配置,如需使用将后缀改成.conf即可
- idea_license_server.conf: idea服务认证配置(已废弃)
- naxsi_core.rules: naxsi网页防火墙配置
- rtmp.conf_demo: rtmp服务配置
- rtmp_api.conf_demo: rtmp服务接口配置
- rtmp_stat.conf: rtmp状态监控配置
- upstream_check.conf: 反向代理健康检测配置
- vts.conf: 域名监控配置

# 模块
## ip2location
### 支持的变量
- ip2location_country_short
- ip2location_country_long
- ip2location_region
- ip2location_city
- ip2location_isp
- ip2location_latitude
- ip2location_longitude
- ip2location_domain
- ip2location_zipcode
- ip2location_timezone
- ip2location_netspeed
- ip2location_iddcode
- ip2location_areacode
- ip2location_weatherstationcode
- ip2location_weatherstationname
- ip2location_mcc
- ip2location_mnc
- ip2location_elevation
- ip2location_usagetype

# 其他
## 防止通过接口上传大文件来恶意攻击服务器
nginx直接处理,避免透传到后端来判断,占用后端的服务资源
```
location / {
    rewrite_by_lua_block {
        local contentLength = 0
        if ngx.var.content_length ~= nil then
            contentLength = tonumber(ngx.var.content_length)
        end
        
        //最大不允许超过3M
        if contentLength > 3145728 then
            ngx.exit(403)
        elseif contentLength <= 0 then
            ngx.exit(403)
        end
    }
}
```
