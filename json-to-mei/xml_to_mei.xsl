<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    
    <!--
    <xsl:variable name="typeNote" select="noteType/text()"/>
    <xsl:variable name="liquescence" select="focus/text()"/>
    -->
    
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
        
        <mdiv>
            
            <xsl:apply-templates select="/root/TEI/children/item/children/text()"/>
            <score>
            <scoreDef>
                
                <staffGrp>
                    
                    <staffDef>
                        
                        <xsl:value-of select="shape"/>
                        
                        <xsl:attribute name="clef.shape">
                            
                            <xsl:apply-templates select=".//shape/[text()]"/>
                            
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
                    
                </staffGrp>
                
            </scoreDef>
            
        <section>
            <xsl:attribute name="n">
                <xsl:number level="single"/>
            </xsl:attribute>
            
            <xsl:apply-templates select="/root/TEI/children/item/children/item/children/text()"/>
            

                <staff>
                    <xsl:attribute name="n">
                        <xsl:number value="'1'"/>
                    </xsl:attribute>
                
                    <layer>
                        <xsl:attribute name="n">
                            <xsl:number value="'1'"/>
                        </xsl:attribute>
                        
                        <xsl:for-each
                            select=".//children/item">
                            
                            <syllable>
                                <xsl:element name="syl">
                                    
                                    
                                    <xsl:apply-templates select="text"/>
                                </xsl:element> 
                                 
                            <neume>
                            <xsl:for-each select=".//grouped/item">
                            
                                <xsl:element name="nc">
                                
                                <xsl:attribute name="pname">
                                    <xsl:value-of select="lower-case(base)"/>

                                </xsl:attribute>
                                
                                <xsl:attribute name="oct">
                                    <xsl:apply-templates select="octave"/>

                                </xsl:attribute>
                                <!--
                                <xsl:for-each select=".">
                                <xsl:attribute name="syl">
                                    
                                    
                                    <xsl:apply-templates select="../../../../../../../text"/>
                                    
                                </xsl:attribute>
                                </xsl:for-each>
                                -->
                                <xsl:attribute name="stem.dir">
                                    <xsl:choose>
                                        
                                    <xsl:when test=".//noteType/text()='Descending'">
                                       
                                        <xsl:apply-templates select="'down'"/>
                                    </xsl:when>
                                        <xsl:when test=".//noteType/text()='Ascending'">
                                            
                                            <xsl:apply-templates select="'up'"/>
                                        </xsl:when>
                                        
                                    </xsl:choose>
                                    
                                </xsl:attribute>
                                
                                <!--
                                                        <xsl:attribute name="dur">
                                                            <xsl:apply-templates select="'brevis'"/>
                                                        </xsl:attribute>
                                 
                                -->
                                
                                   
                            </xsl:element>
                            
                        </neume>
                         <!-- JBC: si vous voulez itérer sur la chaîne de caractères, ça ressemblera à quelque chose comme: -->
                         <xsl:for-each select="string-to-codepoints(base)">
                             <neume>
                                 <xsl:attribute name="pname">
                                     <xsl:value-of select="lower-case(codepoints-to-string(.))"/>
                                 </xsl:attribute>
                             </neume>
                         </xsl:for-each>
                                
                                
                            </syllabe>

                        </xsl:for-each>
                        
                    </layer>
                </staff>
            
            
        </section>

            </score> 
        </mdiv>
    </xsl:template>


</xsl:stylesheet>
