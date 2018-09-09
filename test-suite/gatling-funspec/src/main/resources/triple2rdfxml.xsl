<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:sem="http://marklogic.com/semantics" exclude-result-prefixes="#all"
  version="3.0">

  <xsl:output indent="yes" omit-xml-declaration="yes"/>

  <xsl:template match="sem:triples">
    <rdf:RDF>
      <xsl:apply-templates/>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="sem:triple">
    <rdf:Description rdf:about="{sem:subject}">
      <xsl:element name="{substring-after(sem:predicate, 'http://')}"
        namespace="{'http:' || '//'}">
        <xsl:attribute name="rdf:resource" select="sem:object"/>
      </xsl:element>
    </rdf:Description>
  </xsl:template>

</xsl:stylesheet>
