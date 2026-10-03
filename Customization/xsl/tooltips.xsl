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
  <!-- Customization to add Bootstrap Tooltips component -->
  <!-- https://getbootstrap.com/docs/6.0/components/tooltips/ -->

  <xsl:template match="*" mode="add-bootstrap-tooltip">
    <xsl:attribute name="data-bs-toggle">
      <xsl:text>tooltip</xsl:text>
    </xsl:attribute>
    <xsl:attribute
      name="data-bs-placement"
      select="
        if (@position) then @position
        else if (contains(@outputclass, 'tooltip-left')) then 'left'
        else if (contains(@outputclass, 'tooltip-right')) then 'right'
        else if (contains(@outputclass, 'tooltip-bottom')) then 'bottom'
        else 'top'"
    />
    <xsl:if test="*[contains(@class, ' topic/data ') and contains(@name, 'class')][1]">
      <xsl:attribute name="data-bs-custom-class">
        <xsl:value-of select="*[contains(@class, ' topic/data ') and contains(@name, 'class')][1]"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="*[contains(@class, ' topic/desc ')]/*">
        <xsl:attribute name="data-bs-html">
          <xsl:text>true</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:apply-templates select="*[contains(@class, ' topic/desc ')][1]" mode="tooltipdesc"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="add-desc-as-hoverhelp"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/desc ')]" mode="tooltipdesc">
    <xsl:variable name="htmlAsString">
      <xsl:variable name="htmlContent">
        <xsl:copy>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:variable>
      <xsl:apply-templates select="$htmlContent" mode="serialize"/>
    </xsl:variable>
    <xsl:value-of select="substring($htmlAsString, 7, string-length($htmlAsString) - 13)"/>
  </xsl:template>

  <xsl:template match="*" mode="serialize">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="serialize"/>
    <xsl:choose>
      <xsl:when test="node()">
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates mode="serialize"/>
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> /&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*" mode="serialize">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="text()" mode="serialize">
    <xsl:value-of select="."/>
  </xsl:template>

  <!--template for xref-->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/tooltip ')] | *[contains(@class, ' topic/xref ') and contains(@outputclass, 'tooltip-')]"
  >
    <xsl:choose>
      <xsl:when test="@href and normalize-space(@href)">
        <a>
          <!-- ↓ Add Bootstrap class attributes template ↓ -->
          <xsl:apply-templates select="." mode="add-bootstrap-tooltip"/>
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates select="." mode="add-linking-attributes"/>
          <!-- if there is text or sub element other than desc, apply templates to them
          otherwise, use the href as the value of link text. -->
          <xsl:choose>
            <xsl:when test="@type = 'fn'">
              <sup>
                <xsl:choose>
                  <xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
                    <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                    <!--use xref content-->
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="href"/><!--use href text-->
                  </xsl:otherwise>
                </xsl:choose>
              </sup>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
                  <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                  <!--use xref content-->
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="href"/><!--use href text-->
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </a>
        <xsl:apply-templates select="." mode="add-xref-highlight-at-end"/>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="commonattributes"/>
          <!-- ↓ Add Bootstrap class attributes template ↓ -->
          <xsl:apply-templates select="." mode="add-bootstrap-tooltip"/>
          <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
          <xsl:apply-templates
            select="*[not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"
          />
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="*[contains(@class, ' bootstrap-d/tooltip ')]" mode="set-output-class">
    <xsl:param name="default"/>
    <xsl:variable name="output-class">
      <xsl:apply-templates select="." mode="get-output-class"/>
    </xsl:variable>
    <xsl:variable name="draft-revs" as="xs:string*">
      <!-- If draft is on, add revisions to default class. Simplifies processing in DITA-OT 1.6 and earlier
           that created an extra div or span around revised content, just to hold @class with revs. -->
      <xsl:if test="$DRAFT = 'yes'">
        <xsl:sequence select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop/@val"/>
      </xsl:if>
    </xsl:variable>
    <xsl:variable
      name="flag-outputclass"
      as="xs:string*"
      select="tokenize(normalize-space(*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass), '\s+')"
    />
    <xsl:variable name="using-output-class" as="xs:string*">
     <xsl:choose>
       <xsl:when test="string-length(normalize-space($output-class)) > 0">
         <xsl:value-of select="tokenize(normalize-space($output-class), '\s+')"/>
       </xsl:when>
       <xsl:when test="string-length(normalize-space($default)) > 0">
         <xsl:value-of select="tokenize(normalize-space($default), '\s+')"/>
       </xsl:when>
     </xsl:choose>
    </xsl:variable>
    <xsl:variable name="ancestry" as="xs:string?">
      <xsl:if test="$PRESERVE-DITA-CLASS = 'yes'">
        <xsl:value-of>
          <xsl:apply-templates select="." mode="get-element-ancestry"/>
        </xsl:value-of>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="outputclass-attribute" as="xs:string">
      <xsl:value-of>
        <xsl:apply-templates select="@outputclass" mode="get-value-for-class"/>
      </xsl:value-of>
    </xsl:variable>
    <!-- Revised design with DITA-OT 1.5: include class ancestry if requested; 
         combine user output class with element default, giving priority to the user value. -->
    <xsl:variable
      name="classes"
      as="xs:string*"
      select="tokenize($ancestry, '\s+'),
                          $using-output-class,
                          $draft-revs, 
                          tokenize($outputclass-attribute, '\s+'),
                          $flag-outputclass"
    />
    <xsl:if test="exists($classes)">
      <xsl:attribute name="class" select="distinct-values($classes)[. != 'tooltip']" separator=" "/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
