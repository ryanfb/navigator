<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-teihead.xsl 1725 2012-01-10 16:08:31Z gabrielbodard $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                version="2.0">
  
  
  <xsl:template match="t:div/t:head">
      <h2>
         <xsl:apply-templates/>
      </h2>
  </xsl:template>
   
   <xsl:template match="t:body/t:head">
      <xsl:choose>
         <xsl:when test="$leiden-style='ddbdp'">
            <xsl:element name="p">
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <h2>
               <xsl:apply-templates/>
            </h2>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
  
</xsl:stylesheet>
