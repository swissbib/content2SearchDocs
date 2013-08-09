<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">

    <xsl:output 
        method="xml" 
        encoding="UTF-8" 
        indent="yes"
        omit-xml-declaration="yes"
        /> 

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            swissbib.solr.step1.xsl ist die erste Stufe der Verarbeitung im Document-Processing zur Aufbereitung 
            der Daten vor der eigentlich Indexierung
            
            Der Schritt ist angelehnt an die stages des document processing von FAST
            Neben FAST internen stages wie LanguageDetection, Kopieren von Attributen, Deduplictaion
            gibt es die haupsaechlich von OCLV erstellten stages
            a) Kopie der kompletten urspruenglichen Struktur in ein eigenes Feld
            b) Erweiterung der urspruenglichen MARC - Struktur mit Feldern und Daten, die fuer das Indexieren 
            benoetigt werden (in oclc.xsl abgehandelt)
            
            c) Mappen der erstellten und erweiterten Struktur auf die Indexfelder des FAST-Index (Definiert im Indexprofil)
            (mehrheitlich in swissbib.solr.step2.xsl)
            
            SOLR bietet diese stages in der recht komfortablen FAST Form (noch) nicht an
            
            Deshalb vorerst 2 eigene XSLT Scripte, die die Transformationen und Anreicherungen abbilden
            
            Die Anreicherungen nur mit XSLT Verarbeitungen genuegen nicht (auch FAST verwendet fuer weitergehende Verarbeitungen
            Python Komponenten)
            Zu diesem Zweck verwenden wir in Java geschriebene XSLT Extensions
            (bspw. das Fetchen von externen Anreicherungsdaten [TOC, Abstracts und sonstige
            Volltexte]. Fuer das Extrahieen dieser Daten setzen wir TIKA ein)
            
            
            Anfangs waren beide scripte in 'einem' XSLT Template vereint (oclc.solr.xsl)
            Dieses XSLT wird dann jedoch sehr gross und damit unuebersichtlich.
            
            Zu pruefen bleibt noch, ob die Aufteilung in mehere templates und das Verketten in einem java - Programm
            nicht Performancenachteile mit sich bringt (meherer templates, Kopieren von streams etc)
            
            Versionen
            =========
            
            0.9 : Adaption des im Herbst 2010 von Guenther erstellten Stylesheets durch Oliver
                  ueberarbeitet, aufgeraeumt
                  offene Punkte in ssorttitle, ISBN sind weiterhin offen (mit hip klaeren)
            ***********************************
            23.09.2011 : Oliver : ueberarbeitet
            ***********************************
            11.11.2011 : Oliver : ueberarbeitet, v.a. Korrekturen in template 'UnionAndBranchlib' (Zeile 479+)
            ***********************************
            18.11.2011 : Oliver : Korrekturen branchlib
            ***********************************
            09.08.2013 : Oliver : Beginn Anpassungen für neues CBS
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

    <!-- ===========================
         Autorenfelder (1xx/7xx/8xx) : MARC-nahe Aufbereitung, Vorstufe zur Erstellung von solr-Feld sauthor
         ===========================
         Personen
    -->
    <xsl:template match="datafield[@tag='100']">
        <!-- nicht invertiert (ind1="0"), leicht umzustellen falls gewuenscht (16.08.2011/osc) -->
        <datafield tag="100" ind1="0" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="concat(child::subfield[@code='D'], ' ', child::subfield[@code='a'])" />
            </subfield>
            <xsl:copy-of select="child::subfield[@code='b']" /> 
            <xsl:copy-of select="child::subfield[@code='c']" /> 
            <xsl:copy-of select="child::subfield[@code='d']" /> 
            <xsl:copy-of select="child::subfield[@code='q']" /> 
            <xsl:copy-of select="child::subfield[@code='8']" /> 
        </datafield>

        <!-- Autorenfeld fuer Facettennavigation
             ergaenzt um Lebensdaten fuer alle und Titel sowie Zaehlung fuer Adel und Geistlichkeit (osc/03.08.2011) 
        -->
        <navAuthor>
            <xsl:value-of select="child::subfield[@code='a']"/>
            <xsl:choose>
                <xsl:when test="child::subfield[@code='D'] and child::subfield[@code='D']/text() != ''">
                    <xsl:value-of select="concat(', ', child::subfield[@code='D'])"/>
                   <!-- <xsl:if test="child::subfield[@code='d'] and child::subfield[@code='d']/text() != ''">
                        <xsl:value-of select="concat(' (', child::subfield[@code='d'][1], ')')" />
                    </xsl:if> -->
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

    <xsl:template match="datafield[@tag='700'][not(matches(child::subfield[@code='l'][1], 'eng|fre'))]">
        <!-- nicht invertiert (ind1="0"), leicht umzustellen falls gewuenscht (16.08.2011/osc) -->
        <datafield tag="700" ind1="0" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="concat(child::subfield[@code='D'], ' ', child::subfield[@code='a'])" />
            </subfield>
            <xsl:copy-of select="child::subfield[@code='b']" /> 
            <xsl:copy-of select="child::subfield[@code='c']" /> 
            <xsl:copy-of select="child::subfield[@code='d']" />
            <xsl:copy-of select="child::subfield[@code='l']" />
            <xsl:copy-of select="child::subfield[@code='q']" /> 
            <xsl:copy-of select="child::subfield[@code='t']" />
            <xsl:copy-of select="child::subfield[@code='4']" />
            <xsl:copy-of select="child::subfield[@code='8']" /> 
        </datafield>
        
        <!-- Autorenfeld fuer Facettennavigation -->
        <navAuthor>
            <xsl:value-of select="child::subfield[@code='a']"/>
            <xsl:choose>
                <xsl:when test="child::subfield[@code='D'] and child::subfield[@code='D']/text() != ''">
                    <xsl:value-of select="concat(', ', child::subfield[@code='D'])"/>
                    <!-- <xsl:if test="child::subfield[@code='d'] and child::subfield[@code='d']/text() != ''">
                        <xsl:value-of select="concat(' (', child::subfield[@code='d'][1], ')')" />
                    </xsl:if> -->
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
        
<!--        <xsl:if test="matches(child::subfield[@code='4'], '^[a-z][a-z][a-z]$')">
            <navRelator>
                <xsl:copy-of select="child::subfield[@code='a']" />
                <xsl:copy-of select="child::subfield[@code='D']" />
                <xsl:copy-of select="child::subfield[@code='b']" />
                <xsl:copy-of select="child::subfield[@code='c']" />
                <xsl:copy-of select="child::subfield[@code='d']" />
                <xsl:copy-of select="child::subfield[@code='q']" />
                <xsl:copy-of select="child::subfield[@code='4']" />
            </navRelator>
        </xsl:if>-->

    </xsl:template>

    <xsl:template match="datafield[@tag='800']">
        <!-- nicht invertiert (ind1="0"), leicht umzustellen falls gewuenscht (16.08.2011/osc) -->
        <datafield tag="800" ind1="0" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="concat(child::subfield[@code='D'], ' ', child::subfield[@code='a'])" />
            </subfield>
            <xsl:copy-of select="child::subfield[@code='b']" /> 
            <xsl:copy-of select="child::subfield[@code='c']" /> 
            <xsl:copy-of select="child::subfield[@code='d']" /> 
            <xsl:copy-of select="child::subfield[@code='q']" /> 
            <xsl:copy-of select="child::subfield[@code='t']" /> 
            <xsl:copy-of select="child::subfield[@code='v']" /> 
        </datafield>
        
        <!-- Autorenfeld fuer Facettennavigation-->
        <navAuthor>
            <xsl:value-of select="child::subfield[@code='a']"/>
            <xsl:choose>
                <xsl:when test="child::subfield[@code='D'] and child::subfield[@code='D']/text() != ''">
                    <xsl:value-of select="concat(', ', child::subfield[@code='D'])"/>
               <!-- <xsl:if test="child::subfield[@code='d'] and child::subfield[@code='d']/text() != ''">
                        <xsl:value-of select="concat(' (', child::subfield[@code='d'][1], ')')" />
                    </xsl:if> -->
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
    
    <!-- Koerperschaften -->
    <xsl:template match="datafield[@tag='110']">
        <datafield tag="110" ind1="1" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::subfield[@code='a']" />
            </subfield>
            <xsl:copy-of select="child::subfield[@code='b']" />
            <xsl:copy-of select="child::subfield[@code='c']" /> 
            <xsl:copy-of select="child::subfield[@code='d']" />
            <xsl:copy-of select="child::subfield[@code='n']" /> 
            <xsl:copy-of select="child::subfield[@code='8']" /> 
        </datafield>

        <!-- Autorenfeld mit Komma fuer Facettennavigation-->
        <navAuthor>
            <xsl:value-of select="child::subfield[@code='a']"/>
            <xsl:if test="child::subfield[@code='b'] and child::subfield[@code='b']/text() != ''">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="child::subfield[@code='b']"/>
            </xsl:if>
        </navAuthor>
    </xsl:template>
    
    <xsl:template match="datafield[@tag='710'][not(matches(child::subfield[@code='l'][1], 'eng|fre'))]">
        <datafield tag="710" ind1="1" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::subfield[@code='a']" />
            </subfield>
            <xsl:copy-of select="child::subfield[@code='b']" />
            <xsl:copy-of select="child::subfield[@code='c']" /> 
            <xsl:copy-of select="child::subfield[@code='d']" /> 
            <xsl:copy-of select="child::subfield[@code='n']" /> 
            <xsl:copy-of select="child::subfield[@code='t']" />
            <xsl:copy-of select="child::subfield[@code='4']" />
            <xsl:copy-of select="child::subfield[@code='8']" /> 
        </datafield>

        <!-- Autorenfeld mit Komma fuer Facettennavigation-->
        <navAuthor>
            <xsl:value-of select="child::subfield[@code='a']"/>
            <xsl:if test="child::subfield[@code='b'] and child::subfield[@code='b']/text() != ''">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="child::subfield[@code='b']"/>
            </xsl:if>
        </navAuthor>
        
<!--        <xsl:if test="matches(child::subfield[@code='4'], '^[a-z][a-z][a-z]$')">
            <navRelator>
                <xsl:copy-of select="child::subfield[@code='a']" />
                <xsl:copy-of select="child::subfield[@code='b']" />
                <xsl:copy-of select="child::subfield[@code='4']" />
            </navRelator>
        </xsl:if>-->
        
    </xsl:template>

    <xsl:template match="datafield[@tag='810']">
        <datafield tag="810" ind1="1" ind2=" ">
            <subfield code="a">
                <xsl:value-of select="child::subfield[@code='a']" />
            </subfield>
            <xsl:copy-of select="child::subfield[@code='b']" />
            <xsl:copy-of select="child::subfield[@code='c']" /> 
            <xsl:copy-of select="child::subfield[@code='d']" /> 
            <xsl:copy-of select="child::subfield[@code='n']" /> 
            <xsl:copy-of select="child::subfield[@code='t']" /> 
            <xsl:copy-of select="child::subfield[@code='v']" /> 
        </datafield>
        
        <!-- Autorenfeld mit Komma fuer Facettennavigation-->
        <navAuthor>
            <xsl:value-of select="child::subfield[@code='a']"/>
            <xsl:if test="child::subfield[@code='b'] and child::subfield[@code='b']/text() != ''">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="child::subfield[@code='b']"/>
            </xsl:if>
        </navAuthor>
    </xsl:template>

    <!-- year with ranges and freshness (05.10.2012/osc) -->
    <xsl:template match="controlfield[@tag='008']">
        <xsl:variable name="datetype" select="substring(text(),7,1)"/>
        <xsl:variable name="year1" select="substring(text()[1],8,4)" />
        <xsl:variable name="year2" select="replace(substring(text()[1],12,4), '9999', '2013')" />
        <xsl:choose>
            <xsl:when test="matches($datetype, '[spt]') and matches($year1, '[\d]{4}')">
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
            <xsl:when test="matches($datetype, '[cdik]')">
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

    <!-- URI  : je einzeln behandelt, ohne unnoetiges Feld <uri>
                muss noch angeschaut werden (18.08.2011/osc) -->
    <!--  First take field 956, than 856; Separator Pipe, 
          counter limit: only proceed once, as template may match twice 
    -->
    <!--<xsl:template match="datafield[@tag='856'] | datafield[@tag='956'] ">-->
        <!-- reduziert (18.08.2011/osc) -->
        <!--<xsl:variable name="counter">
            <xsl:number count="//datafield[@tag='856'] | //datafield[@tag='956']"/>
        </xsl:variable>
        <xsl:if test="$counter &lt; 2 ">
            <uri>
                <xsl:value-of select="//datafield[@tag='956'][position()=1]/subfield[@code='u']"/>
                <xsl:text>|</xsl:text>
                <xsl:value-of select="//datafield[@tag='856'][position()=1]/subfield[@code='u']"/>
                </uri>-->
    <xsl:template match="datafield[@tag='856']">
        <xsl:for-each select=".">
            <uri856>
                <xsl:value-of select="./subfield[@code='u']"/>
            </uri856>
            <xsl:copy-of select="current()"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="datafield[@tag='956'][1]">
        <xsl:for-each select=".">
            <uri956>
                <xsl:value-of select="./subfield[@code='u']"/>   
            </uri956>
            <xsl:copy-of select="current()"/>
        </xsl:for-each>
    </xsl:template>
    

    <!--  sortauthor -->
    <!--  order for entry in sortauthor: 100a, 700a, 110a, 710a, 111a, 711a -->
    <!--  sorttitle, 245$a, 'Nichtsortierkennzeichen' in indicator 2 -->
    <!-- network and branchlib: 949 and 852 can be treated alike; 856 misses $b-->
<!--    <xsl:template match="Docid">-->
    <xsl:template match="controlfield[@tag='001']">
        <myDocId>
            <xsl:value-of select="."/>
        </myDocId>
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
                <!-- Anpassungen (11.11.2011 / osc) : take only one instance to avoid trouble with #001171992 from IDSLU -->
                <xsl:when test="following-sibling::datafield[@tag='490'][1]/subfield[@code='a'][1]">
                    <xsl:value-of select="substring(following-sibling::datafield[@tag='490'][1]/subfield[@code='a'][1],1,30)"/>
                </xsl:when>
                <xsl:when test="following-sibling::datafield[@tag='773'][1]/subfield[@code='t'][1]">
                    <xsl:value-of select="substring(following-sibling::datafield[@tag='773'][1]/subfield[@code='t'][1],1,30)"/>
                </xsl:when>
            </xsl:choose>
        </sorttitle>
        
        <!-- =========
             Holdings treatment
             =========
        -->
        <!-- Schriftenreihen, haeufig ohne Holding, erhalten Eintrag in snetwork (27.11.2011/osc) -->
        <xsl:for-each select="following-sibling::datafield[@tag='035']">
            <xsl:choose>
                <xsl:when test="matches(following-sibling::datafield[@tag='898'][1]/subfield[@code='a'], '^CR030[01]0')">
                    <xsl:if test="matches(./subfield[@code='a']/text(), '^\(IDS|^\(NEBIS|^\(ABN|^\(BGR|^\(SGBN|^\(SBT|^\(SNL|\(RERO')">
                    <xsl:call-template name="UnionAndBranchlib">
                        <xsl:with-param name="union" select="substring-before(substring-after(., '('), ')')" />
                    </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise />
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="following-sibling::datafield[@tag='852']">   
            <xsl:call-template name="UnionAndBranchlib">
                <xsl:with-param name="branchlib" select="child::subfield[@code='b']" />
                <xsl:with-param name="union" select="child::subfield[@code='B']" />
            </xsl:call-template>
        </xsl:for-each> 
        <xsl:for-each select="following-sibling::datafield[@tag='856']">   
            <xsl:call-template name="UnionAndBranchlib">           
                <xsl:with-param name="union" select="child::subfield[@code='B']" />                
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="following-sibling::datafield[@tag='949']">   
            <xsl:call-template name="UnionAndBranchlib">
                <xsl:with-param name="branchlib" select="child::subfield[@code='b']" />
                <xsl:with-param name="union" select="child::subfield[@code='B']" />
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="following-sibling::datafield[@tag='956']">
            <xsl:call-template name="UnionAndBranchlib">
                <xsl:with-param name="branchlib" select="child::subfield[@code='a']" />
                <xsl:with-param name="union" select="child::subfield[@code='B']" />
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- 949 and 852 can be treated alike; 856 misses $b, 956 has branchlib in $a -->
    <xsl:template name="UnionAndBranchlib" >
        <xsl:param name="union" />        
        <xsl:param name="branchlib" />
        <xsl:choose>
            <xsl:when test="matches($union, 'RERO')">
                <xsl:if test="string-length($branchlib) = 8">
                    <branchlib>
                        <xsl:value-of select="concat('R', substring($branchlib,0,5))"/>
                    </branchlib>
                    <network>
                        <xsl:value-of select="concat('R', substring($branchlib,0,2))"/>
                    </network>
                    <network>
                        <xsl:value-of select="$union"/>
                    </network>
                </xsl:if>
                <xsl:if test="string-length($branchlib) = 9">
                    <branchlib>
                        <xsl:value-of select="concat('R', substring($branchlib,0,6))"/>
                    </branchlib>
                    <network>
                        <xsl:value-of select="concat('R', substring($branchlib,0,3))"/>
                    </network>
                    <network>
                        <xsl:value-of select="$union"/>
                    </network>
                </xsl:if>
                <xsl:if test="not($branchlib)">
                    <network>
                        <xsl:value-of select="$union" />
                    </network>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$union = 'SNL'">
                <xsl:if test="string-length($branchlib) = 5">
                    <branchlib>
                        <xsl:value-of select="concat('S', substring($branchlib,0,2))"/>
                    </branchlib>
                </xsl:if>
                <network>
                    <xsl:value-of select="$union"/>
                </network>
            </xsl:when>
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

    <!--  ISBN (020 $a, $z; entferne zusaetzliche Informationen) -->
    <xsl:template match="datafield[@tag='020']">
        <datafield tag="020" ind1=" " ind2=" ">
            <xsl:for-each select="child::subfield[@code='a']">
                <subfield code="a">
                   <xsl:value-of select="replace(., '^[\D]*([\d\-\.]+x?).*$', '$1', 'i')" />
                </subfield>
            </xsl:for-each>
            <xsl:for-each select="child::subfield[@code='z']">
                <subfield code="z">
                    <xsl:value-of select="replace(., '^[\D]*([\d\-\.]+x?).*$', '$1', 'i')" />
                </subfield>
            </xsl:for-each>
        </datafield>
    </xsl:template>

</xsl:stylesheet>
