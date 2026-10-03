<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright © 2017 · infotexture · Roger W. Fienhold Sheen -->
<!-- See the accompanying LICENSE file for applicable license -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
  <!-- the file name containing XHTML to be placed in the HEAD area
       (file name and extension only - no path). -->
  <xsl:param name="BOOTSTRAP_ICONS_CDN"/>
  <!-- Whether to include bootstrap icons.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_ICONS_INCLUDE" select="'yes'"/>
  <!-- Whether include a subheader menu bar.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_MENUBAR_TOC" select="'no'"/>
  <!-- Whether to include bootstrap popovers.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_DARK_MODE_INCLUDE" select="'yes'"/>
  <!-- Whether to include dark mode toggling.  values are 'yes' or 'no' -->
  <xsl:param name="BOOTSTRAP_POPOVERS_INCLUDE" select="'yes'"/>
  <!-- Whether to include a scrollspy Toc -->
  <xsl:param name="BOOTSTRAP_SCROLLSPY_TOC" select="'none'"/>
  <!-- Defines container class for main layout and menubar-TOC -->
  <xsl:param name="BOOTSTRAP_CSS_CONTAINER_SIZE" select="'2xl:container'"/>
  <!-- Defines the CSS class for the menubar-TOC -->
  <xsl:param name="BOOTSTRAP_CSS_MENUBAR_TOC" select="'sticky-top bg-body'"/>

  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/related-links.xsl"/>
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-textonly.xsl"/>

  <xsl:import href="plugin:org.dita.html5:xsl/topic.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/concept.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/glossdisplay.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/task.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/reference.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/ut-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/sw-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/pr-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/ui-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/hi-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/abbrev-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/markup-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/xml-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/svg-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/hazard-d.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/nav.xsl"/>
  <xsl:import href="plugin:org.dita.html5:xsl/htmlflag.xsl"/>

  <dita:extension
    id="dita.xsl.html5"
    behavior="org.dita.dost.platform.ImportXSLAction"
    xmlns:dita="http://dita-ot.sourceforge.net"
  />

  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/accordion.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/breadcrumb.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/card.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/carousel.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/collapse.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/drawer.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/hi-d.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/nav.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/pagination.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/popovers.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/scrollspy.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/tables.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/tabs.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/tooltips.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:Customization/xsl/topic.xsl"/>
  <xsl:import href="plugin:org.dita-bootstrap.html:xsl/utility-classes.xsl"/>

  <dita:extension
    id="dita.xsl.html5-bootstrap"
    behavior="org.dita.dost.platform.ImportXSLAction"
    xmlns:dita="http://dita-ot.sourceforge.net"
  />

  <!-- root rule -->
  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
