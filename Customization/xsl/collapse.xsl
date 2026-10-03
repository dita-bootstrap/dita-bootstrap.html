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
  <!-- Customization to add Bootstrap Collapse Component -->
  <!-- https://getbootstrap.com/docs/6.0/components/collapse/ -->

  <xsl:template match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'collapse-horizontal')]">
    <xsl:variable name="id" select="if(@id) then dita-ot:generate-html-id(.) else generate-id(.)"/>
    <div>
      <xsl:if test="contains(@otherprops, 'style(')">
        <xsl:attribute name="style">
          <xsl:analyze-string select="@otherprops" regex="[a-z]*\([^\)]*\)">
            <xsl:matching-substring>
              <xsl:variable name="var">
                <xsl:value-of select="."/>
              </xsl:variable>
              <xsl:variable name="attr">
                <xsl:value-of select="substring-before($var, '(')"/>
              </xsl:variable>
              <xsl:attribute name="{$attr}">
                <xsl:value-of select="substring-before(substring-after($var, '('),')')"/>
              </xsl:attribute>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xsl:attribute>
      </xsl:if>
      <div>
        <xsl:attribute name="id" select="$id"/>
        <xsl:call-template name="commonattributes"/>
        <xsl:apply-templates/>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/div ')  and contains(@otherprops, 'style(')]">
    <div>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setid"/>
      <xsl:call-template name="otherprops-attributes"/>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <!-- Override to connect an collapsed element to a button -->
  <xsl:template match="*[contains(@class,' topic/xref ') and contains(@props, 'collapse-toggle')]">
    <xsl:variable name="href" select="substring-after(@href, '#')"/>
    <xsl:variable
      name="id"
      select="if(//*[@id=$href]) then dita-ot:generate-html-id(//*[@id=$href]) else generate-id(//*[@id=$href])"
    />

    <a data-bs-toggle="collapse">
      <xsl:call-template name="commonattributes"/>
      <xsl:attribute name="href" select="concat('#',$id)"/>
      <xsl:attribute name="aria-expanded" select="'false'"/>
      <xsl:attribute name="aria-controls" select="$id"/>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
</xsl:stylesheet>
