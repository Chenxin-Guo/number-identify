#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 21 11:27:54 2019

@author: guochenxin
"""

import math
def qesolution(b, c):
    #x1=b-math.sqrt(b*b+c)
    x1=-c/(b+math.sqrt(b*b+c))
    x2=b+math.sqrt(b*b+c)
    #x2=-c/(b-math.sqrt(b*b+c))
    return x1 ,x2

#test
def within(eps, a, b):
    return abs((a - b)/b) <= eps

lst=[]
for b in range(10, 200, 10):
    for c in [1]:
        x1, x2=qesolution(b, c)
        summ=2*b
        product=-c
        result1=x1+x2
        result2=x1*x2
        #print(summ)
        #print(result1)
        lst.append(within(10**(-12),result1, summ))
        lst.append(within(10**(-12),result2, product))
lst

