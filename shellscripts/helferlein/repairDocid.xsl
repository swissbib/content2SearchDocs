<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:output indent="yes" />

    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="add/doc">
        <doc xmlns:java-nodouble-ext="java:org.swissbib.solr.documentprocessing.RemoveDuplicates"
             xmlns:fn="http://www.w3.org/2005/xpath-functions"
             xmlns:swissbib="www.swissbib.org/solr/documentprocessing">
            <xsl:apply-templates/>
        </doc>
    </xsl:template>

    <xsl:template match="field[@name='Docid']">
        <xsl:variable name="fsourcevalue">
            <xsl:value-of select="following-sibling::field[@name='fsource']"/>
        </xsl:variable>
        <xsl:variable name="docidvalue">
            <xsl:analyze-string select="$fsourcevalue" regex="&lt;Docid&gt;(.*)&lt;/Docid&gt;">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"  />
                </xsl:matching-substring> 
                <xsl:non-matching-substring />
            </xsl:analyze-string> 
        </xsl:variable>    
        <field name="Docid"><xsl:value-of select="$docidvalue"/></field>
    </xsl:template>

    <xsl:template match="field[@name='fsource']">
        
        <xsl:variable name="test1">
        <xsl:analyze-string select="." regex="(.*)&lt;Docid&gt;(.*)&lt;/Docid&gt;">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"  />
            </xsl:matching-substring> 
            <xsl:non-matching-substring />
        </xsl:analyze-string> 
        </xsl:variable>    
        


        <field name="test">
            <xsl:value-of select="$test1"/>    
        </field>
        
        <field name="fsource">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:value-of disable-output-escaping="yes">
                <xsl:copy-of   select="." />
            </xsl:value-of>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
    </xsl:template>


    <xsl:template match="field[@name='sfullTextRemoteData']">
        
        <field name="sfullTextRemoteData">
            <xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
            <xsl:value-of disable-output-escaping="yes">
                <xsl:copy-of   select="." />
            </xsl:value-of>
            <xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
        </field>
        
        
    </xsl:template>
        

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>    
    </xsl:template>

</xsl:stylesheet>