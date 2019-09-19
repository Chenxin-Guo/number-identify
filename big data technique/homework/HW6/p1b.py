
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  4 18:10:03 2019

@author: guochenxin
"""


import math
import threading
import time
lock =threading.Lock()
N=210
n=0
m=0
start=time.time()
def worker():
    global n
    global m
    lock.acquire()
    m=m+1
    n=n+1/(m*m)
    lock.release()
    time.sleep(1)

for i in range(70):
    w=threading.Thread(target=worker)
    w.setDaemon(True)
    w.start()    
for i in range(70, 140):
    w=threading.Thread(target=worker)
    w.start()
for i in range(140, 210):
    w=threading.Thread(target=worker)
    w.start()
    
delta=time.time()-start
print(delta)
print(math.sqrt(n*6))


