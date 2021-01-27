# -*- coding:utf-8 -*-
from abc import ABCMeta, abstractmethod


class CommonBase(object, metaclass=ABCMeta):
    _steps = {}

    def __init__(self):
        self._steps = {}

    @abstractmethod
    def install(self, params: dict):
        pass
