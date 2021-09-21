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

    myxsl = etree.XML('''
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.music-encoding.org/ns/mei" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    exclude-result-prefixes="xs xd">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <mei>
            <meiHead>
                <fileDesc>
                    <titleStmt>
                        <title/>
                        <respStmt>
                            <resp/>
                            <persName/>
                        </respStmt>
                    </titleStmt>
                    <pubStmt/>
                    <seriesStmt>
                        <title/>
                        <editor/>
                    </seriesStmt>
                    <sourceDesc/>
                </fileDesc>
                <encodingDesc/>
                <workList>
                    <work>
                        <title/>
                        <composer/>
                        <contents>
                            <contentItem/>
                        </contents>
                    </work>
                </workList>
            </meiHead>

            <music>
                <body>
                    <mdiv>
                        <score>
                            <xsl:apply-templates select="root/TEI/children/item"/>
                        </score>
                    </mdiv>
                </body>
            </music>
        </mei>
    </xsl:template>
    
    <xsl:template match="item[kind = 'FormteilContainer']">

        <scoreDef>
            <staffGrp>
                
                <xsl:apply-templates select="descendant::item[kind = 'Clef']"/>
            </staffGrp>
        </scoreDef>
        
        <xsl:apply-templates select="children/item[kind = 'ZeileContainer']"/>
        

    </xsl:template>
    
    <xsl:template match="item[kind = 'Clef']">
        <staffDef>
            
            <xsl:attribute name="clef.shape">
                <xsl:apply-templates select="shape"/>
                
            </xsl:attribute>
            
            <xsl:attribute name="n">
                
                <xsl:number level="single"/>
            </xsl:attribute>
            
            <xsl:attribute name="clef.line">
                <xsl:number value="'4'"/>
            </xsl:attribute>
            
            <xsl:attribute name="lines">
                <xsl:number value="'5'"/>
            </xsl:attribute>
            
            
            <xsl:attribute name="notationtype">
                <xsl:apply-templates select="'neume'"/>
            </xsl:attribute>
            
        </staffDef>
    </xsl:template>
    
    <xsl:template match="item[kind = 'ZeileContainer']">
        <section>
            <xsl:attribute name="n">
                <xsl:number level="single"/>
            </xsl:attribute>
            
            
            <measure>
                <staff>
                    <xsl:attribute name="n">
                        <xsl:number value="'1'"/>
                    </xsl:attribute>
                    
                    <layer>
                        <xsl:attribute name="n">
                            <xsl:number value="'1'"/>
                        </xsl:attribute>
                        
                        
                        <xsl:apply-templates
                            select="children/item[kind = 'Syllable'] | children/item[kind = 'LineChange']"/>

                    </layer>
                </staff>
            </measure>
        </section>
    </xsl:template>
    <xsl:template match="item[kind = 'Syllable'] | item[kind = 'LineChange']">
        
        
        <xsl:apply-templates select="children/item"/>
        <syllable>
            <xsl:element name="syl">
                <xsl:apply-templates select="text"/>
            </xsl:element>
            
            <neume>
                <xsl:for-each select="descendant::grouped/item">
                    <xsl:element name="nc">
                        <xsl:attribute name="pname">
                            <xsl:value-of select="translate(base/text(), 'ABCDEFG', 'abcdefg')"/>
                        </xsl:attribute>
                        <xsl:attribute name="oct">
                            <xsl:value-of select="octave"/>
                        </xsl:attribute>
                        <xsl:attribute name="intm">
                            <xsl:choose>
                                <xsl:when test="noteType = 'Descending'">
                                    <xsl:text>d</xsl:text>
                                </xsl:when>
                                <xsl:when test="noteType = 'Ascending'">
                                    <xsl:text>u</xsl:text>
                                </xsl:when>
                                <xsl:when test="noteType = 'Normal'">
                                    <xsl:text>n</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                        
                        <xsl:attribute name="tilt">
                            <xsl:text>se</xsl:text>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </neume>
        </syllable>
    </xsl:template>
</xsl:stylesheet>''')
    myxsl = etree.XSLT(myxsl)
    #myxsl(etree.parse("tests/ANO_RS1098_Tres_haute_amours,_qui_tant_sest_abessie-M12v.json.xml"))

    return myxsl(etree.fromstring(xm))


def MEI_to_TXT(mei, withOctaves=False):
    '''
    Takes an etree mei document, and outputs a simple txt.
    :param mei:
    :return:
    '''
    if withOctaves:
        myxsl = etree.XML('''
            <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mei="http://www.music-encoding.org/ns/mei"
                exclude-result-prefixes="xs" version="1.0">
                <xsl:output method="text" encoding="UTF-8"/>

                <xsl:template match="/">
                    <xsl:apply-templates select="descendant::mei:syllable"/>
                </xsl:template>

                <xsl:template match="mei:syllable">
                    <xsl:text>/</xsl:text>
                    <xsl:apply-templates select="mei:neume"/>
                </xsl:template>

                <xsl:template match="mei:neume">
                    <xsl:apply-templates select="mei:nc"/>
                </xsl:template>

                <xsl:template match="mei:nc">
                    <xsl:value-of select="@pname"/>
                    <xsl:value-of select="@oct"/>
                </xsl:template>

            </xsl:stylesheet>
                ''')

    else:
        myxsl = etree.XML('''
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mei="http://www.music-encoding.org/ns/mei"
        exclude-result-prefixes="xs" version="1.0">
        <xsl:output method="text" encoding="UTF-8"/>
    
        <xsl:template match="/">
            <xsl:apply-templates select="descendant::mei:syllable"/>
        </xsl:template>
    
        <xsl:template match="mei:syllable">
            <xsl:text>/</xsl:text>
            <xsl:apply-templates select="mei:neume"/>
        </xsl:template>
    
        <xsl:template match="mei:neume">
            <xsl:apply-templates select="mei:nc"/>
        </xsl:template>
    
        <xsl:template match="mei:nc">
            <xsl:value-of select="@pname"/>
        </xsl:template>
    
    </xsl:stylesheet>
        ''')

    myxsl = etree.XSLT(myxsl)
    return myxsl(mei)


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
        my_txt.write_output('txt/noOctaves/' + path.split('/')[-1].split('.')[0] + '.txt')
        my_txt = MEI_to_TXT(my_mei, withOctaves=True)
        my_txt.write_output('txt/withOctaves/' + path.split('/')[-1].split('.')[0] + '.txt')
