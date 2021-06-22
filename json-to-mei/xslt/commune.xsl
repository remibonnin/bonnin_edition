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
            <xsl:apply-templates select="/root/TEI/children"/>
        </music>
    </xsl:template>
    <xsl:template match="/TEI/children">
        <body>
            <xsl:apply-templates select="/TEI/children/item"/>
        </body>
    </xsl:template>
    <xsl:template match="/root/TEI/children/item">
        
        <xsl:apply-templates select="/root/TEI/children/item/children"/>
        
    </xsl:template>
    
    <xsl:template match="/root/TEI/children/item/children/item">
        
        <mdiv>
            <xsl:attribute name="xml:id"/>
            <xsl:apply-templates select="/root/TEI/children/item/children/text()"/>
            <score>
                <xsl:attribute name="xml:id"/>
                <scoreDef>
                    <xsl:attribute name="xml:id"/>
                    <staffGrp>
                        <xsl:attribute name="xml:id"/>
                        
                        <staffDef>
                            <xsl:attribute name="xml:id"/>
                            <xsl:value-of select="shape"/>
                            
                            <xsl:attribute name="clef.shape">
                                
                                <xsl:apply-templates select="'G'"/>
                                
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
                                <xsl:apply-templates select="'cmn'"/>
                            </xsl:attribute>
                            
                        </staffDef>
                        
                    </staffGrp>
                    
                </scoreDef>
                
                <section>
                    <xsl:attribute name="xml:id"/>
                    <xsl:attribute name="n">
                        <xsl:number level="single"/>
                    </xsl:attribute>
                    
                    <xsl:apply-templates select="/root/TEI/children/item/children/item/children/text()"/>
                    
                    
                        <staff>
                            <xsl:attribute name="xml:id"/>
                            <xsl:attribute name="n">
                                <xsl:number value="'1'"/>
                            </xsl:attribute>
                            
                            <layer>
                                <xsl:attribute name="xml:id"/>
                                <xsl:attribute name="n">
                                    <xsl:number value="'1'"/>
                                </xsl:attribute>
                                
                                
                                    
                                    
                                <xsl:for-each select=".//../children/item">
                                    
                                       
                                    
                                    
                                            <xsl:for-each select=".//grouped/item">
                                               
                                                   
                                                <xsl:element name="note">
                                                    
                                                    <!--  -->
                                                    <xsl:attribute name="xml:id"/>
                                                    <xsl:attribute name="pname">
                                                        
                                                        
                                                        
                                                        <xsl:apply-templates select="base/lower-case(text())"/>
                                                    </xsl:attribute>
                                                    
                                                    <xsl:attribute name="oct">
                                                        
                                                        <xsl:apply-templates select=".//octave/text()"/>
                                                    </xsl:attribute>
                                                    
                                                    <xsl:attribute name="dur"> <!-- Afin d'afficher des notes rondes, la durée est obligatoire -->
                                                        <xsl:apply-templates select="'4'"/>
                                                    </xsl:attribute>
                                                    <!--
                                <xsl:for-each select=".">
                                <xsl:attribute name="syl">
                                    
                                    
                                    <xsl:apply-templates select="../../../../../../../text"/>
                                    
                                </xsl:attribute>
                                </xsl:for-each>
                                -->
                                                    
                                                    <xsl:attribute name="stem.dir"> <!-- stem.dir -->
                                                        <xsl:choose>
                                                            
                                                            <xsl:when test=".//noteType/text()='Descending'">
                                                                
                                                                <xsl:apply-templates select="'down'"/>
                                                            </xsl:when>
                                                            <xsl:when test=".//noteType/text()='Ascending'">
                                                                
                                                                <xsl:apply-templates select="'up'"/>
                                                            </xsl:when>
                                                            <xsl:when test=".//noteType/text()='Normal'">
                                                                
                                                                <xsl:apply-templates select="''"/>
                                                            </xsl:when>
                                                            
                                                        </xsl:choose>
                                                        
                                                    </xsl:attribute>
                                                    
                                                    <!-- 
                                                    <xsl:attribute name="stem.with">
                                                        <xsl:apply-templates select="'below'"/>
                                                    </xsl:attribute>
                                                     -->
                                                    <xsl:attribute name="stem.len">
                                                        <xsl:apply-templates select="'0'"/>
                                                    </xsl:attribute>
                                                    
                                                    <xsl:attribute name="accid.ges">
                                                        <xsl:apply-templates select="'n'"/>
                                                    </xsl:attribute>
                                                    <!--
                                                    <xsl:for-each-group select="../../../../nonSpaced" group-by="spaced/item">
                                                        <xsl:apply-templates select="../../../../../text"/>
                                                    </xsl:for-each-group>
                                                    -->
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
                                    
                                    
                                </xsl:for-each>
                                     
                                            
                                            <!--
                                <xsl:for-each select="string-to-codepoints(base)">
                                    <neume>
                                        <xsl:attribute name="pname">
                                            <xsl:value-of select="lower-case(codepoints-to-string(.))"/>
                                        </xsl:attribute>
                                    </neume>
                                </xsl:for-each>
                                -->
                                        
                                        
                                
                                
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
            </score> 
            <!--
            <xsl:for-each select=".//../children/item">
                <xsl:element name="lyrics">
                    <xsl:attribute name="staff">
                        <xsl:number level="multiple"/>
                    </xsl:attribute>
                    
                    <xsl:element name="syl">
                        
                        
                        <xsl:apply-templates select=".//../../../../../../../text"/>
                        
                    </xsl:element> 
                </xsl:element>
            </xsl:for-each>
            -->
        </mdiv>
        
    </xsl:template>
    
    
</xsl:stylesheet>
