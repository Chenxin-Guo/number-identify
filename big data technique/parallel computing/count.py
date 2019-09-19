#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  1 14:54:34 2019

@author: guochenxin
"""

from mrjob.job import MRJob


import re
 WORD_RE=re.compile(r"[\w']+")
 
class MRWordCount(MRJob):
    def mapper(self,_, line):
        for word in WORD_RE.findall(line):
            yield (word.lower(), 1) 
    def reducer(self, word, count):
        yield(word, sum(count))
        
MRWordCount.run()



'''
python3 word_count.py + text
'''