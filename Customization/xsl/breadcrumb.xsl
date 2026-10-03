<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
  version="2.0"
  exclude-result-prefixes="xs dita-ot ditamsg"
>
  <!-- Override to add Bootstrap breadcrumb component -->
  <!-- https://getbootstrap.com/docs/6.0/components/breadcrumb/ -->

  <!-- Whether include a bootstrap breadcrumb component on each page.  values are 'yes' or 'no' -->
  <xsl:param name="BREADCRUMBS" select="'no'"/>
  <!-- Dividers can be changed via an input parameter -->
  <xsl:param name="BREADCRUMB_DIVIDER" select="'/'"/>

  <!-- Add Bootstrap breadcrumb -->
  <xsl:template match="*" mode="gen-user-breadcrumb">
    <nav aria-label="breadcrumb">
      <xsl:if test="not($BREADCRUMB_DIVIDER = '/')">
        <xsl:attribute name="style">
          <xsl:text>--bs-breadcrumb-divider: '</xsl:text>
          <xsl:value-of select="$BREADCRUMB_DIVIDER"/>
          <xsl:text>';</xsl:text>
        </xsl:attribute>
      </xsl:if>

      <ol class="breadcrumb">
        <xsl:for-each select="ancestor::node()">
          <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
          </xsl:variable>
          <xsl:if test="normalize-space($title)">
            <li class="breadcrumb-item">
              <xsl:choose>
                <xsl:when test="@href">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:if test="not(@scope = 'external')">
                        <xsl:value-of select="$PATH2PROJ"/>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when
                          test="@copy-to and not(contains(@chunk, 'to-content')) and
                                          (not(@format) or @format = 'dita' or @format = 'ditamap') "
                        >
                          <xsl:call-template name="replace-extension">
                            <xsl:with-param name="filename" select="@copy-to"/>
                            <xsl:with-param name="extension" select="$OUTEXT"/>
                          </xsl:call-template>
                          <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                            <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                          </xsl:if>
                        </xsl:when>
                        <xsl:when
                          test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')"
                        >
                          <xsl:call-template name="replace-extension">
                            <xsl:with-param name="filename" select="@href"/>
                            <xsl:with-param name="extension" select="$OUTEXT"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="@href"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="$title"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <span>
                    <xsl:value-of select="$title"/>
                  </span>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:if>
        </xsl:for-each>
        <xsl:variable name="title">
          <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>
        <xsl:if test="normalize-space($title)">
          <li class="breadcrumb-item active" aria-current="page">
            <xsl:value-of select="$title"/>
          </li>
        </xsl:if>
      </ol>
    </nav>
  </xsl:template>
</xsl:stylesheet>
