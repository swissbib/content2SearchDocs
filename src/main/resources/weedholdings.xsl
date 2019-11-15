<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    version="2.0"
>
    
    <!--
    Kommentar
    =========
    * Skript jätet (weeding) Holdings und Items für die Indexierung im Index swissbib grün
    * ohne skip-Bedingungen, sämtliche Elemente werden übernommen
    
    Geschichte
    ==========
    12.08.2013 : Oliver : erstellt für Daten von CBS 7.x, Kürzungen
    -->
    
    <xsl:output omit-xml-declaration="yes" />
    
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="datafield[@tag=852]/subfield">
        <xsl:if test="matches(@code, 'a|F|B|b|j|s|x|c')">
            <xsl:copy-of select="." />
        </xsl:if>
    </xsl:template>
    <!-- a=Holding-Notiz, F=CHB-Bibliothek (Zweigstelle), B=Verbund-Code,
         j=Signatur 1, s=Signatur 2 -->
    
    <xsl:template match="datafield[@tag=949]/subfield">
        <xsl:if test="matches(@code, 'F|B|b|j|s|x|z|c')">
            <xsl:copy-of select="." />    
        </xsl:if>
    </xsl:template>
    <!-- F=CHB-Bibliothek (Zweigstelle), B=Verbund-Code, 
         j=Signatur 1, s=Signatur 2, x=interne Notiz (NEL), z=Notiz/Bemerkung -->
    
</xsl:stylesheet>