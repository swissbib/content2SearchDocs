<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:java-tika-ext="java:org.swissbib.documentprocessing.plugins.FulltextContentEnrichment"
                xmlns:java-nodouble-ext="java:org.swissbib.documentprocessing.plugins.RemoveDuplicates"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:swissbib="www.swissbib.org/solr/documentprocessing" exclude-result-prefixes="java-tika-ext">
    <!--xmlns:fn="http://www.w3.org/2005/xpath-functions"> -->
    
    <xsl:output method="xml" 
                encoding="UTF-8" 
                indent="yes" 
                omit-xml-declaration="yes"
    /> 

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            Dokumentation im swissbib-Wiki
            ==============================
            * Members:Suchfelder
            * Members:Facetten
            * und ev. weitere
            * s. auch Beschreibung zu swissbib.solr.step1.xsl
            *************************************************            
            - die Funktionalitaet dieses Templates entspricht grob der von XMLMapper aus der FAST Pipeline
            -> die in swissbib.solr.step1.xsl aufbereitete Struktur wird zum Teil noch erweitert
            (Beispielsweise remote content mittels TIKA)
            *************************************************
            
            Versionen
            =========
            ca.08.2011 : Oliver : Ueberarbeitung des Skripts
            *************************************************
            23.09.2011 : Oliver : Weitere Ueberarbeitung
            *************************************************
        </desc>
    </doc>

    <xsl:template match="/">
        <!-- ===================
             Start solr-Dokument : Call all necessary templates
             =================== 
        -->
        <doc>
            <xsl:call-template name="Docid">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="smediatype">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            
            <xsl:call-template name="title_short">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            
            <xsl:call-template name="title_long">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            
            <xsl:call-template name="title_uniform">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="title_series">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="sauthor">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="sauthorlink">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="sinstitution">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="sinstitutionlink">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="sconname">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="sconnamelink">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="scondate">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="bibid">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="subpers_lcsh">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            
            <xsl:call-template name="subtitle_lcsh">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>

            <xsl:call-template name="subtime_lcsh">
                <xsl:with-param name="fragment" select="record"/>
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

            <xsl:call-template name="subpers_swd">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            
            <xsl:call-template name="subtitle_swd">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>

            <xsl:call-template name="subtime_swd">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="subtop_swd">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="subgeo_swd">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="subform_swd">
                <xsl:with-param name="fragment" select="record"/>
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

            <xsl:call-template name="subpers_idslu">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="subtime_idslu">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="subtop_idslu">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="subgeo_idslu">
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
            
            <xsl:call-template name="submusic">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            
            <xsl:call-template name="sublocal">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            
            <xsl:call-template name="subclassif">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            
            <xsl:call-template name="subudc">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            
            <xsl:call-template name="sfulltext">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            
            <xsl:call-template name="sfilter">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>

            <xsl:call-template name="sbranchlib">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="snetwork">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            
            <xsl:call-template name="callno">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="srecnum">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="slinkupper">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="slinkarticle">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="sfrbr">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="stag">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="slanguage">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template> 

            <xsl:call-template name="syear">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            
            <xsl:call-template name="navYear">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>
            
            <xsl:call-template name="navYearUTC">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>

            <xsl:call-template name="navAuthor">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            
            <xsl:call-template name="navRelator">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>
            
            <xsl:call-template name="publplace">
                <xsl:with-param name="fragment" select="record" />
            </xsl:call-template>

            <xsl:call-template name="sfreshness">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="suri">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="ssorttitle">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="ssortauthor">
                <xsl:with-param name="fragment" select="record"/>
            </xsl:call-template>

            <xsl:call-template name="fsource">
                <xsl:with-param name="nativeXML" select="record"/>
            </xsl:call-template>
           
            <xsl:call-template name="time_processed">
                <xsl:with-param name="nativeXML" select="record"/>
            </xsl:call-template>
        </doc>                
    </xsl:template>
 
    <xsl:template name="Docid">
        <xsl:param name="fragment"/>
        <field name="Docid">
            <xsl:value-of select="$fragment/myDocId" />
        </field>
    </xsl:template>

    <xsl:template name="smediatype">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='898']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'smediatype'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- =====
         TITEL : Drei Felder mit unterschiedlicher Inhalt, Funktion und Boostig
         ===== 
    -->
    <!-- title_short : Kurztitelfeld, alle singulaeren Titel-Unterfelder (ohne Haupt- und
         Einheitstitel -->
    <xsl:template name="title_short">
        <xsl:param name="fragment" />
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
            <xsl:for-each select="$fragment/datafield[@tag='242']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='243']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <!-- die naechsten drei Unterfelder sind IDS special, bei CBS als Datenquelle nicht notwendig (23.09.2011/osc)
            <xsl:for-each select="$fragment/datafield[@tag=245]/subfield[@code='d']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag=245]/subfield[@code='i']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag=245]/subfield[@code='j']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            -->
            <xsl:for-each select="$fragment/datafield[@tag=245]/subfield[@code='p']">
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
            <!-- Haupttitel von Analytika doch mal reingenommen, da sonst nirgends indexiert, sonst bei sfulltext rein (23.09.2011/osc) -->
            <xsl:for-each select="$fragment/datafield[@tag='773']/subfield[@code='t']">
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
            <xsl:for-each select="$fragment/datafield[@tag='780']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='785']/subfield[@code='t']">
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
            <xsl:with-param name="fieldname" select="'title_short'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- title_long : Titel aus 245 $a : $b (spaeter ev. noch 505 $t), keine Dedublierung notwendig, hohes boosting -->
    <xsl:template name="title_long">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='a'][empty(following-sibling::subfield[@code='b'])]">
            <field name="title_long">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='a'][exists(following-sibling::subfield[@code='b'])]">
            <field name="title_long">
                <xsl:value-of select="concat(., ' : ', following-sibling::subfield[@code='b'])" />
            </field>
        </xsl:for-each>
    </xsl:template>

    <!-- ============ 
        Einheitstitel : Erweiterungen versuchsweise, es gibt auch noch Fehler in den input-Daten (SNB?)
        =============   (12.08.2011/osc; 21.09.2011)
    -->
    <xsl:template name="title_uniform">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='130']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='n']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='n'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='p']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='p'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='m']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='m'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='o']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='o'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='r']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='r'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='s']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='s'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='130']/subfield[@code='f']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='730']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='n']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='n'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='p']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='p'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='m']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='m'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='o']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='o'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='r']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='r'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='s']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='s'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='730']/subfield[@code='f']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='240']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='n']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='n'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='p']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='p'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='m']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='m'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='o']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='o'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='r']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='r'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='s']/text()">
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='s'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='240']/subfield[@code='f']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'title_uniform'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>    

    <xsl:template name="title_series">
        <xsl:param name="fragment" />
        <!-- pattern that replaces content in $v with empty, to facilitate deduplication, used in fn:replace() 
             second aggresive pattern in use (23.09.2011/osc) -->
        <!--<xsl:variable name="replPattern">^Bd\. |^Band |^vol.* |^n\. |^nu.* |^Heft |^h\. |^t.* </xsl:variable>-->
        <xsl:variable name="replPattern">^\w.* </xsl:variable>
         <xsl:variable name="forDeduplication">
            <!-- check out 440 $x for issn linking (22.09.2011/osc) -->
            <xsl:for-each select="$fragment/datafield[@tag='440']/subfield[@code='a']">
                <xsl:variable name="f440sfn">
                    <xsl:if test="following-sibling::subfield[@code='n'] and following-sibling::subfield[@code='p']">
                        <xsl:value-of select="concat('. ', following-sibling::subfield[@code='n'][1], ', ')" />
                    </xsl:if>
                    <xsl:if test="following-sibling::subfield[@code='n'] and not(following-sibling::subfield[@code='p'])">
                        <xsl:value-of select="concat('. ', following-sibling::subfield[@code='n'][1])" />
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="f440sfp">
                    <xsl:if test="following-sibling::subfield[@code='p'] and following-sibling::subfield[@code='n']">
                        <xsl:value-of select="following-sibling::subfield[@code='p'][1]" />
                    </xsl:if>
                    <xsl:if test="following-sibling::subfield[@code='p'] and not(following-sibling::subfield[@code='n'])">
                        <xsl:value-of select="concat('. ', following-sibling::subfield[@code='p'][1])" />
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="f440sfv" select="if(following-sibling::subfield[@code='v'])
                                                     then concat(' ; ', replace(following-sibling::subfield[@code='v'][1], $replPattern, '', 'i'))
                                                     else()"
                />
                <xsl:if test="not(following-sibling::subfield[@code='n'] 
                              or following-sibling::subfield[@code='p'] 
                              or following-sibling::subfield[@code='v'])">
                    <xsl:value-of select="concat(replace(., '\.$', ''), '##xx##')" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='n']
                              or following-sibling::subfield[@code='p']
                              or following-sibling::subfield[@code='v']">
                    <xsl:value-of select="concat(replace(., '\.$', ''),
                                                 $f440sfn,
                                                 $f440sfp,
                                                 $f440sfv,
                                                 '##xx##')"
                    />
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='490']/subfield[@code='a']">
                <xsl:if test="not(following-sibling::subfield[@code='v'])">
                    <xsl:value-of select="concat(., '##xx##')" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='v']">
                    <xsl:variable name="f490sfv" select="replace(following-sibling::subfield[@code='v'][1], $replPattern, '', 'i')" />
                    <xsl:value-of select="concat(., ' ; ', $f490sfv, '##xx##')" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'title_series'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <!-- =============
         Autor/Urheber :  
         ============= 
    -->
    <xsl:template name="sauthor">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='100'][@ind1='0']/subfield[@code='a']">
                <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')"/>
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
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='700'][@ind1='0']/subfield[@code='a']">
<!--                <xsl:choose>
                    <xsl:when test="matches(following-sibling::subfield[@code='l'], 'fre|eng')" />
                    <xsl:otherwise>-->
                        <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')"/>
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
<!--                    </xsl:otherwise>
                </xsl:choose> -->
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='800'][@ind1='0']/subfield[@code='a']">
                <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')"/>
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
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sauthor'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="sauthorlink">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='100']/subfield[@code='8']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='700']/subfield[@code='8']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='700']/subfield[@code='8']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='100']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='100']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='100']/subfield[@code='d']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='100']/subfield[@code='q']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='700']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='700']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='700']/subfield[@code='d']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='700']/subfield[@code='q']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='800']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='800']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='800']/subfield[@code='d']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='800']/subfield[@code='q']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'100')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'100')]/subfield[@code='D']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='880'][starts-with(descendant::subfield[@code='6'],'700')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sauthorlink'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="sinstitution">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='110']/subfield[@code='a']">
                <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')"/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='710']/subfield[@code='a']">
                <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')"/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='810']/subfield[@code='a']">
                <xsl:value-of select="replace(., '\[forme avant 2007\]', '', 'i')"/>
                <xsl:if test="following-sibling::subfield[@code='b']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='b']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sinstitution'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="sinstitutionlink">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='110']/subfield[@code='8']">
               <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='110']/subfield[@code='c']">
               <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='110']/subfield[@code='d']">
               <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='110']/subfield[@code='n']">
               <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='710']/subfield[@code='8']">
               <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='710']/subfield[@code='c']">
               <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='710']/subfield[@code='d']">
               <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='710']/subfield[@code='n']">
               <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='810']/subfield[@code='8']">
               <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='810']/subfield[@code='c']">
               <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='810']/subfield[@code='d']">
               <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='810']/subfield[@code='n']">
               <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>-->        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sinstitutionlink'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="sconname">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='111']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='e']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='e']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='e']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='e']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='811']/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:if test="following-sibling::subfield[@code='e']/text()">
                    <xsl:for-each select="following-sibling::subfield[@code='e']">
                        <xsl:value-of select="concat(', ', .)" />
                    </xsl:for-each>
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sconname'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="scondate">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='111']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='111']/subfield[@code='d']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='d']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='811']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='811']/subfield[@code='d']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'scondate'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="sconnamelink">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='111']/subfield[@code='8']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='n']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='f']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='g']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='h']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='j']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='k']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='l']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='p']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='q']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='s']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='t']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='u']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datefield[@tag='111']/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='8']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='n']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='f']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='g']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='h']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='j']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='k']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='l']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='p']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='q']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='s']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='t']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='u']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='711']/subfield[@code='x']">
                <xsl:value-of select="(., '##xx##')" /> 
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="(count($forDeduplication) > 0) and $forDeduplication[1][. ne '']">
            <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
            <xsl:call-template name="createUniqueFields">
                <xsl:with-param name="fieldname" select="'sconnamelink'"/>
                <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="sworklink">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600']/subfield[@code='8']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sworklink'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="bibid">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='020']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='020']/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='022']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='022']/subfield[@code='y']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='022']/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='2']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='2']/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='7'][matches(descendant::subfield[@code='2'],'doi', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='024'][@ind1='7'][matches(descendant::subfield[@code='2'],'URN', 'i')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'bibid'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
   
   <!-- ====
        LCSH : Personen / Koerperschaften / Kongresse
        ====   
   -->
    <xsl:template name="subpers_lcsh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='0']/subfield[@code='a']">
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
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='d'][1])"/>
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
    
    
   <!-- ====
        LCSH : Einheitstitel
        ====  -->
    
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

   <!-- ====
        LCSH : Zeit / Chronologie
        ====   -->

    <xsl:template name="subtime_lcsh">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='0']/subfield[@code='a']">
                <xsl:value-of select="."/>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='0']/subfield[@code='y']">
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
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='0']/subfield[@code='x']">
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
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='0']/subfield[@code='v']">
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
        MESH : Personen / Koerperschaften
        ====    -->
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
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='d'][1])"/>
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
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='2']/subfield[@code='y']">
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
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='2']/subfield[@code='x']">
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
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='2']/subfield[@code='v']">
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
        SWD : Person / Koerperschaft / Kongresse
        ===   -->
    <xsl:template name="subpers_swd">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='a']">
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
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='d'][1])"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='a']">
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
            <xsl:for-each select="$fragment/datafield[@tag='611'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='a']">
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
            <xsl:with-param name="fieldname" select="'subpers_swd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- ===
         SWD : Einheitstitel
         === -->
    
    <xsl:template name="subtitle_swd">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='630'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtitle_swd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- ===
         SWD : Zeit
         === -->
    
    <xsl:template name="subtime_swd">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='y']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_swd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- ===
         SWD : Thema
         === -->
    
    <xsl:template name="subtop_swd">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_swd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- ===
         SWD : Geografikum
         === -->

    <xsl:template name="subgeo_swd">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_swd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- ===
         SWD : Form
         === -->
    
    <xsl:template name="subform_swd">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'sw')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_swd'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

   <!-- ====
        RERO : Personen / Koerperschaften
        ====    -->
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
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='d'][1])"/>
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

    <xsl:template name="subtime_rero">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='y']">
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
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='x']">
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
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'rero')]/subfield[@code='v']">
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
        IDS BB : Personen / Koerperschaften
        ======    -->
    <xsl:template name="subpers_idsbb">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='0'][starts-with(child::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='a']">
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
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='d'][1])"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='a']">
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
    
    <!-- =====
         IDSBB : Einheitstitel
         ===== -->
    
    <xsl:template name="subtitle_idsbb">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='630'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtitle_idsbb'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- =====
         IDSBB : Zeit
         ===== -->
    
    <xsl:template name="subtime_idsbb">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='y']">
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
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='x']">
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
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='z']">
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
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids bs/be')]/subfield[@code='v']">
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
        ZBZ : Personen / Koerperschaften
        ===    -->
    <xsl:template name="subpers_idszbz">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][starts-with(child::subfield[@code='2'][1],'ids zbz')]/subfield[@code='a']">
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
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='d'][1])"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='a']">
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
            <xsl:for-each select="$fragment/datafield[@tag='630'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='a']">
                <xsl:value-of select="." />
                <xsl:text>##xx##</xsl:text>
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
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='a']">
                <xsl:choose>
                    <xsl:when test="matches(., '^[0-9]{4}')">
                        <xsl:value-of select="concat('Geschichte ', ., '##xx##')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(., '##xx##')" /> 
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='y']">
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
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='x']">
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
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='z']">
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
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids zbz')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_idszbz'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
   <!-- ======
        IDS LU : Personen / Koerperschaften
        ======   -->
    <xsl:template name="subpers_idslu">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][starts-with(child::subfield[@code='2'][1],'ids lu')]/subfield[@code='a']">
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
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='d'][1])"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='a']">
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
            <xsl:with-param name="fieldname" select="'subpers_idslu'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="subtime_idslu">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='y']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtime_idslu'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="subtop_idslu">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='x']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subtop_idslu'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="subgeo_idslu">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subgeo_idslu'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="subform_idslu">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'ids lu')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_idslu'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

   <!-- ===
        SBT : Personen / Koerperschaften
        ===   -->
    <xsl:template name="subpers_sbt">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='600'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='a']">
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
                    <xsl:value-of select="concat(', ', following-sibling::subfield[@code='d'][1])"/>
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                   <xsl:value-of select="concat(' - ', following-sibling::subfield[@code='t'][1])" />
                </xsl:if>
                <xsl:text>##xx##</xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='610'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='a']">
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
            <xsl:for-each select="$fragment/datafield[@tag='648'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='y']">
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
            <xsl:for-each select="$fragment/datafield[@tag='650'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='x']">
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
            <xsl:for-each select="$fragment/datafield[@tag='651'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[matches(@tag, '^6[0-5]')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='z']">
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
            <xsl:for-each select="$fragment/datafield[@tag='655'][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[starts-with(@tag, '6')][@ind2='7'][starts-with(descendant::subfield[@code='2'][1],'tessin')]/subfield[@code='v']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'subform_sbt'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- SPEZIAL- UND LOKALSCHLAGWORTE / KLASSIFIKATIONEN (FELDER 690/691) -->
    <!-- Schlagwortkette Musik (690 FJ/LA) -->
    <xsl:template name="submusic">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield[@tag='690'][matches(@ind1, 'F|L')][matches(@ind2, 'J|A')]/subfield[@code='a']">
            <field name="submusic">
                <xsl:choose>
                    <xsl:when test="matches(., '^[^-]')">
                        <xsl:value-of select="concat(., ' -- ', following-sibling::subfield[@code='q'][1])" />
                    </xsl:when>
                    <xsl:when test="matches(., '^-')">
                        <xsl:value-of select="following-sibling::subfield[@code='q']" />
                    </xsl:when>
                </xsl:choose>
                <xsl:if test="following-sibling::subfield[@code='t']/text()">
                    <xsl:value-of select="concat(' -- (', following-sibling::subfield[@code='t'][1], ')')" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='o']/text()">
                    <xsl:value-of select="concat(' -- ', following-sibling::subfield[@code='o'][1])" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='v']/text()">
                    <xsl:value-of select="concat(' -- [', following-sibling::subfield[@code='v'][1], ']')" />
                </xsl:if>
                <xsl:if test="following-sibling::subfield[@code='x']/text()">
                    <xsl:value-of select="concat(' -- ', following-sibling::subfield[@code='x'][1])" />
                </xsl:if>
            </field>
        </xsl:for-each>
    </xsl:template>

    <!-- Lokalbeschlagwortung (690 ** $a) -->
    <xsl:template name="sublocal">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield[@tag='690']/subfield[@code='a']">
            <xsl:variable name="ind1" select="../@ind1" />
            <xsl:variable name="ind2" select="../@ind2" />
            <field name="{concat('sublocal_', $ind1, $ind2)}">
                <xsl:value-of select="." />
            </field>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Lokale Klassifikationen (691 ** $a, ohne UDC) -->
    <xsl:template name="subclassif">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield[@tag='691'][matches(@ind1, '[^E]')][matches(@ind2, '[^12]')]/subfield[@code='a']">
            <field name="subclassif">
                <xsl:value-of select="." />
            </field>
            <!--<xsl:variable name="ind1" select="../@ind1" />
            <xsl:variable name="ind2" select="../@ind2" />
            <field name="{concat('subclassif_', $ind1, $ind2)}">
                <xsl:value-of select="." />
            </field>-->
        </xsl:for-each>
    </xsl:template>
    
    <!-- Versuch fuer UDC-Facetten EPFL-Test, dreisprachig, Sachen und Personen (691 E1/E2) -->
    <xsl:template name="subudc">
        <xsl:param name="fragment" />
        <xsl:for-each select="$fragment/datafield[@tag='691'][@ind1='E'][@ind2='1']/subfield[@code='a']">
            <xsl:choose>
                <xsl:when test="following-sibling::subfield[@code='z']/text() = 'ger'">
                    <field name="subtopudc_de">
                        <xsl:value-of select="." />
                    </field>
                    <field name="subnotudc">
                        <xsl:value-of select="following-sibling::subfield[@code='u']" />
                    </field>
                </xsl:when>
                <xsl:when test="following-sibling::subfield[@code='z']/text() = 'eng'">
                    <field name="subtopudc_en">
                        <xsl:value-of select="." />
                    </field>
                </xsl:when>
                <xsl:when test="following-sibling::subfield[@code='z']/text() = 'fre'">
                    <field name="subtopudc_fr">
                        <xsl:value-of select="." />
                    </field>
                </xsl:when>
                <xsl:otherwise />
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$fragment/datafield[@tag='691'][@ind1='E'][@ind2='2']/subfield[@code='a']">
            <xsl:choose>
                <xsl:when test="following-sibling::subfield[@code='z']/text() = 'ger'">
                    <field name="subpersudc_de">
                        <xsl:value-of select="concat(., ' (', following-sibling::subfield[@code='d'][1], ')')" />
                    </field>
                </xsl:when>
                <xsl:when test="following-sibling::subfield[@code='z']/text() = 'eng'">
                    <field name="subpersudc_en">
                        <xsl:value-of select="concat(., ' (', following-sibling::subfield[@code='d'][1], ')')" />
                    </field>
                </xsl:when>
                <xsl:when test="following-sibling::subfield[@code='z']/text() = 'fre'">
                    <field name="subpersudc_fr">
                        <xsl:value-of select="concat(., ' (', following-sibling::subfield[@code='d'][1], ')')" />
                    </field>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="sfulltext">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
<!--            <xsl:for-each select="year">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>-->
            <xsl:for-each select="yearadditional">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='c']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each> 
            <xsl:for-each select="$fragment/datafield[@tag='245']/subfield[@code='h']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag=245]/subfield[@code='n']">
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
            <xsl:for-each select="$fragment/datafield[@tag='509']/subfield[@code='r']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='520']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='852']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='856']/subfield[@code='u']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='856']/subfield[@code='z']">
                <xsl:value-of select="concat(., '##xx##')" />  
            </xsl:for-each>        
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='z']">
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
            <xsl:with-param name="fieldname" select="'sfulltext'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- sfilter : vorerst fuer online gebraucht (Wert='o') (31.08.2011/osc) -->
    <xsl:template name="sfilter">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <!-- matches() in select funktioniert nicht, xslt-bug?, so laeuft's (31.08.2011/osc) -->
            <xsl:for-each select="$fragment/controlfield[@tag='007']">
                <xsl:if test="matches(., '^c[r| ]')">
                    <xsl:value-of select="concat('o', '##xx##')" />
                </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$fragment/datafield[@tag='949']/subfield[@code='B']">
                <xsl:if test="matches(., 'CCSA')">
                    <xsl:value-of select="concat('o', '##xx##')" />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)" />
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sfilter'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="sbranchlib">
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
            <xsl:with-param name="fieldname" select="'sbranchlib'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>        
    
    <xsl:template name="snetwork">
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
            <xsl:with-param name="fieldname" select="'snetwork'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="callno">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='852']/subfield[@code='j']">
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
            <xsl:with-param name="fieldname" select="'callno'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="srecnum">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='035']/subfield[@code='a']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'srecnum'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template> 

    <xsl:template name="slinkupper">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='490']/subfield[@code='9']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'slinkupper'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template> 
    
    <xsl:template name="slinkarticle">
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
            <xsl:with-param name="fieldname" select="'slinkarticle'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template> 

    <xsl:template name="sfrbr">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='986']/subfield[@code='b']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sfrbr'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template> 
    
    <xsl:template name="stag">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='985']/subfield[@code='n']">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'stag'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template> 
 
     <!-- ====== 
         Sprache : Erweiterungen und Fehlerkorrekturen inkl. (30.08.2011/osc)
          ====== -->
    <xsl:template name="slanguage">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='041']/subfield[@code='a']/text()">
                    <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
            <xsl:for-each select="$fragment/controlfield[@tag='008']">
                    <xsl:value-of select="concat($fragment/substring(controlfield[@tag='008'][1],36,3), '##xx##')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'slanguage'" />
            <xsl:with-param name="fieldValues" select ="$uniqueSeqValues" />
        </xsl:call-template>
    </xsl:template>

   <!-- =======
        Facette Autoren 
        =======
   -->
    <xsl:template name="navAuthor">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/navAuthor">
                <xsl:value-of select="concat(replace(., '\[forme avant 2007\]', '', 'i'), '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'navAuthor'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Facette spezielle Nebeneintragungen (Relatoren)(24.10.2011/osc) -->
    <xsl:template name="navRelator">
        <xsl:param name="fragment" />
            <xsl:for-each select="$fragment/navRelator/subfield[@code='4']">
                <field name="{concat('navRelator_', .)}">
                    <xsl:value-of select="preceding-sibling::subfield[@code='a']" />
                    <xsl:if test="preceding-sibling::subfield[@code='D'] and preceding-sibling::subfield[@code='D']/text() != ''">
                        <xsl:value-of select="concat(', ', preceding-sibling::subfield[@code='D'])" />
                    </xsl:if>
                    <xsl:if test="preceding-sibling::subfield[@code='b'] and preceding-sibling::subfield[@code='b']/text() != ''">
                        <xsl:value-of select="concat(' ', preceding-sibling::subfield[@code='b'][1])" />
                    </xsl:if>
                    <xsl:if test="preceding-sibling::subfield[@code='c'] and preceding-sibling::subfield[@code='c']/text() != ''">
                        <xsl:value-of select="concat(', ', preceding-sibling::subfield[@code='c'][1])" />
                    </xsl:if>
                    <xsl:if test="preceding-sibling::subfield[@code='d'] and preceding-sibling::subfield[@code='d']/text() != ''">
                        <xsl:value-of select="concat(' (', preceding-sibling::subfield[@code='d'][1], ')')" />
                    </xsl:if>
                </field>
            </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="publplace">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/datafield[@tag='752']/subfield[@code='d']/text()">
                <xsl:value-of select="concat(replace(., ' \(1450\-1800,.*on\)', ''), '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'publplace'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="syear">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/year">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'syear'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="navYear">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/year">
                <xsl:value-of select="concat(., '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)" />
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'navYear'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="navYearUTC">
        <xsl:param name="fragment" />
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/year">
                <xsl:value-of select="concat(., '-01-01T00:00:00Z', '##xx##')" />
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)" />
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'navYearUTC'" />
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues" />
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="sfreshness">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/freshness">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'sfreshness'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template> 
    
    <xsl:template name="suri">
        <xsl:param name="fragment"/>
        <!-- reduziert (18.08.2011/osc) -->
        <xsl:variable name="di" select="$fragment/myDocId"/>
        <!-- ich muss hier noch etwas einbauen, dass das Feld nicht aufgebaut wird, wenn kein Text zurueckgeliefert wird -->
        <xsl:for-each select="$fragment/uri856">
            <xsl:variable name="TikaFacade" select="java-tika-ext:new()"/>
            <xsl:variable name="url856" select="."/>
            <xsl:variable name="fulltextcontent" select="java-tika-ext:readURLContent($TikaFacade ,string($url856),$di)"/>
            <field name="sfullTextRemoteData">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:value-of select="$fulltextcontent"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </field>
        </xsl:for-each>    
        <xsl:for-each select="$fragment/uri956">
            <xsl:variable name="TikaFacade" select="java-tika-ext:new()"/>
            <xsl:variable name="url956" select="."/>
            <xsl:variable name="fulltextcontent" select="java-tika-ext:readURLContent($TikaFacade ,string($url956),$di)"/>
            <field name="sfullTextRemoteData">
                <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
                <xsl:value-of select="$fulltextcontent"/>
                <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
            </field>
        </xsl:for-each>    
    </xsl:template> 

    <xsl:template name="ssorttitle">
        <xsl:param name="fragment"/>
        <!-- Achtung: bei sorttitle und sortauthor wird man wohl uniquekey nehmen muessen -->
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/sorttitle">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'ssorttitle'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template> 
    
    <xsl:template name="ssortauthor">
        <xsl:param name="fragment"/>
        <xsl:variable name="forDeduplication">
            <xsl:for-each select="$fragment/sortauthor">
                <xsl:value-of select="concat(., '##xx##')" /> 
            </xsl:for-each>        
        </xsl:variable>
        <xsl:variable name="uniqueSeqValues" select="swissbib:startDeduplication($forDeduplication)"/>
        <xsl:call-template name="createUniqueFields">
            <xsl:with-param name="fieldname" select="'ssortauthor'"/>
            <xsl:with-param name="fieldValues" select="$uniqueSeqValues"/>
        </xsl:call-template>
    </xsl:template> 

    <xsl:template name="fsource">
        <xsl:param name="nativeXML"/>
        <field name="fsource">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:copy-of select="$nativeXML/fsource/record"/>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
    </xsl:template>
    
    <!-- Zeit des Erstellen eines solr-Dokuments im Document Processing-->
    <xsl:template name="time_processed">
        <xsl:param name="nativeXML"/>
        <field name="time_processed">
            <xsl:value-of select="current-dateTime()" />
        </field>
    </xsl:template>

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
