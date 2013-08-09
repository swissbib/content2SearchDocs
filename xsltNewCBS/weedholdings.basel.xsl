<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    version="2.0">

    <!--
    Kommentar
    =========
    * Das Skript baut auf dem urspruenglichen weedholdings.xsl auf und wurde von Oliver vereinfacht und um
      einige subfields aus dem Bereich 949 erweitert.
    * Das Skript wurde fuer swissbib orange erweitert um zwei if-Zeilen, welche in orange ungewollte 
      Items und Holdings skippen.
    * swissbib gruen kann und sollte die Struktur der 949 identisch uebernehmen, dazu muessen fuer eine
      eigene Datei lediglich die zwei skip-Bedinungen (Zeilen 33, 48) entfernt werden.

    Geschichte
    ==========
    04.04.2012 : Guenter : erstellt, mit Erweiterungen von Oliver
    17.04.2012 : Oliver  : erweitert um skip-Bedingung
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
        <xsl:if test="matches(subfield[@code='B'], 'IDSBB|SNL|RETROS') or matches(subfield[@code='b'], 'E2[45]|E3[019]|E44|E5[069]|E60|E7[15]|E96|N0[123]')">
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
        <xsl:if test="matches(subfield[@code='B'], 'IDSBB|SNL|RETROS') or matches(subfield[@code='b'], 'E2[45]|E3[019]|E44|E5[069]|E60|E7[15]|E96|N0[123]')">
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
        <xsl:if test="matches(@code, 'a|b|B|j')">
            <xsl:copy-of select="." />
        </xsl:if>
        <xsl:if test="self::subfield[@code='B'] eq 'RERO'">
            <xsl:element name="subfield">
                <xsl:attribute name="code">b</xsl:attribute>
                <xsl:value-of select="../subfield[@code='1']/text()" />
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!-- a=Textual holding description, b|1(ReRo)=location code, B=network code, j=call number -->
    
    <xsl:template match="datafield[@tag=949]/subfield">
        <xsl:if test="matches(@code, 'b|B|j|s|z|x')">
            <xsl:copy-of select="." />    
        </xsl:if>
    </xsl:template>
    <!-- b=location code, B=network, j=call number, s=second call number (used by NEBIS), x=internal note (NEL), z=Description or public note -->
    
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