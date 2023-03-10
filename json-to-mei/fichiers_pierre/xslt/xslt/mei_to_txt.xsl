<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mei="http://www.music-encoding.org/ns/mei"
    exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="text"/>

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
