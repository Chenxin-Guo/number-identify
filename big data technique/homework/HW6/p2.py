#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar  4 12:09:28 2019

@author: guochenxin
"""
import numpy as np
from mrjob.job import MRJob
from mrjob.step import MRStep

#N=input()
class MRpi(MRJob):
    def steps(self):
        return [
                MRStep(mapper=self.random_points, 
                       reducer=self.reducer_inside_circle),
                MRStep(reducer=self.reducer_estimate_pi)
                ]
    def random_points(self,_, N):
        N = int(N)
        for i in range(N):
            Num=((np.random.rand(), np.random.rand()), 1)
            yield Num
    def reducer_inside_circle(self, Num, count):
        #for i in range(1): 
        #print(Num[0])
        #print(Num[1])
        if pow((Num[0]-0.5), 2)+pow((Num[1]-0.5), 2)<=1/4:
            yield None, (True, 1)
        else:
            yield None, (False, 1)
         
    def reducer_estimate_pi(self,_,result):
        n1=0
        n2=0
        for Status, Count in result:
            if Status==True:
                n1=n1+Count
            else:
                n2=n2+Count
        yield True,(n1/(n1+n2))*4

MRpi.run()