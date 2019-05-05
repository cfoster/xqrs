<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="#all"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xqrs="http://consulting.xmllondon.com/xqrs"
  xmlns:xdmp="http://marklogic.com/xdmp"
  xmlns:map="http://marklogic.com/xdmp/map"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xpath-default-namespace="http://marklogic.com/xdmp/error" 
  version="2.0">
  
  <xsl:output method="html" indent="yes" />

  <!-- Whether or not to include Code Snippets in the Stack Trace -->
  <xsl:param name="show-code-snippets" select="fn:true()" />
  
  <!-- Whether or not to include in-scope Variables and their Content -->
  <xsl:param name="show-variables" select="fn:true()"/>
  
  <!-- Show XQRS call stack information -->
  <xsl:param name="show-xqrs-stack" select="fn:false()"/>
  
  <xsl:template match="error">
    <!-- Was this Error directly generated from within the XQRS framework? -->  
    <xsl:variable name="xqrs-internal-error" as="xs:boolean"
      select="matches(name, '.*:XQRS[0-9]+')"/>
    
    <html>
      <head>
        <title>ERROR <xsl:value-of select="code"/></title>
        <meta charset="utf-8"/>
        <link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400italic,400,600,600italic,700,800,800italic"
          rel="stylesheet" type="text/css"/>

        <style>
          <xsl:sequence select="xqrs:css()" />
        </style>
      </head>
      
      <body>
        <div id="content">
          <h1>
            <xsl:value-of select="replace(name, '^rerr:', '')"/>
            <xsl:if test="not($xqrs-internal-error)">
              <xsl:text> - </xsl:text>
              <xsl:value-of select="(code, message)[normalize-space()][1]" />
            </xsl:if>
          </h1>

          <xsl:apply-templates select="format-string"/>
          
          <xsl:if test="$xqrs-internal-error">
            <p>
              <xsl:value-of select="(code, message)[normalize-space()][1]" />
            </p>
          </xsl:if>
            

          <xsl:if test="not($xqrs-internal-error)">
            <xsl:apply-templates select="stack"/>
          </xsl:if>

        </div>
        <footer>
          <hr class="r"/>
          <div id="bb"/>
          <div class="options">
            <div class="column-1">
              <ul style="margin:0; padding:0;">
                
                <li><a href="https://github.com/cfoster/xqrs">XQRS GitHub Project</a></li>
                <li><a href="http://consulting.xmllondon.com/xqrs/docs" target="_blank">XQRS Documentation</a></li>
                <li><a href="http://consulting.xmllondon.com/" target="_blank">XML London Consulting</a></li>
                
              </ul>
            </div>
            <div class="column-2">
              <ul style="margin:0; padding:0;">
                <li><a href="https://xmllondon.com" target="_blank">XML London Events</a></li>
                <li><a href="https://github.com/cfoster/xqrs/issues" target="_blank">Submit a bug</a></li>
              </ul>
            </div>
          </div>
          
          <span class="s">XQuery API for RESTful Web Services (XQRS).
                          Written by Charles Foster.<br/>
            Copyright © 2018
            
            <xsl:sequence select="
              if(year-from-date(current-date()) gt 2018) then
                concat(' - ', year-from-date(current-date()))
              else ()"/>
            
            XML London Limited. All rights reserved.</span>
        </footer>
      </body>
      
    </html>
  </xsl:template>
  
  <xsl:template match="format-string">
    <h3>
      <xsl:apply-templates />
    </h3>
  </xsl:template>
  
  <xsl:template match="stack">
    <xsl:for-each select="frame">
      <xsl:if test="fn:not(
          fn:not($show-xqrs-stack) and
          fn:matches(uri, '/(rest|xqrs|xqrs-test)\.xqy?$', 'i'))">
        <xsl:apply-templates select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template match="frame">
    <h3 class="frame">
      <span class="uri">
        <xsl:value-of select="uri"/>
      </span>
      
      on line
      <span class="line">
        <xsl:value-of select="line"/>
      </span>, column
      <span class="column">
        <xsl:value-of select="column"/>
      </span>.
    </h3>
    
    <xsl:if test="$show-code-snippets and line gt 0">
      <xsl:sequence select="
        xqrs:snippet(fn:tokenize(xqrs:module(uri), '\n'), line, column)"/>
    </xsl:if>
    
    <xsl:if test="$show-variables and variables">
      <h4 class="in-scope-variables">In scope variables</h4>
      <xsl:apply-templates select="variables"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:function name="xqrs:snippet">
    <xsl:param name="string-lines" as="xs:string*"/>
    <xsl:param name="line" as="xs:integer?"/>
    <xsl:param name="column" as="xs:integer?"/>
    
    <pre class="line-numbers">
      <xsl:for-each select="$string-lines">
        <xsl:if test="
          position() gt $line - 5 and
          position() lt $line + 5">
        <span class="line">
          
          <xsl:attribute name="class">
            <xsl:text>line</xsl:text>
            <xsl:if test="position() = $line">
              <xsl:text> highlight</xsl:text>
            </xsl:if>
          </xsl:attribute>
          
          <span class="before">
            <xsl:value-of select="position()"/>
          </span>
          <xsl:choose>
            <xsl:when test="position() = $line">
              
              <xsl:for-each select="fn:string-to-codepoints(.)">
                <xsl:choose>
                  <xsl:when test="position() = $column + 1">
                    <span class="highlight-major">
                      <xsl:value-of select="fn:codepoints-to-string(.)"/>
                    </span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="fn:codepoints-to-string(.)"/>
                  </xsl:otherwise>
                </xsl:choose>
                
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="."/>
            </xsl:otherwise>
          </xsl:choose>

        </span>
          
        </xsl:if>
        
      </xsl:for-each>
    </pre>
    
  </xsl:function>
  
  <xsl:template match="variables">
    <table class="variables">
      <tr>
        <th>Variable name</th>
        <th>Variable value</th>
      </tr>
      <xsl:apply-templates />
    </table>
  </xsl:template>
  
  <xsl:template match="variable">
    <tr>
      <xsl:attribute name="class"
        select="if(position() mod 2 = 0) then 'even' else 'odd'"/>
      <td class="name">
        <code><xsl:value-of select="name"/></code>
      </td>
      <td>
        <code>
          <xsl:value-of select="value"/>
        </code>
      </td>
    </tr>
  </xsl:template>
  
  <xsl:function name="xqrs:css" as="text()">
    <xsl:text>
      html,body {
        margin: 0;
        font-family: "Open Sans", "Helvetica Neue",
                     Helvetica, Arial, sans-serif;
      }
      #content {
        margin-bottom: 170px;
        padding-left: 50px;
      }
      footer {
        background-color: #6d010e;
        background: url(//xmllondon.com/images/bg-pattern-red.png) repeat
                    left top;
        border-top: 5px solid #c3c3c3;
        width: 100%;
        height: 150px;
        bottom: 0px;
        position: fixed;
        color: white;
      }
      #bb {
        position: absolute;
        right: 70px;
        bottom: -50px;
        width: 50px;
        height: 300px;
        background-image: url(//xmllondon.com/logo/big-ben.svg);
      }
      .s {
        color: #b55762;
        position: absolute;
        bottom: 10px;
        left: 50px;
      }
      hr.r {
        border: 0.5px solid #b41b23;
        margin: 0;
      }
      li {
        list-style: none;
      }
      a {
        color: white;
        text-decoration: none;
      }
      a:hover {
        color: #d5d5d5;
      }
      .column-1 {
        position: absolute;
        width: 200px;
        height: 80px;
        left: 50px;
        bottom: 50px;
      }
      .column-2 {
        position: absolute;
        width: 200px;
        height: 80px;
        left: 350px;
        bottom: 50px;
      }

h4.in-scope-variables {
  padding: 0 0 10px;
  margin: 0;
}

pre.line-numbers
{
  counter-reset: linecounter;
}
pre.line-numbers span.line
{
  display: block;
  counter-increment: linecounter;
}
pre.line-numbers span.line.highlight {
  /* background-color: #fffbc3; */
  
  
  background: linear-gradient(to right, #fffbc3, transparent);
}
.highlight-major {
  background-color: #f19292;
}

table.variables {
  width: 80%;
  border-collapse: collapse;
}
table.variables th {
  text-align: left;
}
table.variables td.name {
  width: 150px;
}
pre.line-numbers span.before
{
  width: 30px;
  text-align: right;
  display: inline-block;
  border-right: 1px solid #444444;
  padding-right: 3px;
  margin-right: 4px;
}

tr th {
  text-transform: uppercase;
  font-family: monospace;
}

tr.odd {
  background: linear-gradient(to right, #cccccc, transparent);
}
tr.even {
  background: linear-gradient(to right, #f0f0f0, transparent);
}

    </xsl:text>
  </xsl:function>
  
  <xsl:function name="xqrs:module">
    <xsl:param name="uri"/>
    <xsl:choose>
      <xsl:when test="xdmp:modules-database() = 0">
        <xsl:sequence
          select="xdmp:filesystem-file(concat(xdmp:modules-root(), '/', $uri))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="eval-options" as="element()">
          <options xmlns="xdmp:eval">
            <database>
              <xsl:value-of select="xdmp:modules-database()"/>
            </database>
            <default-xquery-version>1.0-ml</default-xquery-version>
          </options>
        </xsl:variable>
        <xsl:if test="exists($uri)">
          <xsl:sequence select="
            xdmp:eval(
              'declare variable $uri as xs:string external; fn:unparsed-text($uri)',
              (fn:QName('','uri'), $uri),
              $eval-options
            )
            "/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>