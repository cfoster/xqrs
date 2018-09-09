# XQRS
<img align="right" src="http://consulting.xmllondon.com/images/xqrs.svg">
XQRS: XQuery API for RESTful Web Services is a RESTXQ implementation for MarkLogic Server.

It's fast, scales and is light weight at around 1.1k lines of code. You can seamlessly add it to your existing project without it interfering. Support is available on GitHub. RESTXQ enables you to build RESTful services declaratively with XQuery Annotations in the same way as JAX-RS does for Java.



* Supports Read Only / Update Functions
* Supports Multi-Statement Transactions
* Supports Multiple-File uploads from HTML5 Forms
* Supports multipart/mixed requests
* Supports XML, JSON, RDF (all formats), SPARQL Results (all formats)
* Supports Path expressions defined by Regular Expressions
* Supports Content Negotiation and Quality Factors in Accept Headers
* Well Documented with plenty of examples
* Supports Error Handler Functions
* Very Robust. Built against a very rich Test Suite
* 100% Free, Open Source, Apache 2.0 Licence

## RESTXQ resource functions

Create RESTful Services with URIs that work exactly how you want them to 

```xquery
declare
  %rest:path("/factory/warehouse/wheel/{$wheel-id}")
  %rest:GET
function get-wheel($wheel-id as xs:string) {
  fn:doc($wheel-id)
};

declare
  %rest:path("/factory/warehouse/wheel/{$wheel-id}")
  %rest:PUT("{$doc}")
  %xdmp:update
function put-wheel($wheel-id as xs:string, $doc as document-node(element())) {
  xdmp:document-insert($wheel-id, $doc, map:entry("collections", "wheels"))
};

declare
  %rest:path("/factory/warehouse/wheel")
function list-wheels() {
  <wheels>{
    fn:collection("wheels")
  }</wheels>
};```w
