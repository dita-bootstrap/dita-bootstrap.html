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
  <!-- Customization to add Bootstrap Tabbed Dialog Component -->
  <!-- https://getbootstrap.com/docs/6.0/components/navs-tabs/#tabs -->

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/tabbed-dialog ')] | *[contains(@class,' topic/bodydiv ') and (contains(@outputclass, 'nav-tabs') or contains(@outputclass, 'nav-pills'))]"
  >
    <xsl:choose>
      <!-- Pills with Vertical alignment -->
      <!-- https://getbootstrap.com/docs/6.0/components/navs-tabs/#vertical -->
      <xsl:when test="@style = 'vertical-pills' or contains(@outputclass, 'nav-pills-vertical')">
        <div class="d-flex align-items-start">
          <div role="tablist" aria-orientation="vertical">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setid"/>
            <xsl:apply-templates
              mode="nav-pills-vertical"
              select="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]"
            />
          </div>
          <div class="tab-content">
            <xsl:apply-templates mode="nav-tabs" select="*[contains(@class,' topic/section ')]"/>
          </div>
        </div>
      </xsl:when>
      <!-- Horizontal Tabs or Pills -->
      <xsl:otherwise>
        <ul role="tablist">
          <xsl:call-template name="commonattributes"/>
          <xsl:call-template name="setid"/>
          <xsl:apply-templates
            mode="nav-tabs"
            select="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]"
          />
        </ul>
        <div class="tab-content">
          <xsl:apply-templates mode="nav-tabs" select="*[contains(@class,' topic/section ')]"/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Tabbed dialog header -->
  <xsl:template match="*[contains(@class,' topic/title ')]" mode="nav-tabs">
    <xsl:variable name="parent" select="dita-ot:generate-html-id(..)"/>
    <xsl:variable name="title" select="."/>
    <xsl:variable name="index" select="count(../preceding-sibling::*[contains(@class, ' topic/section ')])"/>

    <li class="nav-item" role="presentation">
      <button data-bs-toggle="tab" type="button" role="tab">
        <xsl:attribute name="id" select="concat('heading_' ,$parent)"/>
        <xsl:attribute name="data-bs-target" select="concat('#tab_' ,$parent)"/>
        <xsl:attribute
          name="class"
          select="
            if ($index = 0) then 'nav-link active'
            else 'nav-link'"
        />
        <xsl:attribute name="aria-selected" select="$index=0"/>
        <xsl:attribute name="aria-controls" select="$title"/>
        <xsl:apply-templates/>
      </button>
    </li>
  </xsl:template>

  <!-- Pills with Vertical alignment header -->
  <xsl:template match="*[contains(@class,' topic/title ')]" mode="nav-pills-vertical">
    <xsl:variable name="parent" select="dita-ot:generate-html-id(..)"/>
    <xsl:variable name="title" select="."/>
    <xsl:variable name="index" select="count(../preceding-sibling::*[contains(@class, ' topic/section ')])"/>
    <button data-bs-toggle="tab" type="button" role="tab">
      <xsl:attribute name="id" select="concat('heading_' ,$parent)"/>
      <xsl:attribute name="data-bs-target" select="concat('#tab_' ,$parent)"/>
      <xsl:attribute name="class" select="
        if ($index = 0) then 'nav-link active'
        else 'nav-link'"/>
      <xsl:attribute name="aria-selected" select="$index=0"/>
      <xsl:attribute name="aria-controls" select="$title"/>
      <xsl:apply-templates/>
    </button>
  </xsl:template>

  <!-- Tabbed Dialog Body -->
  <xsl:template match="*[contains(@class,' topic/section ')]" mode="nav-tabs">
    <xsl:variable name="id" select="dita-ot:generate-html-id(.)"/>
    <xsl:variable name="index" select="count(preceding-sibling::*[contains(@class, ' topic/section ')])"/>

    <div role="tabpanel">
      <xsl:attribute
        name="class"
        select="
          if ($index = 0) then 'tab-pane fade show active'
          else 'tab-pane fade'"
      />
      <xsl:attribute name="id" select="concat('tab_' ,$id)"/>
      <xsl:attribute name="aria-labelledby" select="concat('heading_' ,$id)"/>
      <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
    </div>
  </xsl:template>
</xsl:stylesheet>
