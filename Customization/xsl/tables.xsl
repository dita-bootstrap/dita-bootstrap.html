<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Bootstrap plug-in for DITA Open Toolkit.
  See the accompanying LICENSE file for applicable licenses.
-->
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:table="http://dita-ot.sourceforge.net/ns/201007/dita-ot/table"
  version="2.0"
  exclude-result-prefixes="xs dita-ot table"
>
  <!--override row processing - remove DITA row CSS class -->
  <xsl:template match="*[contains(@class, ' topic/row ')]" name="topic.row">
    <tr>
      <xsl:apply-templates select="." mode="set-output-class">
        <xsl:with-param name="default" select="if (@valign) then concat('align-', @valign) else ()"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="@xml:lang"/>
      <xsl:apply-templates select="@dir"/>
      <xsl:apply-templates
        select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@style"
        mode="add-ditaval-style"
      />
      <xsl:call-template name="setid"/>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <!--override table CSS processing - remove DITA frame CSS processing -->
  <xsl:template match="*[contains(@class, ' topic/table ')]" mode="css-class">
    <xsl:apply-templates select="@pgwide, @scale" mode="#current"/>
  </xsl:template>

  <xsl:template match="*" mode="frame-processing">
    <xsl:choose>
      <xsl:when test="@frame = 'sides'">
        <xsl:attribute name="class" select="'border-start border-end pt-3 px-3'"/>
      </xsl:when>
      <xsl:when test="@frame = 'top'">
        <xsl:attribute name="class" select="'border-top pt-3'"/>
      </xsl:when>
      <xsl:when test="@frame = 'bottom'">
        <xsl:attribute name="class" select="'border-bottom pt-3 px-3'"/>
      </xsl:when>
      <xsl:when test="@frame = 'topbot'">
        <xsl:attribute name="class" select="'border-top border-bottom pt-3 px-3'"/>
      </xsl:when>
      <xsl:when test="@frame = 'all'">
        <xsl:attribute name="class" select="'border pt-3 px-3'"/>
      </xsl:when>
      <xsl:when test="@frame = 'none'">
        <xsl:attribute name="class" select="'border-0 pt-3 px-3'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/table ')]" name="topic.table">
    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]" mode="out-of-line"/>

    <div>
      <!-- ↓ Add Bootstrap CSS frame processing ↓ -->
      <xsl:apply-templates select="." mode="frame-processing"/>
      <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
      <table>
        <!-- ↓ Add Bootstrap CSS class processing ↓ -->
        <xsl:call-template name="commonattributes"/>
        <!-- ↑ End customization · Continue with DITA-OT defaults ↓ -->
        <xsl:call-template name="setid"/>
        <xsl:apply-templates select="." mode="css-class"/>
        <xsl:apply-templates select="." mode="table:title"/>
        <!-- title and desc are processed elsewhere -->
        <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
      </table>
    </div>

    <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/table ')]" mode="table:title">
    <xsl:if test="*[(contains(@class, ' topic/title ') or contains(@class, ' topic/desc '))]">
      <caption>
        <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="label"/>
        <xsl:apply-templates
          select="
          *[contains(@class, ' topic/title ')] | *[contains(@class, ' topic/desc ')]
        "
        />
      </caption>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/entry ')]/@valign" mode="css-class">
    <xsl:value-of select="concat('align-', .)"/>
  </xsl:template>

  <xsl:template match="@colsep" mode="css-class">
    <xsl:if test=".='0' and not(../@rowsep='0')">
      <xsl:value-of select="'border-start-0 border-end-0'"/>
    </xsl:if>
    <xsl:if test=".='1' and not(../@rowsep='1')">
      <xsl:value-of select="'border-start border-end'"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@rowsep" mode="css-class">
    <xsl:if test=".='0' and not(../@colsep='0')">
      <xsl:value-of select="'border-top-0 border-bottom-0'"/>
    </xsl:if>
  </xsl:template>

  <!-- Add a Bootstrap CSS border to tables -->
  <xsl:template match="*[contains(@class, ' topic/table ')]" mode="get-output-class">
    <xsl:value-of select="$BOOTSTRAP_CSS_TABLE"/>
    <xsl:variable
      name="theme"
      select="
      (@color,
       substring-after(tokenize(@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'))[1]"
    />
    <xsl:if test="normalize-space($theme) != ''">
      <xsl:value-of select="concat('table-', $theme, ' ')"/>
    </xsl:if>
    <xsl:if test="@striped = 'yes'">
      <xsl:text> table-striped</xsl:text>
    </xsl:if>
    <xsl:if test="@striped-columns = 'yes'">
      <xsl:text> table-striped-columns</xsl:text>
    </xsl:if>
    <xsl:if test="@compact = 'yes'">
      <xsl:text> table-sm</xsl:text>
    </xsl:if>
    <xsl:variable
      name="border"
      select="
        if (@colsep='1' and @rowsep='1') then ' table-bordered '
        else if (@colsep='0' and @rowsep='0') then ' table-borderless '
        else ''"
    />
    <xsl:value-of select="$border"/>
    <xsl:next-match/>
  </xsl:template>

  <!-- Enhance the default Bootstrap CSS text color of the table headers -->
  <xsl:template
    match="*[contains(@class, ' topic/thead ') or contains(@class, ' topic/tbody ') or contains(@class, ' topic/tfoot ')]"
    mode="get-output-class"
  >
    <xsl:if test="contains(@class, ' topic/thead ')">
      <xsl:value-of select="$BOOTSTRAP_CSS_TABLE_HEAD"/>
    </xsl:if>
    <xsl:variable name="table" select="ancestor::*[contains(@class, ' topic/table ')][1]"/>
    <xsl:if test="contains(@class, ' topic/tbody ') and $table/@divider = 'yes'">
       <xsl:text>table-group-divider </xsl:text>
    </xsl:if>
    <xsl:variable
      name="theme"
      select="
      (@color,
       substring-after(tokenize(@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'),
       $table/@color,
       substring-after(tokenize($table/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'))[1]"
    />
    <xsl:if test="normalize-space($theme) != ''">
      <xsl:value-of select="concat('table-', $theme, ' ')"/>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/row ')]" mode="get-output-class">
    <xsl:variable name="group" select="parent::*"/>
    <xsl:variable name="table" select="ancestor::*[contains(@class, ' topic/table ')][1]"/>
    <xsl:variable
      name="theme"
      select="
      (@color,
       substring-after(tokenize(@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'),
       $group/@color,
       substring-after(tokenize($group/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'),
       $table/@color,
       substring-after(tokenize($table/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'))[1]"
    />
    <xsl:if test="normalize-space($theme) != ''">
      <xsl:value-of select="concat('table-', $theme, ' ')"/>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="get-output-class">
    <xsl:variable name="row" select="parent::*"/>
    <xsl:variable name="group" select="$row/parent::*"/>
    <xsl:variable name="table" select="ancestor::*[contains(@class, ' topic/table ')][1]"/>
    <xsl:variable
      name="theme"
      select="
      (@color,
       substring-after(tokenize(@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'),
       $row/@color,
       substring-after(tokenize($row/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'),
       $group/@color,
       substring-after(tokenize($group/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'),
       $table/@color,
       substring-after(tokenize($table/@outputclass, ' ')[starts-with(., 'table-')][1], 'table-'))[1]"
    />
    <xsl:if test="normalize-space($theme) != ''">
      <xsl:value-of select="concat('table-', $theme, ' ')"/>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>
