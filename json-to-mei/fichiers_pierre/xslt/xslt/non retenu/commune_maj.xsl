<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd">
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
            <measure>
                <xsl:element name="slur">
                    <xsl:attribute name="xml:id"/>
                    <xsl:attribute name="staff"/>
                    <xsl:attribute name="startid"/>
                    <xsl:attribute name="endid"/>
                </xsl:element>
            </measure>
        </section>
    </xsl:template>
    <xsl:template match="item[kind = 'Syllable'] | item[kind = 'LineChange']">
        
        
        <xsl:apply-templates select=".//children/item"/>
        <syllable>
            
            
            
            
                
                <xsl:for-each select=".//grouped/item">
                    
                    <xsl:element name="note">
                        
                        <xsl:attribute name="pname">
                            
                            
                            
                            <xsl:apply-templates select="base/lower-case(text())"/>
                        </xsl:attribute>
                        
                        <xsl:attribute name="oct">
                            
                            <xsl:apply-templates select="'2'"/>
                        </xsl:attribute>
                        
                        <xsl:attribute name="dur"> <!-- Afin d'afficher des notes rondes, la durée est obligatoire -->
                            <xsl:apply-templates select="'4'"/>
                        </xsl:attribute>
                        
                        <xsl:attribute name="intm">
                            
                            <xsl:choose>
                                
                                <xsl:when test=".//noteType/text() = 'Descending'">
                                    
                                    <xsl:apply-templates select="'d'"/>
                                </xsl:when>
                                <xsl:when test=".//noteType/text() = 'Ascending'">
                                    
                                    <xsl:apply-templates select="'u'"/>
                                </xsl:when>
                                <xsl:when test=".//noteType/text() = 'Normal'">
                                    
                                    <xsl:apply-templates select="'n'"/>
                                </xsl:when>
                                
                            </xsl:choose>
                            
                        </xsl:attribute>
                        
                        <xsl:attribute name="stem.len">
                            <xsl:apply-templates select="'0'"/>
                        </xsl:attribute>
                        
                        <xsl:attribute name="accid.ges">
                            <xsl:apply-templates select="'n'"/>
                        </xsl:attribute>
                        
                        <verse>
                            <xsl:attribute name="xml:id"/>
                            <xsl:attribute name="n">
                                <xsl:number/>
                            </xsl:attribute>
                            
                            <xsl:element name="syl">
                                
                                <xsl:attribute name="xml:id"/>
                                <xsl:attribute name="con"/>
                                <xsl:attribute name="wordpos"/>
                                
                                <xsl:apply-templates select=".//../../../../../../../text"/>
                                
                            </xsl:element> 
                        </verse>    
                        
                        
                        
                    </xsl:element>
                    
                </xsl:for-each>
                
                
                
            
            
        </syllable>
        
    </xsl:template>
</xsl:stylesheet>