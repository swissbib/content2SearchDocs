<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0"
>
    
    <xsl:output
        omit-xml-declaration="yes"
        />


    <xsl:template match="@*|node()">
            <xsl:apply-templates select="@*|node()"/>
    </xsl:template>
   
   <xsl:template match="record">
       <record>
           <xsl:apply-templates/>
       </record>
   </xsl:template>
    
    <xsl:template match="datafield[@tag='852']">
        
        <xsl:copy-of select="."/>
        <xsl:apply-templates/>
        
    </xsl:template>    
    
    <xsl:template match="datafield[@tag='949']">
        <xsl:copy-of select="."/>
        <xsl:apply-templates/>
    </xsl:template>    
    
    
</xsl:stylesheet>