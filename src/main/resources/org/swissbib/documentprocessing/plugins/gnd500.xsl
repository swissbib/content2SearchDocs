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

        <xsl:call-template name="related_person"/>
        <xsl:call-template name="related_corporate"/>
        <!--<xsl:call-template name="related_topic"/>-->
        <xsl:call-template name="related_place"/>


    </xsl:template>


    <xsl:variable name="newline"><xsl:text>&#10;</xsl:text></xsl:variable>
    <xsl:template name="related_person">
        <xsl:for-each select="/record/datafield[@tag='500']">
            <xsl:for-each select="./subfield[@code='4']">
                <xsl:if test="matches(./text(),'nawi|pseu')">
                    <xsl:variable name="values">
                        <xsl:text>500XLIMITERX</xsl:text>
                        <xsl:if test="exists(../subfield[@code='a'])">
                            <xsl:value-of select="../subfield[@code='a']/text()"/>
                        </xsl:if>
                        <xsl:if test="exists(../subfield[@code='b'])">
                            <xsl:text>###</xsl:text>
                            <xsl:value-of select="../subfield[@code='b']/text()"/>
                        </xsl:if>
                        <xsl:if test="exists(../subfield[@code='c'])">
                            <xsl:text>###</xsl:text>
                            <xsl:value-of select="../subfield[@code='c']/text()"/>
                        </xsl:if>
                        <xsl:if test="exists(../subfield[@code='d'])">
                            <xsl:text>###</xsl:text>
                            <xsl:value-of select="../subfield[@code='d']/text()"/>
                        </xsl:if>
                        <xsl:if test="exists(../subfield[@code='q'])">
                            <xsl:text>###</xsl:text>
                            <xsl:value-of select="../subfield[@code='q']/text()"/>
                        </xsl:if>
                        <xsl:value-of select="$newline"/>
                    </xsl:variable>
                    <xsl:value-of select="$values"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="related_corporate">
        <xsl:for-each select="/record/datafield[@tag='510']">
            <xsl:for-each select="./subfield[@code='4']">
                <xsl:if test="matches(./text(),'vorg|nach|nazw')">
                    <xsl:variable name="values">
                        <xsl:text>510XLIMITERX</xsl:text>
                        <xsl:if test="exists(../subfield[@code='a'])">
                            <xsl:value-of select="../subfield[@code='a']/text()"/>
                        </xsl:if>
                        <xsl:if test="exists(../subfield[@code='b'])">
                            <xsl:text>###</xsl:text>
                            <xsl:value-of select="../subfield[@code='b']/text()"/>
                        </xsl:if>
                        <xsl:value-of select="$newline"/>
                    </xsl:variable>
                    <xsl:value-of select="$values"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

<!--    <xsl:template name="related_topic">
        <xsl:for-each select="/record/datafield[@tag='550']">
            <xsl:for-each select="./subfield[@code='4']">
                <xsl:if test="matches(./text(),'obal')">
                    <xsl:variable name="values">
                        <xsl:text>550XLIMITERX</xsl:text>
                        <xsl:if test="exists(../subfield[@code='a'])">
                            <xsl:value-of select="../subfield[@code='a']/text()"/>
                        </xsl:if>
                        <xsl:value-of select="$newline"/>
                    </xsl:variable>
                    <xsl:value-of select="$values"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>-->

    <xsl:template name="related_place">
        <xsl:for-each select="/record/datafield[@tag='551']">
            <xsl:for-each select="./subfield[@code='4']">
                <xsl:if test="matches(./text(),'vorg|nach|nazw')">
                    <xsl:variable name="values">
                        <xsl:text>551XLIMITERX</xsl:text>
                        <xsl:if test="exists(../subfield[@code='a'])">
                            <xsl:value-of select="../subfield[@code='a']/text()"/>
                        </xsl:if>
                        <xsl:value-of select="$newline"/>
                    </xsl:variable>
                    <xsl:value-of select="$values"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>