#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Feb 17 19:15:09 2019

@author: guochenxin
"""

import matplotlib.pyplot as plt
import time
import numpy as np
import math

def matrixVectproduct (A, b):
    return np.dot(A,b)

a=20000
c=40000
lst_time=[]
for i in range(a,c,200):
    A=np.eye(i)
    b=np.arange(i).reshape((i,1))
    time1=time.time()
    re=matrixVectproduct (A, b)
    time2=time.time()
    #print(re)
    time_delta=time2-time1
    time_delta_sqrt=math.sqrt(time_delta)
    lst_time.append(time_delta_sqrt)
#print(lst_time)
    
x=list(range(a,c, 200))
plt.plot(x, lst_time)
plt.show()

