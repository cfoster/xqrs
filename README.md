# [XQRS](http://consulting.xmllondon.com/xqrs) - XQuery API for RESTful Web Services
<img align="right" src="http://consulting.xmllondon.com/images/xqrs.svg">
XQRS is a RESTXQ implementation for MarkLogic Server.

It's fast, scales and is light weight at around 1.1k lines of code. You can seamlessly add it to your existing project without it interfering. Support is available on GitHub. RESTXQ enables you to build RESTful services declaratively with XQuery Annotations in the same way as JAX-RS does for Java.

* Supports [Read Only / Update Functions](http://consulting.xmllondon.com/xqrs/docs/update-transactions)
* Supports [Multi-Statement Transactions](http://consulting.xmllondon.com/xqrs/docs/multi-statement-transactions)
* Supports [Multiple-File uploads from HTML5 Forms](http://consulting.xmllondon.com/xqrs/docs/form-file-uploads)
* Supports [multipart/mixed requests](http://consulting.xmllondon.com/xqrs/docs/post-put-body#multipart-types)
* Supports [XML](http://consulting.xmllondon.com/xqrs/docs/output-serialization#xml), [JSON](http://consulting.xmllondon.com/xqrs/docs/output-serialization#json), [RDF](http://consulting.xmllondon.com/xqrs/docs/output-serialization#rdf) (all formats), [SPARQL Results](http://consulting.xmllondon.com/xqrs/docs/output-serialization#sparql) (all formats)
* Supports [Path expressions defined by Regular Expressions](http://consulting.xmllondon.com/xqrs/docs/paths)
* Supports [Content Negotiation and Quality Factors in Accept Headers](http://consulting.xmllondon.com/xqrs/docs/content-negotiation)
* Well Documented with plenty of examples
* Supports [Error Handler Functions](http://consulting.xmllondon.com/xqrs/docs/error-handling)
* Very Robust. Built against a very rich [Test Suite](https://github.com/cfoster/xqrs/tree/master/test-suite)
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

## Basic Examples

There are some basic examples here on this GitHub README. Full Documentation is [available on the website](http://consulting.xmllondon.com/xqrs/docs).

### Regular Expressions in Paths
```xquery
declare
%rest:path("/control-suffix/{$a}/{$b=.+}")
function control-suffix($a as xs:string, $b as xs:string) as xs:string {
  string-join(($a, $b), ',')
};

declare
  %rest:path("{$entire-uri=.+}")
function total-control($entire-uri as xs:string) {
  $entire-uri
};
```

### Selecting function by Method
Method Annotations `GET`, `HEAD`, `POST`, `PUT`, `DELETE`, `OPTIONS`, `PATCH`
```xquery
declare
  %rest:path("/factory/warehouse/wheel/{$wheel-id}")
  %rest:POST
function put($wheel-id as xs:string) {
  create-wheel($wheel-id)
};

declare
  %rest:path("/factory/warehouse/wheel/{$wheel-id}")
  %rest:DELETE
function delete($delete-id as xs:string) {
  delete-wheel($wheel-id)
};

declare
  %rest:path("/factory/warehouse/wheel/{$wheel-id}")
  %rest:GET
function get($delete-id as xs:string) {
  get-wheel($wheel-id)
};
```

### PUT and POST Content
```xquery
declare
  %rest:path("/query-some-triples")
  %rest:POST("{$rdf-data}")
function query-some-triples($rdf as sem:triple*) {
  sem:sparql(
    "SELECT * WHERE { ?a ?b ?c }", (), (),
    sem:in-memory-store($rdf)
  )
};

declare
  %rest:path("/{$uri}")
  %rest:PUT("{$json-data}")
function insert-json($json-data as document-node(object-node()), $uri as xs:string) {
  xdmp:document-insert($uri, $json-data),
  "Thanks"
};
```

### Content Negotiation

```xquery
declare
  %rest:path("/get-resource")
  %rest:produces("application/json") (: Client Accept Header :)
function json-response() {
  array-node { 1, 2, 3, 4 }
};

declare
  %rest:path("/get-resource")
  %rest:produces("text/xml", "application/xml") (: Client Accept Header :)
function xml-response() {
  <data>
    <item>1</item>
    <item>2</item>
    <item>3</item>
    <item>4</item>
  </data>
};
```

### Query Params

```xquery
declare
  %rest:path("/search")
  %rest:query-param-1('query', '{$q}')
  %rest:query-param-2('from', '{$from}', 1)
  %rest:query-param-3('to', '{$to}', 10)
function perform-search(
  $q as xs:string,
  $from as xs:integer,
  $to as xs:integer) {
  <results>{
    cts:search(fn:doc(), cts:parse($q))[$from to $to]
  }</results>
};
```

### Output Serialization

```xquery
declare
  %rest:path("/get.ttl")
  %output:method("turtle")
function turtle() as sem:triple* {
  muh:triples()
};

declare
  %rest:path("/get.n3")
  %output:method("n3")
function n3() as sem:triple* {
  muh:triples()
};

declare
  %rest:path("/get.xml")
  %output:method("xml")
  %output:encoding("iso-8859-1")
  %output:indent("yes")
  %output:media-type("application/special+xml")
function get-xml() {
  muh:xml()
};
```
