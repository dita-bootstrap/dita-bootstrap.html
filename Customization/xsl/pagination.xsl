<?xml version="1.0" encoding="utf-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  version="2.0"
  exclude-result-prefixes="xs xhtml dita-ot"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
  <!-- Customization to add Bootstrap Pagination Component -->
  <!-- https://getbootstrap.com/docs/6.0/components/pagination/ -->

  <xsl:template
    match="*[ (contains(@class, ' topic/ol ') or contains(@class, ' topic/ul ')) and contains(@outputclass, 'pagination')]"
  >
    <nav>
      <xsl:next-match/>
    </nav>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/pagination ') or (contains(@class, ' topic/section ') and contains(@outputclass, 'pagination'))]"
  >
    <nav>
      <xsl:attribute name="aria-label">
        <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
      </xsl:attribute>
      <xsl:apply-templates select="*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul '))]"/>
    </nav>
  </xsl:template>
</xsl:stylesheet>
