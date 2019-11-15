<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
>

    <xsl:output
            method="xml"
            encoding="UTF-8"
            indent="yes"
            omit-xml-declaration="yes"
            />

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            Dieses Skript ist die erste Stufe (Step1) der Verarbeitung im Document-Processing zur Aufbereitung
            der Daten vor der eigentlich Indexierung.

            Stages
            ------
            1) Kopie der kompletten urspruenglichen Struktur in ein eigenes Feld
            2) Erweiterung der urspruenglichen MARC-Struktur mit Feldern und Daten, die fuer das Indexieren
            benoetigt werden
            3) Mappen der erstellten und erweiterten Struktur auf die Indexfelder (primaer in Step2)

            Die Anreicherungen mit XSLT-Verarbeitungen genuegen nicht. Deshalb werden in Java geschriebene
            XSLT-Extensions eingesetzt (alle eingebunden in Step2)
            * Dedublierung Inhalte
            * Anreicherung von TOC / Volltexte (Apache TIKA)
            * Anreicherung GND-Nebenvarianten
            * Anreicherung VIAF-Nebenvarianten

            ************************
            www.swissbib.org
            guenter.hipler@unibas.ch
            oliver.schihin@unibas.ch
            ************************

            Versionen
            =========

            01.10.2010 : Guenter : erstellt
            ***********************************
            23.09.2011 : Oliver : ueberarbeitet
            ***********************************
            11.11.2011 : Oliver : ueberarbeitet, v.a. Korrekturen in template 'UnionAndBranchlib' (Zeile 479+)
            ***********************************
            18.11.2011 : Oliver : Korrekturen branchlib
            ***********************************
            09.08.2013 : Oliver : Beginn Anpassungen fuer neues CBS
            ***********************************
        </desc>
    </doc>

    <xsl:template match="*|@*|comment()|processing-instruction()|text()">
        <xsl:copy>
            <xsl:apply-templates select="*|@*|comment()|processing-instruction()|text()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="originalMarc" >
            <xsl:copy-of select="/"/>
        </xsl:variable>
        <record>
            <xsl:call-template name="orgRecord" >
                <xsl:with-param name="original" select="$originalMarc"/>
            </xsl:call-template>
            <xsl:apply-templates />
        </record>
    </xsl:template>


    <xsl:template name="orgRecord">
        <xsl:param name="original"/>
        <fsource>
            <xsl:copy-of select="$original/record"/>
        </fsource>
    </xsl:template>

    <xsl:template match="record">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- =====
         DocID
         sortfields
         institutions and networks / unions
         URIs for TIKA
         ==================================
    -->

    <xsl:template match="controlfield[@tag='001']">
        <myDocID>
            <xsl:value-of select="."/>
        </myDocID>
        <sortauthor>
            <xsl:choose>
                <xsl:when test="following-sibling::datafield[@tag='100']/subfield[@code='a']">
                    <xsl:value-of select="following-sibling::datafield[@tag='100']/subfield[@code='a']"/>
                    <xsl:if test="following-sibling::datafield[@tag='100']/subfield[@code='D'] and 
                        following-sibling::datafield[@tag='100']/subfield[@code='D']/text() != ''">
                        <xsl:value-of select="following-sibling::datafield[@tag='100']/subfield[@code='D']"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="following-sibling::datafield[@tag='700']/subfield[@code='a']">
                    <xsl:value-of select="following-sibling::datafield[@tag='700']/subfield[@code='a']"/>
                    <xsl:if test="following-sibling::datafield[@tag='700']/subfield[@code='D'] and 
                        following-sibling::datafield[@tag='700']/subfield[@code='D']/text() != ''">
                        <xsl:value-of select="following-sibling::datafield[@tag='700']/subfield[@code='D']"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="following-sibling::datafield[@tag='110']/subfield[@code='a']">
                    <xsl:value-of select="following-sibling::datafield[@tag='110']/subfield[@code='a']"/>
                    <xsl:if test="following-sibling::datafield[@tag='110']/subfield[@code='b'] and 
                        following-sibling::datafield[@tag='110']/subfield[@code='b']/text() != ''">
                        <xsl:value-of select="following-sibling::datafield[@tag='110']/subfield[@code='b']"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="following-sibling::datafield[@tag='710']/subfield[@code='a']">
                    <xsl:value-of select="following-sibling::datafield[@tag='710']/subfield[@code='a']"/>
                    <xsl:if test="following-sibling::datafield[@tag='710']/subfield[@code='b'] and 
                        following-sibling::datafield[@tag='710']/subfield[@code='b']/text() != ''">
                        <xsl:value-of select="following-sibling::datafield[@tag='710']/subfield[@code='b']"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="following-sibling::datafield[@tag='111']/subfield[@code='a']">
                    <xsl:value-of select="following-sibling::datafield[@tag='111']/subfield[@code='a']"/>
                </xsl:when>
                <xsl:when test="following-sibling::datafield[@tag='711']/subfield[@code='a']">
                    <xsl:value-of select="following-sibling::datafield[@tag='711']/subfield[@code='a']"/>
                </xsl:when>
            </xsl:choose>
        </sortauthor>

        <sorttitle>
            <xsl:choose>
                <xsl:when test="following-sibling::datafield[@tag='245']/subfield[@code='a'] != '@'">
                    <xsl:variable name="sorttitle">
                        <xsl:value-of select="following-sibling::datafield[@tag='245']/subfield[@code='a']"/>
                    </xsl:variable>
                    <xsl:if test="string-length($sorttitle) &gt; 0">
                        <xsl:variable name="indicator">
                            <xsl:value-of select="following-sibling::datafield[@tag='245'][1]/@ind2"/>
                        </xsl:variable>
                        <xsl:variable name="sortoutput">
                            <xsl:value-of select="substring($sorttitle, $indicator+1)"/>
                        </xsl:variable>
                        <xsl:value-of select="substring($sortoutput,1,30)"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="following-sibling::datafield[@tag='490'][1]/subfield[@code='a'][1]">
                    <xsl:value-of select="substring(following-sibling::datafield[@tag='490'][1]/subfield[@code='a'][1],1,30)"/>
                </xsl:when>
                <xsl:when test="following-sibling::datafield[@tag='773'][1]/subfield[@code='t'][1]">
                    <xsl:value-of select="substring(following-sibling::datafield[@tag='773'][1]/subfield[@code='t'][1],1,30)"/>
                </xsl:when>
            </xsl:choose>
        </sorttitle>

        <!-- =========
             Preparing fields institution and network
             =========
        -->

        <xsl:for-each select="following-sibling::datafield[@tag='852']">
            <xsl:call-template name="UnionAndBranchlib">
                <xsl:with-param name="union" select="child::subfield[@code='B']" />
                <xsl:with-param name="branchlib" select="child::subfield[@code='F']" />
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="following-sibling::datafield[@tag='949']">
            <xsl:call-template name="UnionAndBranchlib">
                <xsl:with-param name="union" select="child::subfield[@code='B']" />
                <xsl:with-param name="branchlib" select="child::subfield[@code='F']" />
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="following-sibling::datafield[@tag='956']">
            <!--            <xsl:call-template name="UnionAndBranchlib">
                            <xsl:with-param name="union" select="child::subfield[@code='B']" />
                            <xsl:with-param name="branchlib" select="child::subfield[@code='a']" />
                        </xsl:call-template>-->
            <uri956>
                <xsl:value-of select="./subfield[@code='u'][1]"/>
            </uri956>
            <xsl:copy-of select="current()"/>
        </xsl:for-each>
    </xsl:template>

    <!-- IDS Unions get an additional union 'IDS', rest without changes -->
    <xsl:template name="UnionAndBranchlib" >
        <xsl:param name="union" />
        <xsl:param name="branchlib" />
        <xsl:choose>
            <xsl:when test="matches($union, '^IDS|^NEBIS')">
                <network>
                    <xsl:text>IDS</xsl:text>
                </network>
                <network>
                    <xsl:value-of select="$union"/>
                </network>
                <branchlib>
                    <xsl:value-of select="$branchlib"/>
                </branchlib>
            </xsl:when>
            <xsl:when test="matches($union, 'RERO')">
                <network>
                    <xsl:value-of select="$union" />
                </network>
                <network>
                    <xsl:value-of select="substring($branchlib, 1, 4)" />
                </network>
                <branchlib>
                    <xsl:value-of select="$branchlib"/>
                </branchlib>
            </xsl:when>
            <xsl:when test="matches($union, '^VAUDS')">
                <network>
                    <xsl:value-of select="substring($union, 1, 4)" />
                </network>
                <branchlib>
                    <xsl:value-of select="$branchlib"/>
                </branchlib>
            </xsl:when>
            <xsl:otherwise>
                <branchlib>
                    <xsl:value-of select="$branchlib"/>
                </branchlib>
                <network>
                    <xsl:value-of select="$union"/>
                </network>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Dates / Years -->

    <xsl:template match="controlfield[@tag='008']">
        <xsl:variable name="datetype" select="substring(text(),7,1)"/>
        <xsl:variable name="year1" select="substring(text()[1],8,4)" />
        <xsl:variable name="year2" select="replace(substring(text()[1],12,4), '9999', '2015')" />
        <xsl:choose>
            <xsl:when test="matches($datetype, '[espt]') and matches($year1, '[\d]{4}')">
                <year>
                    <xsl:value-of select="$year1" />
                </year>
                <freshness>
                    <xsl:value-of select="concat($year1, '-01-01T00:00:00Z')" />
                </freshness>
                <sortyear>
                    <xsl:value-of select="$year1" />
                </sortyear>
            </xsl:when>
            <xsl:when test="matches($datetype, '[mr]') and (matches($year1, '[\d]{4}') or matches($year2, '[\d]{4}'))">
                <xsl:if test="matches($year1, '[\d]{4}')">
                    <year>
                        <xsl:value-of select="$year1" />
                    </year>
                </xsl:if>
                <xsl:if test="matches($year2, '[012][\d]{3}')">
                    <year>
                        <xsl:value-of select="$year2" />
                    </year>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="matches($year1, '[\d]{4}')">
                        <freshness>
                            <xsl:value-of select="concat($year1, '-01-01T00:00:00Z')" />
                        </freshness>
                        <sortyear>
                            <xsl:value-of select="$year1" />
                        </sortyear>
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </xsl:when>
            <xsl:when test="matches($datetype, '[cdiku]')">
                <xsl:choose>
                    <xsl:when test="matches($year1, '[\d]{4}') and matches($year2, '[012][\d]{3}')">
                        <xsl:if test="$year1 &gt; $year2">
                            <freshness>
                                <xsl:value-of select="concat($year1, '-01-01T00:00:00Z')" />
                            </freshness>
                        </xsl:if>
                        <xsl:if test="$year2 &gt; $year1">
                            <freshness>
                                <xsl:value-of select="concat($year2, '-01-01T00:00:00Z')" />
                            </freshness>
                        </xsl:if>
                        <sortyear>
                            <xsl:value-of select="$year1" />
                        </sortyear>
                        <xsl:call-template name="yearranges">
                            <xsl:with-param name="year1" as="xs:integer" select="xs:integer($year1)" />
                            <xsl:with-param name="year2" as="xs:integer" select="xs:integer($year2)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches($year1, '[\d]{4}') and not(matches($year2, '[\d]{4}'))">
                        <year>
                            <xsl:value-of select="$year1" />
                        </year>
                        <freshness>
                            <xsl:value-of select="concat($year1, '-01-01T00:00:00Z')" />
                        </freshness>
                        <sortyear>
                            <xsl:value-of select="$year1" />
                        </sortyear>
                    </xsl:when>
                    <xsl:when test="matches($year2, '[\d]{4}') and not(matches($year1, '[\d]{4}'))">
                        <year>
                            <xsl:value-of select="$year2" />
                        </year>
                        <freshness>
                            <xsl:value-of select="concat($year2, '-01-01T00:00:00Z')" />
                        </freshness>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="matches($datetype, 'q')">
                <xsl:choose>
                    <xsl:when test="matches($year1, '[\d]{4}') and not(matches($year2, '2015')) and matches($year2, '[012][\d]{3}')">
                        <xsl:if test="$year1 &gt; $year2">
                            <freshness>
                                <xsl:value-of select="concat($year1, '-01-01T00:00:00Z')" />
                            </freshness>
                        </xsl:if>
                        <xsl:if test="$year2 &gt; $year1">
                            <freshness>
                                <xsl:value-of select="concat($year2, '-01-01T00:00:00Z')" />
                            </freshness>
                        </xsl:if>
                        <sortyear>
                            <xsl:value-of select="$year1" />
                        </sortyear>
                        <xsl:call-template name="yearranges">
                            <xsl:with-param name="year1" as="xs:integer" select="xs:integer($year1)" />
                            <xsl:with-param name="year2" as="xs:integer" select="xs:integer($year2)" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="matches($year1, '[\d]{4}') and (matches($year2, '2015') or not(matches($year2, '[012][\d]{3}')))">
                        <year>
                            <xsl:value-of select="$year1" />
                        </year>
                        <freshness>
                            <xsl:value-of select="concat($year1, '-01-01T00:00:00Z')" />
                        </freshness>
                        <sortyear>
                            <xsl:value-of select="$year1" />
                        </sortyear>
                    </xsl:when>
                    <xsl:when test="matches($year2, '[\d]{4}') and not(matches($year1, '[\d]{4}'))">
                        <year>
                            <xsl:value-of select="$year2" />
                        </year>
                        <freshness>
                            <xsl:value-of select="concat($year2, '-01-01T00:00:00Z')" />
                        </freshness>
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
        <xsl:copy-of select="current()"> </xsl:copy-of>
    </xsl:template>

    <xsl:template name="yearranges">
        <xsl:param name="year1" />
        <xsl:param name="year2" />
        <xsl:for-each select="$year1 to $year2">
            <year>
                <xsl:sequence select="."  />
            </year>
        </xsl:for-each>
    </xsl:template>

    <!-- ===========================
         Autorenfelder (1xx/7xx/8xx) : Aufbereitung der Facetten
         ===========================
    -->
    <xsl:template match="datafield[@tag='100']">
        <xsl:call-template name="pers_facet" />
    </xsl:template>

    <xsl:template match="datafield[@tag='700'][not(matches(child::subfield[@code='l'][1], 'eng|fre'))]">
        <xsl:call-template name="pers_facet" />
    </xsl:template>

    <xsl:template match="datafield[@tag='800']">
        <xsl:call-template name="pers_facet" />
    </xsl:template>

    <xsl:template match="datafield[@tag='110'] | 
                         datafield[@tag='710'] | 
                         datafield[@tag='810']">
        <xsl:call-template name="corp_facet" />
    </xsl:template>

    <xsl:template name="pers_facet">
        <xsl:copy-of select="." />
        <!-- Autorenfacette generisch
             ************************
             nur Namensansetzung
             ergaenzt um Lebensdaten, Titel sowie Zaehlung fuer Adel und Geistlichkeit (osc/13.08.2013) 
        -->
        <navAuthor>
            <xsl:value-of select="child::subfield[@code='a']"/>
            <xsl:choose>
                <xsl:when test="child::subfield[@code='D'] and child::subfield[@code='D']/text() != ''">
                    <xsl:value-of select="concat(', ', child::subfield[@code='D'])"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="child::subfield[@code='b'] and child::subfield[@code='b']/text() != ''">
                        <xsl:value-of select="concat(' ', replace(child::subfield[@code='b'][1], '[,.]', ''), '.')" />
                    </xsl:if>
                    <xsl:if test="child::subfield[@code='c'] and child::subfield[@code='c']/text() != ''">
                        <xsl:value-of select="concat(', ', child::subfield[@code='c'][1])" />
                    </xsl:if>
                    <xsl:if test="child::subfield[@code='d'] and child::subfield[@code='d']/text() != ''">
                        <xsl:value-of select="concat(' (', child::subfield[@code='d'][1], ')')" />
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </navAuthor>
    </xsl:template>

    <xsl:template name="corp_facet">
        <xsl:copy-of select="." />
        <!-- Autorenfacette generisch
             ************************
             Koerperschaften, komma-separierte Unterfelder 
        -->
        <navAuthor>
            <xsl:value-of select="child::subfield[@code='a']"/>
            <xsl:if test="exists(child::subfield[@code='b']/text())">
                <xsl:for-each select="child::subfield[@code='b']">
                    <xsl:value-of select="concat(', ', .)"/>
                </xsl:for-each>
            </xsl:if>
        </navAuthor>
    </xsl:template>

    <!-- Autorenfacette source-spezifisch
         ********************************
         Namensansetzungen, inkl. Lebensdaten, Titel, Zaehlung 
    -->
    <xsl:template match="datafield[@tag='950'][matches(child::subfield[@code='P'], '100|110|111|700|710|711')]">
        <!-- Beispiele fuer Ausschlusskriterien von Relatoren (spezifische Liste, oder alle) (15.05.2014 / osc)
        <xsl:template match="datafield[@tag='950'][matches(child::subfield[@code='P'], '100|110|111|700|710|711')][not(matches(child::subfield[@code='4'], 'fmo|ths'))]">
        <xsl:template match="datafield[@tag='950'][matches(child::subfield[@code='P'], '100|110|111|700|710|711')][not(exists(child::subfield[@code='4']))]">
        -->
        <xsl:copy-of select="current()" />
        <!-- this is a random MARC tag for transport use only (13.08.2013/osc) -->
        <datafield tag="979">
            <subfield code="a">
                <xsl:choose>
                    <!-- persons -->
                    <xsl:when test="matches(child::subfield[@code='P'], '100|700')">
                        <xsl:value-of select="child::subfield[@code='a']" />
                        <xsl:if test="child::subfield[@code='D'] and child::subfield[@code='D']/text() != ''">
                            <xsl:value-of select="concat(', ', replace(child::subfield[@code='D'], '\. -$', ''))"/>
                        </xsl:if>
                        <xsl:if test="child::subfield[@code='b'] and child::subfield[@code='b']/text() != ''">
                            <xsl:value-of select="concat(' ', replace(child::subfield[@code='b'][1], '[,.]', ''), '.')" />
                        </xsl:if>
                        <xsl:if test="child::subfield[@code='c'] and child::subfield[@code='c']/text() != ''">
                            <xsl:value-of select="concat(', ', child::subfield[@code='c'][1])" />
                        </xsl:if>
                        <xsl:if test="child::subfield[@code='d'] and child::subfield[@code='d']/text() != ''">
                            <xsl:value-of select="concat(' (', replace(child::subfield[@code='d'][1], '\. -$', ''), ')')" />
                        </xsl:if>
                    </xsl:when>
                    <!-- corporations -->
                    <xsl:when test="matches(child::subfield[@code='P'], '110|710')">
                        <xsl:value-of select="child::subfield[@code='a']"/>
                        <xsl:if test="exists(child::subfield[@code='b']/text())">
                            <xsl:for-each select="child::subfield[@code='b']">
                                <xsl:value-of select="concat(', ', .)"/>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </subfield>
            <subfield code="2">
                <xsl:value-of select="child::subfield[@code='B']/text()" />
            </subfield>
        </datafield>
    </xsl:template>

</xsl:stylesheet>
