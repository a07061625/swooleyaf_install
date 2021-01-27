# -*- coding:utf-8 -*-
from progressbar import *
from jinstall.envs.CommonBase import *


class SyBase(CommonBase):
    _configs_profile = []
    _ports = []

    def __init__(self):
        super(SyBase, self).__init__()
        self._configs_profile = []
        self._ports = []

    def install(self, params: dict):
        """安装环境"""
        func_params = {
            'envs': self._configs_profile,
            'ports': self._ports,
            'init': params['init'],
            'env': params['env']
        }
        widgets = ['Progress: ', Percentage(), ' ', Bar('#'), ' ', Timer()]
        step_bar = ProgressBar(widgets=widgets, maxval=len(self._steps)).start()
        for step, func in self._steps.items():
            if params['step1'] <= step <= params['step2']:
                func(func_params)
            step_bar.update(step)
            print()
