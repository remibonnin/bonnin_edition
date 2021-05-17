from json import load,loads
from dicttoxml import dicttoxml

with open("2-f.4r-li granz desirs.json") as input_var:
 d=load(input_var)
di = {"TEI":d}
xm = dicttoxml(di)     #returns xm as <class 'bytes'> object


with open("output_3.xml", mode='tei') as out:  #opening in write-bytes mode 
    out.write(xm)