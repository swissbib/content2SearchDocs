<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <!--
    Kommentar
    =========
    * erstellt Holdings und Items soweit relevant f. Orange
       
    Geschichte
    ==========
    25.11.2013 : Bernd  : Auswertung der Felder 852 und 949 auf Holdings f. Orange von weedholdings.orange.xsl hierher kopiert
                          mit Zusatz von jeweils <xsl:copy-of select="."/>
    -->

    <xsl:output
        omit-xml-declaration="yes"
        />

    <xsl:template match="@*|node()">
            <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

    <xsl:template match="record">
       <record>
           <xsl:apply-templates/>
       </record>
    </xsl:template>

    <xsl:template match="datafield[@tag='852']">
        <xsl:if test="matches(subfield[@code='B'], 'IDSBB|SNL|RETROS|BORIS') or matches(subfield[@code='F'], '^E30$|^E44$|^E71$|^E75$|^E96$|^N01$|^N02$|^N03$|^N04$|^N05$|^N06$|^N07$|^N10$|^RE71020$|^IUFFP$|^CHSBK$')">
            <xsl:copy-of select="."/>
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="datafield[@tag='949']">
        <xsl:if test="matches(subfield[@code='B'], 'IDSBB|SNL|RETROS|BORIS') or matches(subfield[@code='F'], '^E30$|^E44$|^E71$|^E75$|^E96$|^N01$|^N02$|^N03$|^N04$|^N05$|^N06$|^N07$|^N10$|^RE71020$|^IUFFP$|^CHSBK$')">
            <xsl:copy-of select="."/>
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
