<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mei="http://www.music-encoding.org/ns/mei"
    exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="text" encoding="UTF-8"/>
    
    
    <xsl:param name="notes">True</xsl:param>
    <xsl:param name="octaves">False</xsl:param>
    <xsl:param name="intervals">False</xsl:param>
    <xsl:param name="complexintervals">False</xsl:param>
    
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
        <xsl:if test="$notes = 'True'">
            <xsl:value-of select="@pname"/>
        </xsl:if>
        <xsl:if test="$octaves = 'True'">
            <xsl:value-of select="@oct"/>
        </xsl:if>
        <xsl:if test="$intervals = 'True' or $complexintervals = 'True'">
            <xsl:choose>
                <xsl:when test="not(preceding::mei:nc)">
                    <xsl:value-of select="''"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="notesValues" select="'cdefgab'"/><!-- Octave commence sur do -->
                    <xsl:variable name="numericValues" select="'1234567'"/>
                    <xsl:if test="$complexintervals= 'True'">
                            <xsl:variable 
                                name="absoluteNoteInterval"
                                select="
                                number(translate(
                                ( number(translate(preceding::mei:nc[1]/@pname, $notesValues, $numericValues)) 
                                + ( preceding::mei:nc[1]/@oct - 1 ) * 7
                                )
                                -
                                ( number(translate(@pname, $notesValues, $numericValues))
                                + ( @oct - 1 ) * 7
                                )
                                ,
                                '-',
                                ''
                                )) + 1 
                                "
                            />
                            <xsl:value-of select="
                                $absoluteNoteInterval
                                "/>
                        </xsl:if>
                        <xsl:if test="$intervals = 'True'">
                            <xsl:variable 
                                name="absoluteNoteInterval"
                                select="
                                number(translate(
                                number(translate(preceding::mei:nc[1]/@pname, $notesValues, $numericValues)) - 
                                number(translate(@pname, $notesValues, $numericValues)),
                                '-',
                                ''
                                )) + 1
                                "
                            />
                            <xsl:value-of select="$absoluteNoteInterval"/>
                        </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
