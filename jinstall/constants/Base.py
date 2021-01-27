# -*- coding:utf-8 -*-
class Base:
    def __setattr__(self, key, value):
        if key in self.__dict__:
            raise TypeError("Can't rebind const (%s)" % key)
        self.__dict__[key] = value
