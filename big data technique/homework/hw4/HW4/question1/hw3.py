
# coding: utf-8

# In[3]:


class Array(object):

    def __init__(self, size):
        self._size = size
        self._items = [None] * size

    def __getitem__(self, index):
        return self._items[index]

    def __setitem__(self, index, value):
        self._items[index] = value

    def __len__(self):
        return self._size


# In[16]:


# compare 
def compare(name1, name2):
    lst=name1.split(' ')+name2.split(' ')
    return (lst[1]<lst[3]) or (lst[1]==lst[3] and lst[0]<lst[2])
    
class NameHeap(object):
    def __init__(self, maxsize=100):
        self.maxsize=maxsize
        self._element=Array(maxsize)
        self._count= 0
    def size(self):
        return self._count
    def insertName(self, name):
        if self._count>=self.maxsize:
            raise Exception ('Full')
        self._element[self._count]=name
        count=self._count
        if count!=0:
            print(count)
            print(self._element._items[count])
            parent=(count-1)//2
            while compare(self._element._items[count], self._element._items[parent])==True:
                self._element._items[count], self._element._items[parent]=self._element._items[parent], self._element._items[count]
                count=parent
                parent=(count-1)//2
                if count==0:
                    break
        self._count+=1
        
    def smallestName(self):
        if self.size==0:
            print('There is no one in the Heap.')
            return False
        else:
            value=self._element._items[0]
            return value
        
    def deleteSmallestName(self):
        if self._count<=0:
            print('There is no one in the Heap.')
            return False
        else:
            value=self._element._items[0]
            self._count-=1
            self._element._items[0]=self._element._items[self._count]
            # test whether left exist:
            smallest=0
            left=2*smallest+1
            right=2*smallest+2
            while True:
                if left<self._count and compare(self._element._items[left], self._element._items[smallest])==True and compare(self._element._items[left], self._element._items[right]):
                    self._element._items[left], self._element_items[smallest]=self._element_items[smallest],self._element_items[left]
                    smallest=left
                    left=2*smallest+1
                    right=2*smallest+2
                elif right<self._count and compare(self._element._items[right], self._element._items[smallest]):
                    self._element._items[right], self._element._items[smallest]=self._element._items[smallest],self._element._items[right]
                    smallest=right
                    left=2*smallest+1
                    right=2*smallest+2
                else:
                    break
            return value
    def contains(self,name):
        return (name in self._element._items)
          
    

class CallCenter(object):
    def __init__(self):
        self._queue=[NameHeap()]
        self._total=0
        self._hour=0
        
    def queueCustomer(self,name):
        self._queue[-1].insertName(name)
        
    def dequeueCustomer(self):
        hour=0
        while self._queue[hour].size()==0:
            hour+=1
        return self._queue[hour].deleteSmallestName()
        
        
    def nextHour(self):
        self._hour+=1
        self._queue.append(NameHeap())
        
    def size(self):
        size=0
        for queue in self._queue:
            space=queue.size()
            size+=space
        return size
    def contains(self, name):
        for item in self._queue:
            if item.contains(name):
                return True
        return False


    
 '''   
heap = NameHeap() 
heap.insertName('Bob Ross') 
heap.insertName('Ben Grimmer') 
heap.insertName('Lijun Ding')
print(heap.size()==3) 
print(heap.smallestName() == 'Lijun Ding') 
print(heap.contains('Bob Ross'))
heap.deleteSmallestName () 
print(heap.deleteSmallestName() == 'Ben Grimmer')


callCenter = CallCenter ()
callCenter.queueCustomer('Bob Ross') 
callCenter.queueCustomer('Ben Grimmer') 
callCenter.nextHour ()
callCenter.queueCustomer('Lijun Ding') 
callCenter .queueCustomer('Jim Renegar')
print(callCenter.size()==4) 
print(callCenter.dequeueCustomer()=='Ben Grimmer') 
print(callCenter.dequeueCustomer()=='Bob Ross') 
print(callCenter.dequeueCustomer()=='Lijun Ding') 
print(callCenter.contains('Jim Renegar'))

'''


# In[21]:


#python3 -m unittest discover

