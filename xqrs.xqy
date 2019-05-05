(:
 : XQuery API for RESTful Web Services (XQRS)
 :
 : Version: 1.0.3
 : Author: Charles Foster
 :  
 : Copyright 2019 XML London Limited. All rights reserved.
 :  
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :  
 :     http://www.apache.org/licenses/LICENSE-2.0
 :  
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :)

xquery version "1.0-ml";
 
(: ------------ Add your own RestXQ module library imports here ------------ :)

import module namespace sem = "http://marklogic.com/semantics" 
  at "/MarkLogic/semantics.xqy";

declare namespace rest   = "http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace http   = "http://expath.org/ns/http-client";
declare namespace rerr   = "http://exquery.org/ns/restxq/error";

declare variable $error-xsl as xs:string :=
  xdmp:get-request-field('xqrs-error-xsl', 'optional-libraries/xqrs-error.xsl');

declare variable $invoking-function-name as xs:string? :=
  xdmp:get-request-field("xqrs_fn", ());
  
declare variable $request-path as xs:string? :=
  xdmp:get-request-field("xqrs_rp", xdmp:get-request-path());

declare variable $empty        := 1;
declare variable $exactly-one  := 2;
declare variable $one-or-more  := 3;
declare variable $zero-or-more := 4;
declare variable $zero-or-one  := 5;

declare variable $query-param-annotations  := rest:param-qnames('query');
declare variable $form-param-annotations   := rest:param-qnames('form');
declare variable $header-param-annotations := rest:param-qnames('header');
declare variable $cookie-param-annotations := rest:param-qnames('cookie');
declare variable $error-param-annotations  := rest:param-qnames('error');
  
declare variable $method-triples :=
  ("n3","nquad","ntriple","rdfjson","rdfxml","trig","triplexml","turtle");

declare variable $method-sparql-results :=
  ("sparql-results-xml", "sparql-results-json","sparql-results-csv");
  
declare variable $sequence-level-parameters := (
  "byte-order-mark", "doctype-public", "doctype-system", "encoding",
  "omit-xml-declaration", "output-encoding", "standalone"
);

declare variable $item-level-parameters := (
  "allow-duplicate-names", "cdata-section-elements", "escape-uri-attributes",
  "html-version", "include-content-type", "indent", "json-node-output-method",
  "media-type", "method", "normalization-form", "supress-indentation",
  "undeclare-prefixes", "use-character-maps", "version", "indent-untyped",
  "indent-tabs", "default-attributes", "output-sgml-character-entities"
);

declare variable $http-methods :=
  ("GET","HEAD","POST","PUT","DELETE","OPTIONS","PATCH","CONNECT","TRACE");
  
declare variable $accept as map:map* :=
  rest:http-header-value-params(xdmp:get-request-header('Accept'));
  
declare variable $cookies as map:map* :=
  rest:http-header-value-params(xdmp:get-request-header('Cookie'));
  
declare variable $content-type-header :=
  xdmp:get-request-header('Content-Type');
  
declare variable $output-method-rdf-mime-types :=
  map:entry("n3", "text/n3") =>
  map:with("nquad", "application/n-quads") =>
  map:with("ntriple", "application/n-triples") =>
  map:with("rdfjson", "application/rdf+json") =>
  map:with("rdfxml", "application/rdf+xml") =>
  map:with("trig", "application/trig") =>
  map:with("triplexml", "application/vnd.marklogic.triples+xml") =>
  map:with("turtle", "text/turtle");

declare variable $output-method-default-mime-types := map:new((
  $output-method-rdf-mime-types,
  map:entry("html", "text/html") =>
  map:with("json", "application/json") =>
  map:with("sparql-results-csv", "text/csv") =>
  map:with("sparql-results-json", "application/sparql-results+json") =>
  map:with("sparql-results-xml", "application/sparql-results+xml") =>
  map:with("text", "text/plain") =>
  map:with("xhtml", "text/html") =>
  map:with("xml", "text/xml")
));
  
declare variable $rdf-mime-to-method := -$output-method-rdf-mime-types;
  
declare variable $default-value-extractors :=
  rest:value-from-path#2, rest:value-from-query-param#2,
  rest:value-from-form-param#2, rest:value-from-header-param#2,
  rest:value-from-cookie-param#2, rest:value-from-request-body#2;
  
declare variable $parameter-map as map:map := map:map();

declare option xdmp:mapping "true";

declare function rest:param-qnames($v as xs:string) as xs:QName+ { 
  (xs:QName('rest:' || $v || '-param'),
  (1 to 10) ! (xs:QName('rest:' || $v || '-param-' || .)))
};

declare function rest:occurrence($sequence-type as xs:string) as xs:integer {
  switch(fn:substring($sequence-type, string-length($sequence-type)))
    case "?" return $zero-or-one
    case "+" return $one-or-more
    case "*" return $zero-or-more
    default return $exactly-one
};

declare function rest:parse-type($sequence-type as xs:string) as map:map {
  map:entry('cardinality', rest:occurrence($sequence-type)) =>
  map:with('item-type', replace($sequence-type, '[\?\+\*]$', ''))
};

declare function rest:matches-error(
  $f as function(*),
  $error-map as map:map) as xs:decimal {
  let $ann := xdmp:annotation($f,xs:QName('rest:error'))
  let $err-qname as xs:QName := map:get($error-map, 'code')
  let $marklogic-error-code as xs:string? := (: featureId-errorId :) 
    map:get($error-map, 'additional')/*/Q{http://marklogic.com/xdmp/error}code

  return
  if(fn:matches($ann, '^Q\{[^\}]*\}.*$')) then ( (: URI Qualified Name :)
    let $namespace := fn:replace($ann, '^Q\{([^\}]*)\}.*$', '$1')
    let $localname := fn:replace($ann, '^Q\{[^\}]*\}(.*)$', '$1')
    
    return rest:content-type-match-level(
      fn:namespace-uri-from-QName($err-qname),
      fn:local-name-from-QName($err-qname),
      $namespace, $localname
    )
  )
  else if(fn:contains($ann, ':')) then ( (: QName :)
    let $tokens := fn:tokenize($ann, ':')
    return rest:content-type-match-level(
      fn:prefix-from-QName($err-qname),
      fn:local-name-from-QName($err-qname),
      $tokens[1], $tokens[2]
    )
  )
  else if(fn:matches($ann, '^([A-Z0-9]+|\*)-([A-Z0-9]+|\*)$')
          and
          fn:matches($marklogic-error-code, '^([A-Z0-9]+|\*)-([A-Z0-9]+|\*)$'))
  then (
    (: MarkLogic Proprietary Error Code :)
    let $marklogic-error-code := (: featureId-errorId :) 
      map:get($error-map, 'additional')/*/Q{http://marklogic.com/xdmp/error}code
    let $marklogic-error-code-tokens := fn:tokenize($marklogic-error-code, '-')
    let $tokens := fn:tokenize($ann, '-')
    
    return rest:content-type-match-level(
      $marklogic-error-code-tokens[1], $marklogic-error-code-tokens[2],
      $tokens[1], $tokens[2]
    )
  )
  else if($ann = '*') then ( (: Any kind of Error :)
    0.5
  )
  else 0
};

declare function rest:matches($f as function(*)) as xs:integer {
  let $functions :=
    (rest:matches-path#1, rest:matches-method#1,
     rest:matches-consumes#1, rest:matches-produces#1)
  let $weights := (10, 10000, 1000, 1000)
  return fn:fold-left( (: lazily iterate through match functions, :)
    function($prev, $cur) { (: applying and adding weights as we go :)
      if($prev = 0) then 0 (: importantly, halting as soon as possible :)
      else $functions[$cur]($f) * $weights[$cur] + (($prev, 0)[1])
    }, (), 1 to count($weights)
  )
};

declare function rest:matches-path($f as function(*)) as xs:integer {
  try
  {
    let $path-ann := xdmp:annotation($f, xs:QName('rest:path'))
    let $path-ann := if(starts-with($path-ann, '/')) then $path-ann
                     else '/' || $path-ann
    let $validate :=
      rest:assert-annotation-cardinality($f, xs:QName('rest:path'), 1, 1)

    let $test := rest:path-variable-map($request-path, $path-ann)

    return
    if(exists($path-ann) and exists($test)) then
    (
      let $var-weight := 1
      let $con-weight := 100
      let $path-normalized := replace($path-ann, "^/", "")
      let $path-tokens := tokenize($path-normalized, "/")
      return
      sum(
        for $token at $index in $path-tokens
        return (
          $con-weight +
          (if(matches($token, '\{\$.+\}')) then
            $index * $var-weight
          else
            $con-weight)
        )
      )
    )
    else 0
  } catch rerr:XQRS001 {
    fn:error($err:code,
    "The function " || xdmp:function-name($f) ||
    " has a path annotation string literal '" || 
    xdmp:annotation($f, xs:QName('rest:path'))
    || "' which contains either an invalid or unsupported regular expression.")
  }
};

declare function rest:matches-method($f as function(*)) as xs:integer {
  let $annotation := function($method) {
    xdmp:annotation($f, xs:QName("rest:" || $method))
  }
  return
    if(some $match in ($http-methods ! $annotation(.)) satisfies $match) then
      if(exists($annotation(xdmp:get-request-method()))) then 2 else 0
    else
      1
};

declare function rest:matches-consumes($f as function(*)) as xs:integer {
  rest:assert-valid-mediatype($f, xs:QName('rest:consumes')),
  let $consumes := xdmp:annotation($f, xs:QName("rest:consumes"))
  let $mime := replace(lower-case($content-type-header), '^([^\s;]+).*', '$1')
  let $pair := tokenize($mime, '/')
  return
  if(not($consumes)) then (: no consumes annotation, equiv of */* :)
    1
  else
    fn:max((0,
      for $ann in $consumes
      let $ann-pair := tokenize($ann, '/')
      return rest:content-type-match-level($pair[1], $pair[2],
                                            $ann-pair[1], $ann-pair[2])
    ))
};

declare function rest:content-type-match-level(
  $type1 as xs:string,
  $subtype1 as xs:string,
  $type2 as xs:string,
  $subtype2 as xs:string) as xs:integer {
  if($type1 = $type2 and $type1 != "*") then
  (
    if($subtype1 = $subtype2 and $subtype2 != '*') then 4
    else if($subtype1 = '*' or $subtype2 = '*') then 3
    else 0
  )
  else if($type1 = '*' or $type2 = '*') then (
    if($subtype1 = $subtype2 and $subtype2 != '*') then 2
    else if($subtype2 = '*' or $subtype1 = '*') then 1
    else 0
  )
  else 0
};

declare function rest:matches-produces($f as function(*)) as xs:decimal {
  let $_ := rest:assert-valid-mediatype($f, xs:QName('rest:produces'))
  let $ann := xdmp:annotation($f, xs:QName('rest:produces'))
  return
  if(not(exists($ann))) then (
    1
  ) else (
    let $levels :=
      for $func-produces in $ann
      for $cli-accepts-map in $accept
      let $cli-accept-content-type := map:get($cli-accepts-map, 'xqrs:title')
      return (
        let $ann-pair := fn:tokenize($func-produces, '/')
        let $pair := fn:tokenize($cli-accept-content-type, '/')
        let $match-level := rest:content-type-match-level(
          $ann-pair[1], $ann-pair[2], $pair[1], $pair[2]
        )
        return if($match-level) then (
          let $q := (xs:decimal(map:get($cli-accepts-map, 'q')), 1.0)[1]
          return $q * $match-level
        ) else (
          0
        )
      )
    let $max-level := max($levels)
    return $max-level
  )
};

declare function rest:value-from-path(
  $function as function(*),
  $variable-name as xs:QName) as xs:string? {
  map:get(
    rest:path-variable-map($request-path,
      xdmp:annotation($function, xs:QName('rest:path'))),
    xs:string($variable-name)
  )
};

declare function rest:path-variable-map(
  $path as xs:string,
  $annotation as xs:string) as map:map? {
  try
  {
    let $annotation  := "^" || $annotation || "$"
    let $grouping-map as map:map := map:map()
    let $analyzed := fn:analyze-string($annotation, "\{\$[^}]+\}")/element()
    let $regex :=
    string-join(
    for $element in $analyzed
    return
    typeswitch($element)
      case element(fn:match) return (
        let $key := fn:replace($element,'\{\$([^=}]+).*', '$1')
        let $group-index := count($element/preceding-sibling::fn:match) + 1
        let $_ := map:put($grouping-map, xs:string($group-index), $key)
        let $regex :=
          if(fn:matches($element, '=')) then
            fn:replace($element, '\{\$[^=}]+=([^}]+).*', '($1)')
          else
            '([^/]+)'
        return $regex
      )
      default
        return $element
    )
    
    let $path-match := fn:analyze-string($path, $regex)
    return
    if($path-match/fn:match) then (
      map:new(
        for $group-index-key in map:keys($grouping-map)
        return
          map:entry(
            map:get($grouping-map, $group-index-key),
            string($path-match//fn:group[@nr=xs:integer($group-index-key)])
          )
      )
    ) else ( )
  } catch($e) {
    fn:error(xs:QName('rerr:XQRS001'), "Invalid Path Expression.")
  }
};

declare function rest:value-from-query-param(
  $func as function(*),
  $variable-name as xs:QName) as xs:string* {
  rest:value-from-function(
    $func, $variable-name, $query-param-annotations, rest:get-request-field#2
  )
};

declare function rest:value-from-header-param(
  $func as function(*),
  $variable-name as xs:QName) as xs:string* {
  rest:value-from-function(
    $func, $variable-name, $header-param-annotations, rest:get-request-header#2
  )
};

declare function rest:value-from-function(
  $function as function(*),
  $variable-name as xs:QName,
  $param-annotations as xs:QName+,
  $accessor as function(xs:string, item()*) as item()*) as xs:string* {
  for $qname in $param-annotations
  let $annotation := xdmp:annotation($function, $qname)
  let $validate :=
    rest:assert-annotation-cardinality($function, $qname, 2, ())
  where rest:annotation-literal-matches($function, $qname, $variable-name)
  return $accessor($annotation[1], $annotation[3 to last()] ! string(.))
};

declare function rest:value-from-cookie-param(
  $function as function(*),
  $variable-name as xs:QName) as xs:string* {
  for $qname in $cookie-param-annotations
  let $annotation := xdmp:annotation($function, $qname)
  let $validate :=
    rest:assert-annotation-cardinality($function, $qname, 2, ())
  where rest:annotation-literal-matches($function, $qname, $variable-name)
  return (
    let $cookie-value :=
      for $cookie-map in $cookies
      let $cookie-key as xs:string :=
        map:keys($cookie-map)[not(lower-case(.)=('$path','$version','$domain'))]
      where $cookie-key = $annotation[1]
      return map:get($cookie-map, $cookie-key)
      
    return
    (
      if(exists($cookie-value)) then
        $cookie-value
      else
        $annotation[3 to last()]  ! string(.)
    )
  )
};

declare function rest:value-from-form-param(
  $function as function(*),
  $variable-name as xs:QName) {
  for $qname in $form-param-annotations
  let $annotation := xdmp:annotation($function, $qname)
  let $validate :=
    rest:assert-annotation-cardinality($function, $qname, 2, ())
  
  let $mime := replace(lower-case($content-type-header), '^([^\s;]+).*', '$1')
  
  where rest:annotation-literal-matches($function, $qname, $variable-name)
  return (
    let $e :=
      rest:get-request-field(
        $annotation[1],
        $annotation[3 to last()]  ! string(.)
      )
    return
    
    if($mime = 'multipart/form-data') then (
      let $map := map:map()
      let $_ :=
        for $binary-item at $i in $e
        let $entry :=
            map:entry("body", $binary-item) =>
            map:with("content-type",
              xdmp:get-request-field-content-type($annotation[1])[$i])
              
        return map:put(
          $map, xdmp:get-request-field-filename($annotation[1])[$i], $entry
          )
      return $map
    )
    else (
      $e
    )
  )
};

declare function rest:http-header-value-params($value as xs:string) as map:map*
{
  let $value := (: quoted strings have commas replaced for simplicity :)
  fn:analyze-string($value, '"[^"]*"')/node() ! (
    typeswitch(.)
    case element(fn:match) return fn:replace(., ',', '&#xff0c;')
    default return string(.)
  ) => string-join()
  return
  fn:tokenize($value, ",") !
  map:new(
    fn:tokenize(., ";\s*") !
    (
      if(fn:contains(., '=')) then (
        let $tokens := fn:tokenize(., "=")
        return map:entry(normalize-space($tokens[1]),
                         normalize-space(replace(
                           (: replace the commas in quoted strings back :)
                           replace($tokens[2],'&#xff0c;',',')
                         , '"','')))
      )
      else
        map:entry("xqrs:title", normalize-space(.))
    )
  )
};

declare function rest:rdf-type($content-type as xs:string) as xs:string? { 
  map:get($rdf-mime-to-method, replace($content-type, '^([^\s]+)','$1'))
};

declare function rest:parse-multipart-body() as json:array {
  let $decoded :=
    xdmp:multipart-decode(
      map:get(rest:http-header-value-params($content-type-header), "boundary"),
      xdmp:get-request-body()/node()
    )
  let $part-maps as map:map* :=
    $decoded[1]/part ! (
      map:new(
        headers/element() ! map:entry(lower-case(local-name(.)), string(.))
      )
    )
  let $_ :=
    for $map at $i in $part-maps
    return (
      let $decoded-correction := (
        typeswitch($decoded[$i + 1]/node())
          case $e as binary() | text()
            return rest:parse-multipart-item($decoded[$i + 1],
                                             map:get($map, "content-type")) 
          default
            return $decoded[$i + 1]
       )
       return map:put($map, 'body', $decoded-correction)
    )
    
  return json:to-array($part-maps)
};

declare function rest:parse-multipart-item(
  $input as document-node(), (: For when it just gets a little too spicey :)
  $content-type as xs:string) {
  if(rest:rdf-type($content-type)) then
    sem:rdf-parse($input, rest:rdf-type($content-type))
  else if(starts-with($content-type, 'text/')) then
    xdmp:binary-decode($input/node(), "utf-8")
  else
    $input/node()
};

declare function rest:value-from-request-body(
  $function as function(*),
  $variable-name as xs:QName) {
  let $post := xs:QName('rest:POST') let $put := xs:QName('rest:PUT')
  let $post-ann := xdmp:annotation($function, $post)
  let $put-ann := xdmp:annotation($function, $put)
  let $regex := '\{\$' || $variable-name || '\}'
  
  let $_ := (
    rest:assert-annotation-cardinality($function, $put, 0, 1),
    rest:assert-annotation-cardinality($function, $post, 0, 1),
    rest:annotation-ats($function, $post-ann, $post, $variable-name),
    rest:annotation-ats($function, $put-ann, $put, $variable-name)
  )

  return  
  if(not($post-ann instance of xs:boolean) and matches($post-ann, $regex) or
     not($put-ann instance of xs:boolean) and matches($put-ann, $regex)) then
  (
    if(starts-with($content-type-header, 'multipart/')) then (
      let $array := rest:parse-multipart-body() 
      return json:array-values($array) ! map:get(., 'body')
    )
    else if(rest:rdf-type($content-type-header)) then (
      let $rdf-type := rest:rdf-type($content-type-header)
      return
      sem:rdf-parse(
        xdmp:get-request-body(
          if($rdf-type = ('triplexml', 'rdfxml')) then 'xml'
          else if($rdf-type = 'rdfjson') then 'json'
          else 'text'
        ), $rdf-type
      )
    )
    else if(matches($content-type-header, '^(text|application)/.*\+?xml')) then
      xdmp:get-request-body("xml")
    else if(matches($content-type-header, '^(text|application)/.*\+?json')) then
      xdmp:get-request-body("json")
    else if(matches($content-type-header, '^text/')) then
      xdmp:get-request-body("text")      
    else (
      let $v := xdmp:get-request-body()
      return if($v/node() instance of binary()) then $v/node()
      else $v
    )
  ) else ()
};

declare function rest:get-request-field(
  $name as xs:string,
  $default as item()*) as item()* {
  let $preferred := xdmp:get-request-field($name)
  return if($preferred) then $preferred else $default
};

declare function rest:get-request-header(
  $name as xs:string,
  $default as item()*) as item()* {
  let $preferred := fn:tokenize(xdmp:get-request-header($name), "\s*,\s*")
  return if($preferred) then $preferred else $default
};

declare function rest:apply($function as function(*), $map as map:map) {
  let $XQRSSessionID as xs:string? := map:get($cookies, "XQRS-Session-ID")
  
  let $tx-boundary := 
    exists(xdmp:annotation($function, xs:QName('xdmp:tx-boundary')))

  let $update :=
    (xs:string(xdmp:annotation($function, xs:QName('xdmp:update'))), 'auto')[1]
  let $commit := if($XQRSSessionID) then "explicit" else "auto"
  
  let $v :=
    function($i as xs:integer) {
      map:get(
        $map, xdmp:key-from-QName(xdmp:function-parameter-name($function, $i))
      )
    }
  
  let $func := function() {
  switch(fn:function-arity($function))
    case  0 return xdmp:apply($function)
    case  1 return xdmp:apply($function, $v(1))
    case  2 return xdmp:apply($function, $v(1), $v(2))
    case  3 return xdmp:apply($function, $v(1), $v(2), $v(3))
    case  4 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4))
    case  5 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4), $v(5))
    case  6 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4), $v(5), $v(6))
    case  7 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4), $v(5), $v(6), $v(7))
    case  8 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4), $v(5), $v(6), $v(7), $v(8))
    case  9 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4), $v(5), $v(6), $v(7), $v(8), $v(9))
    case 10 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4), $v(5), $v(6), $v(7), $v(8), $v(9), $v(10))
    case 11 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4), $v(5), $v(6), $v(7), $v(8), $v(9), $v(10), $v(11))
    case 12 return xdmp:apply($function, $v(1), $v(2), $v(3), $v(4), $v(5), $v(6), $v(7), $v(8), $v(9), $v(10), $v(11), $v(12))
    default return
      fn:error(xs:QName('rerr:XQRS009'), 'Unsupported number of arguments.')
  }

  let $response :=
    if($tx-boundary) then $func()
    else
    xdmp:invoke-function(
      $func,
      <options xmlns="xdmp:eval">{
          if($XQRSSessionID) then (
            <transaction-id>{$XQRSSessionID}</transaction-id>
          )
          else (
            <update>{$update}</update>,
            <commit>{$commit}</commit>
          )
        } 
      </options>
    )
    
  return rest:serialize-sequence($function, $response)
};

declare function rest:annotation-literal-matches(
  $function as function(*),
  $annotation-qname as xs:QName,
  $variable-name as xs:QName) as xs:boolean
{
  let $ann := xdmp:annotation($function, $annotation-qname)

  return if(fn:exists($ann)) then (
    let $l1 := $ann[1] let $l2 := $ann[2]
    
    let $validate :=
      if(empty($l1[normalize-space()])) then
        fn:error(xs:QName('rerr:XQRS010'),
        'Annotation %' || $annotation-qname || ' for function ' ||
        xdmp:function-name($function) || ' does not have a value for it''s ' ||
        'first argument.')
      else ()
    return
    string($variable-name) =
    rest:annotation-ats($function, $l2, $annotation-qname,
                                $variable-name)
  ) else fn:false()
};

declare function rest:annotation-ats(
  $function as function(*),
  $ats as xs:string,
  $annotation-qname as xs:QName,
  $variable-name as xs:QName) as xs:string
{
  let $analyze-result := fn:analyze-string($ats, '^\{\$([^\}]+)\}$')
  let $literal-variable as xs:string :=
    if(exists($analyze-result/fn:non-match) or
       empty($analyze-result/fn:match/fn:group)) then
      fn:error(xs:QName('rerr:XQRS008'), 'Invalid Annotation Template Syntax "'
      || $ats || '" in Annotation %' || $annotation-qname ||
      ' for function ' || xdmp:function-name($function))
    else
      $analyze-result/fn:match/fn:group/string()
  return $literal-variable
};

declare function rest:assert-valid-output-method(
  $annotation-method as xs:string,
  $test as xs:string+,
  $result-type as xs:string?) as empty-sequence() {
  
  let $err := function($qname as xs:QName, $message as xs:string) {
    fn:error($qname, $message)
  }
  return
  if(fn:not(map:contains($output-method-default-mime-types,
                         $annotation-method)))
  then (
    let $did-you-mean as xs:string? :=
      (for $key in map:keys($output-method-default-mime-types)      
       let $distance := spell:levenshtein-distance($annotation-method, $key)
       where $distance lt 5 order by $distance return $key)[1]
    return
    $err(
      xs:QName('rerr:XQRS012'),
      'Output method "' || $annotation-method || '" is not supported.' ||
      (if($did-you-mean) then ' Did you mean "' || $did-you-mean || '"?'
      else ()))
  )
  else if(not($annotation-method = $test)) then (
    $err(xs:QName('rerr:XQRS011'),
      'Output method "' || $annotation-method ||
      '" is incompatible with the result type' ||          
      (if($result-type) then ' "' || $result-type || '"' else ())) 
  ) else ()
};

declare function rest:assert-valid-mediatype(
  $function as function(*),
  $annotation-qname as xs:QName) as empty-sequence() {
  let $ann := xdmp:annotation($function, $annotation-qname)
  let $_ :=
    rest:assert-annotation-cardinality($function, $annotation-qname, 1, ())
  return
  for $x in $ann
  return
  if($x instance of xs:string and fn:matches($x, 
    '^(application|audio|image|message|model|multipart|' ||
    'text|video|\*)/(\*|.{2,})$')) then ()
  else
    fn:error(xs:QName('rerr:XQRS013'),
      'Invalid Media Type "' || string($x) || '" in annotation %' ||
      $annotation-qname || ' for function ' || xdmp:function-name($function))
};

declare function rest:assert-annotation-cardinality(
  $function as function(*),
  $annotation-qname as xs:QName,
  $min as xs:integer,
  $max as xs:integer?) as empty-sequence() {
  let $f := function($count as xs:integer) {
    if(($max and $count gt $max) or $count lt $min) then
      fn:error(xs:QName('rerr:XQRS007'),
      'The annotation %' || $annotation-qname || ' in function ' ||
      xdmp:function-name($function) ||
      ' must have a literal cardinality of ' || $min || ' ' ||
      (if($max) then 'to ' || $max else 'or more') ||
      ', the current cardinality is '
      || $count || '.')
    else ()
  }
  return  
  typeswitch(xdmp:annotation($function, $annotation-qname))
    case xs:boolean return $f(0)
    case $v as item()+ return $f(count($v))
    default return ()
};

declare function rest:serialize-sequence($function as function(*), $response)
{
  let $serialization-map as map:map :=
    rest:serialization-parameter-map($function)
  let $serialization-map-item-level as map:map :=
    map:new(
      map:keys($serialization-map)[. = $item-level-parameters] !
      map:entry(., map:get($serialization-map, .))
    )
  let $annotation-method := map:get($serialization-map, 'method')

  let $encoding :=
    xdmp:set-response-encoding(
      (map:get($serialization-map, 'encoding'), "UTF-8")[1]
    )

  let $first-item as item()? := fn:head($response)
  
  return
  (
    let $sequence :=
    if($first-item instance of document-node(element(rest:response)) or
       $first-item instance of element(rest:response)) then (
      rest:rest-response($first-item/descendant-or-self::rest:response),
      fn:tail($response)
    )
    else $response
    let $response-media-type := 
      xdmp:set-response-content-type(
        (
          map:get($serialization-map, 'mediaType'),
          map:get($output-method-default-mime-types, $annotation-method),
          rest:default-response-mimetype($sequence)
        )[1]
      )
    
    return
  
    if($sequence instance of sem:triple+) then (
      let $as := ($annotation-method, "turtle")[1]
      return (
        rest:assert-valid-output-method($as, $method-triples, "sem:triple+"),
        sem:rdf-serialize($sequence, $as)
      )
    )
    else if($sequence instance of map:map+ and
            $annotation-method = $method-sparql-results) then (
      rest:serialize-sparql-results($annotation-method, $sequence)
    ) else (
      fn:fold-left(
        function($prev, $item) {
          $prev,
          rest:serialize-item(
            (if($prev instance of empty-sequence()) then $serialization-map
            else $serialization-map-item-level), $item)
        }, (), $sequence)
    )
    =>
    rest:item-separator(
      xdmp:annotation($function, xs:QName('output:item-separator')))
  )
};

declare function rest:item-separator($seq, $item-separator as xs:string?) {
  if(not(exists($item-separator))) then $seq
  else string-join($seq ! xdmp:quote(.), $item-separator)
};

declare function rest:serialization-parameter-map(
  $function as function(*)) as map:map {
  map:new(
    ($sequence-level-parameters, $item-level-parameters)
    ! (
      let $ann := xdmp:annotation($function, xs:QName('output:' || .))
      return if(exists($ann)) then (
        map:entry(rest:camel-case(.), $ann),
        if(. = 'indent') then (
          map:entry('indentUntyped', $ann)
        ) else ()
      ) else ()
    )
  )
};

declare function rest:camel-case($input as xs:string) as xs:string {
  let $tokens := fn:tokenize(lower-case($input), '-')
  return string-join((fn:head($tokens), fn:tail($tokens) ! xdmp:initcap(.)))
};

declare function rest:serialize-sparql-results(
  $method as xs:string,
  $v as map:map*) {
  sem:query-results-serialize($v, substring-after($method, "sparql-results-"))
};

declare function rest:serialize-item($output as map:map, $item as item()) {
  typeswitch($item)
    case document-node(element()) | element() return
      rest:serialize-xml($output, $item)
    case xs:anyAtomicType return (
      rest:assert-valid-output-method((map:get($output, 'method'), "text")[1],
        "text", string(xdmp:type($item))),
      if(map:contains($output, 'normalizationForm')) then
        fn:normalize-unicode($item, map:get($output, 'normalizationForm'))
      else
        $item
    )
    default return $item
};

declare function rest:serialize-xml($output-map as map:map, $node as node()) {
  rest:assert-valid-output-method(
    (map:get($output-map, 'method'), 'xml')[1],
    ('xml', 'xhtml', 'html'),
    xdmp:node-kind($node)
  ),
  xdmp:quote($node, $output-map)
};

declare function rest:default-response-mimetype($i as item()*) as xs:string? {
  typeswitch($i)
    case document-node(element()) return "text/xml"
    case element() return "text/xml"
    case text() return "text/plain"
    case $v as document-node() return
      if(exists($v/object-node()) or exists($v/array-node())) then
        "application/json" else "text/xml"
    case binary() return "application/octet-stream"
    case sem:triple+ return "text/turtle"
    case xs:anyAtomicType+ return "text/plain"
    default return ()
};

declare function rest:rest-response(
  $response as element(rest:response)) as empty-sequence() {
  rest:http-response($response/http:response)
};

declare function rest:http-response($http-response as element(http:response)) {
  xdmp:set-response-code(
    (xs:integer($http-response/@status[normalize-space()]), 200)[1],
    ($http-response/@message, "")[1]
  ),
  $http-response/http:header ! rest:http-header(.)
};

declare function rest:http-header($header as element(http:header)) {
  xdmp:add-response-header($header/@name, $header/@value)
};

declare function rest:build-parameter-map(
  $function as function(*),
  $value-extractors as (function(function(*), xs:QName) as item()*)+
) as empty-sequence()
{
  for $index in 1 to fn:function-arity($function)
  let $parameter-qname as xs:QName :=
    xdmp:function-parameter-name($function, $index)
    
  let $parameter-sequence-type as xs:string :=
    xdmp:function-parameter-type($function, $index)
    
  let $sequence-type := rest:parse-type($parameter-sequence-type)
  let $parameter-cardinality := map:get($sequence-type, 'cardinality')
  let $item-type as xs:string := map:get($sequence-type, 'item-type')
  
  let $value :=
    fn:fold-left(
      function($prev, $item) {
        if(fn:exists($prev)) then $prev
        else (
          let $v := $item($function, $parameter-qname)
          let $_ := 
          if(exists($v) and xdmp:function-name($item) =
                            xdmp:function-name(rest:value-from-path#2) and
            $parameter-cardinality != $exactly-one) then (
            fn:error(xs:QName('rerr:XQRS004'), 'As parameter $' ||
            $parameter-qname ||
            ' comes from a path annotation, it must allow for "exactly one" ' ||
            'atomic value in function ' || xdmp:function-name($function) ||
            ', presently it is "' || $parameter-sequence-type || '"')
          ) else ()
          return $v
        )
      }, (), $value-extractors
    )

  let $castable := (
    if($item-type = 'document-node()') then $value instance of document-node()*
    else if($item-type = 'sem:triple') then $value instance of sem:triple*
    else if($item-type = 'binary()') then $value instance of binary()*
    else if($item-type = 'item()') then $value instance of item()*
    else if($item-type = 'map:map') then $value instance of map:map*
    else if($item-type = 'text()') then (
      fn:error(xs:QName('rerr:XQRS005'),
      'text() parameter types are not allowed, see parameter $' ||
      $parameter-qname || ' in function ' || xdmp:function-name($function))
    )    
    else (
      let $ns := fn:namespace-uri-from-QName(xs:QName($item-type))
      let $local := fn:local-name-from-QName(xs:QName($item-type))
      return
      every $item in $value satisfies xdmp:castable-as($ns, $local, $item)
    )
  )
  
  let $marklogic-castable := (: MarkLogic Function Mapping coming to get us :)
    fn:not($parameter-cardinality = $exactly-one and fn:empty($value))
  
  let $void := if(not($marklogic-castable) or
                  not($castable) and
                  not($parameter-cardinality =
                        ($zero-or-more, $zero-or-one))) then (
    if(exists($value)) then
        fn:error(
          xs:QName('rerr:XQRS002'),
          '"' || $value || '" not castable as ' || $parameter-sequence-type ||
          " for parameter $" || $parameter-qname ||
          " in function " || xdmp:function-name($function)
        )
      else
        fn:error(
          xs:QName('rerr:XQRS003'),
          'Could not find a value for parameter $' || $parameter-qname ||
          ' in function ' || xdmp:function-name($function) ||
          ' from the RESTXQ Annotations.'
        )
  ) else ( )
  
  let $cast-function :=
    function($individual-item) {
      if($item-type =
        ("document-node()", "sem:triple","binary()","item()","map:map")) then (
        $individual-item
      )
      else (
        fn:function-lookup(xs:QName($item-type), 1)($individual-item)
      )
    }

  return
    if(exists($value)) then
      map:put(
        $parameter-map,
        xdmp:key-from-QName($parameter-qname),
        $cast-function($value)
    )
    else ()
};

declare function rest:handle-error($error-map as map:map)
{
  let $error-functions :=
    xdmp:functions()[xdmp:annotation(., xs:QName("rest:error"))]
    
  let $function-to-invoke :=
    (for $error-function in $error-functions
    let $matches := rest:matches-error($error-function, $error-map)
    where $matches gt 0
    order by $matches descending
    return $error-function)[1]
    
  let $params :=
    rest:build-parameter-map($function-to-invoke,
      function($function as function(*), $variable-name as xs:QName) {
      
      for $qname in $error-param-annotations
      let $annotation := xdmp:annotation($function, $qname)
      where rest:annotation-literal-matches($function, $qname, $variable-name)
      return
        map:get($error-map, $annotation[1])
      }
    )
    
  let $_ := xdmp:set-response-code(400, 'Bad Request')

  return
    if(fn:exists($function-to-invoke)) then (
      rest:apply($function-to-invoke, $parameter-map)
    )
    else
    (
      let $err := try { 
        let $e := map:get($error-map, 'additional')/element()
        let $message as xs:string? :=
          string-join(($e/error:name, $e/error:message), ': ')
        let $potential-code as xs:string? := $e/error:data/error:datum[1]
        let $code as xs:integer? :=
          if($potential-code castable as xs:integer) then (
            xs:integer($potential-code)[. ge 100 and . lt 600]
          ) else ()
          
        let $_ := xdmp:set-response-code(($code, 400)[1], $message)
        return (
          xdmp:xslt-invoke($error-xsl, $e),
          xdmp:set-response-content-type("text/html")
        )
      } catch ($e) { }
      return
      if(fn:empty($err)) then
      (
        if(fn:namespace-uri-from-QName(map:get($error-map, 'code'))
          = 'http://exquery.org/ns/restxq/error') then (
          xdmp:set-response-content-type("text/plain"),
          let $code := local-name-from-QName(map:get($error-map, "code"))
          let $desc := map:get($error-map, "description")
          return $code || ": " || $desc
        )
        else
        (
          xdmp:rethrow() (: User / External error :)
        )
      )
      else (
        $err
      )
    )
};

declare function rest:static-error() {
  xdmp:set-response-code(400, "Bad Request"),
  xdmp:get-request-field("xqrs_message")
};

if($invoking-function-name) then
(
  let $function-to-invoke :=
    fn:function-lookup(
      xdmp:QName-from-key($invoking-function-name),
      xs:integer(xdmp:get-request-field("xqrs_fa", ()))
    )
    
  return
  try
  {
    rest:build-parameter-map($function-to-invoke, $default-value-extractors),
    rest:apply($function-to-invoke, $parameter-map)
  } catch * { (: Dynamic Error occurred :) 
    rest:handle-error(
      map:entry('code', $err:code) =>
      map:with('description', $err:description) =>
      map:with('value', $err:value) =>
      map:with('module', $err:module) =>
      map:with('line-number', $err:line-number) =>
      map:with('column-number', $err:column-number) =>
      map:with('additional', document { $err:additional })
    )
  } 
)
else
(
  let $xqrs :=
    map:entry('functions', xdmp:functions()[
      xdmp:annotation(., xs:QName("rest:path"))]
    )

  let $_ :=
    if(xdmp:has-privilege(
      "http://marklogic.com/xdmp/privileges/xdmp-set-server-field", "execute"))
    then xdmp:set-server-field('xqrs', $xqrs) else ()
    
  let $function-to-invoke :=
    try {
      (for $function in map:get($xqrs, "functions")
      let $matches := rest:matches($function)
      where $matches ge 1
      order by $matches descending
      return $function)[1]
    } catch * { (: Static Error occurred :)
      rest:static-error#0,
      local-name-from-QName($err:code) || ': ' || $err:description,
      xdmp:log($err:module || ' on line ' || $err:line-number)
    }
    
  return
  if(exists($function-to-invoke)) then (
    let $rp := xdmp:get-url-rewriter-path()
    let $prefix := if(fn:contains($rp, '?')) then '&amp;' else '?'
    return
    $rp || $prefix || "xqrs_fn=" ||
      xdmp:key-from-QName(xdmp:function-name($function-to-invoke[1])) ||
      "&amp;" ||
    "xqrs_fa=" || fn:function-arity($function-to-invoke[1]) || "&amp;" ||
    (if(exists($function-to-invoke[2])) then (
      "xqrs_message=" || xdmp:url-encode($function-to-invoke[2]) || "&amp;"      
    ) else ())  ||
    "xqrs_rp=" || xdmp:get-request-path() || "&amp;" ||
    fn:replace(xdmp:get-original-url(), '^[^?]*\?', '')
  )
  else (
    xdmp:get-request-url()
  )
)
