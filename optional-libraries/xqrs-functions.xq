(:
 : XQRS Functions Export Module
 :
 : Version: 1.0
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

module namespace xqrs-functions = "http://xmllondon.com/xquery/xqrs-functions";

declare namespace rest   = "http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare default element namespace "http://xmllondon.com/xquery/xqrs-functions";

declare variable $params :=
  "query", "form", "header", "cookie", "error";

declare variable $http-methods :=
  "GET","HEAD","POST","PUT","DELETE","OPTIONS","PATCH","CONNECT","TRACE";
  
declare variable $output := 
  "method", "encoding", "output-encoding", "item-separator", "media-type",
  "byte-order-mark", "output-sgml-character-entities",
  "cdata-section-elements", "use-character-maps", "indent", "indent-untyped",
  "indent-tabs", "include-content-type", "escape-uri-attributes",
  "doctype-public", "doctype-system", "omit-xml-declaration", "standalone",
  "normalization-form", "default-attributes";
  
declare variable $ignored :=
  "/marklogic-tests/dynamic-errors", "/marklogic-tests/errors";
  (: build/test process needs to validate everything
     against the RelaxNG Schema. These namesapces cause that to fail. :)
  
declare option xdmp:mapping "true";

declare
  %rest:path("/xqrs-functions")
  %output:indent("yes")
function xqrs-functions:export() as document-node(element(functions)) {
  document
  {
    processing-instruction { 'xml-model' } {
      'href="http://xmllondon.com/schema/xqrs-functions-1.0.rnc"
      schematypens="http://xmllondon.com/xquery/xqrs-functions"'
    },
    comment {
      "&#10;  Description of RESTful Endpoints managed by XQRS &#10;" ||
      "  https://consulting.xmllondon.com/xqrs&#10;"
    },
    
    <functions
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization"
      xmlns:xdmp="http://marklogic.com/xdmp"
      base-url="{
        xdmp:get-request-protocol() || "://" || xdmp:get-request-header('host')
      }">{
      
      xqrs-function(
        map:get(xdmp:get-server-field("xqrs"), "functions")[
          fn:not(namespace-uri-from-QName(xdmp:function-name(.)) = $ignored)
        ]
      )

    }</functions>
  }
};

declare function consumes($string as xs:string) as element(consumes) {
  element consumes { $string }
};

declare function produces($string as xs:string) as element(produces) {
  element produces { $string } 
};

declare function xquery-uri($uri as xs:string) as attribute(xquery-uri) {
  attribute xquery-uri { $uri }
};

declare function cardinality($map as map:map) as attribute(cardinality) {
  attribute cardinality { map:get($map, 'cardinality') }
};

declare function to-var($name as xs:string) as attribute(maps-to-variable) {
  attribute maps-to-variable { $name }
};

declare function required($i as item()) as attribute(required) {
  attribute required { fn:false() }
};

declare function item-element($value as item()) as element(item) {
  element item {
    attribute type { "xs:" || xdmp:type($value) },
    $value
  }
};

declare function tx-boundary($i as item()) as element(xdmp:tx-boundary) {
  element xdmp:tx-boundary {
    if(fn:not($i instance of xs:boolean)) then $i else ()
  }
};

declare function update($i as item()) as element(xdmp:update) {
  element xdmp:update {
    if(fn:not($i instance of xs:boolean)) then $i else ()
  }
};

declare function output-props($function as function(*), $key as xs:string) {
  let $ann := xdmp:annotation($function, xs:QName('output:' || $key))
  where fn:exists($ann) and not($ann[1] instance of xs:boolean)
  return element { xs:QName('output:' || $key) } { $ann }
};

declare function return-type($string as xs:string) as element(return-type) {
  parse-type($string) ! ( 
    element return-type {
      if(map:get(., 'cardinality') != 'exactly-one') then
        cardinality(.)
      else (),
      map:get(., 'item-type')
    }
  )
};

declare function xqrs-function($function as function(*)) {
  <function
      namespace="{namespace-uri-from-QName(xdmp:function-name($function))}"
      local-name="{local-name-from-QName(xdmp:function-name($function))}"
      arity="{function-arity($function)}">
    {
      xquery-uri(xdmp:function-module($function)),
      
      <path uri="{ann($function, 'path')}">{
        segments($function, ann($function, 'path'))          
      }</path>,
      
      method($function, $http-methods),
      parameters($function, $params),
      consumes(ann($function, 'consumes')[with-values(.)]),
      produces(ann($function, 'produces')[with-values(.)]),
      output-props($function, $output),
      tx-boundary(xdmp:annotation($function, xs:QName('xdmp:tx-boundary'))),
      update(xdmp:annotation($function, xs:QName('xdmp:update'))),
      return-type(xdmp:function-return-type($function)[. != "item()*"])
    }
  </function>
};

declare function parameter-type(
  $function as function(*),
  $var-name as xs:string) as map:map? {
  for $i in 1 to fn:function-arity($function)
  let $function-qname as xs:QName := xdmp:function-parameter-name($function, $i) 
  let $local as xs:string := fn:local-name-from-QName($function-qname)
  let $sequence-type := xdmp:function-parameter-type($function, $i)
  let $type := parse-type($sequence-type)
  where $local = $var-name
  return $type
};

declare function method($function as function(*), $method as xs:string) {
  let $ann := ann($function, $method)
  let $var-name as xs:string? :=
    if($ann[1] instance of xs:string) then
      fn:replace($ann[1], '[{$}]', '')
    else ()
  
  return if(fn:exists($ann)) then
    <method name="{$method}">{
      if(fn:exists($var-name)) then (
        let $type := parameter-type($function, $var-name)
        
        return
        (
          to-var($var-name),
          element type {
            if(map:get($type, 'cardinality') != "exactly-one") then (
              cardinality($type)
            ) else(),
            map:get($type, 'item-type')
          }
        )
      ) else ()
    }</method>
    else ()
};


declare function parameters($function as function(*), $op as xs:string) {

  let $qname-parameters := param-qnames($op)
  for $qname in $qname-parameters 

  let $ann := xdmp:annotation($function, $qname)
  let $exists := $ann[fn:string-length(string(.)) gt 0]
  let $var-name := fn:replace($ann[2], '[{$}]', '')
  let $count := fn:count($ann)

  return if($exists) then
    element { $op || "-parameters"} {
      element { $op || "-parameter" } {
        required($ann[3]),
        to-var($var-name),
        element name { $ann[1] },

        let $type := parameter-type($function, $var-name)

        return element type {
          if(map:get($type, "cardinality") != "exactly-one") then
            cardinality($type)
          else (),
          map:get($type, "item-type")
        },
        
        if($count gt 2) then
          element default-value {
            if($count = 3) then (
              attribute type { 'xs:' || xdmp:type($ann[3]) },
              $ann[3]
            ) else (
              attribute type { "sequence" },
              element sequence { item-element($ann[3 to $count]) }
            )
          }
        else ()
      }
    }
  else ()
};

declare function occurrence($sequence-type as xs:string) as xs:string {
  switch(fn:substring($sequence-type, string-length($sequence-type)))
    case "?" return "zero-or-one"
    case "+" return "one-or-more"
    case "*" return "zero-or-more"
    default return "exactly-one"
};

declare function parse-type($sequence-type as xs:string) as map:map {
  map:entry('cardinality', occurrence($sequence-type)) =>
  map:with('item-type', replace($sequence-type, '[\?\+\*]$', ''))
};

declare function param-qnames($v as xs:string) as xs:QName+ { 
  (xs:QName('rest:' || $v || '-param'),
  (1 to 10) ! (xs:QName('rest:' || $v || '-param-' || .)))
};

declare function segments($function as function(*), $annotation as xs:string) {
  let $grouping-map as map:map := map:map()
  let $analyzed := fn:analyze-string($annotation, "\{\$[^}]+\}")/element()
  return
  $analyzed ! (
    if(fn:starts-with(., '{$')) then (
      let $var-name := replace(., '\{\$([^}=]+).*', '$1')
      return
      element variable-segment {
        attribute type {
          map:get(parameter-type($function, $var-name), 'item-type')
        },
        if(contains(., '=')) then (
          attribute regex { fn:replace(., '\{\$[^=}]+=([^}]+).*', '($1)') }
        ) else (),
        to-var($var-name)
      }
    )
    else (
      tokenize(string(.), '/')[normalize-space()] ! element segment { . }
    )
  )
};

declare %private function with-values($v as item()*) {
  fn:not($v instance of xs:boolean)
};
declare %private function ann($function as function(*), $name as xs:string) {
  xdmp:annotation($function, xs:QName('rest:' || $name))
};