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
  <!-- Customization to add Bootstrap Accordion Component -->
  <!-- https://getbootstrap.com/docs/6.0/components/accordion/ -->

  <xsl:template
    match="*[contains(@class, ' bootstrap-d/accordion ') or (contains(@class,' topic/bodydiv ') and (contains(@outputclass, 'accordion') or contains(@outputclass, 'accordion-flush')))]"
  >
    <div>
      <xsl:attribute name="id" select="dita-ot:generate-html-id(.)"/>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates mode="accordion"/>
    </div>
  </xsl:template>


  <xsl:template match="*[contains(@class, ' topic/section ')]" mode="accordion">

    <xsl:variable name="id" select="dita-ot:generate-html-id(..)"/>
    <details class="accordion-item">

       <xsl:if test="not(contains(../@outputclass, 'open')) and not(../@open = 'yes')">
          <xsl:attribute name="name" select="$id"/>
        </xsl:if>
       <xsl:if test="(contains(@outputclass, 'show') or @open = 'yes')">
         <xsl:attribute name="open" select="'yes'"/>
       </xsl:if>

      <summary class="accordion-header">
        <xsl:apply-templates select="*[(contains(@class, ' topic/title '))]"/>
        <svg
          class="accordion-icon"
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 16 16"
          fill="none"
          stroke="currentColor"
          stroke-linecap="round"
          stroke-linejoin="round"
        ><path d="m2 5 6 6 6-6"/></svg>

      </summary>
      <div class="accordion-body">
          <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>
          <xsl:apply-templates
          select="*[not(contains(@class, ' topic/title '))] | text() | comment() | processing-instruction()"
        />
          <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
      </div>
    </details>
  </xsl:template>
</xsl:stylesheet>
