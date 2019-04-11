<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:java-isbn-ext="java:org.swissbib.documentprocessing.plugins.CreateSecondISBN"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:swissbib="www.swissbib.org/solr/documentprocessing.plugins"
                exclude-result-prefixes="fn swissbib java-isbn-ext">
    <!--xmlns:fn="http://www.w3.org/2005/xpath-functions"> -->

    <xsl:output method="xml"
            encoding="UTF-8"
            indent="yes"
            omit-xml-declaration="yes"
/>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>

        Testscript für den Aufruf externer plugins

    </desc>
</doc>

    <xsl:param name="holdingsStructure" select="''"/>

    <!--=================
        CALLING TEMPLATES
        =================-->
    <xsl:template match="/">
        <doc>

            <xsl:call-template name="bibid">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
        </doc>
    </xsl:template>


    <!-- bibliographic identifiers -->
    <xsl:template name="bibid">
        <xsl:param name="fragment"/>
        <xsl:for-each select="$fragment/datafield[@tag='015']/subfield[@code='a']">
            <field name="nbn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='016']/subfield[@code='a']">
            <field name="nbacn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>



        <xsl:variable name="createISBNFacade" select="java-isbn-ext:new()" />


        <xsl:for-each select="$fragment/datafield[@tag='020']/subfield[@code='a']">
            <field name="isbn">
                <xsl:value-of select="." />
            </field>

            <xsl:variable name="currentISBN" select="." />

            <xsl:variable name="vISBNVariation" select="java-isbn-ext:getAlternativeISBN($createISBNFacade, $currentISBN)"/>


            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'variant_isbn_isn_mv'" />
                <xsl:with-param name="fieldValues" select="$vISBNVariation"/>
            </xsl:call-template>


        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='020']/subfield[@code='z']">
            <field name="cancisbn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='022']/subfield[@code='a']">
            <field name="issn">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='022']/subfield[@code='y']">
            <field name="incoissn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='022']/subfield[@code='z']">
            <field name="cancissn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='2']/subfield[@code='a']">
            <field name="ismn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='2']/subfield[@code='z']">
            <field name="cancismn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='7'][matches(descendant::subfield[@code='2'],'doi', 'i')]/subfield[@code='a']">
            <field name="doi_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='7'][matches(descendant::subfield[@code='2'],'URN', 'i')]/subfield[@code='a']">
            <field name="urn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='8']/subfield[@code='a']">
            <field name="other_id_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='773']/subfield[@code='o']">
            <field name="hostotherID_str_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='773']/subfield[@code='x']">
            <field name="hostissn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='773']/subfield[@code='y']">
            <field name="hostisbn_isn_mv">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="createUniqueFields">
        <xsl:param name="fieldname"/>
        <xsl:param name="fieldValues"/>
        <xsl:if test="(count($fieldValues) > 0) and $fieldValues[1][. ne '']">
            <xsl:for-each select="$fieldValues">
                <xsl:element name="field">
                    <xsl:attribute name="name">
                        <xsl:value-of select="$fieldname"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
        <!--<xsl:if test="(count($fieldValues) > 0) and $fieldValues[1][. ne '']"> -->
    </xsl:template>


</xsl:stylesheet>
