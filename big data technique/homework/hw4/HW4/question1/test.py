
# coding: utf-8

# In[ ]:


# NameHeapTests.py
import unittest
class NameHeapTests(unittest.TestCase):
    def setUp(self):
        self.heap=NameHeap()
        
    def test_insertName(self):
        self.heap.insertName('Bob Ross') 
        self.heap.insertName('Ben Grimmer') 
        self.heap.insertName('Lijun Ding')
        self.heap.assertEqual(3, self.heap.size())
        
    def test_smallestName(self):
        self.heap.insertName('Bob Ross') 
        self.heap.insertName('Ben Grimmer') 
        self.heap.insertName('Lijun Ding')
        self.heap.assertEqual('Lijun Ding', self.heap.smallestName())
    def test_smallestName2(self):
        self.heap.assertFalse(self.heap.smallestName())
        
    def test_contains(self):
        self.heap.insertName('Bob Ross') 
        self.heap.assertTrue(self.heap.contains('Bob Ross'))
        
    def test_deleteSmallestName(self):
        self.heap.insertName('Bob Ross') 
        self.heap.insertName('Ben Grimmer') 
        self.heap.insertName('Lijun Ding')
        self.heap.aassertTrue('Ben Grimmer', self.heap.deleteSmallestName())
    def test_deleteSmallestName2(self):
        self.heap.assertFalse(self.heap.deleteSmallestName())

