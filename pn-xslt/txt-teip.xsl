<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: txt-teip.xsl 1543 2011-08-31 15:47:37Z ryanfb $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                version="2.0">

  <xsl:template match="t:p">
      <xsl:text>
&#xD;
&#xD;</xsl:text>
      <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>
