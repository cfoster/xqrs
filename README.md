# [XQRS](http://consulting.xmllondon.com/xqrs) - XQuery API for RESTful Web Services
<img align="right" src="http://consulting.xmllondon.com/images/xqrs.svg">
XQRS is a RESTXQ implementation for MarkLogic Server.

It's fast, scales and is light weight at around 1.1k lines of code. You can seamlessly add it to your existing project without it interfering. Support is available on GitHub. RESTXQ enables you to build RESTful services declaratively with XQuery Annotations in the same way as JAX-RS does for Java.

* Supports [Read Only / Update Functions](http://consulting.xmllondon.com/xqrs/docs/update-transactions)
* Supports [Multi-Statement Transactions](http://consulting.xmllondon.com/xqrs/docs/multi-statement-transactions)
* Supports [Multiple-File uploads from HTML5 Forms](http://consulting.xmllondon.com/xqrs/docs/form-file-uploads)
* Supports [multipart/mixed requests](http://consulting.xmllondon.com/xqrs/docs/post-put-body#multipart-types)
* Supports XML, JSON, RDF (all formats), SPARQL Results (all formats)
* Supports [Path expressions defined by Regular Expressions](http://consulting.xmllondon.com/xqrs/docs/paths)
* Supports [Content Negotiation and Quality Factors in Accept Headers](http://consulting.xmllondon.com/xqrs/docs/content-negotiation)
* Well Documented with plenty of examples
* Supports [Error Handler Functions](http://consulting.xmllondon.com/xqrs/docs/error-handling)
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
};
```
