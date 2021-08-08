# 说明
## addition_to_sys.sql.sql
检测集群状态的sql视图脚本和探测语句
## proxysql_groupreplication_checker.sh
用于multi-primary（多主）模式,可以实现读写分离,以及故障切换,同一时间点多个节点可以多写
## gr_mw_mode_cheker.sh
用于multi-primary(多主)模式,可以实现读写分离,以及故障切换,不过在同一时间点只能有一个节点能写
## gr_sw_mode_checker.sh
用于single-primary(单主)模式,可以实现读写分离,以及故障切换