# -*- coding:utf-8 -*-
import requests
import json
import os

from jcomponent.configs.notify_pro import *


class DingTalk:
    @staticmethod
    def send_robot(params: dict):
        """发送钉钉机器人通知"""
        msg_content = ''
        if os.path.exists(params['msg_file']):
            f = open(params['msg_file'], "r")
            msg_content = f.read()
            f.close()

        if len(msg_content) > 0:
            send_res = requests.post(component_notify_configs['dingtalk.robot.url'], json.dumps({
                "msgtype": "text",
                "at": {
                    "atMobiles": [],
                    "isAtAll": True
                },
                "text": {
                    "content": msg_content
                }
            }), headers=component_notify_configs['dingtalk.robot.headers'])
            return str(send_res.content, encoding="utf-8")
        else:
            return '{"errcode":9999,"errmsg":"通知消息内容为空"}'
