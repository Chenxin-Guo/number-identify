#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar  9 16:35:29 2019

@author: guochenxin
"""

# problem 2
conn = sqlite3.connect('problem2.db')
c = conn.cursor()
c.execute("DROP TABLE IF EXISTS Customers")
c.execute("DROP TABLE IF EXISTS Reservation")
c.execute('''CREATE TABLE Customers
             (CustomerId int, Name text)''')
c.execute("INSERT INTO Customers VALUES (1, 'Paul Novak')")
c.execute("INSERT INTO Customers VALUES (2, 'Terry Neils')")
c.execute("INSERT INTO Customers VALUES (3, 'Jack Fonda')")
c.execute("INSERT INTO Customers VALUES (4, 'Tom Willis')")
conn.commit()


c.execute('''CREATE TABLE Reservation
             (ID int, CustomerId int, Day Text)''')
c.execute("INSERT INTO Reservation VALUES (1, 1, '2009−22−11')")
c.execute("INSERT INTO Reservation VALUES (2, 2, '2009−28−11')")
c.execute("INSERT INTO Reservation VALUES (3, 2, '2009−29−11')")
c.execute("INSERT INTO Reservation VALUES (4, 1, '2009−29−11')")
c.execute("INSERT INTO Reservation VALUES (5, 3, '2009−02−12')")

c.execute('''SELECT Name, Day FROM Customers AS C JOIN Reservation
                   AS R ON C. CustomerId = R. CustomerId''')
print(c.fetchall())

c.execute('''SELECT Name, Day FROM Customers LEFT JOIN Reservation
                   ON Customers . CustomerId = Reservation . CustomerId''')
print(c.fetchall())