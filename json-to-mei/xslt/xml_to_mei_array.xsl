<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.music-encoding.org/ns/mei" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" exclude-result-prefixes="xs math xd">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <mei meiversion="4.0.0">
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
            <!-- JBC: Je simplifie le code… -->
            <music>
                <body>
                    <mdiv>
                        <score>
                            <xsl:apply-templates select="JSON/children/array"/>
                        </score>
                    </mdiv>
                </body>
            </music>
        </mei>
    </xsl:template>

    <!--    <xsl:template match="TEI">
        <music>
            <xsl:apply-templates select="children"/>
        </music>
    </xsl:template>
    <xsl:template match="/root/TEI/children">
        <body>
            <mdiv>
            <xsl:apply-templates select="item"/>
            </mdiv>
        </body>
    </xsl:template>
    <xsl:template match="/root/TEI/children/item">
        
            <xsl:apply-templates select="children"/>
        
    </xsl:template>
-->
    <xsl:template match="array[kind = 'FormteilContainer']">
        <!--match="/root/TEI/children/item/children/item">-->

        <!-- JBC: Je ne comprends pas: vous voulez un mdiv par petit item ? Ou un par pièce ?-->
        <!-- si le second cas, pourquoi le laisser ici ? -->
        <!--<mdiv>-->

        <!-- JBC: l'instruction suivante ne sert à rien (= aucun effet). Je retire. -->
        <!--<xsl:apply-templates select="/root/TEI/children/item/children/text()"/>-->

        <!-- Par rapport à votre question, il est logique que les staffDef soient répétés à chaque item,
        puisque c'est ici que figurait l'instruction.
        -->
        <!--<score>-->
        <!-- JBC: commençons donc par les clés -->
        <scoreDef>
            <staffGrp>
                <!-- JBC: si on veut un staffDef par shape, alors c'est ça qu'il faut matcher -->
                <xsl:apply-templates select="descendant::children[kind = 'Clef']"/>
            </staffGrp>
        </scoreDef>

        <!-- JBC: est-ce moi, où est-ce que les sections ne se situeraient pas plutôt à un niveau inférieur de l'arborescence ??? -->

        <xsl:apply-templates select="children[kind = 'ZeileContainer']"/>

        <!--        <section>
            <xsl:attribute name="n">
                <xsl:number level="single"/>
            </xsl:attribute>
            
            <!-\- JBC: non non non, pas d'instruction comme ça par pitié. -\->
            <!-\-<xsl:apply-templates select="/root/TEI/children/item/children/item/children/text()"/>-\->
            <!-\- En outre, elle n'a pas d'effet, car, le seul contenu texte de l'élément en question est de l'espacement -\->


            <measure>
                <staff>
                    <xsl:attribute name="n">
                        <xsl:number value="'1'"/>
                    </xsl:attribute>

                    <layer>
                        <xsl:attribute name="n">
                            <xsl:number value="'1'"/>
                        </xsl:attribute>

                        <xsl:for-each select=".//children/item">

                            <syllable>
                                <xsl:element name="syl">


                                    <xsl:apply-templates select="text"/>
                                </xsl:element>

                                <neume>
                                    <xsl:for-each select=".//grouped/item">

                                        <xsl:element name="nc">

                                            <xsl:attribute name="pname">



                                                <xsl:apply-templates
                                                  select="base/lower-case(text())"/>
                                            </xsl:attribute>

                                            <xsl:attribute name="oct">

                                                <xsl:apply-templates select="'2'"/>
                                            </xsl:attribute>


                                            <xsl:attribute name="intm">
                                                <!-\- stem.dir -\->
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


                                            <xsl:attribute name="tilt">
                                                <xsl:apply-templates select="'se'"/>
                                            </xsl:attribute>




                                        </xsl:element>

                                    </xsl:for-each>



                                </neume>
                            </syllable>
                        </xsl:for-each>

                    </layer>
                </staff>
            </measure>

        </section>-->
        <!--</score>-->
        <!--</mdiv>-->

    </xsl:template>

    <xsl:template match="children[kind ='Clef']">
        <staffDef>
            <!-- JBC: on est d'accord que cette instruction ne sert à rien? -->
            <!--<xsl:value-of select="shape"/>-->

            <xsl:attribute name="clef.shape">
                <xsl:apply-templates select="shape"/>
                <!-- select=".//shape/[text()]"/>-->
                <!-- Tous les descendants shape tels qu'ils contiennent du texte ??? -->
            </xsl:attribute>

            <xsl:attribute name="n">
                <!-- Tout ce qui suit est en dur car pas dans le doc source ? -->
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

    <xsl:template match="children[kind = 'ZeileContainer']">
        <section>
            <xsl:attribute name="n">
                <xsl:number level="single"/>
            </xsl:attribute>

            <!-- JBC: non non non, pas d'instruction comme ça par pitié. -->
            <!--<xsl:apply-templates select="/root/TEI/children/item/children/item/children/text()"/>-->
            <!-- En outre, elle n'a pas d'effet, car, le seul contenu texte de l'élément en question est de l'espacement -->
            
            <staff>
                <xsl:attribute name="n">
                    <xsl:number level="single"/>
                </xsl:attribute>
                <layer>

            
                
                        


                        <xsl:apply-templates
                            select="children[kind = 'Syllable'] | children[kind = 'LineChange']"/>
                        <!-- JBC: je m'arrête là, et je vous laisse reprendre la suite, en définissant le traitement de ces items. -->

                        <!-- JBC: ah non, pas de for-each ici ! -->
                    
                </layer>
            </staff>
        </section>
    </xsl:template>
    <xsl:template match="children[kind = 'Syllable'] | children[kind = 'LineChange']">
        

        <xsl:apply-templates select=".//children/array"/>
        <syllable>

            <xsl:element name="syl">


                <xsl:value-of select=".//text"/>
            </xsl:element>

            <neume>

                <xsl:for-each select=".//grouped">

                    <xsl:element name="nc">

                        <xsl:attribute name="pname">



                            <xsl:apply-templates select=".//base/lower-case(text())"/>
                        </xsl:attribute>

                        <xsl:attribute name="oct">

                            <xsl:apply-templates select="'2'"/>
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


                        <xsl:attribute name="tilt">
                            <xsl:apply-templates select="'se'"/>
                        </xsl:attribute>




                    </xsl:element>

                </xsl:for-each>



            </neume>

        </syllable>
    </xsl:template>
</xsl:stylesheet>
