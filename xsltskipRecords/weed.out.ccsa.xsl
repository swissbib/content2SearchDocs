<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:swissbib="www.swissbib.org/solr/documentprocessing"
    
    exclude-result-prefixes="xs"
    version="2.0">

        <!-- dieses template wurde zum Ausfiltern der Posters Saetze fuer den initialen ETH Export benoetigt -->


        <xsl:output omit-xml-declaration="yes" method="text"/>
        
        <xsl:template match="/">
            <xsl:variable name="isNotCCSA">
                <xsl:choose>
                    <xsl:when test="/record/datafield[@tag='949']/subfield[@code='B'] and
                            /record/datafield[@tag='949']/subfield[@code='B'] = 'CCSA'">
                        <xsl:value-of select="'false'" />
                    </xsl:when>

                    <xsl:when test="some $x in /record/datafield[@tag='856']/subfield[@code='u']
                         satisfies fn:matches($x,'ccsa\.admin\.ch')">
                        <xsl:value-of select="'false'" />
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:value-of select="'true'" />
                    </xsl:otherwise>

                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="$isNotCCSA" />
        </xsl:template>

</xsl:stylesheet>