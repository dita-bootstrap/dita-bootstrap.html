<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="xs xhtml dita-ot"
>
  <!-- Customization to add Bootstrap Offcanvas Component -->
  <!-- https://getbootstrap.com/docs/6.0/components/drawer/ -->

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/drawer ')] | *[contains(@class,' topic/section ') and contains(@outputclass, 'drawer-')]"
  >
    <xsl:param name="headLevel">
      <xsl:variable name="headCount" select="count(ancestor::*[contains(@class, ' topic/topic ')])+1"/>
      <xsl:choose>
        <xsl:when test="$headCount > 6">h6</xsl:when>
        <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:variable name="id" select="dita-ot:generate-html-id(.)"/>
    <dialog>
      <xsl:call-template name="commonattributes"/>
      <xsl:attribute name="tabindex" select="'-1'"/>
      <xsl:attribute name="id" select="$id"/>
      <xsl:attribute name="aria-labelledby" select="concat('drawerLabel_', $id)"/>
      <div class="drawer-header">
        <xsl:element name="{$headLevel}">
          <xsl:attribute name="id" select="concat('drawerLabel_' ,$id)"/>
          <xsl:attribute name="class" select='drawer-title'/>
          <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
        </xsl:element>
        <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="drawer"/>
      </div>
      <div class="drawer-body">
        <xsl:apply-templates select="*[not(contains(@class, ' topic/title '))]"/>
      </div>
    </dialog>
  </xsl:template>

  <!-- Override to connect an drawer to a button -->
  <xsl:template match="*[contains(@class,' topic/xref ') and contains(@props, 'drawer-toggle')]">
    <xsl:variable name="href" select="substring-after(@href, '#')"/>
    <xsl:variable
      name="id"
      select="if(//*[@id=$href]) then dita-ot:generate-html-id(//*[@id=$href]) else generate-id(//*[@id=$href])"
    />

    <a data-bs-toggle="drawer">
      <xsl:call-template name="commonattributes"/>
      <xsl:attribute name="href" select="concat('#',$id)"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
</xsl:stylesheet>
