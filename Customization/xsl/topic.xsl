<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  version="2.0"
  exclude-result-prefixes="xs dita-ot dita2html"
>
  <xsl:param name="defaultLanguage" select="'en'" as="xs:string"/>
  <xsl:param name="BIDIRECTIONAL_DOCUMENT" select="'no'" as="xs:string"/>
  <xsl:param name="BOOTSTRAP_THEME_FOOTER" select="'none'"/>
  <xsl:param name="BOOTSTRAP_THEME_HEADER" select="'primary-contrast'"/>
  <xsl:param name="BOOTSTRAP_THEME_SIDEBAR" select="'none'"/>
  <xsl:param name="BOOTSTRAP_THEME_TOPBAR" select="'none'"/>
  <xsl:param name="BOOTSTRAP_THEME_CONTENT" select="'none'"/>
  <xsl:param name="BOOTSTRAP_THEME_BODY" select="'none'"/>
  <xsl:param name="BOOTSTRAP_THEME_SCROLLSPY" select="'none'"/>
  <xsl:param name="BOOTSTRAP_TOPBAR_HDR"/>

  <!-- Splits a hyphenated theme value (e.g. 'warning-subtle-border') into
       prefixed classes. $prefix (default 'theme') applies to the first
       token (the color, e.g. 'theme-warning'); $suffix-prefix (default
       'theme') applies to every token after it (e.g. 'theme-subtle
       theme-border'). Pass a component-specific $suffix-prefix (e.g.
       'badge', 'btn', 'table') when that component has its own scoped
       modifier classes instead of the generic 'theme-{suffix}' ones.
       'none' returns ''. -->
  <xsl:template name="theme-classes">
    <xsl:param name="value" as="xs:string"/>
    <xsl:param name="prefix" select="'theme'" as="xs:string"/>
    <xsl:param name="suffix-prefix" select="'theme'" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$value = 'none'">
        <xsl:sequence select="''"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="parts" select="tokenize($value, '-')" as="xs:string*"/>
        <xsl:sequence
          select="
            string-join(
              (concat($prefix, '-', $parts[1]),
               for $part in $parts[position() > 1] return concat($suffix-prefix, '-', $part)),
              ' ')"
        />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--Check the file Url Definition of the TOP HDR FTR-->
  <xsl:variable name="TOPHDFFILE">
    <xsl:choose>
      <xsl:when test="not($BOOTSTRAP_TOPBAR_HDR)"/> <!-- If no filterfile leave empty -->
      <xsl:when test="starts-with($BOOTSTRAP_TOPBAR_HDR, 'file:')">
        <xsl:value-of select="$BOOTSTRAP_TOPBAR_HDR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="starts-with($BOOTSTRAP_TOPBAR_HDR, '/')">
            <xsl:text>file://</xsl:text><xsl:value-of select="$BOOTSTRAP_TOPBAR_HDR"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>file:/</xsl:text><xsl:value-of select="$BOOTSTRAP_TOPBAR_HDR"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="defaultDirection">
    <xsl:apply-templates select="." mode="get-render-direction">
      <xsl:with-param name="lang" select="$defaultLanguage"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!-- Define a $newline variable that inserts a Unicode line feed character -->
  <xsl:variable name="newline" select="'&#xa;'" as="xs:string"/>

  <xsl:template name="bidi-auto-code">
    <!-- ↓ Ensure code is rendered LTR in RTL documents ↓ -->
    <xsl:if test="$BIDIRECTIONAL_DOCUMENT='yes' and not(@dir)">
      <xsl:choose>
        <xsl:when test="contains(@class,' pr-d/')">
          <xsl:attribute name="dir">auto</xsl:attribute>
        </xsl:when>
        <xsl:when test="contains(@class,' sw-d/')">
          <xsl:attribute name="dir">auto</xsl:attribute>
        </xsl:when>
        <xsl:when test="contains(@class,' xml-d/')">
          <xsl:attribute name="dir">auto</xsl:attribute>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- Customized templates from `org.dita.html5/xsl/topic.xsl` -->

  <xsl:template name="chapter-setup">
    <html>
      <!-- ↓ Add check for bi-directional content ↓ -->
      <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'no'">
        <xsl:call-template name="setTopicLanguage"/>
      </xsl:if>
      <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'yes'">
        <xsl:attribute name="dir" select="$defaultDirection"/>
        <xsl:attribute name="lang" select="$defaultLanguage"/>
      </xsl:if>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="chapterHead"/>
      <xsl:call-template name="chapterBody"/>
    </html>
  </xsl:template>

  <!-- Process <body> content that is appropriate for HTML5 header section. -->
  <xsl:template match="*" mode="addHeaderToHtmlBodyElement">
    <xsl:variable name="header-content" as="node()*">
      <xsl:call-template name="generateBreadcrumbs"/>
      <xsl:call-template name="gen-user-header"/>  <!-- include user's XSL running header here -->
      <xsl:call-template name="processHDR"/>
      <xsl:if test="$INDEXSHOW = 'yes'">
        <xsl:apply-templates
          select="/*/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/metadata ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')] |
                                     /dita/*[1]/*[contains(@class, ' topic/prolog ')]/*[contains(@class, ' topic/metadata ')]/*[contains(@class, ' topic/keywords ')]/*[contains(@class, ' topic/indexterm ')]"
        />
      </xsl:if>
    </xsl:variable>

    <!-- ↓ Add collapsible top header ↓ -->
    <xsl:if test="string-length($TOPHDFFILE) > 0">
      <div>
        <xsl:variable name="topbar-theme-classes">
          <xsl:call-template name="theme-classes">
            <xsl:with-param name="value" select="$BOOTSTRAP_THEME_TOPBAR"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:attribute name="class" select="concat('d-none lg:d-block ', $topbar-theme-classes)"/>
        <xsl:copy-of select="document($TOPHDFFILE, /)"/>
      </div>
    </xsl:if>
    <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->

    <xsl:if test="exists($header-content)">
      <header xsl:use-attribute-sets="banner">
        <!-- ↓ Add Bootstrap class attributes template ↓ -->
        <xsl:variable name="header-theme-classes">
          <xsl:call-template name="theme-classes">
            <xsl:with-param name="value" select="$BOOTSTRAP_THEME_HEADER"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:attribute
          name="class"
          select="concat('navbar lg:navbar-expand bd-navbar border-bottom border-inverse border-20 sticky-top ', $header-theme-classes)"
        />
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:sequence select="$header-content"/>
      </header>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="addContentToHtmlBodyElement">
    <main xsl:use-attribute-sets="main">
      <!-- ↓ Override to add scrollspy ↓ -->
      <xsl:if test="$BOOTSTRAP_SCROLLSPY_TOC != 'none'">
        <xsl:choose>
          <xsl:when test="count(*[contains(@class, ' topic/topic ')])&gt;0">
            <xsl:attribute name="data-bs-spy">scroll</xsl:attribute>
            <xsl:attribute name="data-bs-target">#bs-scrollspy</xsl:attribute>
            <xsl:attribute name="data-bs-offset">0</xsl:attribute>
          </xsl:when>
          <xsl:when
            test="count(*/*[@id and (contains(@class, ' topic/section ') or contains(@class, ' topic/example '))])&gt;0"
          >
            <xsl:attribute name="data-bs-spy">scroll</xsl:attribute>
            <xsl:attribute name="data-bs-target">#bs-scrollspy</xsl:attribute>
            <xsl:attribute name="data-bs-offset">0</xsl:attribute>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->

      <article role="article" class="bs-content">
        <!-- ↓ Add check for bi-directional content ↓ -->
        <xsl:if test="$BIDIRECTIONAL_DOCUMENT = 'yes'">
          <xsl:variable name="direction">
            <xsl:apply-templates select="." mode="get-render-direction">
              <xsl:with-param name="lang" select="dita-ot:get-current-language(.)"/>
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:attribute name="dir" select="$direction"/>
          <xsl:attribute name="lang" select="dita-ot:get-current-language(.)"/>
        </xsl:if>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:attribute name="aria-labelledby">
          <xsl:apply-templates
            select="*[contains(@class,' topic/title ')] |
                                       self::dita/*[1]/*[contains(@class,' topic/title ')]"
            mode="return-aria-label-id"
          />
        </xsl:attribute>
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
        <!-- ↓ Add Bootstrap breadcrumb ↓ -->
        <xsl:if test="$BREADCRUMBS = 'yes'">
          <xsl:apply-templates select="$current-topicref" mode="gen-user-breadcrumb"/>
        </xsl:if>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:apply-templates/> <!-- this will include all things within topic; therefore, -->
                               <!-- title content will appear here by fall-through -->
                               <!-- followed by prolog (but no fall-through is permitted for it) -->
                               <!-- followed by body content, again by fall-through in document order -->
                               <!-- followed by related links -->
                               <!-- followed by child topics by fall-through -->
        <xsl:call-template name="gen-endnotes"/>    <!-- include footnote-endnotes -->
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
      </article>
      <xsl:if test="$BOOTSTRAP_SCROLLSPY_TOC != 'none'">
        <xsl:choose>
          <xsl:when test="count(*[contains(@class, ' topic/topic ')])&gt;0">
            <div class="bs-scrollspy mt-3 mb-5 lg:my-0 lg:mb-5 sm:px-1 fg-2">
              <xsl:call-template name="scrollspy-content"/>
            </div>
          </xsl:when>
          <xsl:when
            test="count(*/*[@id and (contains(@class, ' topic/section ') or contains(@class, ' topic/example '))])&gt;0"
          >
            <div class="bs-scrollspy mt-3 mb-5 lg:my-0 lg:mb-5 sm:px-1 fg-2">
              <xsl:call-template name="scrollspy-content"/>
            </div>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </main>
  </xsl:template>

  <xsl:template match="*" mode="addAttributesToBody" priority="5.0">
    <xsl:variable name="body-theme-classes">
      <xsl:call-template name="theme-classes">
        <xsl:with-param name="value" select="$BOOTSTRAP_THEME_BODY"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:attribute name="class">
      <xsl:text>d-flex flex-column min-vh-100</xsl:text>
      <xsl:if test="*[contains(@class, ' topic/body ')]/@outputclass">
        <xsl:text> </xsl:text>
        <xsl:value-of select="*[contains(@class, ' topic/body ')]/@outputclass"/>
      </xsl:if>
      <xsl:if test="self::dita">
        <xsl:if test="*[contains(@class, ' topic/body ')]/*[contains(@class, ' topic/topic ')][1]/@outputclass">
          <xsl:text> </xsl:text>
          <xsl:value-of
            select="*[contains(@class, ' topic/body ')]/*[contains(@class, ' topic/topic ')][1]/@outputclass"
          />
        </xsl:if>
      </xsl:if>
      <xsl:if test="$body-theme-classes != ''">
        <xsl:value-of select="concat(' ', $body-theme-classes)"/>
      </xsl:if>
    </xsl:attribute>
    <xsl:if test="$BOOTSTRAP_THEME_BODY != 'none' and count(tokenize($BOOTSTRAP_THEME_BODY, '-')) = 1">
      <xsl:attribute
        name="style"
      >background-color: color-mix(in srgb, var(--bs-theme-bg-muted, var(--bs-gray-100)) 10%, transparent);</xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- Override to add Bootstrap classes and roles -->
  <xsl:template match="@* | node()" mode="commonattributes">
    <xsl:param name="default-output-class" as="xs:string*"/>
    <xsl:apply-templates select="@xml:lang"/>
    <xsl:apply-templates select="@dir"/>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style" mode="add-ditaval-style"/>
    <!-- ↓ Add Bootstrap role template ↓ -->
    <xsl:call-template name="bootstrap-role"/>
    <!-- ↓ Set Bidi to auto for code ↓ -->
    <xsl:call-template name="bidi-auto-code"/>
    <!-- ↓ Add Bootstrap class attributes template ↓ -->
    <xsl:variable name="bootstrap-class">
      <xsl:call-template name="bootstrap-class"/>
      <xsl:value-of select="$default-output-class"/>
    </xsl:variable>
    <!-- ↓ Remove DITA-OT styling from titles since Bootstrap does this ↓ -->
    <xsl:choose>
      <xsl:when test="starts-with($default-output-class[1] , 'topictitle')">
        <xsl:apply-templates select="." mode="set-output-class">
          <xsl:with-param name="default" select="replace($bootstrap-class, 'topictitle\d+', '')"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="starts-with($default-output-class[1] , 'sectiontitle')">
        <xsl:apply-templates select="." mode="set-output-class">
          <xsl:with-param name="default" select="replace($bootstrap-class, 'sectiontitle', '')"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="set-output-class">
          <xsl:with-param name="default" select="$bootstrap-class"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="gen-user-bootstrap-attrs"/>
    <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
    <xsl:choose>
      <xsl:when test="exists($passthrough-attrs[empty(@att) and empty(@value)])">
        <xsl:variable name="specializations" as="xs:string*">
          <xsl:for-each select="ancestor-or-self::*[@domains][1]/@domains">
            <xsl:analyze-string select="normalize-space(.)" regex="a\(props (.+?)\)">
              <xsl:matching-substring>
                <xsl:sequence select="tokenize(regex-group(1), '\s+')"/>
              </xsl:matching-substring>
            </xsl:analyze-string>
          </xsl:for-each>
        </xsl:variable>
        <xsl:for-each
          select="@props |
                              @audience |
                              @platform |
                              @product |
                              @otherprops |
                              @deliveryTarget |
                              @*[local-name() = $specializations]"
        >
          <xsl:attribute name="data-{name()}" select="."/>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="exists($passthrough-attrs)">
        <xsl:for-each select="@*">
          <xsl:if
            test="$passthrough-attrs[@att = name(current()) and (empty(@val) or (some $v in tokenize(current(), '\s+') satisfies $v = @val))]"
          >
            <xsl:attribute name="data-{name()}" select="."/>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="gen-user-bootstrap-attrs">
    <xsl:apply-templates select="." mode="gen-user-bootstrap-attrs"/>
  </xsl:template>

  <xsl:template match="/ | @* | node()" mode="gen-user-bootstrap-attrs" priority="-10"/>

  <!-- Override to add Bootstrap Alert classes and roles to Note elements -->
  <!-- https://getbootstrap.com/docs/6.0/components/alerts/ -->
  <xsl:template match="*" mode="process.note.common-processing">
    <xsl:param name="type" select="@type"/>
    <xsl:param name="title">
      <xsl:call-template name="getVariable">
        <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
      </xsl:call-template>
    </xsl:param>
    <!-- ↓ Add Bootstrap class attributes template ↓ -->
    <xsl:variable name="bootstrap-class">
      <xsl:call-template name="bootstrap-note"/>
    </xsl:variable>
    <div role="alert">
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$bootstrap-class"/>
        <!--xsl:with-param name="default-output-class" select="string-join(($type, concat('note_', $type)), ' ')"/-->
      </xsl:call-template>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="setidaname"/>
      <!-- Normal flags go before the generated title; revision flags only go on the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
      <div>
      <span class="note__title">
        <!-- ↓ Add Bootstrap icon ↓ -->
        <xsl:if test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
          <xsl:call-template name="bootstrap-icon"/>
        </xsl:if>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:copy-of select="$title"/>
        <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="'ColonSymbol'"/>
        </xsl:call-template>
      </span>
      <xsl:text> </xsl:text>
      <xsl:apply-templates
          select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
          mode="ditaval-outputflag"
        />
      <xsl:apply-templates/>
      <!-- Normal end flags and revision end flags both go out after the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </div>
    </div>
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/alert ') or contains(@class, ' topic/note ')]/*[contains(@class, ' topic/title ')]"
  >
    <xsl:variable name="headCount" select="count(ancestor::*[contains(@class, ' topic/topic ')])+1"/>
    <xsl:variable name="headLevel">
      <xsl:choose>
        <xsl:when test="contains(@outputclass, 'h1')">h1</xsl:when>
        <xsl:when test="contains(@outputclass, 'h2')">h2</xsl:when>
        <xsl:when test="contains(@outputclass, 'h3')">h3</xsl:when>
        <xsl:when test="contains(@outputclass, 'h4')">h4</xsl:when>
        <xsl:when test="contains(@outputclass, 'h5')">h5</xsl:when>
        <xsl:when test="contains(@outputclass, 'h6')">h6</xsl:when>
        <xsl:when test="$headCount > 6">h6</xsl:when>
        <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$headLevel}">
      <xsl:attribute name="class" select="concat('alert-heading ', @outputclass)"/>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setidaname"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- Customization to add Bootstrap Figure Content -->
  <!-- https://getbootstrap.com/docs/6.0/content/figures/ -->
  <xsl:template
    match="*[contains(@class, ' topic/fig ') and not(contains(@class,' pr-d/syntaxdiagram ')) and not(contains(@class,' ut-d/imagemap '))]"
    name="topic.fig"
  >
    <xsl:variable name="default-fig-class">
      <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
    </xsl:variable>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
    <figure>
      <xsl:if test="$default-fig-class != ''">
        <xsl:attribute name="class" select="$default-fig-class"/>
      </xsl:if>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$default-fig-class"/>
      </xsl:call-template>
      <xsl:call-template name="setscale"/>
      <xsl:call-template name="setidaname"/>
      <!--xsl:call-template name="place-fig-lbl"/-->
      <xsl:apply-templates
        select="node() except *[contains(@class, ' topic/title ') or contains(@class, ' topic/desc ')]"
      />
      <!-- ↓ Move Figure title below image ↓ -->
      <xsl:call-template name="place-fig-lbl"/>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
    </figure>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <!-- Figure caption -->
  <xsl:template name="place-fig-lbl">
    <xsl:param name="stringName"/>
    <xsl:param name="suppress-title-label" select="false()" tunnel="yes"/>
    <!-- Number of fig/title's including this one -->
    <xsl:variable
      name="fig-count-actual"
      select="count(preceding::*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')])+1"
    />
    <xsl:variable name="ancestorlang">
      <xsl:call-template name="getLowerCaseLang"/>
    </xsl:variable>
    <xsl:choose>
      <!-- title -or- title & desc -->
      <xsl:when test="*[contains(@class, ' topic/title ')]">
        <figcaption>
          <!-- ↓ Add Bootstrap figure caption class ↓ -->
          <xsl:variable name="fig-caption-class">
            <xsl:choose>
              <xsl:when test="*[contains(@class, ' topic/lq ')]">
                <xsl:value-of select="concat('blockquote-footer ', $BOOTSTRAP_CSS_FIGURE_CAPTION)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('figure-caption ', $BOOTSTRAP_CSS_FIGURE_CAPTION)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:apply-templates select="." mode="set-output-class">
            <xsl:with-param
              name="default"
              select="concat($fig-caption-class, ./*[contains(@class, ' topic/title ')][1]/@outputclass)"
            />
          </xsl:apply-templates>
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          <xsl:if test="not($suppress-title-label)">
            <span class="fig--title-label">
              <xsl:choose>
                <!-- Blockquote - figure -->
                <xsl:when test="*[contains(@class, ' topic/lq ')]">
                </xsl:when>
                <!-- Hungarian: "1. Figure " -->
                <xsl:when test="$ancestorlang = ('hu', 'hu-hu')">
                  <xsl:value-of select="$fig-count-actual"/>
                  <xsl:text>. </xsl:text>
                  <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Figure'"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Figure'"/>
                  </xsl:call-template>
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$fig-count-actual"/>
                  <xsl:text>. </xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </span>
          </xsl:if>
          <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="figtitle"/>
          <xsl:if test="*[contains(@class, ' topic/desc ')]">
            <xsl:text>. </xsl:text>
          </xsl:if>
          <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
            <span class="figdesc">
              <xsl:call-template name="commonattributes"/>
              <xsl:apply-templates select="." mode="figdesc"/>
            </span>
          </xsl:for-each>
        </figcaption>
      </xsl:when>
      <!-- desc -->
      <xsl:when test="*[contains(@class, ' topic/desc ')]">
        <xsl:for-each select="*[contains(@class, ' topic/desc ')]">
          <figcaption>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates select="." mode="figdesc"/>
          </figcaption>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Customization to add Bootstrap Borders to Codeblock elements-->
  <!-- https://getbootstrap.com/docs/6.0/utilities/borders/ -->
  <xsl:template match="*[contains(@class, ' topic/pre ') and @frame]">
    <xsl:variable name="default-fig-class">
      <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
    </xsl:variable>
    <figure>
      <xsl:if test="$default-fig-class != ''">
        <xsl:attribute name="class">
          <xsl:value-of select="$default-fig-class"/>
          <xsl:text> figure </xsl:text>
          <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
      <xsl:call-template name="spec-title-nospace"/>
      <pre>
        <xsl:attribute name="class" select="name()"/>
        <xsl:call-template name="commonattributes"/>
        <xsl:call-template name="setscale"/>
        <xsl:call-template name="setidaname"/>
        <xsl:apply-templates/>
      </pre>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </figure>
  </xsl:template>

  <!-- Customization to add Bootstrap Borders to Lines elements-->
  <!-- https://getbootstrap.com/docs/6.0/utilities/borders/ -->
  <xsl:template match="*[contains(@class, ' topic/lines ') and @frame]">
    <xsl:variable name="default-fig-class">
      <xsl:apply-templates select="." mode="dita2html:get-default-fig-class"/>
    </xsl:variable>
    <figure>
      <xsl:if test="$default-fig-class != ''">
        <xsl:attribute name="class">
          <xsl:value-of select="$default-fig-class"/>
          <xsl:text> figure </xsl:text>
          <xsl:value-of select="$BOOTSTRAP_CSS_FIGURE"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="spec-title-nospace"/>
      <p>
        <xsl:call-template name="commonattributes"/>
        <xsl:call-template name="setscale"/>
        <xsl:call-template name="setidaname"/>
        <xsl:apply-templates/>
      </p>
    </figure>
  </xsl:template>

  <!-- Determine the default Bootstrap class attribute for a figure -->
  <xsl:template match="*" mode="dita2html:get-default-fig-class">
    <xsl:value-of
      select="
        if (@frame = 'all') then 'p-3 border'
        else if (@frame = 'sides') then 'px-3 border-start border-end'
        else if (@frame = 'top') then 'pt-3 border-top'
        else if (@frame = 'bottom') then 'pb-3 border-bottom'
        else if (@frame = 'topbot') then 'py-3 border-top border-bottom'
        else ''"
    />
  </xsl:template>

  <xsl:template
    match="*[contains(@class, ' topic/ph ') and contains(@otherprops, 'title(')  and (contains(@outputclass, 'initialism') or contains(@outputclass, 'abbreviation'))]"
  >
    <abbr>
      <xsl:attribute name="title">
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
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setidaname"/>
      <xsl:apply-templates/>
    </abbr>
  </xsl:template>

  <xsl:template match="*" mode="addFooterToHtmlBodyElement">
    <xsl:variable name="footer-content" as="node()*">
      <xsl:call-template name="gen-user-footer"/> <!-- include user's XSL running footer here -->
      <xsl:call-template name="processFTR"/>      <!-- Include XHTML footer, if specified -->
    </xsl:variable>
    <xsl:if test="exists($footer-content)">
      <footer xsl:use-attribute-sets="footer">
        <!-- ↓ Add Bootstrap CSS ↓ -->
        <xsl:variable name="footer-theme-classes">
          <xsl:call-template name="theme-classes">
            <xsl:with-param name="value" select="$BOOTSTRAP_THEME_FOOTER"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('mt-auto ', $footer-theme-classes)"/>
          <xsl:if test="not($TOC_SPACER_PADDING = '0')">
            <xsl:value-of select="concat(' py-', $TOC_SPACER_PADDING)"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:sequence select="$footer-content"/>
        <!-- ↓ Add Bootstrap CSS ↓ -->
      </footer>
    </xsl:if>
  </xsl:template>

  <!-- list item -->
  <xsl:template match="*[contains(@class, ' topic/li ')]" name="topic.li">
    <li>
      <xsl:choose>
        <xsl:when test="parent::*/@compact = 'no'">
          <!-- handle non-compact list items -->
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class" select="'py-3'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="parent::*/@compact = 'yes'">
          <!-- handle non-compact list items -->
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class" select="'py-0'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="commonattributes"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="setidaname"/>
      <xsl:apply-templates/>
    </li>
  </xsl:template>

  <!-- Process a list of images as a single HTML5 Picture element. -->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/picture ') or (contains(@class, ' topic/div ') and contains(@outputclass, 'd-picture'))]"
  >
    <picture>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setid"/>
      <xsl:for-each select="*[contains(@class,' topic/image ')]">
        <xsl:choose>
          <xsl:when test="position()=last()">
            <xsl:apply-templates select="."/>
          </xsl:when>
          <xsl:otherwise>
            <source>
              <xsl:attribute name="srcset" select="@href"/>
              <xsl:if test="@media">
                <xsl:attribute name="media" select="concat('(', @media, ')')"/>
              </xsl:if>
              <xsl:if test="@type">
                <xsl:attribute name="type" select="@type"/>
              </xsl:if>
              <xsl:if test="@otherprops">
                <xsl:apply-templates select="." mode="otherprops-attributes"/>
              </xsl:if>
            </source>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </picture>
  </xsl:template>

  <xsl:template name="topic-image">
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
    <img>
      <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class">
          <xsl:if test="@placement = 'break'"><!--Align only works for break-->
            <xsl:choose>
              <xsl:when test="@align = 'left'">imageleft</xsl:when>
              <xsl:when test="@align = 'right'">imageright</xsl:when>
              <xsl:when test="@align = 'center'">imagecenter</xsl:when>
            </xsl:choose>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="setid"/>
      <!-- ↓ Add otherprops for lazy loading ↓ -->
      <xsl:if test="@loading">
        <xsl:attribute name="loading" select="@loading"/>
      </xsl:if>
      <xsl:if test="@otherprops">
        <xsl:apply-templates select="." mode="otherprops-attributes"/>
      </xsl:if>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
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
          <xsl:variable name="alt-content"><xsl:apply-templates
              select="*[contains(@class, ' topic/alt ')]"
              mode="text-only"
            /></xsl:variable>
          <xsl:attribute name="alt" select="normalize-space($alt-content)"/>
        </xsl:when>
        <xsl:when test="@alt">
          <xsl:attribute name="alt" select="@alt"/>
        </xsl:when>
      </xsl:choose>
    </img>
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  </xsl:template>

  <!-- Override to add <meta> elements to page heads -->
  <xsl:template match="*" mode="chapterHead">
    <head>
      <!-- initial meta information -->
      <xsl:call-template name="generateCharset"/>   <!-- Set the character set to UTF-8 -->
      <!-- ↓ Add <meta> element from Bootstrap starter template ↓ -->
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <xsl:call-template name="generateDefaultCopyright"/> <!-- Generate a default copyright, if needed -->
      <xsl:call-template name="generateDefaultMeta"/> <!-- Standard meta for security, robots, etc -->
      <xsl:call-template name="getMeta"/>           <!-- Process metadata from topic prolog -->
      <xsl:call-template name="copyright"/>         <!-- Generate copyright, if specified manually -->
      <xsl:call-template name="generateChapterTitle"/> <!-- Generate the <title> element -->
      <xsl:call-template name="gen-user-head"/>    <!-- include user's XSL HEAD processing here -->
      <xsl:call-template name="gen-user-scripts"/> <!-- include user's XSL javascripts here -->
      <xsl:call-template name="processHDF"/>        <!-- Add user HDF file, if specified -->
      <xsl:call-template name="generateCssLinks"/>  <!-- Generate links to CSS files -->
      <xsl:call-template name="gen-user-styles"/>   <!-- include user's XSL style element and content here -->

      <!-- Add Bootstrap icons -->
      <xsl:if test="$BOOTSTRAP_ICONS_INCLUDE = 'yes'">
        <!--Check the file Url Definition of HDF HDR FTR-->
        <xsl:variable name="BOOTSTRAP_CDNFILE">
          <xsl:choose>
            <xsl:when test="not($BOOTSTRAP_ICONS_CDN)"/> <!-- If no filterfile leave empty -->
            <xsl:when test="starts-with($BOOTSTRAP_ICONS_CDN, 'file:')">
              <xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="starts-with($BOOTSTRAP_ICONS_CDN, '/')">
                  <xsl:text>file://</xsl:text><xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>file:/</xsl:text><xsl:value-of select="$BOOTSTRAP_ICONS_CDN"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="string-length($BOOTSTRAP_CDNFILE) > 0">
          <xsl:copy-of select="document($BOOTSTRAP_CDNFILE, /)"/>
        </xsl:if>
      </xsl:if>
    </head>
  </xsl:template>

  <!-- Override to use a CSS Grid -->
  <xsl:template match="*" mode="chapterBody">
    <body>
      <xsl:apply-templates select="." mode="addAttributesToHtmlBodyElement"/>
      <xsl:call-template name="setaname"/>  <!-- For HTML4 compatibility, if needed -->

      <xsl:call-template name="gen-skip-to-main"/>
      <!-- ↓ Add CSS classes to use a CSS Grid - see side-toc.css for details  -->
      <xsl:apply-templates select="." mode="addHeaderToHtmlBodyElement"/>
      <xsl:if test="$BOOTSTRAP_MENUBAR_TOC = 'yes'">
        <xsl:apply-templates select="." mode="gen-user-toptoc"/>
      </xsl:if>

      <div>
        <xsl:attribute
          name="class"
          select="concat('bs-container ', $BOOTSTRAP_CSS_CONTAINER_SIZE, ' bd-gutter mt-3 my-md-4')"
        />
        <xsl:attribute name="id" select="'content'"/>
        <xsl:call-template name="gen-user-sidetoc"/>
        <xsl:apply-templates select="." mode="addContentToHtmlBodyElement"/>
      </div>

      <xsl:variable name="relpath">
        <xsl:choose>
          <xsl:when test="$FILEDIR='.'">
            <xsl:text>.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="replace(replace($FILEDIR, '\\', '/') ,'[^/]+','..')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="$BOOTSTRAP_POPOVERS_INCLUDE = 'yes'">
        <script language="javascript" src="{$relpath}/js/popovers.js"/>
      </xsl:if>
      <xsl:if test="$BOOTSTRAP_DARK_MODE_INCLUDE = 'yes'">
        <script language="javascript" src="{$relpath}/js/dark-mode-toggler.js"/>
      </xsl:if>
      <!-- ↑ End customization -->
      <xsl:apply-templates select="." mode="addFooterToHtmlBodyElement"/>
    </body>
  </xsl:template>

  <!-- Hidden accessibility buttons for screen readers and keyboard navigation-->
  <xsl:template name="gen-skip-to-main">
    <xsl:variable name="skip-to-main-theme-classes">
      <xsl:call-template name="theme-classes">
        <xsl:with-param name="value" select="$BOOTSTRAP_THEME_ACCESSIBILITY"/>
      </xsl:call-template>
    </xsl:variable>
    <div>
      <xsl:attribute
        name="class"
        select="concat('visually-hidden-focusable overflow-hidden p-2 ', $skip-to-main-theme-classes)"
      />

      <div>
        <xsl:attribute name="class" select="$BOOTSTRAP_CSS_CONTAINER_SIZE"/>
        <a>
          <xsl:attribute name="class" select="concat('d-inline-flex m-1 ', $BOOTSTRAP_CSS_ACCESSIBILITY_LINK)"/>
          <xsl:apply-templates mode="scrollspy-href" select="*[contains(@class, ' topic/title ')][1]"/>
          <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Skip to main content'"/>
          </xsl:call-template>
        </a>
        <xsl:choose>
          <xsl:when test="$BOOTSTRAP_MENUBAR_TOC = 'yes'">
            <!-- "skip to docs" link refers to the menubar -->
            <a href="#bs-menubar-nav">
              <xsl:attribute
                name="class"
                select="concat('d-none md:d-inline-flex m-1 ', $BOOTSTRAP_CSS_ACCESSIBILITY_LINK)"
              />
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Skip to docs navigation'"/>
              </xsl:call-template>
            </a>
          </xsl:when>
          <xsl:when test="$nav-toc = 'none'">
            <!-- do not add a "skip to docs" link -->
          </xsl:when>
          <xsl:otherwise>
            <!-- Add a "skip to docs" link to the sidebar -->
            <a href="#bs-sidebar-nav">
              <xsl:attribute
                name="class"
                select="concat('d-none md:d-inline-flex m-1 ', $BOOTSTRAP_CSS_ACCESSIBILITY_LINK)"
              />
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Skip to docs navigation'"/>
              </xsl:call-template>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <!--
    Overrides to add CSS classes to use a CSS Grid for the navigation layout
  -->
  <xsl:attribute-set name="main">
    <xsl:attribute name="class">
      <xsl:variable name="content-theme-classes">
        <xsl:call-template name="theme-classes">
          <xsl:with-param name="value" select="$BOOTSTRAP_THEME_CONTENT"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="'bs-main me-3'"/>
      <xsl:if test="$content-theme-classes != ''">
        <xsl:value-of select="concat(' ', $content-theme-classes)"/>
      </xsl:if>
      <xsl:if test="'border' = tokenize($BOOTSTRAP_THEME_CONTENT, '-')">
        <xsl:text> p-2</xsl:text>
      </xsl:if>
    </xsl:attribute>
    <xsl:attribute name="role">main</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="toc">
    <xsl:attribute name="role">navigation</xsl:attribute>
    <xsl:attribute name="id">bs-sidebar-nav</xsl:attribute>
    <xsl:attribute name="class">
      <xsl:variable name="sidebar-theme-parts" select="tokenize($BOOTSTRAP_THEME_SIDEBAR, '-')" as="xs:string*"/>
      <xsl:text>d-flex align-items-start flex-column h-100 </xsl:text>
      <xsl:if test="$BOOTSTRAP_THEME_SIDEBAR != 'none' and $nav-toc = 'collapsible'">
        <xsl:value-of select="concat('theme-', $sidebar-theme-parts[1])"/>
        <xsl:if test="'border' = $sidebar-theme-parts">
          <xsl:text> theme-border p-2</xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="menubar-toc">
    <xsl:attribute name="class">navbar px-3 border-0</xsl:attribute>
    <xsl:attribute name="role">navigation</xsl:attribute>
    <xsl:attribute name="id">bs-menubar-nav</xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
