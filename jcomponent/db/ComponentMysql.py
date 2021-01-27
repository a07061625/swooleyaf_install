# -*- coding:utf-8 -*-
import prettytable as pt
import pymysql
from colorama import init, Fore

from jcomponent.configs.db_pro import *


class ComponentMysql:
    @staticmethod
    def inception(params: dict):
        """SQL审计"""
        init(autoreset=False)
        tb = pt.PrettyTable()
        tb.field_names = ['tag', 'sql', 'err_msg', 'affect_rows', 'exec_time', 'back_db', 'back_time']
        conn = pymysql.connect(host=component_db_configs['mysql.inception.host'], user='', passwd='', db='', port=component_db_configs['mysql.inception.port'], charset=component_db_configs['mysql.inception.charset'])
        cur = conn.cursor()
        for tag, sql in component_db_configs['mysql.inception.sqls'].items():
            cur.execute(sql)
            result = cur.fetchall()
            for row in result:
                row_info = [tag, Fore.LIGHTGREEN_EX + row[5] + Fore.RESET]
                if row[2] == 0:
                    row_info.append(Fore.LIGHTGREEN_EX + '-' + Fore.RESET)
                else:
                    row_info.append(Fore.LIGHTRED_EX + row[4] + Fore.RESET)
                row_info.append(row[6])
                row_info.append(row[9])
                if isinstance(row[8], str):
                    row_info.append(row[8])
                else:
                    row_info.append('-')
                row_info.append(row[11])
                tb.add_row(row_info)

        cur.close()
        conn.close()
        print(tb)
