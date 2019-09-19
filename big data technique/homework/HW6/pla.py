#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  4 11:38:20 2019

@author: guochenxin
"""

import math
import threading
import time
lock =threading.Lock()
N=200
n=0
m=0
def worker():
    global n
    global m
    lock.acquire()
    m=m+1
    n=n+1/(m*m)
    lock.release()
    time.sleep(1)

for i in range(N):
    w=threading.Thread(target=worker)
    w.start()
print(math.sqrt(n*6))

