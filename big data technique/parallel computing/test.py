#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  1 13:49:48 2019

@author: guochenxin
"""
import threading
import time
# global and local variables
N=0

lock =threading.Lock() # mutex -  mutual exclusion object
#sema=threading.Samaphore(1)n# similar as lock, sema=threading.Samaphore(10)

def worker():
    global N
    print (threading.currentThread().getName(), "starting", N)
    #N=N+1
    lock.acquire() # safe region
    M=N
    print(M)
    N=M+1
    lock.release() # end safe region
    time.sleep(1)
    print(threading.currentThread().getName(), "exiting", N)
  
for i in range(5):
    w=threading.Thread(target=worker)
    w.start()
