<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    version="2.0">

    <!--
    Kommentar
    =========
    * erstellt Holdings und Items für die Indexierung
    * jätet (weeding) Holdings und Items, welche nicht der Definition des Index orange entsprechen (swissbib Basel Bern)
       (siehe skip-Zeilen 34 / 49)
       
    Geschichte
    ==========
    04.04.2012 : Guenter : erstellt, mit Erweiterungen von Oliver
    17.04.2012 : Oliver : erweitert um skip-Bedingung
    09.08.2013 : Oliver : angepasst für neue Holdingsstruktur CBS 7.x
    -->

    <xsl:output omit-xml-declaration="yes" />

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="datafield[@tag='852']">
        <xsl:if test="matches(subfield[@code='B'], 'IDSBB|SNL|RETROS|BORIS') or matches(subfield[@code='F'], '^E30$|^E44$|^E71$|^E75$|^E96$|^N01$|^N02$|^N03$|^N04$|^N05$|^N06$|^N07$|^N10$|^RE71020$|^IUFFP$|^CHSBK$')">
            <xsl:element name="datafield" >
                <xsl:attribute name="tag">852</xsl:attribute>
                <xsl:attribute name="ind1">
                    <xsl:value-of select="@ind1"/>
                </xsl:attribute>
                <xsl:attribute name="ind2">
                    <xsl:value-of select="@ind2"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="datafield[@tag='949']">
        <xsl:if test="matches(subfield[@code='B'], 'IDSBB|SNL|RETROS|BORIS') or matches(subfield[@code='F'], '^E30$|^E44$|^E71$|^E75$|^E96$|^N01$|^N02$|^N03$|^N04$|^N05$|^N06$|^N07$|^N10$|^RE71020$|^IUFFP$|^CHSBK$')">
            <xsl:element name="datafield" >
                <xsl:attribute name="tag">949</xsl:attribute>
                <xsl:attribute name="ind1">
                    <xsl:value-of select="@ind1" />
                </xsl:attribute>
                <xsl:attribute name="ind2">
                    <xsl:value-of select="@ind2" />
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="datafield[@tag=852]/subfield">
        <xsl:if test="matches(@code, 'a|F|B|j|s')">
            <xsl:copy-of select="." />
        </xsl:if>
    </xsl:template>
    <!-- a=Holding-Notiz, F=CHB-Bibliothek (Zweigstelle), B=Verbund-Code,
         j=Signatur 1, s=Signatur 2 -->

    <xsl:template match="datafield[@tag=949]/subfield">
        <xsl:if test="matches(@code, 'F|B|j|s|x|z|u')">
            <xsl:copy-of select="." />
        </xsl:if>
    </xsl:template>
    <!-- F=CHB-Bibliothek (Zweigstelle), B=Verbund-Code, 
         j=Signatur 1, s=Signatur 2, x=interne Notiz (NEL), z=Notiz/Bemerkung -->

    <xsl:template match="datafield[@tag=956]">
        <xsl:choose>
            <xsl:when test="matches(subfield[@code='B']/text(), 'IDSBB')">
                <xsl:copy-of select="." />
            </xsl:when>
            <!-- for non-IDSBB, leave out branchlibs in subfield $a -->
            <xsl:otherwise>
                <xsl:element name="datafield">
                    <xsl:attribute name="tag">956</xsl:attribute>
                    <xsl:attribute name="ind1">
                        <xsl:value-of select="@ind1" />
                    </xsl:attribute>
                    <xsl:attribute name="ind2">
                        <xsl:value-of select="@ind2" />
                    </xsl:attribute>
                    <xsl:copy-of select="subfield[@code='B'] | subfield[@code='C'] |
                        subfield[@code='d'] | subfield[@code='f'] |
                        subfield[@code='q'] | subfield[@code='u'] |
                        subfield[@code='x'] | subfield[@code='y']"
                    />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
