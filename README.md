# 介绍
## 安装python3(centos7)
    wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz
    mkdir /usr/local/python3
    tar -Jxvf Python-3.6.4.tar.xz
    cd Python-3.6.4
    ./configure --prefix=/usr/local/python3
    make && make install
    /usr/local/python3/bin/pip3 install fabric3

## 环境配置
详情参见文件: jinstall/helper_install.md

## 初始化(***必须先处理***)
    cd resources/ && git remote add resources https://jw07061625.coding.net/public/devops/syinstall_resources/git && git pull resources master && git lfs install && git lfs pull
    #如有需要请根据情况修改configs_pro.py
    cp configs_exp.py configs_pro.py
    #如有需要请根据情况修改jinstall/configs/swooleyaf_pro.py
    cp jinstall/configs/swooleyaf_exp.py jinstall/configs/swooleyaf_pro.py
    #如有需要请根据情况修改jcomponent/configs/db_pro.py
    cp jcomponent/configs/db_exp.py jcomponent/configs/db_pro.py

# 命令
## 环境安装
    /usr/local/python3/bin/python3 helper_install.py
## 组件管理
    /usr/local/python3/bin/python3 helper_component.py

# 其他
## docker-compose安装
    cp resources/linux/docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    docker-compose --version

## pycharm配置
    Setting->Project->Project Interpreter->Add Local
    设置Base interpreter并勾选上Inherit global site-packages

## 贝叶斯分类
    https://www.jianshu.com/p/f6a3f3200689

## sywaf防火墙
    详情参见文件: resources/nginx/lualib/helper_sywaf.md
