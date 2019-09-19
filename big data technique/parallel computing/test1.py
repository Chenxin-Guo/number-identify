#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  1 14:12:07 2019

@author: guochenxin
"""

import threading
data=[1,3,1,4,5,9,2,6,3,5]

def worker(p):
    global data
    if data[p-1]>data[p]:
        temp=data[p-1]
        data[p-1]=data[p]
        data[p]=temp
    
for j in range(5):
    threads=[]
    for i in range(5):
        w= threading.Thread(target=worker, args=[2*i+1])
        w.start()
        threads.append(w)
    for w in threads:
        w.join()
    print(data)
    threads=[]
    for i in range(4):
        w= threading.Thread(target=worker, args=[2*i+2])
        w.start()
        threads.append(w)
    for w in threads:
        w.join()
    print(data)  #semaphores
                   
        