<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:java-tika-ext="java:org.swissbib.documentprocessing.plugins.FulltextContentEnrichment"
    xmlns:java-gnd-ext="java:org.swissbib.documentprocessing.plugins.GNDContentEnrichment"
    xmlns:java-viaf-ext="java:org.swissbib.documentprocessing.plugins.ViafContentEnrichment"
    xmlns:java-nodouble-ext="java:org.swissbib.documentprocessing.plugins.RemoveDuplicates"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:swissbib="www.swissbib.org/solr/documentprocessing.plugins" exclude-result-prefixes="java-tika-ext java-gnd-ext java-viaf-ext">
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
            <xsl:call-template name="format">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="bibid">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="group_id">
                <xsl:with-param name="fragment" select="record"/>
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
            <xsl:call-template name="union">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            <xsl:call-template name="itemnote">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            <xsl:call-template name="itemid">
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
            <xsl:call-template name="gndnum">
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
            <xsl:for-each select="$fragment/datafield[@tag='041']/subfield[@code='a']/text()">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/controlfield[@tag='008']">
				<!-- Test, if language not coded but fill characters -->
				<xsl:variable name="lang" select="substring(text()[1],36,3)"/>
				<xsl:choose>
				    <xsl:when test="matches($lang, '\|\|\|')">
						<xsl:value-of select="concat('und', '##xx##')" />
				    </xsl:when>
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
        <!-- droit systematique (law classification) -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'idslu L1', 'i')]/subfield[@code='u'] |
                                  $fragment/datafield[@tag='691'][matches(@ind2, '7')][matches(descendant::subfield[@code='2'][1], 'dr-sys', 'i')]/subfield[@code='u']">
                <xsl:choose>
                    <xsl:when test="matches(., '^PD[\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of irregular special case "PD 18.0" => "D 18" -->
                        <xsl:value-of select="concat(replace(., '(^[P])([D][\s][\d]{1,2})([.][0]{1,2}[\s]?.*$)', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^PD')"> <!-- Takes care of special case "PD 18.12 de" => "D 18.12" -->
                        <xsl:value-of select="concat(replace(., '(^[P])([D][\s][\d]{1,2}[.]?[\d]{0,2})([\s]?.*$)', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^D[\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of irregular special case "D 18.0" => "D 18" -->
                        <xsl:value-of select="concat(replace(., '(^D[\s][\d]{1,2})([.][0]{1,2}[\s]?.*$)', '$1'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^D')"> <!-- Takes care of special case "D 18.12 de" => "D 18.12" -->
                        <xsl:value-of select="concat(replace(., '(^D[\s][\d]{1,2}[.]?[\d]{0,2})([\s]?.*$)', '$1'), '##xx##')" />
                    </xsl:when>
                    <xsl:when test="matches(., '^[\D]*[\s][\d]{1,2}[.][0]{1,2}')"> <!-- Takes care of irregular normal case "CA/CH 37.0 fr" => "37" -->
                        <xsl:value-of select="concat(replace(., '(^[\D]*[\s])([\d]{1,2})([.][0]{1,2}[\s]?.*$)', '$2'), '##xx##')" />
                    </xsl:when>
                    <xsl:otherwise> <!-- Takes care of irregular normal case "CA/CH 37.11 fr" => "37.11" -->
                        <xsl:value-of select="concat(replace(., '(^[\D]*[\s])([\d]{1,2}[.]?[\d]{0,2})([\s]?.*$)', '$2'), '##xx##')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'classif_drsys'"/>
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
            <xsl:for-each select="$fragment/datafield[matches(@tag, '100|700|800')]/subfield[matches(@code, '[b-su-z8]')] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '100|700|800')]/subfield[matches(@code, '[b-su-z]')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '110|710|810')]/subfield[matches(@code, '[c-su-z]')] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '110|710|810')]/subfield[matches(@code, '[c-su-z]')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '111|711|811')]/subfield[matches(@code, '[b-df-su-z]')] |
                                  $fragment/datafield[@tag='950'][matches(child::subfield[@code='P'], '111|711|811')]/subfield[matches(@code, '[b-df-su-z]')]">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'author_additional'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
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
                        <xsl:value-of select="concat(., ' : ', following-sibling::subfield[@code='b'])" />
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
            <xsl:for-each select="$fragment/datafield[@tag='240']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='242']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='243']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='p']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='246']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='247']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='505']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='509']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='509']/subfield[@code='p']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='700']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='710']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='740']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='740']/subfield[@code='p']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='775']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='776']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='777']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='786']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='787']/subfield[@code='t']">
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
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'title_alt'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
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
        <xsl:for-each select="$fragment/datafield[@tag='020']/subfield[@code='a']">
            <field name="isbn">
                <xsl:value-of select="." />
            </field>
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
    </xsl:template>
    
    <xsl:template name="group_id">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='986']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'groupid_isn_mv'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
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
        <xsl:if test="exists($fragment//datafield[@tag='490']/subfield[@code='9'])">
            <field name="hierarchytype">series</field>
            <field name="is_hierarchy_id">
                <xsl:value-of select="$fragment/myDocID" />
            </field>
            <field name="is_hierarchy_title">
                <xsl:value-of select="$fragment/datafield[@tag='245']/subfield[@code='a']" />
            </field>
        </xsl:if>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='490']/subfield[@code='9']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'hierarchy_top_id'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'hierarchy_parent_id'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='490']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'hierarchy_top_title'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'hierarchy_parent_title'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='490']/subfield[@code='i']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'hierarchy_sequence'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
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

    <xsl:template name="itemnote">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'itemnote_txt_mv'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="itemid">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='852']/subfield[@code='j']">
                <xsl:value-of select="concat(preceding-sibling::subfield[@code='F'], '_', ., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='j']">
                <xsl:value-of select="concat(preceding-sibling::subfield[@code='F'], '_', ., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'itemid_isn_mv'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
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
            <xsl:for-each select="$fragment/datafield[@tag='752']">
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
    </xsl:template>
    
    <!-- additional content, anything not indexed somewhere else -->
    <xsl:template name="add_fields">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each> 
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='h']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='n']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='250']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='250']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='254']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='255']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='255']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='255']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='255']/subfield[@code='d']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='255']/subfield[@code='e']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='255']/subfield[@code='f']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='255']/subfield[@code='g']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='260']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='260']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='800']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='800']/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='810']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='810']/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='811']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='811']/subfield[@code='v']">
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
            <xsl:for-each select="$fragment/datafield[@tag='500']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='502']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='505']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='505']/subfield[@code='g']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='508']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='509']/subfield[@code='r']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='511']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='518']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='520']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='520']/subfield[@code='b']">
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
            <xsl:with-param name="fieldname" select="'localcode_txt_mv'" />
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
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='2']/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" /> 
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
                    <xsl:value-of select="concat(' (', following-sibling::subfield[@code='g'][1]), ')'" />
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
    
    <xsl:template name="gndnum">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^[6][0-5]\d')]/subfield[@code='0']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'authnum_isn_mv'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
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
         * enthält auch Text aus Klassifikationsfelder (fuer Notation s. Template subclassif)
         * ohne eigene Indexe (bei Bedarf wieder einbauen)
    -->
    <xsl:template name="sublocal">
        <xsl:param name="fragment" />
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