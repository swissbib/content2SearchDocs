<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:java-tika-ext="java:org.swissbib.documentprocessing.plugins.FulltextContentEnrichment"
    xmlns:java-gnd-ext="java:org.swissbib.documentprocessing.plugins.GNDContentEnrichment"
    xmlns:java-viaf-ext="java:org.swissbib.documentprocessing.plugins.ViafContentEnrichment"
    xmlns:java-dsv11-ext="java:org.swissbib.documentprocessing.plugins.DSV11ContentEnrichment"
    xmlns:java-nodouble-ext="java:org.swissbib.documentprocessing.plugins.RemoveDuplicates"
    xmlns:java-isbn-ext="java:org.swissbib.documentprocessing.plugins.CreateSecondISBN"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:swissbib="www.swissbib.org/solr/documentprocessing.plugins" exclude-result-prefixes="java-tika-ext java-gnd-ext java-viaf-ext java-dsv11-ext java-nodouble-ext fn swissbib java-isbn-ext">
    <!--xmlns:fn="http://www.w3.org/2005/xpath-functions"> -->

    <xsl:output method="xml"
            encoding="UTF-8"
            indent="yes"
            omit-xml-declaration="yes"
/>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>
        Dieses Skript ist die zweite Stufe (step2) der Verarbeitung im Document-Processing zur Aufbereitung
        der Daten vor der eigentlich Indexierung.
        Siehe Kurzbeschreibung im Step1, Dokumentation im wiki, Issues, etc.

        ************************
        www.swissbib.org
        guenter.hipler@unibas.ch
        oliver.schihin@unibas.ch
        ************************

        ****************************
        07.02.2013 : Guenter : integration of complete holdings structure into the index as stored field
        ****************************
        09.08.2013 : Oliver : Beginn Anpassungen neues CBS
        ****************************
    </desc>
</doc>

    <xsl:param name="holdingsStructure" select="''"/>

    <!--=================
        CALLING TEMPLATES
        =================-->
    <xsl:template match="/">
        <doc>

            <xsl:call-template name="id_type">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="lang_country">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="classifications">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="jus_class_gen">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="jus_class_D">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="jus_class_E">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <!--xsl:call-template name="jus_class_F">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template -->
            <xsl:call-template name="format">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="bibid">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="container_id">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="series_hierarchy">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="callnumber">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="institution">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="e_institution">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="union">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="itemnote">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="itemid">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="location">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="filter">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="ctrlnum">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="publishDate">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="freshness">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="publplace">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="authors">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="titles">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="title_old">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="title_new">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="series">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="journals">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="add_fields">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="localcode">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="subpers_lcsh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtitle_lcsh">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="subtop_lcsh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
             <xsl:call-template name="subgeo_lcsh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
             <xsl:call-template name="subform_lcsh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subpers_mesh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtime_mesh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtop_mesh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subgeo_mesh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subform_mesh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subpers_gnd">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="subtitle_gnd">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="subtime_gnd">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtop_gnd">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subgeo_gnd">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subform_gnd">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subenrichment_gnd">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="subpers_rero">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtime_rero">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtop_rero">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subgeo_rero">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subform_rero">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subpers_idsbb">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtitle_idsbb">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="subtime_idsbb">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtop_idsbb">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subgeo_idsbb">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subform_idsbb">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subpers_idszbz">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtitle_idszbz">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="subtime_idszbz">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtop_idszbz">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subgeo_idszbz">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subform_idszbz">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subpers_sbt">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtime_sbt">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtop_sbt">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subgeo_sbt">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subform_sbt">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subpers_jurivoc">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtime_jurivoc">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subtop_jurivoc">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subgeo_jurivoc">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subform_jurivoc">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="auth_controlnumber">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="subundef">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="submusic">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="sublocal">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="fulltext">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="proctime_fullrecord">
                <xsl:with-param name="nativeXML" select="record" />
            </xsl:call-template>
            <xsl:call-template name="createHoldings" />
        </doc>
    </xsl:template>

    <!--======================
        CALLED NAMED TEMPLATES
        ======================-->

    <xsl:template name="id_type">
        <xsl:param name="fragment" />
        <field name="id">
            <xsl:value-of select="$fragment/myDocID" />
        </field>
        <field name="recordtype">marc</field>
    </xsl:template>

    <!-- codes: language / country of origin of publication -->
    <xsl:template name="lang_country">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <!-- remove undefined values (|||, und) from index -->
            <xsl:for-each select="$fragment/datafield[@tag='041']/subfield[@code='a']/text()">
                <xsl:choose>
                    <xsl:when test="matches(., '\|\|\||und')" />
                    <xsl:when test="string-length(.) &gt; 3" />
                    <xsl:otherwise>
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$fragment/controlfield[@tag='008']">
				<xsl:variable name="lang" select="substring(text()[1],36,3)"/>
				<xsl:choose>
				    <xsl:when test="matches($lang, '\|\|\||und')" />
				    <xsl:otherwise>
				        <xsl:value-of select="concat($fragment/substring(controlfield[@tag='008'][1],36,3), '##xx##')" />
				    </xsl:otherwise>
				</xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'language'" />
            <xsl:with-param name="fieldValues" select ="$uniqueSeqValues" />
        </xsl:call-template>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/controlfield[@tag='008']">
                <xsl:value-of select="concat(substring(text(),16,3), '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='044']/subfield[@code='a']/text()">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'origcountry_isn_mv'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- classifications -->
    <xsl:template name="classifications">
        <xsl:param name="fragment" />
        <!-- subject category codes (MARC field 072) -->
        <xsl:for-each select="$fragment/datafield[@tag='072']/subfield[@code='a']">
            <xsl:variable name="source" select="following-sibling::subfield[@code='2']/text()" />
            <field name="{concat('classif_', $source)}">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <!-- local category codes (MARC field 912) -->
        <xsl:for-each select="$fragment/datafield[@tag='912']/subfield[@code='a']">
            <field name="classif_912">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <!-- local category codes Basel/Bern (MARC field 912) -->
        <xsl:for-each select="$fragment/datafield[@tag='912'] [@ind2='7'][matches(descendant::subfield[@code='2'][1], '^SzZuIDS BS/BE', 'i')]/subfield[@code='a']">
            <field name="classif_912_BSBE">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <!-- UDC fields, standard and non-standard (11.10.2012 / osc) -->
        <xsl:for-each select="$fragment/datafield[@tag='080']/subfield[@code='a']">
            <field name="classif_udc">
                <xsl:value-of select="concat(., following-sibling::subfield[@code='x'][1], following-sibling::subfield[@code='x'][2], following-sibling::subfield[@code='x'][3])" />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^snl local', 'i')]/subfield[@code='u']">
            <field name="classif_udc">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='909'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'sb_xxxx', 'i')]/subfield[@code='c']">
            <field name="classif_udc">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <!-- DDC fields, standard and non-standard (11.10.2012 / osc) -->
        <xsl:for-each select="$fragment/datafield[@tag='082']/subfield[@code='a']">
            <field name="classif_ddc">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='909'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'sb_2001', 'i')]/subfield[@code='c']">)">
            <field name="classif_ddc">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='909'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'ehelv', 'i')]/subfield[@code='d']">)">
            <field name="classif_ddc">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <!-- DDC main class, standard and non-standard -->
        <xsl:for-each select="$fragment/datafield[@tag='082']/subfield[@code='a']">
            <field name="classif_ddc_main">
                <xsl:value-of select="concat('ddc', substring(., 1,1))" />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='909'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'sb_2001', 'i')]/subfield[@code='c']">)">
            <field name="classif_ddc_main">
                <xsl:value-of select="concat('ddc', substring(., 1,1))" />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='909'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'ehelv', 'i')]/subfield[@code='d']">)">
            <field name="classif_ddc_main">
                <xsl:value-of select="concat('ddc', substring(., 1,1))" />
            </field>
        </xsl:for-each>
        <!-- RVK / ZDBS classifications  -->
        <xsl:for-each select="$fragment/datafield[@tag='084']/subfield[@code='a']">
            <xsl:if test="matches(following-sibling::subfield[@code='2'], 'rvk', 'i')">
                <field name="classif_rvk">
                    <xsl:value-of select="." />
                </field>
            </xsl:if>
            <xsl:if test="matches(following-sibling::subfield[@code='2'], 'zdbs', 'i')">
                <field name="classif_zdbs">
                    <xsl:value-of select="." />
                </field>
            </xsl:if>
            <xsl:if test="matches(following-sibling::subfield[@code='2'], 'sdnb', 'i')">
                <field name="sdnb_str_mv">
                    <xsl:value-of select="." />
                </field>
            </xsl:if>
        </xsl:for-each>
        <!-- OCM / OWC classification-->
        <xsl:for-each select="$fragment/datafield[@tag='691'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb FG', 'i')]/subfield[@code='u'] ">
            <field name="classif_ocm">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='691'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb FH', 'i')]/subfield[@code='u'] ">
            <field name="classif_owc">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <!-- selected local classifications idsbb with source code)-->
        <xsl:for-each select="$fragment/datafield[@tag='691'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb FA', 'i')]/subfield[@code='u'] |
                              $fragment/datafield[@tag='691'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb GA', 'i')]/subfield[@code='u'] |
                              $fragment/datafield[@tag='691'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb GC', 'i')]/subfield[@code='u'] |
                              $fragment/datafield[@tag='691'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb GM', 'i')]/subfield[@code='u'] |
                              $fragment/datafield[@tag='691'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb GQ', 'i')]/subfield[@code='u'] ">
            <xsl:variable name="source" select="replace(following-sibling::subfield[@code='2']/text(),' ', '')" />
            <field name="{concat('classif_', $source)}">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <!-- local classifications (without source code) -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='691']/subfield[@code='u']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'classif_local'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- JUS classifications -->
    <xsl:template name="jus_class_gen">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'idslu L1', 'i')]/subfield[@code='u'] |
                                  $fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'dr-sys', 'i')]/subfield[@code='u']">
                <xsl:choose>
                    <xsl:when test="matches(., '^[\d].*')"> <!-- Takes care of ids-dr-sys without alphabetic prefix -->
                        <xsl:value-of select="concat(replace(., '^([\D]*[\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^[P][A|B|C|F][\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of irregular Lucerne case "P# 18.0" => "18" -->
                        <xsl:value-of select="concat(replace(., '^([P][A|B|C|F][\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^[P][A|B|C|F]')"> <!-- Takes care of Lucerne case "P# 18.12 de" => "18.12" -->
                        <xsl:value-of select="concat(replace(., '^([P][A|B|C|F][\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^[A|B|C][\D]*[-][\D]*[\s][\d]{1,2}[.][0]{1,2}.*')"> <!-- Takes care of irregular normal case "CA/CH-ZH 37.0 fr" => "37" -->
                        <xsl:value-of select="concat(replace(., '^([\D]*[-][\D]*[\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^[A|B|C][\w][\W][\w][\w][-][\w]*[\s].*')"> <!-- Takes care of irregular normal case "CA/CH-ZH 37.5 fr" => "37.5" -->
                        <xsl:value-of select="concat(replace(., '^([A|B|C][\D]*[-][\D]*[\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^[A|B|C][\D]*[\s][\d]{1,2}[.][0]{1,2}.*')"> <!-- Takes care of irregular normal case "CA/CH 37.0 fr" => "37" -->
                        <xsl:value-of select="concat(replace(., '^([\D]*[\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^[A|B|C][\D][\W][\D].*')"> <!-- Takes care of normal case "CA/CH 37.5 fr" => "37.5" -->
                        <xsl:value-of select="concat(replace(., '^([A|B|C][\D]*[\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^A[\s][\d]{1,2}.*')"> <!-- Takes care of irregular case of Bundesverwaltungsgericht "A 7.3 h" => "7.3" -->
                        <xsl:value-of select="concat(replace(., '^(A[\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'classif_drsys_gen'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="jus_class_D">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'idslu L1', 'i')]/subfield[@code='u'] |
                                  $fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'dr-sys', 'i')]/subfield[@code='u']">
                <xsl:choose>
                    <xsl:when test="matches(., '^PD[\s][\d]{1,2}[.][0]{1,2}.*')"> <!-- Takes care of irregular Lucerne case "PD 18.0" => "D 18" -->
                        <xsl:value-of select="concat(replace(., '^([P])([D][\s][\d]{1,2})([.][0]{1,2}[\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^PD[\s].*')"> <!-- Takes care of Lucerne case "PD 18.12 de" => "D 18.12" -->
                        <xsl:value-of select="concat(replace(., '^([P])([D][\s][\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^D[\D][\s][\d]{1,2}[.][0]{1,2}.*')"> <!-- Takes care of irregular normal case "D# 18.0" => "D 18" -->
                        <xsl:value-of select="concat(replace(., '^(D[\D][\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', 'D $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^D[\D][\s].*')"> <!-- Takes care of normal case "D# 18.12 de" => "D# 18.12" -->
                        <xsl:value-of select="concat(replace(., '^(D[\D][\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', 'D $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^D[\s][\d]{1,2}[.][0]{1,2}.*')"> <!-- Takes care of irregular special case "D 18.0" => "D 18" -->
                        <xsl:value-of select="concat(replace(., '^(D[\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', 'D $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^D[\s].*')"> <!-- Takes care of Lucerne case "D 18.12 de" => "D 18.12" -->
                        <xsl:value-of select="concat(replace(., '^(D[\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', 'D $2'), '##xx##')" />
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'classif_drsys_D'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="jus_class_E">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'idslu L1', 'i')]/subfield[@code='u'] |
                                  $fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'dr-sys', 'i')]/subfield[@code='u']">
                <xsl:choose>
                    <xsl:when test="matches(., '^PE[\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of Lucerne case "PE 18.0 de" => E 18 -->
                        <xsl:value-of select="concat(replace(., '^([P])([E][\s][\d]{1,2})([.][0]{1,2}[\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^PE')"> <!-- Takes care of special case "PE 18.12 de" => E 18.12 -->
                        <xsl:value-of select="concat(replace(., '^([P])([E][\s][\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^E[\D][\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of case "E# 18.0 de" => E 18 -->
                        <xsl:value-of select="concat(replace(., '^(E[\D][\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', 'E $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^E[\D][\s].*')"> <!-- Takes care of case "E# 18.12 de" => E 18.12 -->
                        <xsl:value-of select="concat(replace(., '^(E[\D][\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', 'E $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^E[\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of special case "E 18.0 de" => E 18 -->
                        <xsl:value-of select="concat(replace(., '^(E[\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', 'E $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^E[\s].*')"> <!-- Takes care of special case "E 18.12 de" => E 18.12 -->
                        <xsl:value-of select="concat(replace(., '^(E[\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', 'E $2'), '##xx##')" />
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'classif_drsys_E'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="jus_class_F">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'idslu L1', 'i')]/subfield[@code='u'] |
                                  $fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'dr-sys', 'i')]/subfield[@code='u']">
                <xsl:choose>
                    <xsl:when test="matches(., '^PF[\s][\d]{1,2}[.][0]{1,2}.*$')"> <!-- Takes care of irregular Lucerne case "PF 18.0" => "F 18" -->
                        <!-- The PF-values are treated as PC-values because it customary for IDSLU L1 to use the A/B/C-classifiaction for PF
                            xsl:value-of select="concat(replace(., '(^[P])([F][\s][\d]{1,2})([.][0]{1,2}[\s]?.*$)', '$2'), '##xx##')" / -->
                    </xsl:when>
                    <xsl:when test="matches(., '^PF.*$')"> <!-- Takes care of Lucerne case "PF 18.12 de" => "F 18.12" -->
                        <!-- The PF-values are treated as PC-values because it customary for IDSLU L1 to use the A/B/C-classifiaction for PF
                            xsl:value-of select="concat(replace(., '(^[P])([F][\s][\d]{1,2}[.]?[\d]{0,2})([\s]?.*$)', '$2'), '##xx##')" / -->
                    </xsl:when>
                    <xsl:when test="matches(., '^F[\D][\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of irregular case "FA 18.0" => "F 18" -->
                        <xsl:value-of select="concat(replace(., '(^[F][A][\s])([\d]{1,2})([.][0]{1,2}[\s]?.*$)', 'F $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^F[\D][\s].*')"> <!-- Takes care of case "FA 18.12 de" => "F 18.12" -->
                        <xsl:value-of select="concat(replace(., '(^[F][A][\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*$)', 'F $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^F[\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of special case "F 18.0 de" => F 18 -->
                        <xsl:value-of select="concat(replace(., '^(F[\s])([\d]{1,2})([.][0]{1,2}[\s]?.*)$', 'F $2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^F[\s].*')"> <!-- Takes care of special case "F 18.12 de" => F 18.12 -->
                        <xsl:value-of select="concat(replace(., '^(F[\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*)$', 'F $2'), '##xx##')" />
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'classif_drsys_F'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>





    <!-- main and added entries -->
    <xsl:template name="authors">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <!-- personal entries -->
            <xsl:for-each select="$fragment/datafield[matches(@tag, '100|700|800')]/subfield[@code='a'] |
                                  $fragment/datafield[@tag='880'][matches(child::subfield[@code='6'],'100|700|800')]/subfield[@code='a'] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '100|700')]/subfield[@code='a']">
                <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')" />
                <xsl:if test="following-sibling::subfield[@code='D']">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='D'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <!-- corporate entries -->
            <xsl:for-each select="$fragment/datafield[matches(@tag, '110|710|810')]/subfield[@code='a'] |
                                  $fragment/datafield[@tag='880'][matches(child::subfield[@code='6'],'110|710|810')]/subfield[@code='a'] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '110|710|810')]/subfield[@code='a']">
                <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')" />
                <xsl:if test="following-sibling::subfield[@code='b']">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <!-- meeting entries -->
            <xsl:for-each select="$fragment/datafield[matches(@tag, '111|711|811')]/subfield[@code='a'] |
                                  $fragment/datafield[@tag='880'][matches(child::subfield[@code='6'],'111|711|811')]/subfield[@code='a'] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '111|711|811')]/subfield[@code='a']">
                <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')" />
                <xsl:if test="following-sibling::subfield[@code='e']">
                    <xsl:for-each select="following-sibling::subfield[@code='e']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'author'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[matches(@tag, '100|700|800')]/subfield[matches(@code, '[b-df-su-z8]')] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '100|700|800')]/subfield[matches(@code, '[b-df-su-z]')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '110|710|810')]/subfield[matches(@code, '[c-df-su-z]')] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '110|710|810')]/subfield[matches(@code, '[c-df-su-z]')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '111|711|811')]/subfield[matches(@code, '[b-df-gk-su-z]')] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '111|711|811')]/subfield[matches(@code, '[b-df-gk-su-z]')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'author_additional'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <!-- added entries for IDSBB DSV11 -->
        <!-- authors -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='B'], 'IDSBB')][matches(child::subfield[@code='P'], '100|700')]/subfield[@code='a']">
            <xsl:variable name="dsv11Facade" select="java-dsv11-ext:new()" />
            <xsl:variable name="authorMatchString" select="replace(lower-case(concat(., following-sibling::subfield[@code='D'], 
                                                                                        following-sibling::subfield[@code='b'][1],
                                                                                        following-sibling::subfield[@code='c'][1],
                                                                                        following-sibling::subfield[@code='d'][1],
                                                                                        following-sibling::subfield[@code='q'][1])), '[\W]', '')" />
            <xsl:variable name="additionalDSV11Values" select="java-dsv11-ext:getAdditionalDSV11Values($dsv11Facade, string(100), $authorMatchString)"/>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($additionalDSV11Values)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'author_additional_dsv11_txt_mv'" />
                <xsl:with-param name="fieldValues" select ="$uniqueSeqValues" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- corporations -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='B'], 'IDSBB')][matches(child::subfield[@code='P'], '710')]/subfield[@code='a']">
            <xsl:variable name="dsv11Facade" select="java-dsv11-ext:new()" />
            <xsl:variable name="corpMatchString" select="replace(lower-case(concat(., following-sibling::subfield[@code='b'][1], following-sibling::subfield[@code='b'][2], following-sibling::subfield[@code='b'][3])), '[\W]', '')" />
            <xsl:variable name="additionalDSV11Values" select="java-dsv11-ext:getAdditionalDSV11Values($dsv11Facade, string(110), $corpMatchString)"/>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($additionalDSV11Values)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'author_additional_dsv11_txt_mv'" />
                <xsl:with-param name="fieldValues" select ="$uniqueSeqValues" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- congresses -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='B'], 'IDSBB')][matches(child::subfield[@code='P'], '711')]/subfield[@code='a']">
            <xsl:variable name="dsv11Facade" select="java-dsv11-ext:new()" />
            <xsl:variable name="congressMatchString" select="replace(lower-case(.), '[\W]', '')" />
            <xsl:variable name="additionalDSV11Values" select="java-dsv11-ext:getAdditionalDSV11Values($dsv11Facade, string(110), $congressMatchString)"/>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($additionalDSV11Values)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'author_additional_dsv11_txt_mv'" />
                <xsl:with-param name="fieldValues" select ="$uniqueSeqValues" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- added entries for GND -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '[17][01][01]')][matches(child::subfield[@code='E'], '[0-3]-')][matches(descendant::subfield[@code='0'][1], '^\(DE-588\)', 'i')]/subfield[@code='0']">
            <xsl:variable name="gndFacade" select="java-gnd-ext:new()" />
            <xsl:variable name="gndnumber" select="text()" />
            <xsl:variable name="forDeduplication" select="java-gnd-ext:getReferencesConcatenated($gndFacade, string($gndnumber))"></xsl:variable>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'author_additional_gnd_txt_mv'"/>
                <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
            </xsl:call-template>
        </xsl:for-each>
        <!-- relator specific search fields -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '100|700|110|710')]/subfield[@code='4']">
            <xsl:variable name="relatorcode" select="." />
            <xsl:variable name="forDeduplication">
                <xsl:for-each select="preceding-sibling::subfield[@code='a']">
                <xsl:value-of select="." />
                    <xsl:for-each select="following-sibling::subfield[matches(@code, '[Db-df-su-z]')]">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                <xsl:text>##xx##</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="concat('author_', $relatorcode, '_txt_mv')" />
                <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
            </xsl:call-template>
            </xsl:for-each>

        <!-- generic author facet-->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/navAuthor">
                <xsl:value-of select="concat(replace(., '\[forme avant 2007\]', '', 'i'), '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'navAuthor_full'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <!-- source specific author facet -->
        <xsl:for-each select="$fragment/datafield[@tag='979']/subfield[@code='a']">
            <xsl:variable name="source" select="following-sibling::subfield[@code='2']" />
            <field name="{concat('navAuthor_', $source)}">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/sortauthor">
            <field name="author_sort">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
    </xsl:template>

    <!-- subfield templates for name entries -->
    <xsl:template name="pers_sf">
        <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')"/>
        <xsl:if test="following-sibling::subfield[@code='D']">
            <xsl:value-of select="concat(', ', following-sibling::subfield[@code='D'][1])" />
        </xsl:if>
        <xsl:if test="following-sibling::subfield[@code='q']/text()">
            <xsl:value-of select="concat(' (', following-sibling::subfield[@code='q'][1], ')')" />
        </xsl:if>
        <xsl:if test="following-sibling::subfield[@code='b']/text()">
            <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])"/>
        </xsl:if>
        <xsl:if test="following-sibling::subfield[@code='c']/text()">
            <xsl:for-each select="following-sibling::subfield[@code='c']">
                <xsl:value-of select="concat(', ', .)"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="following-sibling::subfield[@code='d']/text()">
            <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
        </xsl:if>
        <xsl:text>##xx##</xsl:text>
    </xsl:template>

    <!-- Template zur Erstellung der Titelfelder gemaess VF-Standard
         Felder werden auch gefuellt, wenn kein Titel vorhanden ist, je nach Typ mit 773 oder 490 (first shot, 23.5.2013/osc) -->
    <xsl:template name="titles">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='a'][empty(following-sibling::subfield[@code='b'])]">
            <xsl:choose>
                <xsl:when test="matches(text(), '^@$') and exists($fragment/datafield[@tag='773'][1]/subfield[@code='t']/text())">
                    <field name="title">
                        <xsl:value-of select="concat($fragment/datafield[@tag='773'][1]/subfield[@code='t'][1], ', ', $fragment/datafield[@tag='773'][1]/subfield[@code='g'][1])" />
                    </field>
                    <field name="title_short">
                        <xsl:value-of select="concat($fragment/datafield[@tag='773'][1]/subfield[@code='t'][1], ', ', $fragment/datafield[@tag='773'][1]/subfield[@code='g'][1])" />
                    </field>
                    <field name="title_sub">
                        <xsl:value-of select="following-sibling::subfield[@code='b'][1]" />
                    </field>
                </xsl:when>
                <xsl:when test="matches(text(), '^@$') and exists($fragment/datafield[@tag='490'][1]/subfield[@code='a']/text())">
                    <field name="title">
                        <xsl:value-of select="concat($fragment/datafield[@tag='490'][1]/subfield[@code='a'][1], ', ', $fragment/datafield[@tag='490'][1]/subfield[@code='v'][1])" />
                    </field>
                    <field name="title_short">
                        <xsl:value-of select="concat($fragment/datafield[@tag='490'][1]/subfield[@code='a'][1], ', ', $fragment/datafield[@tag='490'][1]/subfield[@code='v'][1])" />
                    </field>
                    <field name="title_sub">
                        <xsl:value-of select="following-sibling::subfield[@code='b'][1]" />
                    </field>
                </xsl:when>
                <xsl:otherwise>
                    <field name="title">
                        <xsl:value-of select="." />
                    </field>
                    <field name="title_short">
                        <xsl:value-of select="." />
                    </field>
                    <field name="title_sub">
                        <xsl:value-of select="following-sibling::subfield[@code='b'][1]" />
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='a'][exists(following-sibling::subfield[@code='b'])]">
            <xsl:choose>
                <xsl:when test="matches(text(), '^@$') and exists($fragment/datafield[@tag='773']/subfield[@code='t']/text())">
                    <field name="title">
                        <xsl:value-of select="concat($fragment/datafield[@tag='773'][1]/subfield[@code='t'][1],
                                                    ', ', 
                                                    $fragment/datafield[@tag='773'][1]/subfield[@code='g'][1])" />
                    </field>
                    <field name="title_short">
                        <xsl:value-of select="concat($fragment/datafield[@tag='773'][1]/subfield[@code='t'][1], ', ', $fragment/datafield[@tag='773'][1]/subfield[@code='g'][1])" />
                    </field>
                    <field name="title_sub">
                        <xsl:value-of select="following-sibling::subfield[@code='b'][1]" />
                    </field>
                </xsl:when>
                <xsl:when test="matches(text(), '^@$') and exists($fragment/datafield[@tag='490']/subfield[@code='a']/text())">
                    <field name="title">
                        <xsl:value-of select="concat($fragment/datafield[@tag='490'][1]/subfield[@code='a'][1], 
                                                    ', ', 
                                                    $fragment/datafield[@tag='490'][1]/subfield[@code='v'][1])" />
                    </field>
                    <field name="title_short">
                        <xsl:value-of select="concat($fragment/datafield[@tag='490'][1]/subfield[@code='a'][1], ', ', $fragment/datafield[@tag='490'][1]/subfield[@code='v'][1])" />
                    </field>
                    <field name="title_sub">
                        <xsl:value-of select="following-sibling::subfield[@code='b'][1]" />
                    </field>
                </xsl:when>
                <xsl:otherwise>
                    <field name="title">
                        <xsl:value-of select="concat(., ' : ', following-sibling::subfield[@code='b'][1])" />
                    </field>
                    <field name="title_short">
                        <xsl:value-of select="." />
                    </field>
                    <field name="title_sub">
                        <xsl:value-of select="following-sibling::subfield[@code='b'][1]" />
                    </field>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='130']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='210']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='222']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '240|242|243|246|247')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '240|242|243|246|247')]/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '240|242|243|246|247')]/subfield[@code='n']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '240|242|243|246|247')]/subfield[@code='p']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='n']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='p']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='505']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='509']/subfield[matches(@code, 'a|t|p')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='534']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='700']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='710']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='730']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='740']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='740']/subfield[@code='p']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '765|767|775|776|777|786|787')]/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'245')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'246')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'505')]/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '240')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'title_alt'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <!-- titles variants from DSV11 -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='B'], 'IDSBB')][matches(child::subfield[@code='P'], '730')]/subfield[@code='a']">
            <xsl:variable name="dsv11Facade" select="java-dsv11-ext:new()" />
            <xsl:variable name="titleMatchString" select="replace(lower-case(concat(., following-sibling::subfield[@code='g'][1],
                following-sibling::subfield[@code='k'][1],
                following-sibling::subfield[@code='m'][1],
                following-sibling::subfield[@code='n'][1],
                following-sibling::subfield[@code='o'][1],
                following-sibling::subfield[@code='p'][1],
                following-sibling::subfield[@code='p'][2],
                following-sibling::subfield[@code='p'][3],
                following-sibling::subfield[@code='r'][1],
                following-sibling::subfield[@code='s'][1])), '[\W]', '')" />
            <xsl:variable name="additionalDSV11Values" select="java-dsv11-ext:getAdditionalDSV11Values($dsv11Facade, string(130), $titleMatchString)"/>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($additionalDSV11Values)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'title_additional_dsv11_txt_mv'" />
                <xsl:with-param name="fieldValues" select ="$uniqueSeqValues" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- title variants from GND -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '7[01][01]')][matches(child::subfield[@code='E'], '[0-3][029]')][matches(descendant::subfield[@code='0'][1], '^\(DE-588\)', 'i')]/subfield[@code='0']">
            <xsl:variable name="gndFacade" select="java-gnd-ext:new()" />
            <xsl:variable name="gndnumber" select="text()" />
            <xsl:variable name="forDeduplication" select="java-gnd-ext:getReferencesConcatenated($gndFacade, string($gndnumber))"></xsl:variable>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'title_additional_gnd_txt_mv'"/>
                <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '[17]30')][matches(descendant::subfield[@code='0'][1], '^\(DE-588\)', 'i')]/subfield[@code='0']">
            <xsl:variable name="gndFacade" select="java-gnd-ext:new()" />
            <xsl:variable name="gndnumber" select="text()" />
            <xsl:variable name="forDeduplication" select="java-gnd-ext:getReferencesConcatenated($gndFacade, string($gndnumber))"></xsl:variable>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'title_additional_gnd_txt_mv'"/>
                <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$fragment/sorttitle">
            <field name="title_sort">
                <xsl:value-of select="replace(., '[\W]', '')" />
            </field>
        </xsl:for-each>
     </xsl:template>

    <xsl:template name="title_old">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
        <xsl:for-each select="$fragment/datafield[@tag='780']/subfield[@code='t']">
            <xsl:value-of select="concat(., '##xx##')" />
        </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)" />
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'title_old'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="title_new">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
        <xsl:for-each select="$fragment/datafield[@tag='785']/subfield[@code='t']">
            <xsl:value-of select="concat(., '##xx##')" />
        </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)" />
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'title_new'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- series titles -->
    <xsl:template name="series">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='490']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='v']">
                    <xsl:value-of select="concat(' ', .)" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='773']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'series'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- journal titles -->
    <xsl:template name="journals">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:choose>
                <xsl:when test="$fragment/datafield[@tag='898']/subfield[@code='a'][matches(text(), '^CR030[567]')]">
                    <xsl:for-each select="$fragment/datafield[@tag='210']/subfield[@code='a']">
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:for-each>
                    <xsl:for-each select="$fragment/datafield[@tag='222']/subfield[@code='a']">
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:for-each>
                    <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='a']">
                        <xsl:value-of select="." />
                        <xsl:if test="following-sibling::subfield[@code='b']/text()">
                            <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='b'][1])" />
                        </xsl:if>
                        <xsl:if test="following-sibling::subfield[@code='p']/text()">
                            <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='p'][1])" />
                        </xsl:if>
                        <xsl:text>##xx##</xsl:text>
                    </xsl:for-each>
                    <xsl:for-each select="$fragment/datafield[@tag=246]/subfield[@code='a']">
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:for-each>
                    <xsl:for-each select="$fragment/datafield[@tag=247]/subfield[@code='a']">
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:for-each>
                    <xsl:for-each select="$fragment/datafield[@tag='730']/subfield[@code='a']">
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise />
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'journals'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- format : swissbib codes and IDS specific codes -->
    <xsl:template name="format">
        <!-- format field with simplified codes for facet and search (898b)-->
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='898']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'format'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <!-- format field with extended codes for testing (898a) -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='898']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'format_str_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
        <!-- format field for hierarchical facet (898c) -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='898']/subfield[@code='c']">
                <xsl:choose>
                    <xsl:when test="matches(., '^X[KL]010000')">
                        <xsl:value-of select="concat('0/', substring(., 1,4), '/', '##xx##')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('0/', substring(., 1,4), '/', '##xx##')" />
                        <xsl:value-of select="concat('1/', substring(., 1,4), '/', substring(., 5,4), '/', '##xx##')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'format_hierarchy_str_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
        <!-- IDS specific codes (source: 906/907 or 9013) -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='908']/subfield">
                <xsl:if test="matches(@code, '[a-j]')">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='913']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'idscode_txt_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
        <!-- rdacontent 336 -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='336'][matches(descendant::subfield[@code='2'][1],'^rdacontent','i')]/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'rdacontent_str_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
        <!-- rdamedia 337 -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='337'][matches(descendant::subfield[@code='2'][1],'^rdamedia','i')]/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'rdamedia_str_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
        <!-- rdacarrier 338 -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='338'][matches(descendant::subfield[@code='2'][1],'^rdacarrier','i')]/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'rdacarrier_str_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
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

    <!-- formerly 'slinkarticle', indexed to link articles from journal 
          @todo necessary in VuFind? -->
    <xsl:template name="container_id">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='772']/subfield[@code='9']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='773']/subfield[@code='9']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'container_id'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- for use in vufind hierarchy driver -->
    <xsl:template name="series_hierarchy">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/hierarchytype |
                              $fragment/is_hierarchy_id |
                              $fragment/is_hierarchy_title |
                              $fragment/hierarchy_top_id |
                              $fragment/hierarchy_top_title |
                              $fragment/hierarchy_parent_id |
                              $fragment/hierarchy_parent_title |
                              $fragment/title_in_hierarchy |
                              $fragment/hierarchy_sequence |
                              $fragment/groupid_isn_mv">
            <xsl:variable name="fieldname" select="name()" />
            <field name="{$fieldname}">
                <xsl:copy-of select="text()" />
            </field>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="callnumber">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='852']/subfield[@code='j']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='852']/subfield[@code='s']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='j']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='s']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'callnumber'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="union">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/network">
                <xsl:if test=". != ''">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'union'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="institution">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/branchlib">
                <xsl:if test=". != ''">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'institution'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="e_institution">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/branchlib">
                <xsl:choose>
                    <xsl:when test="matches(., 'A145|B405|B406|B407')">
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., 'FREE|BORIS|RETROS')">
                        <xsl:text>FREE##xx##</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'e_institution_str_mv'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="itemnote">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'itemnote_isn_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="itemid">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='852']/subfield[@code='j']">
                <xsl:value-of select="concat(preceding-sibling::subfield[@code='F'], '_', replace(., '[\W\s\+]', '_', ''), '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='j']">
                <xsl:value-of select="concat(preceding-sibling::subfield[@code='F'], '_', replace(., '[\W\s\+]', '_', ''), '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'itemid_isn_mv'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="location">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='852']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'location_str_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="filter">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='898']/subfield[@code='a']">
                <xsl:choose>
                    <xsl:when test="matches(., '53$')">
                        <xsl:text>ONL##xx##</xsl:text>
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='900']/subfield[@code='a']">
                <xsl:choose>
                    <xsl:when test="matches(., 'Metadata rights reserved')">
                        <xsl:text>MDRR##xx##</xsl:text>
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'filter_str_mv'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="ctrlnum">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='035']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'ctrlnum'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="publishDate">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/year">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'publishDate'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/sortyear">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'publishDateSort'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="freshness">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/freshness">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'freshness'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="publplace">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='752'] | $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '751')]">
                <xsl:for-each select="child::subfield[@code='a']">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:for-each>
                <xsl:for-each select="child::subfield[@code='d']">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)" />
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'publplace_txt_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
        <!-- place variants from DSV11 -->
        <xsl:for-each select="$fragment/datafield[@tag='752']/subfield[@code='d']">
            <xsl:variable name="dsv11Facade" select="java-dsv11-ext:new()" />
            <xsl:variable name="placeMatchString" select="lower-case(.)" />
            <xsl:variable name="additionalDSV11Values" select="java-dsv11-ext:getAdditionalDSV11Values($dsv11Facade, string(152), $placeMatchString)"/>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($additionalDSV11Values)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'publplace_dsv11_txt_mv'" />
                <xsl:with-param name="fieldValues" select ="$uniqueSeqValues" />
            </xsl:call-template>
        </xsl:for-each>
        <!-- added entries from GND -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '751')][matches(descendant::subfield[@code='0'][1], '^\(DE-588\)', 'i')]/subfield[@code='0']">
            <xsl:variable name="gndFacade" select="java-gnd-ext:new()" />
            <xsl:variable name="gndnumber" select="text()" />
            <xsl:variable name="forDeduplication" select="java-gnd-ext:getReferencesConcatenated($gndFacade, string($gndnumber))"></xsl:variable>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'publplace_additional_gnd_txt_mv'"/>
                <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
            </xsl:call-template>
        </xsl:for-each>
        <!-- relator specific search fields -->
        <xsl:for-each select="$fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '751')]/subfield[@code='4']">
            <xsl:variable name="relatorcode" select="." />
            <xsl:variable name="forDeduplication">
                <xsl:for-each select="preceding-sibling::subfield[@code='a']">
                    <xsl:value-of select="." />
                    <xsl:text>##xx##</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="concat('publplace_', $relatorcode, '_txt_mv')" />
                <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- additional content, anything not indexed somewhere else: -->
    <!-- 245, 250, 255, 260, 264, 300, 500, 501, 502, 504, 505, 506, 507, 508, 509, 510, 511, 513, 516, 518, 520, 521,
         522, 524, 536, 538, 545, 546, 561, 562, 563, 581, 585, 590, 800, 810, 811, 830, 852, 856, 880, 949-->
    <xsl:template name="add_fields">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[matches(@code, 'c|h')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='250']/subfield[matches(@code, 'a|b')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='254']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='255']/subfield[matches(@code, 'a|b|c|d|e|f|g')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '26[04]')]/subfield[matches(@code, 'a|b')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='300']/subfield[@code='a']">
                <xsl:value-of select="concat(replace(., 
                                             '[\d]+|bd|vol|band|volume|tome', 
                                             '', 
                                             'i'), 
                                             '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '8[01][01]')]/subfield[matches(@code, 't|v')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='830']/subfield[@code='a']">
                <xsl:value-of select="concat(replace(., '\[forme avant 2007\]', '', 'i'), '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='830']/subfield[@code='n']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='830']/subfield[@code='p']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='830']/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'260')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'260')]/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '50[014678]')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='502']/subfield[matches(@code, 'a|b|c|g')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='505']/subfield[matches(@code, 'a|g|r')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='509']/subfield[@code='r']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '51[1368]')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='510']/subfield[matches(@code, 'a|c')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='520']/subfield[matches(@code, 'a|b')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '52[124]')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '53[68]')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '54[56]')]/subfield[matches(@code, 'a|b')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '56[1-3]')]/subfield[matches(@code, 'a|b|c|d|e')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '58[15]')]/subfield[matches(@code, 'a')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='590']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='852']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='856']/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'245')]/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'250')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'250')]/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'505')]/subfield[@code='g']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'490')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'490')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'addfields_txt_mv'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="localcode">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='909']/subfield">
                <xsl:if test="matches(@code, '[a-x]')">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)" />
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'localcode'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
    </xsl:template>


   <!-- ====
        LCSH
        ==== -->
    <xsl:template name="subpers_lcsh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='0']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
            <!-- Umgang mit $t klaeren, eigener Eintrag nur aus $a und $t fuer Facette waere moeglich (s.u. bei Koerp) -->
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='0']/subfield[@code='a']">
               <xsl:value-of select="."/>
               <xsl:if test="following-sibling::subfield[@code='b']/text()">
                   <xsl:for-each select="following-sibling::subfield[@code='b']">
                       <xsl:value-of select="concat(', ', .)"/>
                   </xsl:for-each>
               </xsl:if>
               <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
               </xsl:if>
               <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='611'][@ind2='0']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='d']">
                        <xsl:value-of select="concat('(', ., ')')" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subpers_lcsh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtitle_lcsh">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='630'][@ind2='0']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='p']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='p']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtitle_lcsh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtime_lcsh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='0']/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='0']/subfield[@code='y']">
                <xsl:value-of select="."/>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_lcsh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtop_lcsh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='0']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='0']/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_lcsh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subgeo_lcsh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='0']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='0']/subfield[@code='z']">
            <!--<xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='0']/subfield[@code='z']">-->
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_lcsh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subform_lcsh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='0']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='0']/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_lcsh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

   <!-- ====
        MESH
        ==== -->
    <xsl:template name="subpers_mesh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='2']/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='2']/subfield[@code='a']">
               <xsl:value-of select="."/>
               <xsl:if test="following-sibling::subfield[@code='b']/text()">
                   <xsl:for-each select="following-sibling::subfield[@code='b']">
                       <xsl:value-of select="concat(', ', .)"/>
                   </xsl:for-each>
               </xsl:if>
               <xsl:if test="following-sibling::subfield[@code='t']/text()">
                  <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
               </xsl:if>
               <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='611'][@ind2='2']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='d']">
                        <xsl:value-of select="concat('(', ., ')')" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subpers_mesh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtime_mesh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='2']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='2']/subfield[@code='y']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_mesh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtop_mesh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='2']/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='x']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='x'][1])" />
                </xsl:if>
            <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_mesh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subgeo_mesh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='2']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='2']/subfield[@code='z']">
            <!--<xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='2']/subfield[@code='z']">-->
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_mesh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subform_mesh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='2']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='2']/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_mesh'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

   <!-- ===
        GND
        === -->

    <xsl:template name="subpers_gnd">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^gnd', 'i')]/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^gnd', 'i')]/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='g']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='g'][1], ')')" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='611'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^gnd', 'i')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='d']">
                        <xsl:value-of select="concat(' (', ., ')')" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subpers_gnd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtitle_gnd">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='630'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^gnd', 'i')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='g']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='g'][1], ')')" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtitle_gnd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtime_gnd">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^gnd', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_gnd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtop_gnd">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^gnd', 'i')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='x']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='x'][1], ')')"/>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_gnd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subgeo_gnd">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^gnd', 'i')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='x']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='x'][1], ')')"/>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_gnd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    <!-- spaeter ausbauen bzw. besser fuer die Facettierung vorbereiten -->
    <xsl:template name="subform_gnd">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'^gnd', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_gnd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- Anreicherung des Index mit GND-Nebenvarianten, Feld wird vorläufig lediglich 
         in 'subfull' indexiert (siehe copyField-Direktiven im Schema) (15.01.2013) -->
    <xsl:template name="subenrichment_gnd">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield[matches(@tag, '^[6][0-5]\d')][@ind2='7'][matches(descendant::subfield[@code='2'][1], '^gnd', 'i')]/subfield[@code='0']">
            <xsl:variable name="gndFacade" select="java-gnd-ext:new()" />
            <xsl:variable name="gndnumber" select="text()" />
            <xsl:variable name="forDeduplication" select="java-gnd-ext:getReferencesConcatenated($gndFacade, string($gndnumber))"></xsl:variable>
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'subgnd_enriched'"/>
                <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- template to index authority control numbers of entry fields -->
    <xsl:template name="auth_controlnumber">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield/subfield[@code='0']">
            <xsl:choose>
                <xsl:when test="parent::datafield[matches(@tag, '^[1278][01345][0124]')]">
                    <xsl:variable name="source">
                        <xsl:call-template name="id_sourcecodes"/>
                    </xsl:variable>
                    <xsl:variable name="id" select="substring-after(., ')')" />
                    <field name="{concat('from_', $source, '_isn_mv')}">
                        <xsl:value-of select="$id" />
                    </field>
                </xsl:when>
                <xsl:when test="parent::datafield[matches(@tag, '^[6][0-5]\d')]/subfield[@code='0']">
                    <xsl:variable name="source">
                        <xsl:call-template name="id_sourcecodes"/>
                    </xsl:variable>
                    <xsl:variable name="id" select="substring-after(., ')')"/>
                    <field name="{concat('about_', $source, '_isn_mv')}">
                        <xsl:value-of select="$id" />
                    </field>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- source codes according to
         * http://www.loc.gov/standards/sourcelist/standard-identifier.html
         * LOC organization code database (http://www.loc.gov/marc/organizations/orgshome.html)
         * Online Directory of German ISIL and Library Codes (http://sigel.staatsbibliothek-berlin.de/startseite/)
         -->
    <xsl:template name="id_sourcecodes">
        <xsl:choose>
            <xsl:when test="matches(., '^\(DE-588\)', 'i')">
                <xsl:text>gnd</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., '^\(DE-101\)', 'i')">
                <xsl:text>dnb</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., '^\(DE-603\)', 'i')">
                <xsl:text>hebis</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., '^\(isni\)', 'i')">
                <xsl:text>isni</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., '^\(orcid\)', 'i')">
                <xsl:text>orcid</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., '^\(rid\)', 'i')">
                <xsl:text>rid</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., '^\(scopus\)', 'i')">
                <xsl:text>scopus</xsl:text>
            </xsl:when>
            <xsl:when test="matches(., '^\(viaf\)', 'i')">
                <xsl:text>viaf</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>undef</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

   <!-- ====
        RERO
        ==== -->

    <xsl:template name="subpers_rero">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
               <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subpers_rero'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtitle_rero">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='630'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'rero', 'i')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='g']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='g'][1], ')')" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtitle_rero'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtime_rero">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='y']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_rero'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtop_rero">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_rero'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subgeo_rero">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_rero'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subform_rero">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_rero'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

   <!-- ======
        IDS BB
        ====== -->
    <xsl:template name="subpers_idsbb">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][starts-with(child::subfield[@code='2'][1],'idsbb')]/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subpers_idsbb'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtitle_idsbb">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='630'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtitle_idsbb'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtime_idsbb">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='y']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_idsbb'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtop_idsbb">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_idsbb'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subgeo_idsbb">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_idsbb'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subform_idsbb">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idsbb')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_idsbb'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

   <!-- ===
        ZBZ
        === -->
    <xsl:template name="subpers_idszbz">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][starts-with(child::subfield[@code='2'][1],'idszbz')]/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subpers_idszbz'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtitle_idszbz">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='630'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtitle_idszbz'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtime_idszbz">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='a']">
                <xsl:choose>
                    <xsl:when test="matches(., '^[0-9]{4}')">
                        <xsl:value-of select="concat('Geschichte ', ., '##xx##')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='y']">
                <xsl:choose>
                    <xsl:when test="matches(., '^[0-9]{4}')">
                        <xsl:value-of select="concat('Geschichte ', ., '##xx##')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(., '##xx##')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_idszbz'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtop_idszbz">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_idszbz'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subgeo_idszbz">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_idszbz'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subform_idszbz">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'idszbz')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='695'][starts-with(descendant::subfield[@code='2'][1], 'idszbz')]/subfield[@code='a']">
                <xsl:value-of select="concat(replace(., '\[Formschlagwort Sondersammlungen\]', '', 'i'), '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_idszbz'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

   <!-- ===
        SBT
        === -->

    <xsl:template name="subpers_sbt">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subpers_sbt'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtime_sbt">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='y']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_sbt'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtop_sbt">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_sbt'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subgeo_sbt">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_sbt'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subform_sbt">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][matches(descendant::subfield[@code='2'][1],'sbt', 'i')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_sbt'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>


    <!-- ===
        JURIVOC 
        === -->

    <xsl:template name="subpers_jurivoc">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='b'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='c']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='d'][1], ')')"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)"/>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subpers_jurivoc'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtime_jurivoc">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='y']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_jurivoc'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subtop_jurivoc">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_jurivoc'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subgeo_jurivoc">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_jurivoc'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="subform_jurivoc">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][matches(descendant::subfield[@code='2'][1],'jurivoc', 'i')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_jurivoc'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>


    <!-- allgemeines Feld subundef, wird nicht in Facette navSubidsbb kopiert (25.05.2012/osc) 
         erweitert für Felder 653 (4.9.2012/osc) -->
    <xsl:template name="subundef">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5][0-9]')][@ind2='4']/subfield[@code='a'] | 
                                  $fragment/datafield[matches(@tag, '^653')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='b'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='c']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='c'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='d']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='d'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='v']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='v'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='x']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='x'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='y']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='y'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='z']/text()">
                    <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='z'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subundef'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- Lokalbeschlagwortung Musik (Ketten, Feld 692 -->
    <xsl:template name="submusic">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='692'][matches(subfield[@code='2']/text(), 'idsmgb', 'i')]/subfield">
                <xsl:if test="matches(@code, '[a-x]')">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'submusic'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- Lokalbeschlagwortung (690 / 691 / 695)
         * enthält auch Text aus Klassifikationsfelder (fuer Notation s. Template classif)
         * eigene Indexe für ausgewählte 690 IDSBB (bei Bedarf ausbauen)
    -->
    <xsl:template name="sublocal">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb A2', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb A8', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb AC', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb AM', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb BB', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb BC', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb BD', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb BE', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb BF', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb BW', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb FC', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb G8', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb G9', 'i')]/subfield[matches(@code, '[a-z]')] |
                              $fragment/datafield[@tag='690'][@ind2='7'][matches(descendant::subfield[@code='2'][1], 'idsbb GC', 'i')]/subfield[matches(@code, '[a-z]')] ">
            <xsl:variable name="source" select="replace(following-sibling::subfield[@code='2']/text(),' ', '')" />
            <field name="{concat('sublocal_', $source, '_txt_mv')}">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='690']/subfield |
                                  $fragment/datafield[@tag='691']/subfield |
                                  $fragment/datafield[@tag='695']/subfield">
                <xsl:if test="matches(@code, '[a-e|t|o|v|x]')">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sublocal'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- fetching TOC fulltext -->
    <xsl:template name="fulltext">
        <xsl:param name="fragment"/>
        <!-- reduziert (18.08.2011/osc) -->
        <xsl:variable name="di" select="$fragment/myDocID"/>
        <!-- ich muss hier noch etwas einbauen, dass das Feld nicht aufgebaut wird, wenn kein Text zurueckgeliefert wird -->
        <xsl:for-each select="$fragment/uri856">
            <xsl:variable name="TikaFacade" select="java-tika-ext:new()"/>
            <xsl:variable name="url856" select="."/>
            <xsl:variable name="fulltextcontent" select="java-tika-ext:readURLContent($TikaFacade ,string($url856),$di)"/>
            <xsl:if test="$fulltextcontent != ''">
                <field name="fulltext">
                    <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                    <xsl:value-of select="$fulltextcontent"/>
                    <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                </field>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="$fragment/uri956">
            <xsl:variable name="TikaFacade" select="java-tika-ext:new()"/>
            <xsl:variable name="url956" select="."/>
            <xsl:variable name="fulltextcontent" select="java-tika-ext:readURLContent($TikaFacade ,string($url956),$di)"/>
            <xsl:if test="$fulltextcontent != ''">
                <field name="fulltext">
                    <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                    <xsl:value-of select="$fulltextcontent"/>
                    <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
                </field>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- time of processing, full marc record -->
    <xsl:template name="proctime_fullrecord">
        <xsl:param name="nativeXML"/>
        <field name="time_processed">
            <xsl:value-of select="concat(adjust-dateTime-to-timezone(current-dateTime(), (PT0H)), 'Z')" />
        </field>
        <field name="fullrecord">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[&lt;?xml version="1.0"?&gt;</xsl:text>
            <xsl:copy-of select="$nativeXML/fsource/record"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
    </xsl:template>

    <!-- complete holdings structure as part of the bib record-->
    <xsl:template name="createHoldings">
        <field name="holdings">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:value-of disable-output-escaping="yes" select="$holdingsStructure" />
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
    </xsl:template>

    <!-- special functions and templates -->
    <xsl:function name="swissbib:startDeduplication">
        <xsl:param name="forDeduplication"/>
        <xsl:variable name="DedubExtension" select="java-nodouble-ext:new()"/>
        <xsl:variable name="uniqueStrValues" select="java-nodouble-ext:removeDuplicatesFromMultiValuedField($DedubExtension ,string($forDeduplication))"/>
        <xsl:sequence select="fn:tokenize($uniqueStrValues,'##xx##')"/>
    </xsl:function>

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
