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
        <library>E24</library><!-- Fachhochschule Nordwestschweiz, Pädagogik Brugg -->
        <library>E25</library><!-- Berner Fachhochschule - Architektur, Holz und Bau, Biel -->
        <library>E30</library><!-- Bibliothek Exakte Wissenschaften, Universität Bern -->
        <library>E31</library><!-- Fachhochschule Nordwestschweiz, Pädagogik Aarau -->
        <library>E39</library><!-- Fachhochschule Nordwestschweiz, Pädagogik Solothurn -->
        <library>E44</library><!-- Fachhochschule Nordwestschweiz, Hochschulbibliothek Muttenz -->
        <library>E50</library><!-- Fachhochschule Nordwestschweiz, Bibliothek Olten -->
        <library>E56</library><!-- Berner Fachhochschule - Technik und Informatik, Biel -->
        <library>E59</library><!-- Berner Fachhochschule - Architektur, Holz und Bau / Technik und Informatik, Burgdorf -->
        <library>E60</library><!-- Fachhochschule Nordwestschweiz, Technik und Wirtschaft, Windisch -->
        <library>E71</library><!-- BFH - Agrar-, Forst- und Lebensmittelwissenschaften, Zollikofen -->
        <library>E75</library><!-- Fachhochschule Nordwestschweiz, Gestaltung, Aarau -->
        <library>E96</library><!-- Schweizerische Nationalbank, Bibliothek Bern -->
        <library>N01</library><!-- FHNW Pädagogik Basel  -->
        <library>N02</library><!-- FHNW Pädagogik ISP, Basel --> 
        <library>N03</library><!-- FHNW Pädagogik Liestal  -->
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