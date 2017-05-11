<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.loc.gov/MARC21/slim"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output
        method="xml"
        encoding="UTF-8"
        indent="yes"
        omit-xml-declaration="yes"
        
    />

    <xsl:template match="/">
        
        <xsl:call-template name="test500"/>
        <xsl:call-template name="test510"/>
        <xsl:call-template name="test550"/>
        <xsl:call-template name="test551"/>

        
    </xsl:template>
    
    
    <xsl:variable name="newline"><xsl:text>&#10;</xsl:text></xsl:variable>
    
    <xsl:template name="test500">
        <xsl:if test="matches(/record/datafield[@tag='500']/subfield[@code='4']/text(),'nawi|pseu')">
            <xsl:variable name="values">
                <xsl:text>500XLIMITERX</xsl:text>
                <xsl:if test="exists(/record/datafield[@tag='500']/subfield[@code='a'])">
                    <xsl:value-of select="/record/datafield[@tag='500']/subfield[@code='a']/text()"/>
                </xsl:if>
                <xsl:if test="exists(/record/datafield[@tag='500']/subfield[@code='b'])">
                    <xsl:text>###</xsl:text>
                    <xsl:value-of select="/record/datafield[@tag='500']/subfield[@code='b']/text()"/>
                </xsl:if>
                <xsl:if test="exists(/record/datafield[@tag='500']/subfield[@code='c'])">
                    <xsl:text>###</xsl:text>
                    <xsl:value-of select="/record/datafield[@tag='500']/subfield[@code='c']/text()"/>
                </xsl:if>
                <xsl:if test="exists(/record/datafield[@tag='500']/subfield[@code='d'])">
                    <xsl:text>###</xsl:text>
                    <xsl:value-of select="/record/datafield[@tag='500']/subfield[@code='d']/text()"/>
                </xsl:if>
                <xsl:if test="exists(/record/datafield[@tag='500']/subfield[@code='q'])">
                    <xsl:text>###</xsl:text>
                    <xsl:value-of select="/record/datafield[@tag='500']/subfield[@code='q']/text()"/>
                </xsl:if>
                <xsl:value-of select="$newline"/>
            </xsl:variable>
            <xsl:value-of select="$values"/>
            
        </xsl:if>
        
        
    </xsl:template>
    
    <xsl:template name="test510">
        <xsl:if test="matches(/record/datafield[@tag='510']/subfield[@code='4']/text(),'vorg|nach|nazw')">
            <xsl:variable name="values">
                <xsl:text>510XLIMITERX</xsl:text>
                <xsl:if test="exists(/record/datafield[@tag='510']/subfield[@code='a'])">
                    <xsl:value-of select="/record/datafield[@tag='510']/subfield[@code='a']/text()"/>
                </xsl:if>
                <xsl:if test="exists(/record/datafield[@tag='510']/subfield[@code='b'])">
                    <xsl:text>###</xsl:text>
                    <xsl:value-of select="/record/datafield[@tag='510']/subfield[@code='b']/text()"/>
                </xsl:if>
                <xsl:value-of select="$newline"/>
            </xsl:variable>
            <xsl:value-of select="$values"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="test550">
        <xsl:if test="matches(/record/datafield[@tag='550']/subfield[@code='4']/text(),'vorg|nach|nazw')">
            <xsl:variable name="values">
                <xsl:text>550XLIMITERX</xsl:text>
                <xsl:if test="exists(/record/datafield[@tag='550']/subfield[@code='a'])">
                    <xsl:value-of select="/record/datafield[@tag='550']/subfield[@code='a']/text()"/>
                </xsl:if>
                <xsl:value-of select="$newline"/>
            </xsl:variable>
            <xsl:value-of select="$values"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="test551">
        <xsl:if test="matches(/record/datafield[@tag='551']/subfield[@code='4']/text(),'vorg|nach|nazw')">
            <xsl:variable name="values">
                <xsl:text>551XLIMITERX</xsl:text>
                <xsl:if test="exists(/record/datafield[@tag='551']/subfield[@code='a'])">
                    <xsl:value-of select="/record/datafield[@tag='551']/subfield[@code='a']/text()"/>
                </xsl:if>
                <xsl:value-of select="$newline"/>
            </xsl:variable>
            <xsl:value-of select="$values"/>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>