#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 21 10:54:51 2019

@author: guochenxin
"""

def detectSubnormalNumber(x):
    if 2**(-52-1022)<=abs(x)<=2**(-1022):
        return True
    else:
        return False


#test
detectSubnormalNumber(-2**(-51-1022))
detectSubnormalNumber(2**(-52-1022))
detectSubnormalNumber(2**(-53-1022))
detectSubnormalNumber(2**(-54-1022))
detectSubnormalNumber(2**(-1021))