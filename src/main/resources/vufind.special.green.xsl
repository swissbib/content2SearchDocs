<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:swissbib="www.swissbib.org/solr/documentprocessing.plugins"
    exclude-result-prefixes="fn swissbib"
>
    <!--xmlns:fn="http://www.w3.org/2005/xpath-functions"> -->
    
    <xsl:output method="xml"
        encoding="UTF-8"
        indent="yes"
        omit-xml-declaration="yes"
    />

    <xsl:template match="record">
        <xsl:choose>
            <xsl:when test="exists(datafield[@tag='490']/subfield[@code='9'])
                or exists(datafield[@tag='986'][matches(subfield[@code='a']/text(), '^SWISSBIB')])">
                <xsl:copy>
                    <xsl:call-template name="green_special">
                        <xsl:with-param name="record" select="." />
                    </xsl:call-template>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- fields for use in vufind hierarchy driver (standard linking fields 490) -->
    <xsl:template name="green_special">
        <xsl:param name="record" />
        <xsl:if test="exists(datafield[@tag='490']/subfield[@code='9'])">
            <hierarchytype>series</hierarchytype>
            <is_hierarchy_id>
                <xsl:value-of select="$record/myDocID" />
            </is_hierarchy_id>
            <is_hierarchy_title>
                <xsl:value-of select="$record/datafield[@tag='245']/subfield[@code='a'][1]" />
            </is_hierarchy_title>
        </xsl:if>
        <xsl:for-each select="datafield[@tag='490']/subfield[@code='9']">
            <hierarchy_top_id>
                <xsl:value-of select="."></xsl:value-of>
            </hierarchy_top_id>
            <hierarchy_top_title>
                <xsl:value-of select="preceding-sibling::subfield[@code='a'][1]" />
            </hierarchy_top_title>
            <hierarchy_parent_id>
                <xsl:value-of select="." />
            </hierarchy_parent_id>
            <hierarchy_parent_title>
                <xsl:value-of select="preceding-sibling::subfield[@code='a'][1]" />
            </hierarchy_parent_title>
            <xsl:choose>
                <xsl:when test="exists(preceding-sibling::subfield[@code='v'])">
                    <title_in_hierarchy>
                        <xsl:value-of select="concat(preceding-sibling::subfield[@code='v'][1], ' : ', $record/datafield[@tag='245']/subfield[@code='a'][1], ' (', $record/sortyear, ')')" />
                    </title_in_hierarchy>
                </xsl:when>
                <xsl:otherwise>
                    <title_in_hierarchy>
                        <xsl:value-of select="concat($record/datafield[@tag='245']/subfield[@code='a'][1], ' (', $record/sortyear, ')')" />
                    </title_in_hierarchy>
                </xsl:otherwise>
            </xsl:choose>
            <hierarchy_sequence>
                <xsl:value-of select="replace(preceding-sibling::subfield[@code='i'][1], '[/]', '.')" />
            </hierarchy_sequence>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag='986'][matches(subfield[@code='a']/text(), '^SWISSBIB')]/subfield[@code='b']">
            <groupid_isn_mv>
                <xsl:value-of select="." />
            </groupid_isn_mv>
        </xsl:for-each>
        <xsl:copy-of select="$record/node()" />
    </xsl:template>
    
</xsl:stylesheet>