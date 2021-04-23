<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mei="http://www.music-encoding.org/ns/mei" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/">
        <mei>
            <xsl:variable name="meiversion" select="'3.0.0'"/>
            <!-- The variable meiversion can be used for further processing.  -->


            <xsl:attribute name="meiversion">
                <xsl:value-of select="$meiversion"/>
            </xsl:attribute>
            <meiHead>

                <!-- The variable meiversion can be used for further processing.  -->


                <xsl:attribute name="meiversion">
                    <xsl:value-of select="$meiversion"/>
                </xsl:attribute>
                <fileDesc>
                    <titleStmt>
                        <xsl:for-each select=".">
                            <title>
                                <xsl:value-of select="''"/>
                            </title>
                        </xsl:for-each>
                    </titleStmt>
                    <pubStmt>
                        <xsl:value-of select="''"/>
                    </pubStmt>
                </fileDesc>
                <encodingDesc>
                    <appInfo>
                        <application version="unknown">
                            <name>Verovio</name>
                        </application>
                    </appInfo>
                </encodingDesc>
            </meiHead>
            <music>
                <!-- The variable meiversion can be used for further processing.  -->


                <xsl:attribute name="meiversion">
                    <xsl:value-of select="$meiversion"/>
                </xsl:attribute>

                <body>

                    <mdiv>
                        <xsl:for-each select="root/TEI/children/item/children/item">
                            <xsl:element name="score">
                                <xsl:element name="scoreDef">
                                    <xsl:element name="staffGrp">
                                        <xsl:element name="staffDef">
                                            <xsl:for-each select=".//children/item/base">
                                            <xsl:attribute name="clef.shape">
                                                <xsl:value-of select=".//base/text()"/>
                                                <xsl:apply-templates select=".//base[text()]"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="clef.line"/>
                                            <xsl:attribute name="n"/>
                                            <xsl:attribute name="lines"/>
                                            <xsl:attribute name="notationtype">
                                                <xsl:apply-templates select="'mensural.black'"/>
                                            </xsl:attribute>
                                            </xsl:for-each>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                                <xsl:element name="section">
                                    <xsl:attribute name="n">
                                        <xsl:number/>
                                    </xsl:attribute>


                                    <xsl:element name="measure">
                                        <xsl:element name="staff">
                                            <xsl:attribute name="n">
                                                <xsl:number/>
                                            </xsl:attribute>
                                            <xsl:element name="layer">
                                                <xsl:attribute name="n">
                                                  <xsl:number level="multiple"/>
                                                </xsl:attribute>
                                                

                                                <xsl:for-each
                                                  select=".//children/item">
                                                  <xsl:element name="note">
                                                  <xsl:attribute name="pname">
                                                  <xsl:value-of select=".//base/text()"/>
                                                  <xsl:apply-templates select="base[text()]"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="oct">
                                                  <xsl:value-of select=".//octave/text()"/>
                                                  <xsl:apply-templates select="octave[text()]"/>
                                                  </xsl:attribute>
                                                  <xsl:attribute name="dur">
                                                  <xsl:apply-templates select="'brevis'"/>
                                                  </xsl:attribute>
                                                  <xsl:element name="plica">
                                                      <xsl:attribute name="dir"/>
                                                  </xsl:element>
                                                  </xsl:element>
                                                </xsl:for-each>
                                                



                                                <!--    <xsl:for-each
                                          select="root/TEI/children/item/children/item/children/item">
                                          <xsl:element name="note">
                                            <xsl:attribute name="id">
                                            <xsl:value-of
                                            select=".//children/item/children/item/children/item/uuid/text()"/>
                                            <xsl:apply-templates select="uuid[text()]"/>
                                            </xsl:attribute>
      
                                            <xsl:attribute name="focus">
                                            <xsl:value-of select=".//focus/text()"/>
                                            <xsl:apply-templates select="focus[text()]"/>
                                            </xsl:attribute>
      
                                            <xsl:attribute name="pname">
                                            <xsl:value-of select=".//base/text()"/>
                                            <xsl:apply-templates select="base[text()]"/>
                                            </xsl:attribute>
      
                                            <xsl:attribute name="oct">
                                            <xsl:value-of select=".//octave/text()"/>
                                            <xsl:apply-templates select="octave[text()]"/>
                                            </xsl:attribute>
      
                                            <xsl:attribute name="kind">
                                            <xsl:value-of
                                            select="root/TEI/children/item/children/item/children/item/kind/text()"/>
                                            <xsl:apply-templates select="kind[text()]"/>
                                            </xsl:attribute>
                                          </xsl:element>
                                      </xsl:for-each> -->


                                            </xsl:element>

                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:for-each>
                    </mdiv>
                    <xsl:element name="annot"/>
                    <xsl:element name="typeDesc">
                        <xsl:value-of select="root/TEI/documentType"/>
                    </xsl:element>
                    <xsl:element name="version"/>
                    <xsl:element name="sourceDesc">
                        <xsl:value-of select="root/TEI/kind"/>
                    </xsl:element>
                </body>
            </music>
        </mei>
    </xsl:template>
</xsl:stylesheet>
