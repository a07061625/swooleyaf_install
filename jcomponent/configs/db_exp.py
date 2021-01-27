# -*- coding:utf-8 -*-


component_db_configs = {
    'mysql.inception.host': '127.0.0.1',
    'mysql.inception.port': 4000,
    'mysql.inception.charset': 'utf8mb4',
    'mysql.inception.sqls': {
        'xxx': '''
        /*--user=root;--password=jw123456;--host=192.168.96.31;--check=1;--port=3306;*/
        inception_magic_start;
        use gomanager;
        create table t1(id int primary key,c1 int);
        insert into t1(id,c1,c2) values(1,1,1);
        inception_magic_commit;
        ''',
    },
}
