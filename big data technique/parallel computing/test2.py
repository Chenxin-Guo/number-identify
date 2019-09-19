#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  1 14:54:34 2019

@author: guochenxin
"""

from mrjob.job import MRJob
from mrjob.step import MRStep

import re
 WORD_RE=re.compile(r"[\w']+")
 
class MRWordCount(MRJob):
    def steps(self):
        return [
                MRStep(maper=self.mapper_get_words, 
                       reducer=self.reducer_count_words),
                MRStep(reducer=self.reducer_find_max)
                ]
        
    def mapper_get_words(self,_, line):
        for word in WORD_RE.findall(line):
            yield (word.lower(), 1) 
            
    def reducer_count_words(self, word, count):
        yield None, (sum(count), word)
        
    def reducer_find_max(self, _, pairs):
        yield max(pairs)
        
MRWordCount.run()



'''
python3 word_count.py + text
'''