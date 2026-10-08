<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="xs dita-ot"
>
  <xsl:param name="BOOTSTRAP_CSS_SHORTDESC" select="'text-body-secondary lead'"/>
  <xsl:param name="BOOTSTRAP_CSS_CODEBLOCK" select="'alert alert-secondary'"/>
  <xsl:param name="BOOTSTRAP_CSS_TOPIC_TITLE" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_SECTION_TITLE" select="'h4'"/>
  <xsl:param name="BOOTSTRAP_CSS_CARD_TITLE" select="'h5'"/>
  <xsl:param name="BOOTSTRAP_CSS_CARD" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_CARD_WIDTH" select="'w-50'"/>
  <xsl:param name="BOOTSTRAP_CSS_CAROUSEL" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_CAPTION" select="'alert alert-secondary p-1'"/>
  <xsl:param name="BOOTSTRAP_CSS_TABS" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABS_VERTICAL" select="'me-3'"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCORDION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCESSIBILITY_NAV" select="'bg-body-tertiary'"/>
  <xsl:param name="BOOTSTRAP_CSS_ACCESSIBILITY_LINK" select="'btn btn-outline-primary btn-sm'"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE" select="' w-100 mw-100 p-3 '"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE_CAPTION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_FIGURE_IMAGE" select="'img-fluid border rounded'"/>
  <xsl:param name="BOOTSTRAP_CSS_DL" select="'row'"/>
  <xsl:param name="BOOTSTRAP_CSS_DT" select="'text-truncate '"/>
  <xsl:param name="BOOTSTRAP_CSS_DD" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_PAGINATION" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABLE" select="''"/>
  <xsl:param name="BOOTSTRAP_CSS_TABLE_HEAD" select="''"/>

  <xsl:param name="BOOTSTRAP_ICON_TIP" select="'bi bi-lightbulb'"/>
  <xsl:param name="BOOTSTRAP_ICON_FASTPATH" select="'bi bi-shield-check'"/>
  <xsl:param name="BOOTSTRAP_ICON_REMEMBER" select="'bi bi-clipboard-check'"/>
  <xsl:param name="BOOTSTRAP_ICON_RESTRICTION" select="'bi bi-slash-circle'"/>
  <xsl:param name="BOOTSTRAP_ICON_IMPORTANT" select="'bi bi-exclamation-circle-fill'"/>
  <xsl:param name="BOOTSTRAP_ICON_ATTENTION" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_CAUTION" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_WARNING" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_TROUBLE" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_DANGER" select="'bi bi-exclamation-triangle'"/>
  <xsl:param name="BOOTSTRAP_ICON_NOTICE" select="'bi bi-info-circle-fill'"/>
  <xsl:param name="BOOTSTRAP_ICON_NOTE" select="'bi bi-pencil'"/>

  <!-- Add a Bootstrap CSS border to codeblocks -->
  <xsl:template match="*[contains(@class, ' topic/pre ')]" mode="get-output-class">
    <xsl:choose>
       <xsl:when test="@color">
          <xsl:text>alert alert-</xsl:text>
          <xsl:value-of select="@color"/>
       </xsl:when>
       <xsl:otherwise>
          <xsl:value-of select="$BOOTSTRAP_CSS_CODEBLOCK"/>
       </xsl:otherwise>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>



  <!-- Enhance the short desc with a Bootstrap CSS lead class -->
  <xsl:template match="*[contains(@class, ' topic/shortdesc ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_SHORTDESC"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS text color of the headers -->
  <xsl:template
    match="*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_TOPIC_TITLE"/>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
  >
    <xsl:value-of
      select="
        if (contains(@outputclass, 'h1')) then ''
        else if (contains(@outputclass, 'h2')) then ''
        else if (contains(@outputclass, 'h3')) then ''
        else if (contains(@outputclass, 'h4')) then ''
        else if (contains(@outputclass, 'h5')) then ''
        else if (contains(@outputclass, 'h6')) then ''
        else if (contains(@outputclass, 'display-')) then ''
        else ($BOOTSTRAP_CSS_SECTION_TITLE || ' ')"
    />
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/card ') or (contains(@class, ' topic/section ') and contains(@outputclass, 'card'))]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
    priority="10"
  >
    <xsl:value-of
      select="
        if (contains(@outputclass, 'h1')) then ''
        else if (contains(@outputclass, 'h2')) then ''
        else if (contains(@outputclass, 'h3')) then ''
        else if (contains(@outputclass, 'h4')) then ''
        else if (contains(@outputclass, 'h5')) then ''
        else if (contains(@outputclass, 'h6')) then ''
        else if (contains(@outputclass, 'display-')) then ''
        else ($BOOTSTRAP_CSS_CARD_TITLE || ' ')"
    />
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/card ') or (contains(@class,' topic/section ') and contains(@outputclass, 'card'))]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_CARD"/>
    <xsl:if test="not(@width or contains(@outputclass, 'w-'))">
       <xsl:text> </xsl:text>
       <xsl:value-of select="$BOOTSTRAP_CSS_CARD_WIDTH"/>
    </xsl:if>
    <xsl:if test="@color">
       <xsl:text> alert p-0 alert-</xsl:text>
       <xsl:value-of select="@color"/>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of carousel -->
  <xsl:template
    match="*[ (contains(@class,' topic/ul ') or contains(@class, ' topic/ol ')) and contains(@outputclass, 'carousel')]"
    mode="get-output-class"
  >
    <xsl:text>slide </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_CAROUSEL"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Amend the text and background of Figure Captions -->
  <xsl:template
    match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
    priority="5"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_CAPTION"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of tabs -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-tabs')]"
    mode="get-output-class"
  >
    <xsl:text>nav </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_TABS"/>
    <xsl:next-match/>
  </xsl:template>
  <!-- Change the default Bootstrap CSS classes of tab pills -->
  <xsl:template
    match="*[contains(@class,' topic/bodydiv ') and contains(@outputclass, 'nav-pills')]"
    mode="get-output-class"
  >
    <xsl:text>nav </xsl:text>
    <xsl:choose>
      <xsl:when test="contains(@outputclass, 'nav-pills-vertical')">
        <xsl:text>flex-column nav-pills </xsl:text>
        <xsl:value-of select="$BOOTSTRAP_CSS_TABS_VERTICAL"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$BOOTSTRAP_CSS_TABS"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of accordion -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/accordion ') or (contains(@class,' topic/bodydiv ') and contains(@outputclass, 'accordion'))]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_ACCORDION"/>
    <xsl:if test="@flush = 'yes'">
       <xsl:text> accordion-flush</xsl:text>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>


  <!-- Change the default Bootstrap CSS classes of grid rows -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/grid-row ')]" mode="bootstrap-class" priority="10">
    <xsl:text>row </xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of grid columns -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/grid-col ')]" mode="bootstrap-class" priority="10">
    <xsl:text>col</xsl:text>
    <xsl:if test="@breakpoint">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@breakpoint"/>
    </xsl:if>
    <xsl:if test="@colspan">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="@colspan"/>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS text color of the figure captions -->
  <xsl:template match="*[contains(@class, ' topic/figcaption ')]" mode="get-output-class">
    <xsl:text>figure-caption </xsl:text>
    <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE_CAPTION"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of pagination -->
  <xsl:template
    match="*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul ')) and contains(@outputclass, 'pagination')]"
    mode="get-output-class"
  >
    <xsl:value-of select="$BOOTSTRAP_CSS_PAGINATION"/>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class,' bootstrap-d/pagination ')]/*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul '))]"
    mode="get-output-class"
    priority="10"
  >
    <xsl:text>pagination </xsl:text>
    <xsl:variable name="size" select="ancestor::*[contains(@class,' bootstrap-d/pagination ')][1]/@size"/>
    <xsl:choose>
      <xsl:when test="$size = 'small'">pagination-sm </xsl:when>
      <xsl:when test="$size = 'large'">pagination-lg </xsl:when>
    </xsl:choose>
    <xsl:if test="not(ancestor::*[contains(@class,' bootstrap-d/pagination ')][1]/@outputclass = 'pagination')">
      <xsl:value-of select="ancestor::*[contains(@class,' bootstrap-d/pagination ')][1]/@outputclass"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:value-of select="$BOOTSTRAP_CSS_PAGINATION"/>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class,' topic/section ') and not(contains(@class, ' bootstrap-d/pagination ')) and contains(@outputclass, 'pagination')]/*[(contains(@class, ' topic/ol ') or contains(@class, ' topic/ul '))]"
    mode="get-output-class"
    priority="5"
  >
    <xsl:if test="ancestor::*[contains(@outputclass, 'pagination-')]">
      <xsl:text>pagination </xsl:text>
    </xsl:if>
    <xsl:value-of select="ancestor::*[contains(@outputclass, 'pagination')][1]/@outputclass"/>
    <xsl:value-of select="concat(' ', $BOOTSTRAP_CSS_PAGINATION)"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of alerts -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/alert ')]" mode="bootstrap-class" priority="10">
    <xsl:text>alert-</xsl:text>
    <xsl:value-of select="@color"/>
    <xsl:text> </xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of alert titles -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ')]/*[contains(@class, ' topic/title ')]"
    mode="bootstrap-class"
    priority="10"
  >
    <xsl:text>alert-heading </xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ')]//*[contains(@class, ' topic/xref ')]"
    mode="bootstrap-class"
    priority="10"
  >
    <xsl:text>alert-link </xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/note ')]//*[contains(@class, ' topic/xref ')]"
    mode="bootstrap-class"
    priority="10"
  >
    <xsl:text>alert-link </xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ')]/*[contains(@class, ' topic/title ')]"
    mode="get-output-class"
    priority="10"
  >
    <xsl:text>h4 </xsl:text> <!-- Default heading level for alerts -->
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of buttons -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/button ')]" mode="bootstrap-class" priority="10">
    <xsl:text>btn btn-</xsl:text>
    <xsl:if test="@outline = 'yes'">
       <xsl:text>outline-</xsl:text>
    </xsl:if>
    <xsl:value-of select="(@color, 'primary')[1]"/>
    <xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="@size = 'small'">btn-sm </xsl:when>
      <xsl:when test="@size = 'large'">btn-lg </xsl:when>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of badges -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/badge ')]" mode="bootstrap-class" priority="10">
    <xsl:text>text-bg-</xsl:text>
    <xsl:value-of select="(@color, 'primary')[1]"/>
    <xsl:text> </xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of cards -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/card ')]" mode="bootstrap-class" priority="10">
    <xsl:if test="@color">
      <xsl:text>alert alert-</xsl:text>
      <xsl:value-of select="@color"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of carousels -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/carousel ')]" mode="bootstrap-class" priority="10">
    <xsl:text>carousel slide </xsl:text>
    <xsl:if test="@fade = 'yes'">
       <xsl:text>carousel-fade </xsl:text>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of popovers -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/popover ')]" mode="bootstrap-class" priority="10">
    <xsl:if test="@position">
      <xsl:text>popover-</xsl:text>
      <xsl:value-of select="@position"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of tooltips -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/tooltip ')]" mode="bootstrap-class" priority="10">
    <xsl:if test="@position">
      <xsl:text>tooltip-</xsl:text>
      <xsl:value-of select="@position"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of offcanvas -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/offcanvas ')]" mode="bootstrap-class" priority="10">
    <xsl:choose>
      <xsl:when test="@breakpoint">
        <xsl:text>offcanvas-</xsl:text>
        <xsl:value-of select="@breakpoint"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>offcanvas </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="@position">
        <xsl:text>offcanvas-</xsl:text>
        <xsl:value-of select="@position"/>
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>offcanvas-start </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of list groups -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/list-group ')]" mode="bootstrap-class" priority="10">
    <xsl:text>list-group </xsl:text>
    <xsl:if test="@flush = 'yes'">
      <xsl:text>list-group-flush </xsl:text>
    </xsl:if>
    <xsl:if test="@compact = 'yes'">
      <xsl:text>list-group-compact </xsl:text>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/li ') and (ancestor::*[contains(@class, ' bootstrap-d/list-group ')] or ancestor::*[contains(@outputclass, 'list-group')])]"
    mode="get-output-class"
  >
    <xsl:variable
      name="parent-color"
      select="ancestor::*[contains(@class, ' bootstrap-d/list-group ') or contains(@outputclass, 'list-group')][1]/@color"
    />
    <xsl:text>list-group-item </xsl:text>
    <xsl:if test="$parent-color">
       <xsl:text>text-</xsl:text>
       <xsl:value-of select="$parent-color"/>
       <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of tabbed dialogs -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/tabbed-dialog ')]" mode="bootstrap-class" priority="10">
    <xsl:text>nav </xsl:text>
    <xsl:choose>
      <xsl:when test="@style = 'pills'">
        <xsl:text>nav-pills </xsl:text>
      </xsl:when>
      <xsl:when test="@style = 'vertical-pills'">
        <xsl:text>nav-pills nav-pills-vertical </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>nav-tabs </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>

  <!-- Change the default Bootstrap CSS classes of button groups -->
  <xsl:template match="*[contains(@class, ' bootstrap-d/button-group ')]" mode="bootstrap-class" priority="10">
    <xsl:choose>
      <xsl:when test="@vertical = 'yes'">
        <xsl:if test="not(contains(@outputclass, 'btn-group-vertical'))">
          <xsl:text>btn-group-vertical </xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group-vertical')"/>
      <xsl:when test="contains(@outputclass, 'btn-group')"/>
      <xsl:otherwise>
        <xsl:text>btn-group </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:next-match/>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes based on outputclass -->
  <xsl:template name="bootstrap-class">
    <xsl:apply-templates select="." mode="bootstrap-class"/>
    <xsl:apply-templates select="." mode="gen-user-bootstrap-class"/>
  </xsl:template>
  <xsl:template match="/ | @* | node()" mode="gen-user-bootstrap-class"/>

  <xsl:template match="/ | @* | node()" mode="bootstrap-class">
    <xsl:choose>
      <xsl:when test="contains(@class, ' topic/dt ')">
        <xsl:if test="empty(@outputclass)">
          <xsl:call-template name="bootstrap-dt"/>
        </xsl:if>
        <xsl:value-of select="$BOOTSTRAP_CSS_DT"/>
      </xsl:when>
      <xsl:when test="contains(@class, ' topic/dd ')">
        <xsl:if test="empty(@outputclass)">
          <xsl:call-template name="bootstrap-dd"/>
        </xsl:if>
        <xsl:value-of select="$BOOTSTRAP_CSS_DD"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="
            if (contains(@class, ' bootstrap-d/button ')) then ''
            else if (contains(@class, ' bootstrap-d/badge ')) then ''
            else if (contains(@class, ' bootstrap-d/carousel ')) then ''
            else if (contains(@class, ' bootstrap-d/button-group ')) then ''
            else if (contains(@class, ' bootstrap-d/list-group ')) then ''
            else if (contains(@class, ' bootstrap-d/tabbed-dialog ')) then ''
            else if (contains(@outputclass, 'btn-group-vertical')) then ''
            else if (contains(@outputclass, 'btn-group')) then ''
            else if (contains(@outputclass, 'btn-toolbar')) then ''
            else if (contains(@outputclass, 'accordion-')) then 'accordion'
            else if (contains(@outputclass, 'btn-')) then 'btn'
            else if (contains(@outputclass, 'collapse-')) then 'collapse'
            else if (contains(@outputclass, 'alert-')) then 'alert'
            else if (contains(@outputclass, 'list-group-')) then 'list-group'
            else if (contains(@class, ' topic/fig ')) then ' figure ' || $BOOTSTRAP_CSS_FIGURE
            else if (contains(@class, ' topic/lq ')) then ' blockquote '
            else if (contains(@class, ' topic/dl ')) then $BOOTSTRAP_CSS_DL
            else if (contains(@class, ' topic/image ') and ancestor::*[contains(@class, ' topic/fig ')]) then '  figure-img ' || $BOOTSTRAP_CSS_FIGURE_IMAGE
            else if (contains(@outputclass, 'carousel-')) then 'carousel'
            else if (contains(@class, ' topic/title ') and ancestor::*[contains(@outputclass, 'alert-')]) then 'alert-heading'
            else if (contains(@class, ' topic/xref ') and ancestor::*[contains(@outputclass, 'alert-')]) then 'alert-link'
            else if (contains(@class, ' topic/li ') and (ancestor::*[contains(@class, ' bootstrap-d/list-group ')] or ancestor::ul[contains(@outputclass, 'list-group')] or ancestor::ol[contains(@outputclass, 'list-group')])) then 'list-group-item'
            else if (contains(@class, ' topic/li ') and (ancestor::ul[contains(@outputclass, 'list-inline')] or ancestor::ol[contains(@outputclass, 'list-inline')])) then 'list-inline-item'
            else if (contains(@outputclass, 'pagination-')) then 'pagination'
            else if (contains(@class, ' topic/li ') and (ancestor::*[contains(@class, ' bootstrap-d/pagination ')] or ancestor::*[contains(@outputclass, 'pagination')])) then 'page-item'
            else if (contains(@class, ' topic/xref ') and (ancestor::*[contains(@class, ' bootstrap-d/pagination ')] or ancestor::*[contains(@outputclass, 'pagination')])) then 'page-link'
            else ''"
        />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="(@scalefit='yes')">
      <xsl:text> img-fluid</xsl:text>
    </xsl:if>
    <xsl:if test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
      <xsl:value-of
        select="
          if (contains(@class,' hi-d/i ') and contains(@outputclass, 'bi-')) then 'bi'
          else if (contains(@class, ' topic/xref ') and .//*[contains(@class,' hi-d/i ') and contains(@outputclass, 'bi-')]) then 'icon-link'
          else ''"
      />
    </xsl:if>
    <xsl:if test="ancestor::*[contains(@class, ' topic/dt ')]">
      <xsl:call-template name="bootstrap-dt-word-wrap"/>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <dd> elements -->
  <xsl:template name="bootstrap-dd">
    <xsl:variable name="terms" select="count(../*[contains(@class, ' topic/dt ')])"/>
    <xsl:variable name="is-first-dd" select="empty(preceding-sibling::*[contains(@class, ' topic/dd ')])"/>
    <xsl:choose>
      <xsl:when test="not($is-first-dd)">
        <xsl:text>col-lg-12 </xsl:text>
      </xsl:when>
      <xsl:when test="$terms=1">
        <xsl:variable name="dl" select="../../."/>
        <xsl:variable name="colspan">
          <xsl:choose>
            <xsl:when test="$dl/@colspan">
               <xsl:value-of select="$dl/@colspan"/>
            </xsl:when>
            <xsl:when test="contains($dl/@otherprops, 'cols(')">
               <xsl:value-of select="substring-before(substring-after($dl/@otherprops, 'cols('), ')')"/>
            </xsl:when>
            <xsl:otherwise>3</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat('col-lg-', 12 - xs:integer($colspan), ' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="
            if ($terms=2) then 'col-lg-6 '
            else if ($terms=3) then 'col-lg-3 '
            else if ($terms=4) then 'col-lg-2 '
            else ''"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <dt> elements -->
  <xsl:template name="bootstrap-dt">
    <xsl:variable name="terms" select="count(../*[contains(@class, ' topic/dt ')])"/>
    <xsl:choose>
      <xsl:when test="$terms=1">
        <xsl:variable name="dl" select="../../."/>
        <xsl:variable name="colspan">
          <xsl:choose>
            <xsl:when test="$dl/@colspan">
               <xsl:value-of select="$dl/@colspan"/>
            </xsl:when>
            <xsl:when test="contains($dl/@otherprops, 'cols(')">
               <xsl:value-of select="substring-before(substring-after($dl/@otherprops, 'cols('), ')')"/>
            </xsl:when>
            <xsl:otherwise>3</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat('col-lg-', $colspan, ' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of
          select="
            if ($terms=2) then 'col-lg-3 '
            else if ($terms=3) then 'col-lg-3 '
            else if ($terms=4) then 'col-lg-2 '
            else ''"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes to software elements -->
  <xsl:template name="bootstrap-dt-word-wrap">
    <xsl:value-of
      select="
        if (contains(@class,' pr-d/')) then ' text-wrap'
        else if (contains(@class,' sw-d/')) then ' text-wrap'
        else if (contains(@class,' xml-d/')) then ' text-wrap'
        else ''"
    />
  </xsl:template>

  <!-- Add additional Bootstrap CSS classes and roles to <note> elements -->
  <xsl:template name="bootstrap-note">
    <xsl:text>alert </xsl:text>
    <xsl:choose>
       <xsl:when test="@color">
          <xsl:text>alert-</xsl:text>
          <xsl:value-of select="@color"/>
       </xsl:when>
       <xsl:otherwise>
          <xsl:value-of
          select="
              if (@type='tip') then 'alert-success'
              else if (@type='fastpath') then 'alert-success'
              else if (@type='remember') then 'alert-success'
              else if (@type='restriction') then 'alert-warning'
              else if (@type='important') then 'alert-warning'
              else if (@type='attention') then 'alert-warning'
              else if (@type='caution') then 'alert-warning'
              else if (@type='warning') then 'alert-warning'
              else if (@type='trouble') then 'alert-warning'
              else if (@type='danger') then 'alert-danger'
              else if (@type='notice') then 'alert-info'
              else if (@type='note' or (contains(@class, ' topic/note ') and not(contains(@class, ' bootstrap-d/alert ')) and not(contains(@class, ' topic/section ')) and empty(@type))) then 'alert-primary'
              else if (@type='other') then 'alert-dark'
              else 'alert-info'"
        />
       </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add style to a bootstrap element based on otherprops -->
  <xsl:template name="otherprops-attributes">
    <xsl:apply-templates select="." mode="otherprops-attributes"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/note ')]" mode="otherprops-attributes">
    <xsl:if test="@icon">
      <xsl:attribute name="class" select="concat('pe-2 ', @icon)"/>
    </xsl:if>
    <xsl:if test="@style">
      <xsl:attribute name="style" select="@style"/>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <!-- Process decorations (color, border, rounded, width) on any element -->
  <!-- Process spacing and shadow decorations on any element -->
  <xsl:template match="*[@margin or @padding or @shadow]" mode="get-output-class" priority="-1">
    <xsl:variable
      name="margin"
      select="(@margin, (if (@shadow and @shadow != 'no' and @shadow != 'none' and not(contains(@outputclass, 'm-'))) then '3' else ()))[1]"
    />
    <xsl:for-each select="tokenize(normalize-space($margin), '\s+')">
      <xsl:choose>
        <xsl:when test="matches(., '^[etbsxy]([n-]?\d+|auto)$')">
          <xsl:value-of select="concat('m', substring(., 1, 1), '-', translate(substring(., 2), '-', 'n'))"/>
        </xsl:when>
        <xsl:when test="contains(., '-')">
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('m-', .)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> </xsl:text>
    </xsl:for-each>
    <xsl:if
      test="@padding and not(contains(@class, ' topic/note ') or 
                                   contains(@class, ' topic/pre ') or 
                                   contains(@class, ' bootstrap-d/card ') or 
                                   contains(@class, ' bootstrap-d/alert '))"
    >
      <xsl:for-each select="tokenize(normalize-space(@padding), '\s+')">
        <xsl:choose>
          <xsl:when test="matches(., '^[etbsxy](\d+|auto)$')">
            <xsl:value-of select="concat('p', substring(., 1, 1), '-', substring(., 2))"/>
          </xsl:when>
          <xsl:when test="contains(., '-')">
            <xsl:value-of select="."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat('p-', .)"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="@shadow">
       <xsl:choose>
          <xsl:when test="@shadow='yes'">
             <xsl:text>shadow </xsl:text>
          </xsl:when>
          <xsl:when test="@shadow='no' or @shadow='none'">
             <xsl:text>shadow-none </xsl:text>
          </xsl:when>
          <xsl:otherwise>
             <xsl:text>shadow-</xsl:text>
             <xsl:value-of select="@shadow"/>
             <xsl:text> </xsl:text>
          </xsl:otherwise>
       </xsl:choose>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <!-- Add a Bootstrap Link CSS color to xrefs and links -->
  <xsl:template
    match="*[contains(@class, ' topic/xref ') or contains(@class, ' topic/link ')][@color][not(contains(@class, ' bootstrap-d/button '))][not(contains(@outputclass, 'btn-'))]"
    mode="get-output-class"
  >
    <xsl:text>link-</xsl:text>
    <xsl:value-of select="@color"/>
    <xsl:text> </xsl:text>
    <xsl:next-match/>
  </xsl:template>

  <!-- Process decorations (color, border, rounded, width) on any element -->
  <xsl:template
    match="*[@color or @border or @bordercolor or @rounded or @width]"
    mode="get-output-class"
    priority="-2"
  >
    <xsl:if
      test="@color and not(contains(@class, ' topic/note ') or 
                                 contains(@class, ' topic/pre ') or 
                                 contains(@class, ' topic/xref ') or 
                                 contains(@class, ' topic/link ') or 
                                 contains(@class, ' bootstrap-d/card ') or 
                                 contains(@class, ' bootstrap-d/alert ') or
                                 contains(@class, ' bootstrap-d/badge ') or
                                 contains(@class, ' bootstrap-d/list-group ') or
                                 contains(@class, ' bootstrap-d/carousel ') or
                                 contains(@class, ' bootstrap-d/button ') or
                                 contains(@class, ' topic/table ') or
                                 contains(@class, ' topic/thead ') or
                                 contains(@class, ' topic/tbody ') or
                                 contains(@class, ' topic/tfoot ') or
                                 contains(@class, ' topic/row ') or
                                 contains(@class, ' topic/entry '))"
    >
       <xsl:text>text-bg-</xsl:text>
       <xsl:value-of select="@color"/>
       <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:if test="@border or @bordercolor">
       <xsl:choose>
          <xsl:when test="@border='no'">
             <xsl:text>border-0 </xsl:text>
          </xsl:when>
          <xsl:otherwise>
             <xsl:if test="empty(@border) or @border='yes' or matches(@border, '^\d+$') or @bordercolor">
                <xsl:text>border </xsl:text>
             </xsl:if>
             <xsl:if test="@border and @border != 'yes'">
                <xsl:text>border-</xsl:text>
                <xsl:value-of select="@border"/>
                <xsl:text> </xsl:text>
             </xsl:if>
             <xsl:if test="@bordercolor">
                <xsl:text>border-</xsl:text>
                <xsl:value-of select="@bordercolor"/>
                <xsl:text> </xsl:text>
             </xsl:if>
          </xsl:otherwise>
       </xsl:choose>
    </xsl:if>
    <xsl:if test="@rounded">
       <xsl:choose>
          <xsl:when test="@rounded='yes'">
             <xsl:text>rounded </xsl:text>
          </xsl:when>
          <xsl:when test="@rounded='no' or @rounded='0'">
             <xsl:text>rounded-0 </xsl:text>
          </xsl:when>
          <xsl:otherwise>
             <xsl:text>rounded-</xsl:text>
             <xsl:value-of select="@rounded"/>
             <xsl:text> </xsl:text>
          </xsl:otherwise>
       </xsl:choose>
    </xsl:if>
    <xsl:if test="@width">
       <xsl:text>w-</xsl:text>
       <xsl:value-of select="@width"/>
       <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="/ | @* | node()" mode="otherprops-attributes">
    <xsl:analyze-string select="@otherprops" regex="[A-Za-z0-9_\-]*\([^\)]*\)">
      <xsl:matching-substring>
        <xsl:variable name="var">
          <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:variable name="attr">
          <xsl:value-of select="substring-before($var, '(')"/>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$attr='icon'">
            <xsl:attribute name="class" select="concat('pe-2 ', substring-before(substring-after($var, '('),')'))"/>
          </xsl:when>
          <xsl:when test="$attr='media'">
            <xsl:attribute
              name="media"
              select="concat('(', concat( substring-before(substring-after($var, '('),')'), ')'))"
            />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="{$attr}" select="substring-before(substring-after($var, '('),')')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <!-- Add icons to <note> elements -->
  <xsl:template name="bootstrap-icon">
    <xsl:variable name="icon">
      <xsl:value-of
        select="
          if (@icon or contains(@otherprops, 'icon(') or *[contains(@class, ' topic/title ')]/*[contains(@class, ' bootstrap-d/icon ')]) then ''
          else if (@type='tip') then $BOOTSTRAP_ICON_TIP
          else if (@type='fastpath') then $BOOTSTRAP_ICON_FASTPATH
          else if (@type='remember') then $BOOTSTRAP_ICON_REMEMBER
          else if (@type='restriction') then $BOOTSTRAP_ICON_RESTRICTION
          else if (@type='important') then $BOOTSTRAP_ICON_IMPORTANT
          else if (@type='attention') then $BOOTSTRAP_ICON_ATTENTION
          else if (@type='caution') then $BOOTSTRAP_ICON_CAUTION
          else if (@type='warning') then $BOOTSTRAP_ICON_WARNING
          else if (@type='trouble') then $BOOTSTRAP_ICON_TROUBLE
          else if (@type='danger') then $BOOTSTRAP_ICON_DANGER
          else if (@type='notice') then $BOOTSTRAP_ICON_NOTICE
          else if (@type='note' or (contains(@class, ' topic/note ') and not(contains(@class, ' bootstrap-d/alert ')) and not(contains(@class, ' topic/section ')) and empty(@type))) then $BOOTSTRAP_ICON_NOTE
          else ''"
      />
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="@icon or contains(@otherprops, 'icon(')">
        <xsl:element name="i">
          <xsl:choose>
            <xsl:when test="@icon">
               <xsl:attribute name="class" select="concat('pe-2 ', @icon)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="otherprops-attributes"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="@style">
            <xsl:attribute name="style" select="@style"/>
          </xsl:if>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$icon != '' or (contains(@class, ' bootstrap-d/icon ') and @outputclass)">
        <xsl:element name="i">
          <xsl:attribute name="class" select="concat('pe-2 ', $icon, ' ', @outputclass)"/>
          <xsl:if test="contains(@otherprops, 'style(')">
            <xsl:call-template name="otherprops-attributes"/>
          </xsl:if>
          <xsl:if test="@style">
            <xsl:attribute name="style" select="@style"/>
          </xsl:if>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' bootstrap-d/icon ')]">
    <xsl:call-template name="bootstrap-icon"/>
  </xsl:template>

  <!-- add role attributes based on outputclass -->
  <xsl:template name="bootstrap-role">
    <xsl:choose>
      <xsl:when test="contains(@class, ' bootstrap-d/button ')">
        <xsl:attribute name="role" select="'button'"/>
      </xsl:when>
      <xsl:when test="contains(@class, ' bootstrap-d/button-group ')">
        <xsl:attribute name="role" select="'group'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'alert-')">
        <xsl:attribute name="role" select="'alert'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group-vertical')">
        <xsl:attribute name="role" select="'group'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-group')">
        <xsl:attribute name="role" select="'group'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-toolbar')">
        <xsl:attribute name="role" select="'toolbar'"/>
      </xsl:when>
      <xsl:when test="contains(@outputclass, 'btn-')">
        <xsl:attribute name="role" select="'button'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- 
    The default set-output-class for a class of elements may be passed in with $default, 
    but that default can be overridden with mode="get-output-class". 
    In DITA Bootstrap we want these to be additive.
  -->
  <xsl:template match="*" mode="set-output-class" priority="10">
    <xsl:param name="default"/>
    <xsl:variable name="output-class">
      <xsl:apply-templates select="." mode="get-output-class"/>
    </xsl:variable>

    <xsl:variable name="using-output-class" as="xs:string*">
       <xsl:sequence select="tokenize(normalize-space($output-class), '\s+')"/>
       <xsl:sequence select="tokenize(normalize-space($default), '\s+')"/>
    </xsl:variable>


    <xsl:variable name="ancestry" as="xs:string?">
      <xsl:if test="$PRESERVE-DITA-CLASS = 'yes'">
        <xsl:choose>
          <xsl:when test="contains(@class, ' topic/row ')">
            <!-- Suppress 'row' class on <tr> to avoid Bootstrap grid conflict -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of>
              <xsl:apply-templates select="." mode="get-element-ancestry"/>
            </xsl:value-of>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="outputclass-attribute" as="xs:string">
      <xsl:value-of>
        <xsl:apply-templates select="@outputclass" mode="get-value-for-class"/>
      </xsl:value-of>
    </xsl:variable>

    <xsl:variable
      name="classes"
      as="xs:string*"
      select="tokenize($ancestry, '\s+'),
                          $using-output-class,
                          tokenize($outputclass-attribute, '\s+')"
    />
    <xsl:if test="exists($classes)">
      <xsl:attribute name="class" select="distinct-values($classes)[. != 'tooltip' and . != 'popover']" separator=" "/>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
