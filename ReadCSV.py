'''
http://dangoldin.com/2016/01/10/cleanest-way-to-read-a-csv-file-with-python/
https://docs.python.org/3/library/collections.html#collections.namedtuple
828,Barak Frierson,z000jaed,barak.frierson@ABC.com,Absent
827,Juerg von Bueren,z001tywx,juerg.von-bueren@ABC.com,Absent
826,Arthur Effting,z003pdzz,arthur.effting@ABC.com,Absent
825,Hara Shankar Banerjee,z00171va,hara.banerjee@ABC.com,Absent
'''

'''
import csv
from collections import namedtuple

# Can add whatever columns you want to parse here
# Can also generate this via the header (skipped in this example)

Details = namedtuple('ID',('ID,Name,UserID,Email,Present'))
with open('C:\\Users\\vikram.uk\\Desktop\\Lookup.csv', 'r') as f:
    r = csv.reader(f, delimiter=',')
    #r.next() # Skip header
    rows = [Details(*l) for l in r]
    print(Details)
'''



import csv
from collections import namedtuple

ID = namedtuple('ID','ID,Name,UserID,Email,Present')
for emp in map(ID._make, csv.reader(open("C:\\Users\\vikram.uk\\Desktop\\Lookup.csv", "r"))):
    print(emp.ID, emp.Present,emp.Email)
