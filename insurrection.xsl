<?xml version="1.0" encoding="utf-8"?>
<!-- $Id$ -->
<!-- Copyright 2004-2006 - Michael Sinz -->
<!-- This is my magic Insurrection XSLT transform to HTML -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:atom="http://www.w3.org/2005/Atom" version="1.0">

  <xsl:output
    method="html"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    indent="no"/>

  <xsl:template match="*"/>

  <!-- ******************************************************************************************************************* -->
  <!-- This is where all of the configuration should happen.  I used to have
       the configuration in its own file but certain browsers had problems
       with the XPath document() function.  So I am centeralizing this into
       the XSLT file near the top. -->

  <!-- This is the global configuration for the header of the
       HTML pages.  The XSLT and CGIs use this to include
       the standard set of elements in the header.  This
       is here specifically such that the URLs can be
       configured as needed for your system configuration.

       Don't forget the matching insurrection.js and insurrection.pl files. -->
  <!-- Note: the data within this template must be literal - no XSLT tags -->
  <xsl:template name="banner">
    <div style="margin: 0px; border: 0px; padding: 0px; text-align: center;">
      <a href="/" title="Home"><img src="/Logo.gif" alt="Revision Management with Insurrection and Subversion" border="0"/></a>
    </div>
  </xsl:template>

  <!-- This is the page banner shown at the top of all of the managed
       pages within the Insurrection Web Tools.  This file is used by
       both the XSLT and CGI scripts so there is only one place you
       need to update. -->
  <!-- Note: the data within this template must be literal - no XSLT tags -->
  <xsl:template name="header">
    <link href="/favicon.ico" rel="shortcut icon"/>
    <link href="/styles.css" rel="stylesheet" type="text/css"/>
    <script src="/insurrection.js" language="JavaScript" type="text/javascript"></script>
    <script src="/svnindex.js" language="JavaScript" type="text/javascript"></script>
    <script src="/log.js" language="JavaScript" type="text/javascript"></script>
  </xsl:template>

  <!-- Where and what these images are.  Note that these need to be paths
       to the images and not just relative links.  The default shows
       that the images are at the "root" of the server. -->
  <!-- Note: the data within these templates must be literal - no XSLT tags -->
  <xsl:template name="closedicon-path">/closed.gif</xsl:template>
  <xsl:template name="openingicon-path">/opening.gif</xsl:template>
  <xsl:template name="openedicon-path">/opened.gif</xsl:template>
  <xsl:template name="diricon-path">/folder.gif</xsl:template>
  <xsl:template name="fileicon-path">/file.gif</xsl:template>
  <xsl:template name="infoicon-path">/info.gif</xsl:template>
  <xsl:template name="spacericon-path">/spacer.gif</xsl:template>
  <xsl:template name="blankicon-path">/blank.gif</xsl:template>
  <xsl:template name="pasticon-path">/past.gif</xsl:template>
  <xsl:template name="rssicon-path">/rss.gif</xsl:template>
  <xsl:template name="atomicon-path">/atom.gif</xsl:template>
  <xsl:template name="loginicon-path">/login.gif</xsl:template>
  <xsl:template name="passwordicon-path">/password.gif</xsl:template>
  <xsl:template name="adminicon-path">/admin.gif</xsl:template>
  <xsl:template name="editicon-path">/edit.gif</xsl:template>
  <xsl:template name="saveicon-path">/save.gif</xsl:template>
  <xsl:template name="cancelicon-path">/cancel.gif</xsl:template>
  <xsl:template name="previewicon-path">/preview.gif</xsl:template>
  <xsl:template name="linkicon-path">/link.gif</xsl:template>
  <xsl:template name="aticon-path">/at.gif</xsl:template>
  <xsl:template name="xmlicon-path">/valid-xml10.png</xsl:template>
  <xsl:template name="htmlicon-path">/valid-html401.png</xsl:template>

  <!-- ******************************************************************************************************************* -->

  <!-- Some "macros" for doing our standard page layout -->
  <!-- Note that the top-left and bottom-right have an image in them to force the frame border sizes via the CSS -->
  <!-- This is to work around the lack of min-width/min-height support in a number of CSS implementations. -->
  <xsl:template name="top-bottom">
    <thead>
      <tr>
        <th id="top-left">
          <xsl:element name="img">
            <xsl:attribute name="src">
              <xsl:call-template name="blankicon-path"/>
            </xsl:attribute>
            <xsl:attribute name="alt"></xsl:attribute>
          </xsl:element>
        </th>
        <th id="top"></th>
        <th id="top-right"></th>
      </tr>
    </thead>
    <tfoot>
      <tr>
        <th id="bottom-left"></th>
        <th id="bottom"></th>
        <th id="bottom-right">
          <xsl:element name="img">
            <xsl:attribute name="src">
              <xsl:call-template name="blankicon-path"/>
            </xsl:attribute>
            <xsl:attribute name="alt"></xsl:attribute>
          </xsl:element>
        </th>
      </tr>
    </tfoot>
  </xsl:template>

  <xsl:template name="left-side">
    <th id="left"></th>
  </xsl:template>

  <xsl:template name="right-side">
    <th id="right"></th>
  </xsl:template>

  <xsl:template name="feed-links">
    <link rel="alternate" type="application/rss+xml" href="?Insurrection=rss" title="The RSS feed for this directory in the repository"/>
    <link rel="service.feed" type="application/x.atom+xml" href="?Insurrection=atom" title="The Atom feed for this directory in the repository"/>
  </xsl:template>

  <xsl:template name="footer-common">
    <xsl:text>Powered by </xsl:text>
    <a title="Insurrection Web Tools for Subversion" href="http://svn.code-host.net/project.html" target="_new">Insurrection</a>
    <xsl:text> &amp; </xsl:text>
    <a title="Subversion: The Version Control System" href="http://subversion.apache.org/" target="_new">Subversion</a>
  </xsl:template>

  <xsl:template name="footer">
    <div class="footer" title="$Id$">
      <a title="Valid XML 1.0!" href="http://validator.w3.org/check?uri=referer">
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="xmlicon-path"/>
          </xsl:attribute>
          <xsl:attribute name="alt">Valid XML 1.0!</xsl:attribute>
        </xsl:element>
      </a>
      <xsl:call-template name="footer-common"/>
    </div>
  </xsl:template>

  <xsl:template name="footer-noXML">
    <div class="footer" title="$Id$">
      <xsl:call-template name="footer-common"/>
    </div>
  </xsl:template>

  <!-- ******************************************************************************************************************* -->
  <!-- This is the template for the SVN index browsing -->
  <xsl:template match="svn">
    <html>
      <head>
        <title>
          <xsl:if test="string-length(index/@name) != 0">
            <xsl:value-of select="index/@name"/>
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="index/@path"/>
        </title>
        <xsl:call-template name="feed-links"/>
        <xsl:call-template name="header"/>
      </head>
      <body>
        <table id="pagetable" cellpadding="0" cellspacing="0">
          <xsl:call-template name="top-bottom"/>
          <tbody>
            <tr>
              <xsl:call-template name="left-side"/>
              <td id="content">
                <xsl:call-template name="banner"/>
                <xsl:apply-templates select="index"/>
                <xsl:call-template name="footer"/>
              </td>
              <xsl:call-template name="right-side"/>
            </tr>
          </tbody>
        </table>

        <!-- Some hidden images for the Javascript to access by Id -->
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="closedicon-path"/>
          </xsl:attribute>
          <xsl:attribute name="id">closedImage</xsl:attribute>
          <xsl:attribute name="style">display: none</xsl:attribute>
          <xsl:attribute name="alt"></xsl:attribute>
        </xsl:element>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="openingicon-path"/>
          </xsl:attribute>
          <xsl:attribute name="id">openingImage</xsl:attribute>
          <xsl:attribute name="style">display: none</xsl:attribute>
          <xsl:attribute name="alt"></xsl:attribute>
        </xsl:element>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="openedicon-path"/>
          </xsl:attribute>
          <xsl:attribute name="id">openedImage</xsl:attribute>
          <xsl:attribute name="style">display: none</xsl:attribute>
          <xsl:attribute name="alt"></xsl:attribute>
        </xsl:element>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="diricon-path"/>
          </xsl:attribute>
          <xsl:attribute name="id">dirImage</xsl:attribute>
          <xsl:attribute name="style">display: none</xsl:attribute>
          <xsl:attribute name="alt"></xsl:attribute>
        </xsl:element>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="fileicon-path"/>
          </xsl:attribute>
          <xsl:attribute name="id">fileImage</xsl:attribute>
          <xsl:attribute name="style">display: none</xsl:attribute>
          <xsl:attribute name="alt"></xsl:attribute>
        </xsl:element>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="infoicon-path"/>
          </xsl:attribute>
          <xsl:attribute name="id">infoImage</xsl:attribute>
          <xsl:attribute name="style">display: none</xsl:attribute>
          <xsl:attribute name="alt"></xsl:attribute>
        </xsl:element>
        <xsl:element name="img">
          <xsl:attribute name="src">
            <xsl:call-template name="spacericon-path"/>
          </xsl:attribute>
          <xsl:attribute name="id">spacerImage</xsl:attribute>
          <xsl:attribute name="style">display: none</xsl:attribute>
          <xsl:attribute name="alt"></xsl:attribute>
        </xsl:element>

        <xsl:element name="script">
          <xsl:attribute name="type">text/javascript</xsl:attribute>
          <xsl:attribute name="language">JavaScript</xsl:attribute>
          <xsl:if test="string-length(index/@rev) != 0">
            <xsl:text>document.InsurrectionRev=</xsl:text>
            <xsl:value-of select="index/@rev"/>
            <xsl:text>;</xsl:text>
          </xsl:if>
          <!-- If there is a local banner defined, have the JS load it -->
          <xsl:if test="index/file[@href = '.svn_index']">
            <xsl:text>loadBanner('.svn_index');</xsl:text>
          </xsl:if>
        </xsl:element>

      </body>
    </html>
  </xsl:template>

  <!-- Make a relative link string for the top directory given a relative path -->
  <xsl:template name="pathlink">
    <xsl:param name="path"/>
    <xsl:if test="$path = '/'">.</xsl:if>
    <xsl:if test="$path != '/'">
      <xsl:if test="contains($path,'/')">
        <xsl:text>../</xsl:text>
        <xsl:call-template name="pathlink">
          <xsl:with-param name="path" select="substring-after($path,'/')"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- This builds a directory/URL path string with links for each element -->
  <xsl:template name="pathtree">
    <xsl:param name="path"/>
    <xsl:param name="rev"/>
    <xsl:if test="$path = '/'">
      <xsl:text>/</xsl:text>
    </xsl:if>
    <xsl:if test="$path != '/'">
      <xsl:if test="contains($path,'/')">
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:call-template name="pathlink">
              <xsl:with-param name="path" select="$path"/>
            </xsl:call-template>
            <xsl:if test="string-length($rev) != 0">
              <xsl:text>?r</xsl:text>
              <xsl:value-of select="$rev"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:if test="substring-before($path,'/') = ''">
            <xsl:text>&lt;root&gt;</xsl:text>
          </xsl:if>
          <xsl:value-of select="substring-before($path,'/')"/>
          <xsl:text>/</xsl:text>
        </xsl:element>
        <xsl:call-template name="pathtree">
          <xsl:with-param name="path" select="substring-after($path,'/')"/>
          <xsl:with-param name="rev" select="$rev"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="not(contains($path,'/'))">
        <xsl:element name="a">
          <xsl:attribute name="href"/>
          <xsl:value-of select="$path"/>
        </xsl:element>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- The index node contains the path information for an SVN index XML page. -->
  <xsl:template match="index">
    <div class="svn">

      <!-- If there is a local banner defined, have the JS load it here and make it visible -->
      <div id="localbanner"/>

      <!-- I could not come up with a non-table way to render this the way I wanted -->
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr class="pathrow">
          <td class="foldspace">
            <xsl:element name="img">
              <xsl:attribute name="class">dirarrow</xsl:attribute>
              <xsl:attribute name="align">middle</xsl:attribute>
              <xsl:attribute name="onclick">foldDir(this)</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:text>/</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="src">
                <xsl:call-template name="openedicon-path"/>
              </xsl:attribute>
              <xsl:attribute name="title">Collapse directory</xsl:attribute>
              <xsl:attribute name="alt">Collapse directory</xsl:attribute>
            </xsl:element>
          </td>
          <td class="path">
            <xsl:element name="img">
              <xsl:attribute name="alt">Folder</xsl:attribute>
              <xsl:attribute name="class">svnentryicon</xsl:attribute>
              <xsl:attribute name="align">middle</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:if test="string-length(@rev) = 0">
                  <xsl:call-template name="diricon-path"/>
                </xsl:if>
                <xsl:if test="string-length(@rev) != 0">
                  <xsl:call-template name="pasticon-path"/>
                </xsl:if>
              </xsl:attribute>
            </xsl:element>
            <xsl:call-template name="pathtree">
              <xsl:with-param name="path" select="@path"/>
              <xsl:with-param name="rev" select="@rev"/>
            </xsl:call-template>
          </td>
          <td class="rev">
            <xsl:if test="string-length(@name) != 0">
              <xsl:value-of select="@name"/>
              <xsl:text> - </xsl:text>
            </xsl:if>
            <xsl:if test="string-length(@rev) = 0">
              <xsl:text> - </xsl:text>
            </xsl:if>
            <xsl:if test="string-length(@rev) != 0">
              <xsl:text>as of revision </xsl:text>
              <xsl:value-of select="@rev"/>
            </xsl:if>
          </td>
          <xsl:if test="string-length(@rev) = 0">
            <td class="showlog">
              <xsl:element name="a">
                <xsl:attribute name="title">Atom Feed of activity in this directory</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:text>?Insurrection=atom</xsl:text>
                </xsl:attribute>
                <xsl:element name="img">
                  <xsl:attribute name="align">middle</xsl:attribute>
                  <xsl:attribute name="alt">Atom Feed of activity in this directory</xsl:attribute>
                  <xsl:attribute name="src">
                    <xsl:call-template name="atomicon-path"/>
                  </xsl:attribute>
                </xsl:element>
              </xsl:element>
            </td>
            <td class="showlog">
              <xsl:element name="a">
                <xsl:attribute name="title">RSS Feed of activity in this directory</xsl:attribute>
                <xsl:attribute name="href">
                  <xsl:text>?Insurrection=rss</xsl:text>
                </xsl:attribute>
                <xsl:element name="img">
                  <xsl:attribute name="align">middle</xsl:attribute>
                  <xsl:attribute name="alt">RSS Feed of activity in this directory</xsl:attribute>
                  <xsl:attribute name="src">
                    <xsl:call-template name="rssicon-path"/>
                  </xsl:attribute>
                </xsl:element>
              </xsl:element>
            </td>
          </xsl:if>
          <td class="showlog">
            <xsl:if test="string-length(@rev) != 0">
              <xsl:attribute name="colspan">3</xsl:attribute>
            </xsl:if>
            <xsl:element name="a">
              <xsl:attribute name="title">Show revision history for this directory</xsl:attribute>
              <xsl:attribute name="href">
                <xsl:text>?Insurrection=log</xsl:text>
                <xsl:if test="string-length(@rev) != 0">
                  <xsl:text>&amp;r1=</xsl:text>
                  <xsl:value-of select="@rev"/>
                </xsl:if>
              </xsl:attribute>
              <xsl:element name="img">
                <xsl:attribute name="align">middle</xsl:attribute>
                <xsl:attribute name="alt">Show revision history for this directory</xsl:attribute>
                <xsl:attribute name="src">
                  <xsl:call-template name="infoicon-path"/>
                </xsl:attribute>
              </xsl:element>
            </xsl:element>
          </td>
        </tr>
        <tr id=".//">
          <td>
            <xsl:element name="img">
              <xsl:attribute name="alt"></xsl:attribute>
              <xsl:attribute name="src">
                <xsl:call-template name="spacericon-path"/>
              </xsl:attribute>
            </xsl:element>
          </td>
          <td colspan="5" id="./">
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
              <!-- I want directories displayed before files -->
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
          <xsl:attribute name="alt"></xsl:attribute>
          <xsl:attribute name="class">dirarrow</xsl:attribute>
          <xsl:attribute name="align">middle</xsl:attribute>
          <xsl:attribute name="src">
            <xsl:call-template name="closedicon-path"/>
          </xsl:attribute>
          <xsl:attribute name="title">Expand directory</xsl:attribute>
          <xsl:attribute name="onclick">loadDir(this)</xsl:attribute>
          <xsl:attribute name="id">
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@href"/>
          </xsl:attribute>
        </xsl:element>
      </td>
      <td class="pathname">
        <xsl:element name="a">
          <xsl:attribute name="title">
            <xsl:text>Go to directory "</xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>"</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
            <xsl:if test="string-length(../@rev) != 0">
              <xsl:text>?r</xsl:text>
              <xsl:value-of select="../@rev"/>
            </xsl:if>
          </xsl:attribute>
          <div class="dir">
            <!-- If we have extended info, put it here -->
            <xsl:if test="string-length(@revision) != 0">
              <span class="revinfo-date">
                <xsl:value-of select="@date"/>
              </span>
              <span class="revinfo-rev">
                <xsl:text>r</xsl:text>
                <xsl:value-of select="@revision"/>
              </span>
              <span class="revinfo-author">
                <xsl:value-of select="@author"/>
              </span>
            </xsl:if>
            <xsl:element name="img">
              <xsl:attribute name="alt">Folder</xsl:attribute>
              <xsl:attribute name="class">svnentryicon</xsl:attribute>
              <xsl:attribute name="align">middle</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:call-template name="diricon-path"/>
              </xsl:attribute>
            </xsl:element>
            <xsl:value-of select="@name"/>
            <xsl:text>/</xsl:text>
          </div>
        </xsl:element>
      </td>
      <td class="showlog">
        <xsl:element name="a">
          <xsl:attribute name="title">
            <xsl:text>Show revision history for directory "</xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>"</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
            <xsl:text>?Insurrection=log</xsl:text>
            <xsl:if test="string-length(../@rev) != 0">
              <xsl:text>&amp;r1=</xsl:text>
              <xsl:value-of select="../@rev"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Show revision history for directory "</xsl:text>
              <xsl:value-of select="@name"/>
              <xsl:text>"</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="src">
              <xsl:call-template name="infoicon-path"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:element>
      </td>
    </tr>
    <!-- The hidden row for expanding the directory "in place" -->
    <xsl:element name="tr">
      <xsl:attribute name="style">display: none</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:text>./</xsl:text>
        <xsl:value-of select="@href"/>
        <xsl:text>/</xsl:text>
      </xsl:attribute>
      <td class="foldspace">
        <xsl:element name="img">
          <xsl:attribute name="alt"></xsl:attribute>
          <xsl:attribute name="src">
            <xsl:call-template name="spacericon-path"/>
          </xsl:attribute>
        </xsl:element>
      </td>
      <xsl:element name="td">
        <xsl:attribute name="colspan">2</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:text>./</xsl:text>
          <xsl:value-of select="@href"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="file">
    <tr class="filerow">
      <td class="foldspace">
        <xsl:element name="img">
          <xsl:attribute name="alt"></xsl:attribute>
          <xsl:attribute name="src">
            <xsl:call-template name="spacericon-path"/>
          </xsl:attribute>
        </xsl:element>
      </td>
      <td class="pathname">
        <xsl:element name="a">
          <xsl:attribute name="title">
            <xsl:text>Get </xsl:text>
            <xsl:if test="string-length(../@rev) = 0">
              <xsl:text>latest version of </xsl:text>
            </xsl:if>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>"</xsl:text>
            <xsl:if test="string-length(../@rev) != 0">
              <xsl:text> as of revision </xsl:text>
              <xsl:value-of select="../@rev"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
            <xsl:if test="string-length(../@rev) != 0">
              <xsl:text>?r</xsl:text>
              <xsl:value-of select="../@rev"/>
            </xsl:if>
          </xsl:attribute>
          <div class="file">
            <xsl:if test="string-length(@revision) != 0">
              <span class="revinfo-date">
                <xsl:value-of select="@date"/>
              </span>
              <span class="revinfo-rev">
                <xsl:text>r</xsl:text>
                <xsl:value-of select="@revision"/>
              </span>
              <span class="revinfo-author">
                <xsl:value-of select="@author"/>
              </span>
            </xsl:if>
            <xsl:element name="img">
              <xsl:attribute name="alt">File</xsl:attribute>
              <xsl:attribute name="class">svnentryicon</xsl:attribute>
              <xsl:attribute name="align">middle</xsl:attribute>
              <xsl:attribute name="src">
                <xsl:call-template name="fileicon-path"/>
              </xsl:attribute>
            </xsl:element>
            <xsl:value-of select="@name"/>
          </div>
        </xsl:element>
      </td>
      <td class="showlog">
        <xsl:element name="a">
          <xsl:attribute name="title">
            <xsl:text>Show revision history for file "</xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>"</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
            <xsl:text>?Insurrection=log</xsl:text>
            <xsl:if test="string-length(../@rev) != 0">
              <xsl:text>&amp;r1=</xsl:text>
              <xsl:value-of select="../@rev"/>
            </xsl:if>
          </xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="align">middle</xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Show revision history for file "</xsl:text>
              <xsl:value-of select="@name"/>
              <xsl:text>"</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="src">
              <xsl:call-template name="infoicon-path"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:element>
      </td>
    </tr>
  </xsl:template>

  <!-- ******************************************************************************************************************* -->
  <!-- This is the template for the SVN log output -->
  <xsl:template match="log">
    <html>
      <head>
        <title>
          <xsl:text>Change log - </xsl:text>
          <xsl:value-of select="@repository"/>
          <xsl:text> - </xsl:text>
          <xsl:value-of select="@path"/>
          <xsl:text> - revision </xsl:text>
          <xsl:value-of select="logentry/@revision"/>
        </title>
        <xsl:call-template name="header"/>
      </head>
      <body>
        <table id="pagetable" cellpadding="0" cellspacing="0">
          <xsl:call-template name="top-bottom"/>
          <tbody>
            <tr>
              <xsl:call-template name="left-side"/>
              <td id="content">
                <xsl:call-template name="banner"/>
                <table class="revision" cellspacing="0">
                  <thead>
                    <tr class="logtitle">
                      <th colspan="3">
                        <xsl:value-of select="@repository"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="@path"/>
                      </th>
                    </tr>
                    <tr class="logtitle">
                      <th colspan="3">
                          <xsl:text>Change log of revision</xsl:text>
                          <xsl:if test="count(logentry) != 1">
                            <xsl:text>s</xsl:text>
                          </xsl:if>
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="logentry/@revision"/>
                          <xsl:if test="count(logentry) != 1">
                            <xsl:text> through </xsl:text>
                            <xsl:value-of select="logentry[last()]/@revision"/>
                          </xsl:if>
                      </th>
                    </tr>
                    <tr class="logheader" onclick="toggleAll();">
                      <th class="logheader1">Rev</th>
                      <th class="logheader1">Author</th>
                      <th class="logheader1" width="99%">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <th class="logheader1">Details</th>
                            <th class="revcount" nowrap="1">
                              <xsl:text>(</xsl:text>
                              <xsl:value-of select="count(logentry)"/>
                              <xsl:text> revision</xsl:text>
                              <xsl:if test="count(logentry) != 1">
                                <xsl:text>s</xsl:text>
                              </xsl:if>
                              <xsl:text>)</xsl:text>
                            </th>
                            <th id="details">
                            </th>
                          </tr>
                        </table>
                      </th>
                    </tr>
                  </thead>

                  <tbody>
                    <!-- We pull of of the log entries here    -->
                    <!-- Note that the table format must match -->
                    <xsl:apply-templates select="logentry"/>
                  </tbody>

                </table>

                <!-- If we have a morelog tag, we need to provide a way to get it -->
                <xsl:apply-templates select="morelog"/>

                <xsl:call-template name="footer"/>
              </td>
              <xsl:call-template name="right-side"/>
            </tr>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>

  <!-- For more log entries (older) we have this template -->
  <xsl:template match="morelog">
    <div class="morelog">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:text>next page...</xsl:text>
      </xsl:element>
    </div>
  </xsl:template>

  <!-- revision log entries are handled in this template... -->
  <xsl:template match="logentry">
    <xsl:variable name="date">
      <xsl:value-of select="date"/>
    </xsl:variable>
    <tr><td class="spacer" colspan="3"></td></tr>
    <xsl:element name="tr">
      <xsl:attribute name="class">revision</xsl:attribute>
      <xsl:element name="th">
        <xsl:attribute name="class">revision</xsl:attribute>
        <xsl:value-of select="@revision"/>
        <br/>
        <xsl:element name="a">
          <xsl:attribute name="class">browsepast</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="../@rpath"/>
            <xsl:text>/?r</xsl:text>
            <xsl:value-of select="@revision"/>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:text>Browse repository at revision </xsl:text>
            <xsl:value-of select="@revision"/>
          </xsl:attribute>
          <xsl:element name="img">
            <xsl:attribute name="alt">
              <xsl:text>Browse repository at revision </xsl:text>
              <xsl:value-of select="@revision"/>
            </xsl:attribute>
            <xsl:attribute name="src">
              <xsl:call-template name="pasticon-path"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:element>

      </xsl:element>
      <xsl:element name="td">
        <xsl:attribute name="class">user</xsl:attribute>
        <xsl:attribute name="title">Show / hide details</xsl:attribute>
        <xsl:attribute name="onclick">
          <xsl:text>toggle(</xsl:text>
          <xsl:value-of select="@revision"/>
          <xsl:text>);</xsl:text>
        </xsl:attribute>
        <xsl:if test="contains(author,'@')">
          <xsl:value-of select="substring-before(author,'@')"/>
          <div class="user">
            <xsl:element name="img">
              <xsl:attribute name="src">
                <xsl:call-template name="aticon-path"/>
              </xsl:attribute>
              <xsl:attribute name="class">user</xsl:attribute>
              <xsl:attribute name="alt">at</xsl:attribute>
            </xsl:element>
            <xsl:value-of select="substring-after(author,'@')"/>
          </div>
        </xsl:if>
        <xsl:if test="not(contains(author,'@'))">
          <xsl:value-of select="author"/>
        </xsl:if>
      </xsl:element>
      <xsl:element name="td">
        <xsl:attribute name="class">details</xsl:attribute>
        <xsl:element name="div">
          <xsl:attribute name="title">Show / hide details</xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:text>toggle(</xsl:text>
            <xsl:value-of select="@revision"/>
            <xsl:text>);</xsl:text>
          </xsl:attribute>
          <xsl:variable name="pathcount">
            <xsl:value-of select="count(paths/path)"/>
          </xsl:variable>
          <xsl:if test="$pathcount &gt; 0">
            <xsl:element name="span">
              <xsl:attribute name="class">revstat</xsl:attribute>
              <xsl:element name="span">
                <xsl:attribute name="class">revstatdetails</xsl:attribute>
                <xsl:variable name="pathcountA">
                  <xsl:value-of select="count(paths/path[@action = 'A'])"/>
                </xsl:variable>
                <xsl:if test="$pathcountA &gt; 0">
                  <xsl:text> | A:</xsl:text>
                  <xsl:value-of select="$pathcountA"/>
                </xsl:if>
                <xsl:variable name="pathcountD">
                  <xsl:value-of select="count(paths/path[@action = 'D'])"/>
                </xsl:variable>
                <xsl:if test="$pathcountD &gt; 0">
                  <xsl:text> | D:</xsl:text>
                  <xsl:value-of select="$pathcountD"/>
                </xsl:if>
                <xsl:variable name="pathcountM">
                  <xsl:value-of select="count(paths/path[@action = 'M'])"/>
                </xsl:variable>
                <xsl:if test="$pathcountM &gt; 0">
                  <xsl:text> | M:</xsl:text>
                  <xsl:value-of select="$pathcountM"/>
                </xsl:if>
                <xsl:variable name="pathcountR">
                  <xsl:value-of select="count(paths/path[@action = 'R'])"/>
                </xsl:variable>
                <xsl:if test="$pathcountR &gt; 0">
                  <xsl:text> | R:</xsl:text>
                  <xsl:value-of select="$pathcountR"/>
                </xsl:if>
                <xsl:text> |</xsl:text>
              </xsl:element>
              <xsl:text>(</xsl:text>
              <xsl:value-of select="$pathcount"/>
              <xsl:text> item</xsl:text>
              <xsl:if test="$pathcount &gt; 1">
                <xsl:text>s</xsl:text>
              </xsl:if>
              <xsl:text>)</xsl:text>
            </xsl:element>
          </xsl:if>
          <span class="revdate">
            <xsl:value-of select="substring-before($date,'T')"/>
            <span>
              <xsl:text>at </xsl:text>
              <xsl:value-of select="substring-before(substring-after($date,'T'),'.')"/>
              <xsl:text> GMT</xsl:text>
            </span>
          </span>
          <div class="logmsg">
            <xsl:if test="/log/@editlog = 1">
              <xsl:element name="img">
                <xsl:attribute name="src">
                  <xsl:call-template name="editicon-path"/>
                </xsl:attribute>
                <xsl:attribute name="class">editlog</xsl:attribute>
                <xsl:attribute name="alt">Edit log message</xsl:attribute>
                <xsl:attribute name="title">Edit log message</xsl:attribute>
                <xsl:attribute name="onclick">
                  <xsl:text>editLog(this,</xsl:text>
                  <xsl:value-of select="@revision"/>
                  <xsl:text>);</xsl:text>
                </xsl:attribute>
              </xsl:element>
              <xsl:element name="div">
                <xsl:attribute name="id">
                  <xsl:text>Log:</xsl:text>
                  <xsl:value-of select="@revision"/>
                </xsl:attribute>
                <xsl:call-template name="lf2br">
                  <xsl:with-param name="StringToTransform" select="msg"/>
                </xsl:call-template>
              </xsl:element>
              <xsl:element name="div">
                <xsl:attribute name="id">
                  <xsl:text>LogEdit:</xsl:text>
                  <xsl:value-of select="@revision"/>
                </xsl:attribute>
                <xsl:attribute name="class"><xsl:text>logedit</xsl:text></xsl:attribute>
                <xsl:element name="textarea">
                  <xsl:attribute name="id">
                    <xsl:text>LogEd:</xsl:text>
                    <xsl:value-of select="@revision"/>
                  </xsl:attribute>
                  <xsl:attribute name="class">propedit</xsl:attribute>
                  <xsl:attribute name="title">Log message editor</xsl:attribute>
                  <xsl:attribute name="cols">70</xsl:attribute>
                  <xsl:attribute name="rows">8</xsl:attribute>
                  <xsl:attribute name="wrap">on</xsl:attribute>
                </xsl:element>
                <br/>
                <xsl:element name="img">
                  <xsl:attribute name="src">
                    <xsl:call-template name="previewicon-path"/>
                  </xsl:attribute>
                  <xsl:attribute name="class">previewlog</xsl:attribute>
                  <xsl:attribute name="alt">Preview log message</xsl:attribute>
                  <xsl:attribute name="title">Preview log message</xsl:attribute>
                  <xsl:attribute name="onclick">
                    <xsl:text>previewLog(</xsl:text>
                    <xsl:value-of select="@revision"/>
                    <xsl:text>);</xsl:text>
                  </xsl:attribute>
                </xsl:element>
                <xsl:element name="img">
                  <xsl:attribute name="src">
                    <xsl:call-template name="saveicon-path"/>
                  </xsl:attribute>
                  <xsl:attribute name="class">savelog</xsl:attribute>
                  <xsl:attribute name="alt">Save log message</xsl:attribute>
                  <xsl:attribute name="title">Save log message</xsl:attribute>
                  <xsl:attribute name="onclick">
                    <xsl:text>saveLog(</xsl:text>
                    <xsl:value-of select="@revision"/>
                    <xsl:text>);</xsl:text>
                  </xsl:attribute>
                </xsl:element>
                <xsl:element name="img">
                  <xsl:attribute name="src">
                    <xsl:call-template name="cancelicon-path"/>
                  </xsl:attribute>
                  <xsl:attribute name="class">cancellog</xsl:attribute>
                  <xsl:attribute name="alt">Cancel log message edit</xsl:attribute>
                  <xsl:attribute name="title">Cancel log message edit</xsl:attribute>
                  <xsl:attribute name="onclick">
                    <xsl:text>cancelLog(</xsl:text>
                    <xsl:value-of select="@revision"/>
                    <xsl:text>);</xsl:text>
                  </xsl:attribute>
                </xsl:element>
              </xsl:element>
            </xsl:if>
            <xsl:if test="not(/log/@editlog = 1)">
              <xsl:call-template name="lf2br">
                <xsl:with-param name="StringToTransform" select="msg"/>
              </xsl:call-template>
            </xsl:if>
          </div>
        </xsl:element>

        <!-- If we have any paths, use this template -->
        <xsl:apply-templates select="paths"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- The paths entry may have one or more path entries. -->
  <!-- Here we handle each, including sorting them into   -->
  <!-- the order we like.  (Type and then filename)       -->
  <xsl:template match="paths">
    <xsl:element name="div">
      <xsl:attribute name="class">paths</xsl:attribute>
      <xsl:attribute name="id">
        <xsl:text>:</xsl:text>
        <xsl:value-of select="../@revision"/>
      </xsl:attribute>
      <xsl:attribute name="style">display: none;</xsl:attribute>
      <xsl:for-each select="path">
        <xsl:sort select="@action"/>
        <xsl:sort select="."/>
        <xsl:element name="div">
          <xsl:attribute name="class">pathline</xsl:attribute>
          <xsl:attribute name="title">Show menu of operations</xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:text>detailClick('</xsl:text>
            <xsl:value-of select="../../../@repository"/>
            <xsl:text>','</xsl:text>
            <xsl:value-of select="@action"/>
            <xsl:text>','</xsl:text>
            <xsl:call-template name="url-encode">
              <xsl:with-param name="str" select="."/>
            </xsl:call-template>
            <xsl:text>','</xsl:text>
            <xsl:value-of select="../../@revision"/>
            <xsl:text>','</xsl:text>
            <xsl:value-of select="../../../logentry[1]/@revision"/>
            <xsl:text>');</xsl:text>
          </xsl:attribute>
          <xsl:element name="div">
            <xsl:attribute name="class">pathaction</xsl:attribute>
            <xsl:value-of select="@action"/>
          </xsl:element>
          <xsl:element name="div">
            <xsl:attribute name="class">pathfile</xsl:attribute>
            <xsl:value-of select="."/>
            <xsl:if test="@copyfrom-path">
              <xsl:element name="span">
                <xsl:attribute name="class">copyfrom</xsl:attribute>
                <xsl:element name="span">
                  <xsl:attribute name="class">copyfromnote</xsl:attribute>
                  <xsl:text>from: </xsl:text>
                </xsl:element>
                <xsl:value-of select="@copyfrom-path"/>
                <xsl:if test="@copyfrom-rev">
                  <xsl:element name="span">
                    <xsl:attribute name="class">copyfromnote</xsl:attribute>
                    <xsl:text> rev </xsl:text>
                    <xsl:value-of select="@copyfrom-rev"/>
                  </xsl:element>
                </xsl:if>
              </xsl:element>
            </xsl:if>
            <br/>
            <xsl:element name="div">
              <xsl:attribute name="class">pathpopup</xsl:attribute>
              <xsl:attribute name="onmouseover">onPopup(this);</xsl:attribute>
              <xsl:attribute name="onmouseout">offPopup(this);</xsl:attribute>
              <xsl:attribute name="id">
                <xsl:call-template name="url-encode">
                  <xsl:with-param name="str" select="."/>
                </xsl:call-template>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="../../@revision"/>
              </xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="language">JavaScript</xsl:attribute>
      <xsl:text>addDetail(</xsl:text>
      <xsl:value-of select="../@revision"/>
      <xsl:text>);</xsl:text>
    </xsl:element>
  </xsl:template>

  <!-- template converts LF to <br/> - very useful for the log output -->
  <xsl:template name="lf2br">
    <xsl:param name="StringToTransform"/>
    <xsl:choose>
      <!-- string contains linefeed -->
      <xsl:when test="contains($StringToTransform,'&#xA;')">
        <xsl:value-of select="substring-before($StringToTransform,'&#xA;')"/>
        <br/>
        <xsl:call-template name="lf2br">
          <xsl:with-param name="StringToTransform">
            <xsl:value-of select="substring-after($StringToTransform,'&#xA;')"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <!-- string does not contain newline, so just output it -->
      <xsl:otherwise>
        <xsl:value-of select="$StringToTransform"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- A URL Encoding trick - makes %xx encodings of non-safe characters -->
  <!-- Note that this currently only does byte characters from 32 - 255. -->
  <xsl:variable name="chars">
    <xsl:text>&#032;&#033;&#034;&#035;&#036;&#037;&#038;&#039;</xsl:text>
    <xsl:text>&#040;&#041;&#042;&#043;&#044;&#045;&#046;&#047;</xsl:text>
    <xsl:text>&#048;&#049;&#050;&#051;&#052;&#053;&#054;&#055;</xsl:text>
    <xsl:text>&#056;&#057;&#058;&#059;&#060;&#061;&#062;&#063;</xsl:text>
    <xsl:text>&#064;&#065;&#066;&#067;&#068;&#069;&#070;&#071;</xsl:text>
    <xsl:text>&#072;&#073;&#074;&#075;&#076;&#077;&#078;&#079;</xsl:text>
    <xsl:text>&#080;&#081;&#082;&#083;&#084;&#085;&#086;&#087;</xsl:text>
    <xsl:text>&#088;&#089;&#090;&#091;&#092;&#093;&#094;&#095;</xsl:text>
    <xsl:text>&#096;&#097;&#098;&#099;&#100;&#101;&#102;&#103;</xsl:text>
    <xsl:text>&#104;&#105;&#106;&#107;&#108;&#109;&#110;&#111;</xsl:text>
    <xsl:text>&#112;&#113;&#114;&#115;&#116;&#117;&#118;&#119;</xsl:text>
    <xsl:text>&#120;&#121;&#122;&#123;&#124;&#125;&#126;&#127;</xsl:text>
    <xsl:text>&#128;&#129;&#130;&#131;&#132;&#133;&#134;&#135;</xsl:text>
    <xsl:text>&#136;&#137;&#138;&#139;&#140;&#141;&#142;&#143;</xsl:text>
    <xsl:text>&#144;&#145;&#146;&#147;&#148;&#149;&#150;&#151;</xsl:text>
    <xsl:text>&#152;&#153;&#154;&#155;&#156;&#157;&#158;&#159;</xsl:text>
    <xsl:text>&#160;&#161;&#162;&#163;&#164;&#165;&#166;&#167;</xsl:text>
    <xsl:text>&#168;&#169;&#170;&#171;&#172;&#173;&#174;&#175;</xsl:text>
    <xsl:text>&#176;&#177;&#178;&#179;&#180;&#181;&#182;&#183;</xsl:text>
    <xsl:text>&#184;&#185;&#186;&#187;&#188;&#189;&#190;&#191;</xsl:text>
    <xsl:text>&#192;&#193;&#194;&#195;&#196;&#197;&#198;&#199;</xsl:text>
    <xsl:text>&#200;&#201;&#202;&#203;&#204;&#205;&#206;&#207;</xsl:text>
    <xsl:text>&#208;&#209;&#210;&#211;&#212;&#213;&#214;&#215;</xsl:text>
    <xsl:text>&#216;&#217;&#218;&#219;&#220;&#221;&#222;&#223;</xsl:text>
    <xsl:text>&#224;&#225;&#226;&#227;&#228;&#229;&#230;&#231;</xsl:text>
    <xsl:text>&#232;&#233;&#234;&#235;&#236;&#237;&#238;&#239;</xsl:text>
    <xsl:text>&#240;&#241;&#242;&#243;&#244;&#245;&#246;&#247;</xsl:text>
    <xsl:text>&#248;&#249;&#250;&#251;&#252;&#253;&#254;&#255;</xsl:text>
  </xsl:variable>

  <!-- Characters that usually don't need to be escaped -->
  <xsl:variable name="safe">
    <xsl:text>/-_.</xsl:text>
    <xsl:text>0123456789</xsl:text>
    <xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text>
    <xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text>
  </xsl:variable>

  <!-- Hex characters we will use -->
  <xsl:variable name="hex">0123456789ABCDEF</xsl:variable>

  <xsl:template name="url-encode">
    <xsl:param name="str"/>
    <xsl:if test="$str">
      <xsl:variable name="firstchar" select="substring($str,1,1)"/>
      <xsl:choose>
        <xsl:when test="contains($safe,$firstchar)">
          <xsl:value-of select="$firstchar"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="encodechar">
            <xsl:choose>
              <xsl:when test="contains($chars,$firstchar)">
                <xsl:value-of select="string-length(substring-before($chars,$firstchar)) + 32"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:message terminate="no">Warning: char out of range! Substituting "&#127;".</xsl:message>
                <xsl:text>127</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
        <xsl:variable name="hex-digit1" select="substring($hex,floor($encodechar div 16) + 1,1)"/>
        <xsl:variable name="hex-digit2" select="substring($hex,$encodechar mod 16 + 1,1)"/>
        <xsl:value-of select="concat('%',$hex-digit1,$hex-digit2)"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($str) &gt; 1">
        <xsl:call-template name="url-encode">
          <xsl:with-param name="str" select="substring($str,2)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- ******************************************************************************************************************* -->
  <!-- This is the template for the RSS feed when it happens to be loaded in a browser -->
  <xsl:template match="rss">
    <xsl:apply-templates select="channel"/>
  </xsl:template>

  <xsl:template match="channel">
    <html>
      <head>
        <title>
          <xsl:value-of select="title"/>
        </title>
        <xsl:call-template name="feed-links"/>
        <xsl:call-template name="header"/>
      </head>
      <body>
        <table id="pagetable" cellpadding="0" cellspacing="0">
          <xsl:call-template name="top-bottom"/>
          <tbody>
            <tr>
              <xsl:call-template name="left-side"/>
              <td id="content">
                <xsl:call-template name="banner"/>
                <div class="footer" style="font-size: 16pt; font-weight: bold;">
                  <xsl:text>This XML/RSS data is meant to be read using an RSS viewer.</xsl:text>
                </div>
                <div class="rss-title">
                  <xsl:variable name="tmp" select="description"/>
                  <div>
                    <xsl:variable name="tmp1" select="substring-before($tmp,'. &lt;hr/&gt;')"/>
                    <xsl:value-of select="substring-before($tmp1,' from ')"/>
                    <br/>
                    <xsl:value-of select="substring-after($tmp1,' from ')"/>
                  </div>
                  <xsl:element name="span">
                    <xsl:attribute name="id">title</xsl:attribute>
                    <xsl:attribute name="contents">
                      <xsl:value-of select="substring-after($tmp,'. &lt;hr/&gt;')"/>
                    </xsl:attribute>
                  </xsl:element>
                  <xsl:element name="script">
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <xsl:attribute name="language">JavaScript</xsl:attribute>
                    <xsl:text>function setContents(id) { var x=document.getElementById(id); x.innerHTML = x.getAttribute("contents"); x.removeAttribute("contents"); }</xsl:text>
                    <xsl:text>setContents("title");</xsl:text>
                  </xsl:element>
                </div>
                <xsl:apply-templates select="item"/>
                <xsl:call-template name="footer-noXML"/>
              </td>
              <xsl:call-template name="right-side"/>
            </tr>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="item">
    <div class="rss-item">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="link"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="title"/>
        </xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="alt"></xsl:attribute>
          <xsl:attribute name="src">
            <xsl:call-template name="linkicon-path"/>
          </xsl:attribute>
        </xsl:element>
        <span class="rss-itemtitle">
          <xsl:value-of select="title"/>
        </span>
        <span class="rss-date">
           <xsl:value-of select="pubDate"/>
         </span>
        <span class="rss-author">
          <xsl:text>by </xsl:text>
          <xsl:if test="contains(author,'@')">
            <xsl:value-of select="substring-before(author,'@')"/>
            <xsl:element name="img">
              <xsl:attribute name="src">
                <xsl:call-template name="aticon-path"/>
              </xsl:attribute>
              <xsl:attribute name="class">user</xsl:attribute>
              <xsl:attribute name="alt">at</xsl:attribute>
            </xsl:element>
            <xsl:value-of select="substring-after(author,'@')"/>
          </xsl:if>
          <xsl:if test="not(contains(author,'@'))">
            <xsl:value-of select="author"/>
          </xsl:if>
        </span>
      </xsl:element>
      <xsl:element name="div">
        <xsl:attribute name="class">rss-description</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="title"/>
        </xsl:attribute>
        <xsl:attribute name="contents">
          <xsl:value-of select="description"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:element name="script">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="language">JavaScript</xsl:attribute>
        <xsl:text>setContents("</xsl:text>
        <xsl:value-of select="title"/>
        <xsl:text>");</xsl:text>
      </xsl:element>
   </div>
  </xsl:template>

  <!-- ******************************************************************************************************************* -->
  <!-- This is the template for the Atom 1.x feed when it happens to be loaded in a browser -->
  <xsl:template match="atom:feed">
    <html>
      <head>
        <title>
          <xsl:value-of select="atom:title"/>
        </title>
        <xsl:call-template name="feed-links"/>
        <xsl:call-template name="header"/>
      </head>
      <body>
        <table id="pagetable" cellpadding="0" cellspacing="0">
          <xsl:call-template name="top-bottom"/>
          <tbody>
            <tr>
              <xsl:call-template name="left-side"/>
              <td id="content">
                <xsl:call-template name="banner"/>
                <div class="footer" style="font-size: 16pt; font-weight: bold;">
                  <xsl:text>This XML/Atom data is meant to be read using an Atom viewer.</xsl:text>
                </div>
                <div class="rss-title">
                  <xsl:variable name="tmp" select="atom:subtitle"/>
                  <div>
                    <xsl:variable name="tmp1" select="substring-before($tmp,'. &lt;hr/&gt;')"/>
                    <xsl:value-of select="substring-before($tmp1,' from ')"/>
                    <br/>
                    <xsl:value-of select="substring-after($tmp1,' from ')"/>
                  </div>
                  <xsl:element name="span">
                    <xsl:attribute name="id">title</xsl:attribute>
                    <xsl:attribute name="contents">
                      <xsl:value-of select="substring-after($tmp,'. &lt;hr/&gt;')"/>
                    </xsl:attribute>
                  </xsl:element>
                  <xsl:element name="script">
                    <xsl:attribute name="type">text/javascript</xsl:attribute>
                    <xsl:attribute name="language">JavaScript</xsl:attribute>
                    <xsl:text>function setContents(id) { var x=document.getElementById(id); x.innerHTML = x.getAttribute("contents"); x.removeAttribute("contents"); }</xsl:text>
                    <xsl:text>setContents("title");</xsl:text>
                  </xsl:element>
                </div>
                <xsl:apply-templates select="atom:entry"/>
                <xsl:call-template name="footer-noXML"/>
              </td>
              <xsl:call-template name="right-side"/>
            </tr>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="atom:entry">
    <div class="rss-item">
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="atom:link/@href"/>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:value-of select="atom:title"/>
        </xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="alt"></xsl:attribute>
          <xsl:attribute name="src">
            <xsl:call-template name="linkicon-path"/>
          </xsl:attribute>
        </xsl:element>
        <span class="rss-itemtitle">
          <xsl:value-of select="atom:title"/>
        </span>
        <span class="rss-date">
           <xsl:value-of select="atom:updated"/>
         </span>
        <span class="rss-author">
          <xsl:text>by </xsl:text>
          <xsl:if test="contains(atom:author/atom:name,'@')">
            <xsl:value-of select="substring-before(atom:author/atom:name,'@')"/>
            <xsl:element name="img">
              <xsl:attribute name="src">
                <xsl:call-template name="aticon-path"/>
              </xsl:attribute>
              <xsl:attribute name="class">user</xsl:attribute>
              <xsl:attribute name="alt">at</xsl:attribute>
            </xsl:element>
            <xsl:value-of select="substring-after(atom:author/atom:name,'@')"/>
          </xsl:if>
          <xsl:if test="not(contains(atom:author/atom:name,'@'))">
            <xsl:value-of select="atom:author/atom:name"/>
          </xsl:if>
        </span>
      </xsl:element>
      <xsl:element name="div">
        <xsl:attribute name="class">rss-description</xsl:attribute>
        <xsl:attribute name="id">
          <xsl:value-of select="atom:title"/>
        </xsl:attribute>
        <xsl:attribute name="contents">
          <xsl:value-of select="atom:content"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:element name="script">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="language">JavaScript</xsl:attribute>
        <xsl:text>setContents("</xsl:text>
        <xsl:value-of select="atom:title"/>
        <xsl:text>");</xsl:text>
      </xsl:element>
   </div>
  </xsl:template>


</xsl:stylesheet>
