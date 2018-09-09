module namespace dynamic-errors = "/marklogic-tests/dynamic-errors";

declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

(:
  %rest:path
  1. Templates MUST map to named function parameters
:)
declare %rest:path("/marklogic/error/path/1/a/{$code}")
function path-test-1a($something-else as xs:string) { $something-else };

declare %rest:path("/marklogic/error/path/1/b/{$code}")
function path-test-1a(
  $code as xs:string,
  $something-else as xs:string) { $code };

(:
  %rest:path
  2. The cardinality of each item must be exactly one
:)
declare %rest:path("/marklogic/error/path/2/a/{$code}")
function path-test-2a($code as xs:string?) { $code };
declare %rest:path("/marklogic/error/path/2/b/{$code}")
function path-test-2b($code as xs:string+) { $code };
declare %rest:path("/marklogic/error/path/2/c/{$code}")
function path-test-2c($code as xs:string*) { $code };

(:
  %rest:path
  3. Must be inherit from xs:anyAtomicType
:)
declare %rest:path("/marklogic/error/path/3/a/{$code}")
function path-test-3a($code as text()) { $code };

declare %rest:path("/marklogic/error/path/3/b/{$code}")
function path-test-3b($code as binary()) { $code };

(:
  %rest:path
  4. Conversion from the URI segment string to the required type is
     performed at run-time, and an error MUST be raised if conversion
     is impossible.
:)
declare %rest:path("/marklogic/error/path/4/a/{$code}")
function path-test-4a($code as xs:date) { $code };
declare %rest:path("/marklogic/error/path/4/b/{$code}")
function path-test-4b($code as xs:integer) { $code };
declare %rest:path("/marklogic/error/path/4/c/{$code}")
function path-test-4c($code as xs:dateTime) { $code };

(:
  %rest:path
  5. The Path has an Invalid Syntax or Regular Expression
:)
(: static error
declare %rest:path("/marklogic/error/path/5/{$code=$[\^^}")
function path-test-5($code as xs:string) { $code };
:)

(:
  %rest:path
  6. Must have exactly 1 string
:)
(: static error
declare %rest:path("/marklogic/error/path/6/a", "/marklogic/error/path/6/x")
function path-test-6a() { "Hello" };
:)
(: static error
declare %rest:path
function path-test-6a() { "Hello" };
:)
(:
  %rest:query-param
  $rest:header-param
  1. Must have 2 or more initial values
:)
declare
%rest:path("/marklogic/error/query-param/1/a")
%rest:query-param
function query-param-1a($a as xs:anyAtomicType?) { 'hello' };

declare
%rest:path("/marklogic/error/query-param/1/b")
%rest:query-param('a')
function query-param-1b($a as xs:string?) { $a };

declare
%rest:path("/marklogic/error/header-param/1/a")
%rest:header-param
function header-param-1a($a as xs:string?) { 'hello' };

declare
%rest:path("/marklogic/error/header-param/1/b")
%rest:header-param('a')
function header-param-1b($a as xs:string) { $a };

(:
  %rest:query-param
  $rest:header-param
  2. 2nd parameter must have valid Annotation Template Syntax
:)
declare
%rest:path("/marklogic/error/query-param/2/a")
%rest:query-param('a','${a}')
function query-param-2a($a as xs:string?) { $a };

declare
%rest:path("/marklogic/error/header-param/2/a")
%rest:header-param('a','')
function header-param-2a($a as xs:string) { $a };

(:
  %rest:query-param
  $rest:header-param
  3. All parameters must inherit from xs:anyAtomicType
:)
declare
%rest:path("/marklogic/error/query-param/3/a")
%rest:query-param('a','{$a}', '<e>Hello World</e>')
function query-param-3a($a as document-node(element())) { $a };

declare
%rest:path("/marklogic/error/header-param/3/a")
%rest:header-param('a', '{$a}', '<e>Hello World</e>')
function header-param-3a($a as document-node(element())) { $a };

(:
  %rest:query-param
  $rest:header-param
  4. First parameter must not be empty
:)
declare
%rest:path("/marklogic/error/query-param/4/a")
%rest:query-param('','{$a}')
function query-param-4a($a as xs:string) { $a };

declare
%rest:path("/marklogic/error/header-param/4/a")
%rest:header-param('','{$a}')
function header-param-4a($a as xs:string) { $a };

(:
  %rest:query-param
  $rest:header-param
  5. There must be a function parameter available to be mapped 
:)
declare
%rest:path("/marklogic/error/query-param/5/a")
%rest:query-param('a', '{$a}')
function query-param-5a($b as xs:string) { $b };

declare
%rest:path("/marklogic/error/header-param/5/a")
%rest:header-param('a', '{$a}')
function header-param-5a($b as xs:string) { $b };

(:
  %rest:form-param
  1. If present, cardinality of parameters must be 2 or more
:)
declare
%rest:path("/marklogic/error/form-param/1/a")
%rest:form-param
function form-param-1a($a as xs:string) { $a };

declare
%rest:path("/marklogic/error/form-param/1/b")
%rest:form-param('a')
function form-param-1b($a as xs:string) { $a };

(:
  %rest:form-param
  2. 2nd parameter must have valid Annotation Template Syntax
:)
declare
%rest:path("/marklogic/error/form-param/2/a")
%rest:form-param('a','${a}')
function form-param-2a($a as xs:string) { $a };

(:
  %rest:form-param
  3. All parameters must inherit from xs:anyAtomicType or map:map
:)
declare
%rest:path("/marklogic/error/form-param/3/a")
%rest:form-param('a','{$a}','<e>Hello</e>')
function form-param-3a($a as document-node(element())) { $a };

(:
  %rest:form-param
  4. First parameter must not be empty
:)
declare
%rest:path("/marklogic/error/form-param/4/a")
%rest:form-param('','{$a}')
function form-param-4a($a as xs:string) { $a };

(:
  %rest:form-param
  5. There must be a function parameter available to be mapped 
:)
declare
%rest:path("/marklogic/error/form-param/5/a")
%rest:form-param('a', '{$a}')
function form-param-5a($b as xs:string) { $b };

(:
  %rest:cookie-param
  1. If present, cardinality of parameters must be 2 or more
:)
declare
%rest:path("/marklogic/error/cookie-param/1/a")
%rest:cookie-param
function cookie-param-1a($a as xs:string) { $a };

declare
%rest:path("/marklogic/error/cookie-param/1/b")
%rest:cookie-param('a')
function cookie-param-1b($a as xs:string) { $a };

(:
  %rest:cookie-param
  2. 2nd parameter must have valid Annotation Template Syntax
:)
declare
%rest:path("/marklogic/error/cookie-param/2/a")
%rest:cookie-param('a','${a}')
function cookie-param-2a($a as xs:string) { $a };

(:
  %rest:cookie-param
  3. Mapped parameters must inherit from xs:anyAtomicType
:)
declare
%rest:path("/marklogic/error/cookie-param/3/a")
%rest:cookie-param('a','{$a}', '<e>Hello</e>')
function cookie-param-3a($a as document-node(element())) { $a };

declare
%rest:path("/marklogic/error/cookie-param/3/b")
%rest:cookie-param('a','{$a}', '')
function cookie-param-3b($a as map:map) { 'hello' };

(:
  %rest:cookie-param
  4. First parameter must not be empty
:)
declare
%rest:path("/marklogic/error/cookie-param/4/a")
%rest:cookie-param('','{$a}')
function cookie-param-4a($a as xs:string) { $a };

(:
  %rest:cookie-param
  5. There must be a function parameter available to be mapped 
:)
declare
%rest:path("/marklogic/error/cookie-param/5/a")
%rest:cookie-param('a', '{$a}')
function cookie-param-5a($b as xs:string) { $b };

(:
  %output:method
  1. If present, function result MUST be compatible with
     the serialization method
:)
declare %rest:path("/marklogic/error/output/1/a")
%output:method('text') function output-1a() { <e>Hello World</e> };

declare %rest:path("/marklogic/error/output/1/b")
%output:method('xml') function output-1b() { "Hello World" };

declare %rest:path("/marklogic/error/output/1/c")
%output:method('html') function output-1c() { "Hello World" };

declare %rest:path("/marklogic/error/output/1/d")
%output:method('json') function output-1d() { <e>Hello World</e> };

declare %rest:path("/marklogic/error/output/1/e")
%output:method('json') function output-1e() { "Hello World" };

declare %rest:path("/marklogic/error/output/1/f")
%output:method('turtle') function output-1f() { "Hello World" };

declare %rest:path("/marklogic/error/output/1/g")
%output:method('turtle') function output-1g() { <e>Hello World</e> };

declare %rest:path("/marklogic/error/output/1/h")
%output:method('text') function output-1h() {
  sem:triple(
    sem:iri('http://a'),
    sem:iri('http://b'),
    sem:iri('http://c')
  )
};

(:
  %output:method
  2. Must be a known/acceptable output method.
:)
declare %rest:path("/marklogic/error/output/2/a")
%output:method('whatever') function output-2a() { <e>Hello World</e> };

declare %rest:path("/marklogic/error/output/2/b")
%output:method('triples') function output-2b() { <e>Hello World</e> };


(:
  %POST and %PUT
  1. Must have no more than 1 value
:)
declare %rest:path("/marklogic/error/post/1/a")
%rest:POST('{$a}', 'x')
function post-1a($a) { "a" };

declare %rest:path("/marklogic/error/put/1/a")
%rest:PUT('{$a}', 'x')
function put-1a($a) { "a" };

(:
  %POST and %PUT
  2. Must have valid Annotation Template Syntax
:)
declare %rest:path("/marklogic/error/post/2/a")
%rest:POST('${a}')
function post-2a($a) { "a" };

declare %rest:path("/marklogic/error/put/2/a")
%rest:PUT('${a}')
function put-2a($a) { "a" };

(:
  %POST and %PUT
  3. If ATS specified, it MUST specify a function parameter 
:)
declare %rest:path("/marklogic/error/post/3/a")
%rest:POST('{$a}')
function post-3a($b as item()) { "a" };

declare %rest:path("/marklogic/error/put/3/a")
%rest:PUT('{$a}')
function put-3a($b as item()) { "a" };

(: But if the type could be item()? then invoke with empty-sequence() :)
declare %rest:path("/marklogic/error/post/3/b") %rest:POST('{$a}')
function post-3b($b) { "a" };
declare %rest:path("/marklogic/error/put/3/b") %rest:PUT('{$a}')
function put-3b($b) { "a" };

(:
  %POST and %PUT
  4. An error must be thrown if the Request Body can not be cast to the
     relevant function parameter type.
  TODO
:)
declare %rest:path("/marklogic/error/post/4/a")
%rest:POST("{$a}")
function post-4a($a as document-node(element())) { $a };

declare %rest:path("/marklogic/error/put/4/a")
%rest:PUT("{$a}")
function put-4a($a as document-node(element())) { $a };

(:
  %rest:consumes
  %rest:produces
  1. It is a error if a REST consumes Annotation is empty
:)
declare
  %rest:path("/marklogic/error/consumes/1/a")
  %rest:consumes
function consumes-1a() { "Hello" };

declare
  %rest:path("/marklogic/error/produces/1/a")
  %rest:produces
function produces-1a() { "Hello" };

(:
  %rest:consumes
  %rest:produces
  2. It is a error if consumes is not a valid Internet Media Type
:)
declare
  %rest:path("/marklogic/error/consumes/2/a")
  %rest:consumes('asdfsdf\sdfsdfsf.....')
function consumes-2a() { "Hello" };

declare
  %rest:path("/marklogic/error/produces/2/a")
  %rest:produces('application/json', 'asdfsdf\sdfsdfsf.....')
function produces-2a() { "Hello" };
