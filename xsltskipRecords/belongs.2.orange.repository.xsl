<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:swissbib="www.swissbib.org/solr/documentprocessing"
    
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output omit-xml-declaration="yes" method="text"/>
    
    <!-- HOLDINGS-DEFINITION FOR ORANGE VIEW (SWISSBIB BASEL BERN)
         ===================================
         
         12.08.2013 : Oliver : umgestellt und gekuerzt für CBS 7.x
         **********
    -->
    
    <!-- Check Verbuende gegen Items und Holdings -->
    <xsl:variable name="networks">
        <database>IDSBB</database><!-- IDS Basel Bern, DSV01 -->
        <database>SNL</database><!-- Nationalbibliothek, Bern -->
        <database>RETROS</database><!-- retro.seals -->
    </xsl:variable>
    
    <!-- Check Zweigstellen gegen Items und Holdings -->
    <xsl:variable name="sublibs">
        <library>E30</library><!-- Bibliothek Exakte Wissenschaften, Universität Bern -->
        <library>E44</library><!-- Fachhochschule Nordwestschweiz, Hochschulbibliothek Muttenz -->
        <library>E71</library><!-- BFH Bern - Agrar-, Forst- und Lebensmittelwiss., Zollikofen -->
        <library>E75</library><!-- FHNW – Gestaltung und Kunst, Basel -->
        <library>E96</library><!-- Schweizerische Nationalbank, Bibliothek Bern -->
        <library>N01</library><!-- FHNW Pädagogik Basel  -->
        <library>N02</library><!-- FHNW Pädagogik ISP, Basel --> 
        <library>N03</library><!-- FHNW PH, Liestal -->
        <library>N04</library><!-- BFH Bern - Gesundheit -->
        <library>N05</library><!-- BFH Bern - HKB Mediothek -->
        <library>N06</library><!-- BFH Bern - Soziale Arbeit -->
        <library>N07</library><!-- BFH Bern - Wirtschaft -->
    </xsl:variable>
    
    <xsl:template match="/">
        <xsl:variable name="belongsToRepository">
            <xsl:choose>
                <xsl:when test="some $x in $sublibs/library
                    satisfies $x = /record/datafield[@tag='852']/subfield[@code='F']">
                    <xsl:value-of select="'true'" />                    
                </xsl:when>
                <xsl:when test="some $x in $networks/database
                    satisfies $x = /record/datafield[@tag='852']/subfield[@code='B']">
                    <xsl:value-of select="'true'" />                    
                </xsl:when>
                <xsl:when test="some $x in $networks/database
                    satisfies $x = /record/datafield[@tag='856']/subfield[@code='B']">
                    <xsl:value-of select="'true'" />                    
                </xsl:when>
                <xsl:when test="some $x in $sublibs/library
                    satisfies $x = /record/datafield[@tag='949']/subfield[@code='F']">
                    <xsl:value-of select="'true'" />                    
                </xsl:when>
                <xsl:when test="some $x in $networks/database
                    satisfies $x = /record/datafield[@tag='949']/subfield[@code='B']">
                    <xsl:value-of select="'true'" />                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'false'" />    
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$belongsToRepository" />            
    </xsl:template>
    
</xsl:stylesheet>
