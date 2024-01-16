<?xml version="1.0" encoding="UTF-8" ?>
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
                <staffDef n="1" lines="5" notationtype="neume" clef.shape="G" clef.line="2"/>
                <!--<xsl:apply-templates select="descendant::item[kind = 'Clef']"/>--><!-- Missing in the source, need to update-->
            </staffGrp>
        </scoreDef>
        
        <xsl:apply-templates select="children/item[kind = 'ZeileContainer']"/>
        
        
    </xsl:template>
    
    <!--
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
    -->
    
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
            
            <xsl:for-each select="descendant::grouped">
                <xsl:element name="neume">
                    <xsl:for-each select="item">
                        <xsl:element name="nc">
                            <xsl:attribute name="pname">
                                <xsl:value-of select="translate(base/text(), 'ABCDEFG', 'abcdefg')"/>
                            </xsl:attribute>
                            <xsl:attribute name="oct">
                                <xsl:value-of select="octave"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="noteType"/>
                            <!-- "focus" ne nous intéresse pas a priori. Mais de quoi s'agit-il? -->
                            <xsl:apply-templates select="liquescent"/>
                            
                            
                            
                            <!-- Attributs non nécessaires, cf. mail LP -->
                            <!--<xsl:attribute name="intm">
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
                                </xsl:attribute>-->
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
            
        </syllable>
    </xsl:template>
    
    
    <xsl:template match="noteType">
        <xsl:if test=". != 'Normal'">
            <xsl:attribute name="accid.ges">
                <xsl:choose>
                    <xsl:when test="contains(., 'lat')"><!-- Flat/flat -->
                        <xsl:text>f</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'harp')"><!-- Sharp/sharp -->
                        <xsl:text>s</xsl:text>
                    </xsl:when>
                    <xsl:when test="contains(., 'atural')"><!-- Natural/natural -->
                        <xsl:text>n</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="liquescent">
        <xsl:if test="contains(., 'rue')"><!-- Hack for case of True/true -->
            <xsl:element name="liquescent"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
