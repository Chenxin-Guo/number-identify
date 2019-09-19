#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Mar 10 16:26:00 2019

@author: guochenxin
"""

import sqlite3
conn = sqlite3.connect('problem1.db')
c=conn.cursor()

import pandas as pd
url='https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data'
data=pd.read_csv(url, header=None, index_col=None)
data.columns=['SepalLength','SepalWidth', 'PetalLength', 'PetalWidth', 'Class' ]

#list(data.index)
data=data.reindex(map(lambda x: x+1, list(data.index)))
data.reset_index(level=0, inplace=True)
data.columns=['ID', 'SepalLength','SepalWidth', 'PetalLength', 'PetalWidth', 'Class' ]
data.head()
data.to_sql("Iris", conn, if_exists='replace', index=False)


sq='select * from Iris limit 5'
c.execute(sq)
print(c.fetchall())


#(c)
c.execute('select avg(SepalWidth) as avg, min(SepalWidth) as min, max(SepalWidth) as max from Iris')
print(pd.DataFrame(c.fetchall(), columns=['average', 'min', 'max']))

#(d)
c.execute('select avg(SepalWidth) as avg, min(SepalWidth) as min, max(SepalWidth) as max,Class from Iris group by Class')
print(pd.DataFrame(c.fetchall(), columns=['average', 'min', 'max', 'class']))