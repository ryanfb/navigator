<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: start-txt.xsl 1510 2008-08-14 15:27:51Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:t="http://www.tei-c.org/ns/1.0"
                xmlns:pi="http://papyri.info/ns"
                version="2.0" exclude-result-prefixes="">

  <xsl:output method="text" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>

  <xsl:include href="../epidoc/global-varsandparams.xsl"/>
  
  <xsl:include href="../epidoc/txt-teiab.xsl"/>
  <xsl:include href="../epidoc/txt-teiapp.xsl"/>
  <xsl:include href="../epidoc/txt-teidiv.xsl"/>
  <xsl:include href="../epidoc/txt-teidivedition.xsl"/>
  <xsl:include href="../epidoc/txt-teig.xsl"/>
  <xsl:include href="../epidoc/txt-teigap.xsl"/>
  <xsl:include href="../epidoc/txt-teihead.xsl"/>
  <xsl:include href="../epidoc/txt-teilb.xsl"/>
  <xsl:include href="../epidoc/txt-teilgandl.xsl"/>
  <xsl:include href="../epidoc/txt-teilistanditem.xsl"/>
  <xsl:include href="../epidoc/txt-teilistbiblandbibl.xsl"/>
  <xsl:include href="../epidoc/txt-teimilestone.xsl"/>
  <xsl:include href="../epidoc/txt-teinote.xsl"/>
  <xsl:include href="../epidoc/txt-teip.xsl"/>
  <xsl:include href="../epidoc/txt-teispace.xsl"/>
  <xsl:include href="../epidoc/txt-teisupplied.xsl"/>
  <xsl:include href="../epidoc/txt-teiref.xsl"/>
  
  <xsl:include href="../epidoc/teiabbrandexpan.xsl"/>
  <xsl:include href="../epidoc/teiaddanddel.xsl"/>
  <xsl:include href="../epidoc/teichoice.xsl"/>
  <xsl:include href="../epidoc/teihandshift.xsl"/>
  <xsl:include href="../epidoc/teiheader.xsl"/>
  <xsl:include href="../epidoc/teihi.xsl"/>
  <xsl:include href="../epidoc/teimilestone.xsl"/>
  <xsl:include href="../epidoc/teinum.xsl"/>
  <xsl:include href="../epidoc/teiorig.xsl"/>
  <xsl:include href="../epidoc/teiq.xsl"/>
  <xsl:include href="../epidoc/teiseg.xsl"/>
  <xsl:include href="../epidoc/teisicandcorr.xsl"/>
  <xsl:include href="../epidoc/teispace.xsl"/>
  <xsl:include href="../epidoc/teisupplied.xsl"/>
  <xsl:include href="../epidoc/teiunclear.xsl"/>
  
  <xsl:include href="../epidoc/txt-tpl-apparatus.xsl"/>
	<xsl:include href="../epidoc/txt-tpl-linenumberingtab.xsl"/>
  
  <xsl:include href="../epidoc/tpl-reasonlost.xsl"/>
  <xsl:include href="../epidoc/tpl-certlow.xsl"/>
  <xsl:include href="../epidoc/tpl-text.xsl"/>
  
  <xsl:include href="pi-functions.xsl"/>

  <xsl:param name="collection"/>
  <xsl:param name="related"/>
  <xsl:variable name="relations" select="tokenize($related, ' ')"/>
  <xsl:variable name="path">/data/papyri.info/idp.data</xsl:variable>
  <xsl:variable name="outbase">/data/papyri.info/pn/idp.html</xsl:variable>

  <xsl:template match="/">
    <xsl:variable name="ddbdp" select="$collection = 'ddbdp'"/>
    <xsl:variable name="hgv" select="$collection = 'hgv' or contains($related, 'hgv/')"/>
    <xsl:variable name="apis" select="$collection = 'apis' or contains($related, '/apis/')"/>
    <xsl:variable name="translation" select="contains($related, 'hgvtrans') or (contains($related, '/apis/') and pi:get-docs($relations[contains(., '/apis/')], 'xml')//t:div[@type = 'translation']) or //t:div[@type = 'translation']"/>
    <xsl:variable name="docs" select="pi:get-docs($relations, 'xml')"/>
    
    <xsl:choose>
      <xsl:when test="$collection = 'ddbdp'">
        <xsl:apply-templates select="$docs//t:TEI" mode="metadata"/>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="/t:TEI" mode="metadata"/>
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:if test="$translation">
      <xsl:if test="//t:div[@type = 'translation']">
        <xsl:value-of select="//t:div[@type = 'translation']"/>
      </xsl:if>
      <xsl:for-each select="$docs/t:TEI//t:div[@type = 'translation']">
        <xsl:sort select="number(.//t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno[@type='filename'])"/>
        <xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="t:TEI" mode="metadata">
    <xsl:text>
</xsl:text>
    <!-- Title -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:titleStmt/t:title" mode="metadata"/>
    <!-- Summary -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:summary" mode="metadata"/>
    <!-- Publications -->
    <xsl:apply-templates select="t:text/t:body/t:div[@type = 'bibliography' and @subtype = 'principalEdition']" mode="metadata"/>
    <!-- Inv. Id -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:idno" mode="metadata"/>
    <!-- Physical Desc. -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:p" mode="metadata"/>
    <!-- Post-concordance BL Entries -->
    <xsl:apply-templates select="t:text/t:body/t:div[@type = 'bibliography' and @subtype = 'corrections']" mode="metadata"/>
    <!-- Translations -->
    <xsl:apply-templates select="t:text/t:body/t:div[@type = 'bibliography' and @subtype = 'translations']" mode="metadata"/>
    <!-- Provenance -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/(t:origPlace|t:p)" mode="metadata"/>
    <!-- Material -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:material" mode="metadata"/>
    <!-- Language -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem/t:textLang" mode="metadata"/>
    <!-- Date -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:origDate" mode="metadata"/>
    <!-- Notes (general|lines|palaeography|recto/verso|conservation|preservation) -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem/t:note" mode="metadata"/>
    <!-- Print Illustrations -->
    <xsl:apply-templates select="t:text/t:body/t:div[@type = 'bibliography' and @subtype = 'illustrations'][.//t:bibl]" mode="metadata"/>
    <!-- Subjects -->
    <xsl:apply-templates select="t:teiHeader/t:profileDesc/t:textClass/t:keywords" mode="metadata"/>
    <!-- Associated Names -->
    <xsl:apply-templates select="t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin[t:persName/@type = 'asn']" mode="metadata"/>
    <!-- Images -->
    <xsl:apply-templates select="t:text/t:body/t:div[@type = 'figure']" mode="metadata"/>
  </xsl:template>
  
  <!-- Title -->
  <xsl:template match="t:title" mode="metadata">
    <xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Summary -->
  <xsl:template match="t:summary" mode="metadata">
    <xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Publications -->
  <xsl:template match="t:div[@type = 'bibliography' and @subtype='principalEdition']" mode="metadata">
    <xsl:value-of select=".//t:bibl"/><xsl:text>
</xsl:text>
    <xsl:for-each select="../t:div[@type = 'bibliography' and @subtype = 'otherPublications']//t:bibl">
      <xsl:value-of select="."/><xsl:text>
</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Print Illustrations -->
  <xsl:template match="t:div[@type = 'bibliography' and @subtype='illustrations']" mode="metadata">
    <xsl:for-each select=".//t:bibl"><xsl:value-of select="normalize-space(.)"/><xsl:if test="position() != last()">; </xsl:if></xsl:for-each><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Inv. Id -->
  <xsl:template match="t:msIdentifier/t:idno" mode="metadata">
    <xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Physical Desc. -->
  <xsl:template match="t:physDesc/t:p" mode="metadata">
    <xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Post-Concordance BL Entries -->
  <xsl:template match="t:div[@type = 'bibliography' and @subtype='corrections']" mode="metadata">
    <xsl:for-each select=".//t:bibl"><xsl:value-of select="normalize-space(.)"/><xsl:if test="position() != last()">; </xsl:if></xsl:for-each><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Translations -->
  <xsl:template match="t:div[@type = 'bibliography' and @subtype='translations']" mode="metadata">
    <xsl:for-each select=".//t:bibl"><xsl:value-of select="normalize-space(.)"/><xsl:if test="position() != last()">; </xsl:if></xsl:for-each><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Provenance -->
  <xsl:template match="t:origPlace|t:p[parent::t:origin]" mode="metadata">
    <xsl:choose>
      <xsl:when test="local-name(.) = 'origPlace'"><xsl:value-of select="."/></xsl:when>
      <xsl:otherwise><xsl:if test="t:placeName[@type='ancientFindspot']"><xsl:value-of select="t:placeName[@type='ancientFindspot']"/><xsl:if test="t:geogName">, </xsl:if></xsl:if>
        <xsl:if test="t:geogName[@type='nome']"><xsl:value-of select="t:geogName[@type='nome']"/><xsl:if test="t:geogName[@type='ancientRegion']">, </xsl:if></xsl:if>
      <xsl:value-of select="t:geogName[@type='ancientRegion']"/></xsl:otherwise>
    </xsl:choose>
    <xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Material -->
  <xsl:template match="t:material" mode="metadata">
    <xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Language -->
  <xsl:template match="t:textLang" mode="metadata">
    <xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Date -->
  <xsl:template match="t:origDate" mode="metadata">
    <xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Notes -->
  <xsl:template match="t:msItem/t:note" mode="metadata">
    <xsl:value-of select="."/><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Subjects -->
  <xsl:template match="t:keywords" mode="metadata">
    <xsl:for-each select="t:term"><xsl:value-of select="normalize-space(.)"/><xsl:if test="position() != last()">; </xsl:if></xsl:for-each><xsl:text>
</xsl:text>
  </xsl:template>
  
  <!-- Associated Names -->
  <xsl:template match="t:origin" mode="metadata">
    <xsl:for-each select="t:persName[@type = 'asn']"><xsl:value-of select="normalize-space(.)"/><xsl:if test="position() != last()">; </xsl:if></xsl:for-each><xsl:text>
</xsl:text>
  </xsl:template>
  
</xsl:stylesheet>
