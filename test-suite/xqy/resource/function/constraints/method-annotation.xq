module namespace query-parameters =
  "/spec/resource/function/method-annotation";

declare namespace rest = "http://exquery.org/ns/restxq";

(: Basic/Empty requests :)

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:GET
function get() {
  "get"
};

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:HEAD
function head() {
  "head"
};

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:POST
function post() {
  "post"
};

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:PUT
function put() {
  "put"
};

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:DELETE
function delete() {
  "delete"
};

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:OPTIONS
function options() {
  "options"
};

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:PATCH
function patch() {
  "patch"
};

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:CONNECT
function connect() {
  "should never be executed"
};

declare
  %rest:path("/resource/function/method-annotation/empty")
  %rest:TRACE
function trace() {
  "should never be executed"
};

(: Requests that have a body :)
declare
  %rest:path("/resource/function/method-annotation/post-body")
  %rest:POST("{$request-body}")
function post-request-body($request-body as document-node(element())) {
  $request-body/element()/local-name(.)
};

declare
  %rest:path("/resource/function/method-annotation/put-body")
  %rest:PUT("{$request-body}")
function put-request-body($request-body as document-node(element())) {
  $request-body/element()/local-name(.)
};

(: multipart/mixed, a Sequence of 3 XML documents :)
declare
  %rest:path("/resource/function/method-annotation/post/multipart-mixed")
  %rest:POST("{$data}")
function multipart-mixed-post($data as document-node(element())+) {
  string-join(
    $data ! ./element()/local-name(.),
    ","
  )
};

declare
  %rest:path("/resource/function/method-annotation/post-text-combine/{$path}")
  %rest:POST("{$request-body}")
function post-text-combine($request-body as xs:string, $path as xs:string) {
  $path || "," || $request-body
};

declare
  %rest:path("/resource/function/method-annotation/post-text")
  %rest:POST("{$request-body}")
function post-text($request-body as xs:string) {
  $request-body
};

declare
  %rest:path("/resource/function/method-annotation/post-marklogic-binary")
  %rest:POST("{$request-body}")
function post-binary($request-body as binary()) {
  $request-body
};

declare
  %rest:path("/resource/function/method-annotation/post-base64Binary")
  %rest:POST("{$request-body}")
function post-base64Binary($request-body as xs:base64Binary) {
  xdmp:base64-decode(string($request-body))
};

declare
  %rest:path("/resource/function/method-annotation/post-rdf")
  %rest:POST("{$request-body}")
  (: %output:method("xqrs:turtle") :)
function post-rdf($request-body as sem:triple*) {
  $request-body
};

declare
  %rest:path("/resource/function/method-annotation/post/multipart-mixed-bag")
  %rest:POST("{$data}")
function multipart-mixed-post-bag(
  $data as item()*
  ) {
  let $type := function($item as item()) {
    typeswitch($item) 
      case $e as document-node(element()) return 'document-node(element())' 
      case $e as xs:string return 'xs:string'
      case $e as binary() return 'binary()'
      case $e as document-node(object-node()) return 'document-node(object-node())'
      case $e as document-node(array-node()) return 'document-node(array-node())'
      case $e as sem:triple return 'sem:triple'
      default return xdmp:describe($item)
  }
  return
  string-join($data ! $type(.), ',')
};

declare
  %rest:path("/resource/function/method-annotation/post-body-object")
  %rest:POST("{$request-body}")
function post-json-object($request-body as document-node(object-node())) {
  $request-body
};

declare
  %rest:path("/resource/function/method-annotation/post-body-array")
  %rest:POST("{$request-body}")
function post-json-array($request-body as document-node(array-node())) {
  $request-body
};
