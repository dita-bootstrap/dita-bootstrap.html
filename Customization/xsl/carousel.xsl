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
  <!-- Customization to add Bootstrap Carousel Component -->
  <!-- https://getbootstrap.com/docs/6.0/components/carousel/ -->

  <xsl:param name="BOOTSTRAP_CSS_CAROUSEL_INDICATORS" select="''"/>

  <xsl:template name="carousel-previous-next">
    <xsl:param name="id"/>
    <xsl:variable
      name="btn-style"
      select="
        if (tokenize(@theme, '-') = 'contrast' or tokenize(@outputclass, '\s+') = 'theme-contrast') then 'btn-outline'
        else 'btn-solid'"
    />
    <div class="ps-2 pb-2">
      <button type="button" data-bs-slide="prev">
        <xsl:attribute name="class" select="concat($btn-style, ' btn-icon btn-sm')"/>
        <xsl:attribute name="data-bs-target" select="concat('#' , $id)"/>
        <span class="carousel-icon-prev" aria-hidden="true"/>
        <span class="visually-hidden">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Previous'"/>
          </xsl:call-template>
        </span>
      </button>
      <button type="button" data-bs-slide="next">
        <xsl:attribute name="class" select="concat($btn-style, ' btn-icon btn-sm')"/>
        <xsl:attribute name="data-bs-target" select="concat('#' , $id)"/>
        <span class="carousel-icon-next" aria-hidden="true"/>
        <span class="visually-hidden">
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Next'"/>
          </xsl:call-template>
        </span>
      </button>
    </div>
  </xsl:template>

  <xsl:template name="carousel-indicators">
    <xsl:param name="id"/>

    <div class="carousel-indicators pe-2 pb-2">
      <xsl:for-each select="*[contains(@class, ' topic/li ')]">
        <button type="button">
          <xsl:attribute name="class">
            <xsl:value-of select="$BOOTSTRAP_CSS_CAROUSEL_INDICATORS"/>
            <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/li ')]) = 0">
              <xsl:text> active</xsl:text>
            </xsl:if>
          </xsl:attribute>
          <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/li ')]) = 0">
            <xsl:attribute name="aria-current" select="'true'"/>
          </xsl:if>
          <xsl:attribute name="data-bs-target" select="concat('#', $id)"/>
          <xsl:attribute name="data-bs-slide-to" select="count(preceding-sibling::*[contains(@class, ' topic/li ')])"/>
        </button>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/carousel ')] | *[ (contains(@class,' topic/ul ') or contains(@class, ' topic/ol ')) and contains(@outputclass, 'carousel')]"
  >
    <xsl:variable name="id">
      <xsl:value-of select="concat('carousel_' ,dita-ot:generate-html-id(.))"/>
    </xsl:variable>
    <div>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class">
          <xsl:text>card</xsl:text>
          <xsl:if test="@theme">
            <xsl:text> </xsl:text>
            <xsl:call-template name="theme-classes">
              <xsl:with-param name="value" select="@theme"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <div>
        <xsl:attribute name="class">
          <xsl:text>card-body p-0</xsl:text>
          <xsl:if test="not(*[contains(@class, ' topic/li ')]/*[contains(@class, ' topic/fig ')])">
            <xsl:text> pt-3</xsl:text>
          </xsl:if>
        </xsl:attribute>
        <div>
          <xsl:attribute name="class">
            <xsl:text>carousel slide w-100</xsl:text>
            <xsl:if test="@fade = 'yes'">
              <xsl:text> carousel-fade</xsl:text>
            </xsl:if>
            <xsl:if test="$BOOTSTRAP_CSS_CAROUSEL != ''">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$BOOTSTRAP_CSS_CAROUSEL"/>
            </xsl:if>
          </xsl:attribute>
          <!--xsl:choose>
            <xsl:when test="@autoplay = 'no' or contains(@otherprops, 'autoplay(false)')">
              <xsl:attribute name="data-bs-ride" select="'true'"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="data-bs-ride" select="'carousel'"/>
            </xsl:otherwise>
          </xsl:choose-->
          <xsl:if test="@touch = 'no' or contains(@otherprops, 'touch(false)')">
            <xsl:attribute name="data-bs-touch" select="'false'"/>
          </xsl:if>
          <xsl:if test="@interval">
            <xsl:attribute name="data-bs-interval" select="@interval"/>
          </xsl:if>
          <xsl:attribute name="id" select="$id"/>

          <div class="carousel-inner">
            <xsl:apply-templates mode="carousel"/>
          </div>
          <div class="d-flex justify-content-between align-items-center">
            <xsl:call-template name="carousel-previous-next">
              <xsl:with-param name="id" select="$id"/>
            </xsl:call-template>
            <xsl:if test="@indicators = 'yes' or contains(@otherprops, 'indicators(true)')">
              <xsl:call-template name="carousel-indicators">
                <xsl:with-param name="id" select="$id"/>
              </xsl:call-template>
            </xsl:if>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <!-- Carousel Items, Slides only -->
  <xsl:template match="*[contains(@class,' topic/li ')]" mode="carousel">
    <div>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class">
          <xsl:text>carousel-item</xsl:text>
          <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/li ')]) = 0">
            <xsl:text> active</xsl:text>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="@interval">
          <xsl:attribute name="data-bs-interval" select="@interval"/>
        </xsl:when>
        <xsl:when test="contains(@otherprops, 'interval(')">
          <xsl:call-template name="otherprops-interval"/>
        </xsl:when>
      </xsl:choose>
      <div class="container mx-0">
        <xsl:if test="*[contains(@class,' topic/fig ')] or *[contains(@class,' topic/image ')]">
          <div class="row">
            <xsl:apply-templates select="*[contains(@class,' topic/fig ')]" mode="carousel"/>
            <xsl:apply-templates select="*[contains(@class,' topic/image ')]" mode="carousel"/>
          </div>
        </xsl:if>
        <xsl:apply-templates
          select="* except (*[contains(@class,' topic/fig ')] | *[contains(@class,' topic/image ')])"
          mode="carousel"
        />
        <xsl:if test="../../*[@indicators = 'yes' or contains(@otherprops, 'indicators(true)')]">
          <div class="row py-3"/>
        </xsl:if>
      </div>
      <xsl:apply-templates
        select="*[contains(@class,' topic/fig ')]/*[contains(@class, ' topic/title ')]"
        mode="carousel"
      />
    </div>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/fig ')]" mode="carousel">
    <xsl:call-template name="topic.fig">
      <xsl:with-param name="suppress-title-label" select="true()" tunnel="yes"/>
    </xsl:call-template>
  </xsl:template>
    <!-- Suppress default title processing in carousel mode to avoid duplicate rendering -->
  <xsl:template match="*[contains(@class,' topic/title ')]" mode="carousel"/>

  <xsl:template match="*[contains(@class,' topic/image ')]" mode="carousel">
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
    <xsl:variable name="images" select="count(../*[contains(@class, ' topic/image ')])"/>
    <xsl:variable
      name="imageWidth"
      select="
        if ($images=1) then 'col-12'
        else if ($images=2) then 'col-6'
        else if ($images=3) then 'col-4'
        else 'col-3'"
    />

    <div>
      <xsl:attribute name="class" select="$imageWidth"/>
      <img>
        <xsl:call-template name="commonattributes">
          <xsl:with-param name="default-output-class" select="'d-block w-100'"/>
        </xsl:call-template>
        <xsl:call-template name="setid"/>
        <xsl:choose>
          <xsl:when test="*[contains(@class, ' topic/longdescref ')]">
            <xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="@longdescref"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="@href|@height|@width"/>
        <xsl:apply-templates select="@scale"/>
        <xsl:choose>
          <xsl:when test="*[contains(@class, ' topic/alt ')]">
            <xsl:variable name="alt-content">
              <xsl:apply-templates select="*[contains(@class, ' topic/alt ')]" mode="text-only"/>
            </xsl:variable>
            <xsl:attribute name="alt" select="normalize-space($alt-content)"/>
          </xsl:when>
          <xsl:when test="@alt">
            <xsl:attribute name="alt" select="@alt"/>
          </xsl:when>
        </xsl:choose>
      </img>
    </div>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/div ') or contains(@class,' topic/bodydiv ')]" mode="carousel">
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'row') or contains(@class, ' bootstrap-d/grid-row ')">
        <xsl:apply-templates select="."/>
      </xsl:when>
      <xsl:otherwise>
        <div class="row">
          <xsl:apply-templates select="."/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*" mode="carousel">
    <xsl:apply-templates select="."/>
  </xsl:template>

  <xsl:template name="otherprops-interval">
    <xsl:analyze-string select="@otherprops" regex="[a-z]*\([^\)]*\)">
      <xsl:matching-substring>
        <xsl:variable name="var">
          <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="attr">
          <xsl:value-of select="substring-before($var, '(')"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$attr='interval'">
            <xsl:attribute name="data-bs-interval" select="substring-before(substring-after($var, '('),')')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>
</xsl:stylesheet>
