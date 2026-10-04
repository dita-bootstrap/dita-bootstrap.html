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
  <!-- Customization to add Bootstrap Popover component -->
  <!-- https://getbootstrap.com/docs/6.0/components/popovers/ -->

  <xsl:template match="*" mode="add-bootstrap-popover">
    <xsl:attribute name="data-bs-toggle">
      <xsl:text>popover</xsl:text>
    </xsl:attribute>
    <xsl:attribute
      name="data-bs-placement"
      select="
        if (@position) then @position
        else if (contains(@outputclass, 'popover-left')) then 'left'
        else if (contains(@outputclass, 'popover-right')) then 'right'
        else if (contains(@outputclass, 'popover-bottom')) then 'bottom'
        else 'top'"
    />
    <xsl:if test="*[contains(@class, ' topic/data ') and contains(@name, 'title')][1]">
      <xsl:attribute name="title">
        <xsl:value-of select="*[contains(@class, ' topic/data ') and contains(@name, 'title')][1]"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="*[contains(@class, ' topic/data ') and contains(@name, 'class')][1]">
      <xsl:attribute name="data-bs-custom-class">
        <xsl:value-of select="*[contains(@class, ' topic/data ') and contains(@name, 'class')][1]"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:attribute name="data-bs-content">
      <xsl:value-of select="*[contains(@class, ' topic/desc ')][1]"/>
    </xsl:attribute>
  </xsl:template>

  <!--template for xref-->
  <xsl:template
    match="*[contains(@class, ' bootstrap-d/popover ')] | *[contains(@class, ' topic/xref ') and contains(@outputclass, 'popover-')]"
  >
    <a>
      <!-- ↓ Add Bootstrap class attributes template ↑ -->
      <xsl:apply-templates select="." mode="add-bootstrap-popover"/>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates
        select="*[not(contains(@class, ' topic/desc '))] | text() | comment() | processing-instruction()"
      />
    </a>
  </xsl:template>
  <xsl:template match="*[contains(@class, ' bootstrap-d/popover ')]" mode="set-output-class">
    <xsl:param name="default"/>
    <xsl:variable name="output-class">
      <xsl:apply-templates select="." mode="get-output-class"/>
    </xsl:variable>
    <xsl:variable name="draft-revs" as="xs:string*">
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
      <xsl:attribute name="class" select="distinct-values($classes)[. != 'popover']" separator=" "/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
