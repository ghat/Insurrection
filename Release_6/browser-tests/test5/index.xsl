<?xml version="1.0"?>
<!-- $Id$ -->
<!-- Copyright 2004,2005 - Michael Sinz -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html"/>

  <xsl:template match="*"/>

  <xsl:template match="svn">
    <html>
      <head>
        <title>Insurrection Browser Compatibility Test #5</title>
        <link href="/favicon.ico" rel="shortcut icon"/>
        <link href="/styles.css" rel="stylesheet" type="text/css"/>
        <script type="text/javascript" language="JavaScript" src="index.js"></script>
      </head>
      <body>
        <!-- Now for the real page... -->
        <table id="pagetable">
          <tr>
            <td id="content">
              <div id="banner" style="margin: 0px; border: 0px; padding-top: 4px; text-align: center;">
                <h1>It did not work!</h1>
              </div>

              <xsl:element name="script">
                  <xsl:attribute name="type">text/javascript</xsl:attribute>
                  <xsl:attribute name="language">JavaScript</xsl:attribute>
                  <xsl:text>loadBanner('banner.html');</xsl:text>
              </xsl:element>

              <p style="border-top: 1px solid black; padding-top: 0.6em;">
                In this test, a simplified XSLT translation is used on the index XML and the resulting
                page then loads the standard banner into the page via JavaScript that was generated
                from the XSLT.
              </p>
              <xsl:apply-templates/>
              <div class="footer">
                <xsl:text>$Id$</xsl:text>
              </div>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="updir">
    <tr class="updirrow">
      <td colspan="4">
        <div class="updir">
          <xsl:element name="img">
            <xsl:attribute name="class">svnentryicon</xsl:attribute>
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:text>/folder.gif</xsl:text>
            </xsl:attribute>
          </xsl:element>
          <xsl:text>.. (Parent Directory)</xsl:text>
        </div>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="index">
    <div class="svn">
    <table width="100%" cellpadding="0" cellspacing="0" border="0">
      <xsl:apply-templates select="updir"/>
      <tr class="pathrow">
        <td class="foldspace">
          <xsl:element name="img">
            <xsl:attribute name="class">dirarrow</xsl:attribute>
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:text>/opened.gif</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </td>
        <td class="path">
          <xsl:element name="img">
            <xsl:attribute name="class">svnentryicon</xsl:attribute>
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:text>/folder.gif</xsl:text>
            </xsl:attribute>
          </xsl:element>
          <xsl:value-of select="@path"/>
        </td>
        <td class="rev">
          <xsl:if test="string-length(@name) != 0">
            <xsl:value-of select="@name"/>
          </xsl:if>
          <xsl:if test="string-length(@rev) = 0">
            <xsl:text>&#8212; </xsl:text>
          </xsl:if>
          <xsl:if test="string-length(@rev) != 0">
            <xsl:text>Revision </xsl:text>
            <xsl:value-of select="@rev"/>
          </xsl:if>
        </td>
        <td class="showlog">
          <xsl:element name="img">
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="alt">Get revision history</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:text>/info.gif</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </td>
      </tr>
      <tr id="./_">
        <td>
          <xsl:element name="img">
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:text>/blank.gif</xsl:text>
            </xsl:attribute>
          </xsl:element>
        </td>
        <td colspan="3" id="./">
          <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <xsl:apply-templates select="dir"/>
            <xsl:apply-templates select="file"/>
          </table>
        </td>
      </tr>
    </table>
    </div>
  </xsl:template>

  <xsl:template match="dir">
    <tr class="dirrow">
      <td class="foldspace">
        <xsl:element name="img">
          <xsl:attribute name="class">dirarrow</xsl:attribute>
          <xsl:attribute name="align">middle</xsl:attribute>
          <xsl:attribute name="src">
            <xsl:text>/closed.gif</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </td>
      <td>
        <div class="dir">
          <xsl:element name="img">
            <xsl:attribute name="class">svnentryicon</xsl:attribute>
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:text>/folder.gif</xsl:text>
            </xsl:attribute>
          </xsl:element>
          <xsl:value-of select="@name"/>
          <xsl:text>/</xsl:text>
        </div>
      </td>
      <td class="showlog">
        <xsl:element name="img">
          <xsl:attribute name="align">middle</xsl:attribute>
          <xsl:attribute name="alt">Get revision history</xsl:attribute>
          <xsl:attribute name="src">
            <xsl:text>/info.gif</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="file">
    <tr class="filerow">
      <td class="foldspace">
        <xsl:element name="img">
          <xsl:attribute name="align">middle</xsl:attribute>
          <xsl:attribute name="src">
            <xsl:text>/blank.gif</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </td>
      <td>
        <div class="file">
          <xsl:element name="img">
            <xsl:attribute name="class">svnentryicon</xsl:attribute>
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="src">
              <xsl:text>/file.gif</xsl:text>
            </xsl:attribute>
          </xsl:element>
          <xsl:value-of select="@name"/>
        </div>
      </td>
      <td class="showlog">
        <xsl:element name="img">
          <xsl:attribute name="align">middle</xsl:attribute>
          <xsl:attribute name="alt">Get revision history</xsl:attribute>
          <xsl:attribute name="src">
            <xsl:text>/info.gif</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
