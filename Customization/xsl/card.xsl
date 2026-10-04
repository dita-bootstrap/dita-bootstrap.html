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
  <!-- Customization to add Bootstrap Card Component -->
  <!-- https://getbootstrap.com/docs/6.0/components/card/ -->

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/card ')]
           | *[contains(@class,' topic/section ') and tokenize(@outputclass, '\s+') = 'card']
           | *[contains(@class,' topic/div ') and tokenize(@outputclass, '\s+') = 'card']"
  >
    <xsl:variable name="images" select="*[contains(@class, ' topic/image ')]"/>
    <xsl:variable
      name="top-images"
      select="$images[contains(@outputclass, 'card-img-top')] | $images[not(contains(@outputclass, 'card-img-')) and count($images) = 1]"
    />
    <xsl:variable name="bottom-images" select="$images[contains(@outputclass, 'card-img-bottom')]"/>
    <xsl:variable
      name="header"
      select="*[contains(@class, ' bootstrap-d/card-header ') or (contains(@outputclass, 'card-header') and (contains(@class, ' topic/sectiondiv ') or contains(@class, ' topic/div ')))]"
    />
    <xsl:variable
      name="footer"
      select="*[contains(@class, ' bootstrap-d/card-footer ') or (contains(@outputclass, 'card-footer') and (contains(@class, ' topic/sectiondiv ') or contains(@class, ' topic/div ')))]"
    />

    <div>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setid"/>
      <xsl:apply-templates select="$header"/>
      <xsl:apply-templates select="$top-images"/>
      <div class="card-body">
        <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="card"/>
        <xsl:apply-templates
          select="*[not(contains(@class, ' topic/title ')) 
                    and not(generate-id() = $top-images/generate-id()) 
                    and not(generate-id() = $bottom-images/generate-id()) 
                    and not(generate-id() = $header/generate-id()) 
                    and not(generate-id() = $footer/generate-id())]"
        />
      </div>
      <xsl:apply-templates select="$bottom-images"/>
      <xsl:apply-templates select="$footer"/>
    </div>
  </xsl:template>

  <!-- Card Body -->
  <xsl:template match="*" mode="card">
    <xsl:param name="headLevel">
      <xsl:variable name="headCount" select="count(ancestor::*[contains(@class, ' topic/topic ')])+1"/>
      <xsl:choose>
        <xsl:when test="contains(@outputclass, 'h1')">h1</xsl:when>
        <xsl:when test="contains(@outputclass, 'h2')">h2</xsl:when>
        <xsl:when test="contains(@outputclass, 'h3')">h3</xsl:when>
        <xsl:when test="contains(@outputclass, 'h4')">h4</xsl:when>
        <xsl:when test="contains(@outputclass, 'h5')">h5</xsl:when>
        <xsl:when test="contains(@outputclass, 'h6')">h6</xsl:when>
        <xsl:when test="$headCount > 6">h6</xsl:when>
        <xsl:when test="count(preceding-sibling::*[contains(@class, ' topic/title ')]) > 0">h<xsl:value-of
            select="$headCount+1"
          /></xsl:when>
        <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:variable
      name="bootstrap-class"
      select="
        if (count(preceding-sibling::*[contains(@class, ' topic/title ')]) > 0) then 'sectiontitle card-subtitle fg-2'
        else 'sectiontitle card-title'"
    />
    <xsl:element name="{$headLevel}">
      <xsl:attribute name="class">
        <xsl:value-of select="$bootstrap-class"/>
      </xsl:attribute>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$bootstrap-class"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="*[contains(@class, ' topic/image ')]" mode="get-output-class" priority="10">
    <xsl:variable
      name="card"
      select="parent::*[contains(@class, ' bootstrap-d/card ')
                        or (contains(@class,' topic/section ') and tokenize(@outputclass, '\s+') = 'card')
                        or (contains(@class,' topic/div ') and tokenize(@outputclass, '\s+') = 'card')]"
    />
    <xsl:if test="$card">
      <xsl:variable name="totalImages" select="count($card/*[contains(@class, ' topic/image ')])"/>
      <xsl:if test="$totalImages = 1 and not(contains(@outputclass, 'card-img-'))">
        <xsl:text>card-img-top </xsl:text>
      </xsl:if>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

</xsl:stylesheet>
