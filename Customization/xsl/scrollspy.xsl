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
  <!-- Customization to add Bootstrap Scrollspy Component -->
  <!-- https://getbootstrap.com/docs/6.0/components/scrollspy/ -->

  <xsl:template name="scrollspy-content">
    <xsl:choose>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('list-group')">
        <div id="bs-scrollspy">
          <xsl:variable name="scrollspy-theme-classes">
            <xsl:if test="$BOOTSTRAP_THEME_SCROLLSPY != 'none'">
              <xsl:call-template name="theme-classes">
                <xsl:with-param name="value" select="$BOOTSTRAP_THEME_SCROLLSPY"/>
              </xsl:call-template>
              <xsl:if test="'border' = tokenize($BOOTSTRAP_THEME_SCROLLSPY, '-')">
                <xsl:text> p-2</xsl:text>
              </xsl:if>
            </xsl:if>
          </xsl:variable>
          <xsl:attribute name="class" select="normalize-space(concat('list-group me-3 ', $scrollspy-theme-classes))"/>
          <xsl:if test="$BOOTSTRAP_THEME_SCROLLSPY != 'none'">
            <xsl:attribute
              name="style"
            >background-color: color-mix(in srgb, var(--bs-theme-bg-muted, var(--bs-gray-100)) 10%, transparent);</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates mode="scrollspy"/>
        </div>
      </xsl:when>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('nav-pill')">
        <nav id="bs-scrollspy">
          <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'yes'">
            <xsl:attribute name="dir" select="'rtl'"/>
          </xsl:if>
          <xsl:variable name="scrollspy-theme-classes">
            <xsl:if test="$BOOTSTRAP_THEME_SCROLLSPY != 'none'">
              <xsl:call-template name="theme-classes">
                <xsl:with-param name="value" select="$BOOTSTRAP_THEME_SCROLLSPY"/>
              </xsl:call-template>
              <xsl:if test="'border' = tokenize($BOOTSTRAP_THEME_SCROLLSPY, '-')">
                <xsl:text> p-2</xsl:text>
              </xsl:if>
            </xsl:if>
          </xsl:variable>
          <xsl:attribute
            name="class"
            select="normalize-space(concat('nav nav-pills flex-column ', $scrollspy-theme-classes))"
          />
          <xsl:if test="$BOOTSTRAP_THEME_SCROLLSPY != 'none'">
            <xsl:attribute
              name="style"
            >background-color: color-mix(in srgb, var(--bs-theme-bg-muted, var(--bs-gray-100)) 10%, transparent);</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates mode="scrollspy"/>
        </nav>
      </xsl:when>
      <xsl:otherwise>
        <nav>
          <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'yes'">
            <xsl:attribute name="dir" select="'rtl'"/>
          </xsl:if>
          <xsl:if test="$BOOTSTRAP_THEME_SCROLLSPY != 'none'">
            <xsl:variable name="scrollspy-theme-classes">
              <xsl:call-template name="theme-classes">
                <xsl:with-param name="value" select="$BOOTSTRAP_THEME_SCROLLSPY"/>
              </xsl:call-template>
              <xsl:if test="'border' = tokenize($BOOTSTRAP_THEME_SCROLLSPY, '-')">
                <xsl:text> p-2</xsl:text>
              </xsl:if>
            </xsl:variable>
            <xsl:attribute name="class" select="normalize-space($scrollspy-theme-classes)"/>
            <xsl:attribute
              name="style"
            >background-color: color-mix(in srgb, var(--bs-theme-bg-muted, var(--bs-gray-100)) 10%, transparent);</xsl:attribute>
          </xsl:if>
          <ul>
            <xsl:apply-templates mode="scrollspy"/>
          </ul>
        </nav>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="scrollspy-href">
    <xsl:call-template name="scrollspy-href"/>
  </xsl:template>

  <xsl:template name="scrollspy-href">
    <xsl:attribute name="href">
      <xsl:text>#</xsl:text>
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:sequence select="dita-ot:generate-id(parent::*/@id, @id)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>ariaid-title</xsl:text>
          <xsl:number
            count="*[contains(@class, ' topic/title ')][parent::*[contains(@class,' topic/topic ')]]"
            level="any"
          />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="scrollspy">
    <xsl:choose>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('list-group')">
        <xsl:apply-templates mode="scrollspy"/>
      </xsl:when>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('nav-pill')">
        <nav class="nav nav-pills flex-column ps-3">
          <xsl:if test="$BOOTSTRAP_THEME_SCROLLSPY != 'none'">
            <xsl:attribute
              name="style"
            >background-color: color-mix(in srgb, var(--bs-theme-bg-muted, var(--bs-gray-100)) 10%, transparent);</xsl:attribute>
          </xsl:if>
          <xsl:apply-templates mode="scrollspy"/>
        </nav>
      </xsl:when>
      <xsl:otherwise>
        <ul>
          <xsl:apply-templates mode="scrollspy"/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/title ')]" mode="scrollspy">
    <xsl:choose>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('list-group')">
        <a class="list-group-item list-group-item-action">
          <xsl:call-template name="scrollspy-href"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('nav-pill')">
        <a class="ps-2 nav-link">
          <xsl:call-template name="scrollspy-href"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <a class="ps-2">
            <xsl:call-template name="scrollspy-href"/>
            <xsl:apply-templates/>
          </a>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/body ')]" mode="scrollspy">
    <xsl:if test="*[@id and (contains(@class, ' topic/section ') or contains(@class, ' topic/example '))]">
      <xsl:choose>
        <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('list-group')">
          <xsl:apply-templates mode="scrollspy"/>
        </xsl:when>
        <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('nav-pill')">
          <nav class="nav nav-pills flex-column ps-3">
            <xsl:if test="$BOOTSTRAP_THEME_SCROLLSPY != 'none'">
              <xsl:attribute
                name="style"
              >background-color: color-mix(in srgb, var(--bs-theme-bg-muted, var(--bs-gray-100)) 10%, transparent);</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="scrollspy"/>
          </nav>
        </xsl:when>
        <xsl:otherwise>
          <ul>
            <xsl:apply-templates mode="scrollspy"/>
          </ul>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/drawer ')] | *[contains(@class,' topic/section ') and contains(@outputclass, 'drawer-')]"
    mode="scrollspy"
    priority="5"
  />

  <xsl:template
    match="*[@id and ./*[contains(@class, ' topic/title ')] and (contains(@class, ' topic/section ') or contains(@class, ' topic/example '))]"
    mode="scrollspy"
  >
    <xsl:choose>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('list-group')">
        <a class="list-group-item list-group-item-action">
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:sequence select="dita-ot:generate-id(parent::*/parent::*/@id, @id)"/>
          </xsl:attribute>
          <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="scrollspy-section-title"/>
        </a>
      </xsl:when>
      <xsl:when test="$BOOTSTRAP_SCROLLSPY_TOC = ('nav-pill')">
        <a class="ps-2 nav-link">
          <xsl:attribute name="href">
            <xsl:text>#</xsl:text>
            <xsl:sequence select="dita-ot:generate-id(parent::*/parent::*/@id, @id)"/>
          </xsl:attribute>
          <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="scrollspy-section-title"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <a class="ps-2">
            <xsl:attribute name="href">
              <xsl:text>#</xsl:text>
              <xsl:sequence select="dita-ot:generate-id(parent::*/parent::*/@id, @id)"/>
            </xsl:attribute>
            <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="scrollspy-section-title"/>
          </a>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/title ')]" mode="scrollspy-section-title">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*" mode="scrollspy"/>
</xsl:stylesheet>
