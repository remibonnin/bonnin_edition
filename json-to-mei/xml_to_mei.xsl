<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    
    <xsl:template match="/">
        <mei>
            <xsl:apply-templates/>
        </mei>
    </xsl:template>
    <xsl:template match="TEI">
        <music>
            <xsl:apply-templates/>
        </music>
    </xsl:template>
    <xsl:template match="children[parent::TEI]">
        <body>
            <xsl:apply-templates/>
        </body>
    </xsl:template>
    
    <xsl:template match="item[parent::children[parent::TEI]]">
        <mdiv>
            <score>
                <xsl:apply-templates/>
            </score>
        </mdiv>
    </xsl:template>
    
    <!--/TEI/children/item/children/item-->
    <xsl:template match="item[parent::children[parent::item[parent::children[parent::TEI]]]]">
        <!-- D'abord, la clef -->
        <xsl:apply-templates select="item[1]"/>
        <!-- Ensuite, la section -->
        <xsl:apply-templates select="item[position()>1]"/>
    </xsl:template>
    
    <xsl:template match="item[kind = 'Clef']">
        <!-- Pour traiter les clefs -->
        <!-- Que veut-on en faire ? -->
        <scoreDef>
            <staffGrp>
                <staffDef>
                    <xsl:attribute name="clef.shape">
                        <xsl:value-of select="shape"/>
                    </xsl:attribute>
                   
                    <xsl:attribute name="n">
                        <xsl:number/>
                    </xsl:attribute>
                    <xsl:attribute name="lines">
                        <xsl:number value="'5'"/>
                    </xsl:attribute>
                    <xsl:attribute name="notationtype">
                        <xsl:apply-templates select="'mensural.black'"/>
                    </xsl:attribute>
                </staffDef>
            </staffGrp>
        </scoreDef>
    </xsl:template>
   
   
   <!-- À poursuivre -->
    <xsl:template match="item[text or notes]">
        <!-- Pour traiter les notes -->
        
        
    </xsl:template>
   
    
    <xsl:template match="/root/TEI/children/item/children/item">
            <xsl:apply-templates select="/root/TEI/children/item/children/item/children/text()"/>
            
        <section>
            <xsl:attribute name="n">
                <xsl:number level="single"/>
            </xsl:attribute>
            <measure>
            <xsl:apply-templates select="/root/TEI/children/item/children/item/children/text()"/>
           
                <staff>
                    <xsl:attribute name="n">
                        <xsl:number level="single"/>
                    </xsl:attribute>
                
                    <layer>
                        <xsl:attribute name="n">
                            <xsl:number level="multiple"/>
                        </xsl:attribute>
                        <xsl:for-each
                            select=".//children/item">
                            <syllabe>
                                <xsl:element name="syl">
                                    <xsl:apply-templates select=".//text/[text()]"/>
                                </xsl:element>
                        <neume>
                            <xsl:element name="nc">
                                <xsl:attribute name="pname">
                                    <xsl:value-of select="lower-case(base)"/>
                                </xsl:attribute>
                                <xsl:attribute name="oct">
                                    <xsl:apply-templates select="octave"/>
                                </xsl:attribute>
                                <!--
                                                        <xsl:attribute name="dur">
                                                            <xsl:apply-templates select="'brevis'"/>
                                                        </xsl:attribute>
                                                        -->
                                <xsl:element name="plica"/>                                
                            </xsl:element>
                            
                        </neume>
                            </syllabe>
                        </xsl:for-each>
                    </layer>
                </staff>
               
            </measure>
        </section>
    </xsl:template>



</xsl:stylesheet>
