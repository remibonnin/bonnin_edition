from json import load
from dicttoxml import dicttoxml
from lxml import etree


def JSON_to_MEI(json_path):
    """
    Get main text from xml file
    :param json_path: path to json file
    """

    # first, json to xml
    with open(json_path, 'r') as input_var:
        d = load(input_var)
        di = {"TEI": d}
        xm = dicttoxml(di)  # returns xm as <class 'bytes'> object

    myxsl = etree.XSLT(etree.parse("xsl/json_to_mei.xsl"))
    #myxsl(etree.parse("tests/ANO_RS1098_Tres_haute_amours,_qui_tant_sest_abessie-M12v.json.xml"))

    return myxsl(etree.fromstring(xm))

def MEI_to_TXT(mei, notes=True, octaves=False, intervals=False, complexintervals=False):
    '''
    Takes an etree mei document, and outputs a simple txt.
    :param mei:
    :return:
    '''
    myxsl = etree.XSLT(etree.parse("xsl/mei_to_txt.xsl"))

    if notes:
        notes = "'True'"

    else:
        notes = "'False'"

    if octaves:
        octaves="'True'"

    else:
        octaves="'False'"

    if intervals:
        intervals = "'True'"

    else:
        intervals = "'False'"

    if complexintervals:
        complexintervals = "'True'"

    else:
        complexintervals = "'False'"

    return myxsl(mei, notes=notes, octaves=octaves, intervals=intervals, complexintervals=complexintervals)

if __name__ == '__main__':

    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('-s', nargs='+', help="paths to files")
    args = parser.parse_args()

    for path in args.s:
        print(path)
        my_mei = JSON_to_MEI(path)
        # output mei
        my_mei.write_output('mei/'+path.split('/')[-1].split('.')[0]+'.xml')
        # output txt
        my_txt = MEI_to_TXT(my_mei)
        my_txt.write_output('txt/onlyNotes/' + path.split('/')[-1].split('.')[0] + '.txt')
        my_txt = MEI_to_TXT(my_mei, octaves=True)
        my_txt.write_output('txt/both/' + path.split('/')[-1].split('.')[0] + '.txt')
        my_txt = MEI_to_TXT(my_mei, notes=False, octaves=True)
        my_txt.write_output('txt/onlyOctaves/' + path.split('/')[-1].split('.')[0] + '.txt')
        my_txt = MEI_to_TXT(my_mei, notes=False, octaves=False, intervals=True, complexintervals=False)
        my_txt.write_output('txt/intervals/' + path.split('/')[-1].split('.')[0] + '.txt')
        my_txt = MEI_to_TXT(my_mei, notes=False, octaves=False, intervals=False, complexintervals=True)
        my_txt.write_output('txt/complexintervals/' + path.split('/')[-1].split('.')[0] + '.txt')
