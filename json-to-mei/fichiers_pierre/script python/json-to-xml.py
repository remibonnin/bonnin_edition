from json import load,loads
from dicttoxml import dicttoxml

with open("document.json") as input_var:
 d=load(input_var)
di = {"TEI":d}
xm = dicttoxml(di)     #returns xm as <class 'bytes'> object


with open("document.xml", mode='tei') as out:  #opening in write-bytes mode 
    out.write(xm)