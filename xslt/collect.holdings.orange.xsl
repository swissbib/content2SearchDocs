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
        <xsl:if test="matches(subfield[@code='B'], 'IDSBB|SNL|RETROS') or matches(subfield[@code='F'], 'E30|E44|E96|N01|N02')">
            <xsl:element name="datafield" >
                <xsl:attribute name="tag">852</xsl:attribute>
                <xsl:attribute name="ind1">
                    <xsl:value-of select="@ind1"/>
                </xsl:attribute>
                <xsl:attribute name="ind2">
                    <xsl:value-of select="@ind2"/>
                </xsl:attribute>
                <xsl:copy-of select="."/>
                <xsl:apply-templates/>                
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="datafield[@tag='949']">
        <xsl:if test="matches(subfield[@code='B'], 'IDSBB|SNL|RETROS') or matches(subfield[@code='F'], 'E30|E44|E96|N01|N02')">
            <xsl:element name="datafield" >
                <xsl:attribute name="tag">949</xsl:attribute>
                <xsl:attribute name="ind1">
                    <xsl:value-of select="@ind1" />
                </xsl:attribute>
                <xsl:attribute name="ind2">
                    <xsl:value-of select="@ind2" />
                </xsl:attribute>
                <xsl:copy-of select="."/>
                <xsl:apply-templates/>                
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    
</xsl:stylesheet>
