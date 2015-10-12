### Dict#6.py
states={'Rajasthan':33}
states['Delhi']= 11
states['Punjab']=14
#print states

states['Tamil Nadu']= 64
states['Kerala']= 67
states.update({'Punjab':15})

states.pop("Rajasthan")
for state in states:
    print state, states[state]



#####Employee9.py
from Employee import *

class Book():

    def __init__(self, name, auther):
            self.name=name
            self.auther=auther

    def getName(self):
        return self.name
    
    def getAuthor(self):
        return self.auther

class PythonBook(Book):

    def __init__(self, name, author):
        Book.__init__(self, name, author)
        
    def get_name(self):
        print self.getName()
    
if __name__ == '__main__':
    '''
    emp=Employee()
    emp.callHarish()
    '''
    p=PythonBook("Learn Python", "Vikram U K")
    #print p.getName()
    print p.getName()
    print p.getAuthor()
    


###Employee.py
class Employee():

    def __init__(self):
        print "Hello"
        
    def callHarish(self):
        print "Hi harish"
    
### Functions7.py
def defVal(a, l=[]):
    l.append(a)
    return l
    
def defValNone(b, k=None):
    if k is None:
        k=[]
        k.append(b)
        return k

for i in range(0,4):
    print defVal(i)
    #print defValNone(i)

def myFunc(*kw):    
    for a in enumerate(kw):
        print a
def print_everything(*args):
        for count, thing in enumerate(args):
            print '{0}. {1}'.format(count, thing)
        
List=[1,2,3,4]
myFunc(List)
print type(List)

ArgList=('apple', 'banana', 'cabbage')
print type(ArgList)
print_everything(ArgList)


### Functions#8.py
def MyFunc(n):
    return lambda(n):n*n

List=(1,2,3,4,5)
for i in range(0,3):
    print MyFunc(i)

x= MyFunc(2)
print x(-4)


## List#4.py
subjectsin10=['Maths', 'Social', 'English', 'Science']
subjectsin12 =['Physics','Chemistry', 'Maths', 'Bio']
subjectsinGrad =['SOM', 'Comms','Stats']
#allSubjects =subjectsin10+ subjectsin12+ subjectsinGrad
allSubjects=[]
allSubjects.append(subjectsin10)
allSubjects.append(subjectsin12)
allSubjects.append(subjectsinGrad)
#allSubjectsin12, allSubjectsinGrad]
#print allSubjects

allSubjects10Plus2=[]
allSubjects10Plus2.append(subjectsin10)
allSubjects10Plus2.append(subjectsin12)
print allSubjects10Plus2[1][1]

###String#3.py
str1="Python"
str2="hands On Session"
print str1+" "+str2
str3="Fun learning"
print (str1+"!")*3+str3

str4="Hands on Session"
print str4[1:6] ,str4[6:8]
print "Last Four:"+ str4[-4:]+ "      ---First Four:"+ str4[0:4]
print str4[:5]
print str4[6:9]
print str4[10:60]
x=(len(str4)-4)
print x
print str4[x:]


### Tuple#5.py
tuple1=(1)
tuple2=(1,)
#print type(tuple1)
#print type(tuple2)
mylist = []
for x in range(5):
    mylist.append(x)
mytuple = tuple(mylist)
'''
print mytuple
print type(mylist), type(mytuple)
'''
a=dict(one=1, two=2,three=3)
b={'one': 1, 'two': 2, 'three': 3}
c=dict(zip(['one','two','three'], [1,2,3]))
d=dict([('two',2),('one',1),('three',3)])
e=dict({'three':3, 'one':1, 'two':2})
a==b==c==d==e

'''       
def swaps(val1,val2):
    val1['one']=val1['one']+ val2['two']
    val1['two']=val1['one']- val2['two']
    retu

val1=dict(one=1)
val2=dict(two=2)

'''
def swaps(a,b):
    a=a+b
    b=a-b
    a=a-b
    return a,b

print swaps(5,4)

### Create#1.py
# !#/bin/python
num1=5
num2=6
sum=0
sum= num1+num2
print sum
a,b,c='Python','version','2.9' #print a,b,c
var1=2.50
var2= "Python training"
var3=[1,2,3,4,5]
print type(var1),type(var2),type(var3)
# print type(var3)



### Datatype#2.py
int1=1
long1= 123456789
float3=1.0E6
print int1+long1

var1='Python'
var2='Tutorial'
type(var1)
print type(var1)

val3={'i':'2'}
print val3
print set(val3)

