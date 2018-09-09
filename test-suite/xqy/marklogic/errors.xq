(:
https://openclipart.org/detail/282184/sleeping-cat
:)
module namespace errors = "/marklogic-tests/errors";

declare namespace rest = "http://exquery.org/ns/restxq";

declare namespace e1 = "http://consulting.xmllondon.com/xquery/e1";
declare namespace e2 = "http://consulting.xmllondon.com/xquery/e2";
declare namespace e3 = "http://consulting.xmllondon.com/xquery/e3";
declare namespace e4 = "http://consulting.xmllondon.com/xquery/e4";

declare namespace e6 = "http://consulting.xmllondon.com/xquery/e6";
declare namespace e7 = "http://consulting.xmllondon.com/xquery/e7";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace http = "http://expath.org/ns/http-client";

declare
  %rest:path("/marklogic/error/external/{$code}")
  %rest:query-param("message", "{$message}")
function simple-error($code as xs:integer, $message as xs:string)
{
  fn:error(xs:QName('rest:MyQName'), $message, $code)
};

declare
  %rest:path("/marklogic/error/e1/{$type}")
function e1($type as xs:integer)
{
  switch($type) 
    case 1 return fn:error(xs:QName("e1:error1"), "Description 1")
    case 2 return fn:error(xs:QName("e1:error2"), "Description 2")
    case 3 return fn:error(xs:QName("e1:error3"), "Description 3")
    default return fn:error(xs:QName("e1:errorX"), "Description X") 
};

declare %rest:error("e1:error1") function e1_error1() { "e1:error1" };
declare %rest:error("e1:error2") function e1_error2() { "e1:error2" };
declare %rest:error("e1:error3") function e1_error3() { "e1:error3" };
declare %rest:error("e1:*") function e1_wildcard() { "e1:*" };

declare
  %rest:path("/marklogic/error/e2/{$type}")
function e2($type as xs:integer)
{
  switch($type) 
    case 1 return fn:error(xs:QName("e2:error1"), "Description 1")
    case 2 return fn:error(xs:QName("e2:error2"), "Description 2")
    case 3 return fn:error(xs:QName("e2:error3"), "Description 3")
    default return fn:error(xs:QName("e2:errorX"), "Description X") 
};

declare %rest:error("e2:error1") function e2_error1() { "e2:error1" };
declare %rest:error("e2:error2") function e2_error2() { "e2:error2" };
declare %rest:error("e2:error3") function e2_error3() { "e2:error3" };
declare %rest:error("e2:*") function e2_wildcard() { "e2:*" };


declare
  %rest:path("/marklogic/error/e3/{$type}")
function e3($type as xs:integer)
{
  switch($type) 
    case 1 return fn:error(xs:QName("e3:error1"), "Description 1")
    case 2 return fn:error(xs:QName("e3:error2"), "Description 2")
    case 3 return fn:error(xs:QName("e3:error3"), "Description 3")
    default return fn:error(xs:QName("e3:errorX"), "Description X") 
};

declare %rest:error("*:error1") function star_error1() { "*:error1" };
declare %rest:error("*:error2") function star_error2() { "*:error2" };
declare %rest:error("*:error3") function star_error3() { "*:error3" };
declare %rest:error("*:errorX") function wildcard-errorX() { "*:errorX" };

declare
  %rest:path("/marklogic/error/e4/custom-serialization-and-error-code")
function e4()
{
  fn:error(xs:QName('e4:custom'), "Custom Error")
};

declare
  %rest:error("e4:custom")
  %output:media-type("text/my-special-text-type")
function e4_custom() {
  <rest:response>
    <http:response status="418" message="I'm a teapot">
      <http:header name="X-Custom-Header" value="My Value"/>
    </http:response>
  </rest:response>,
  "e4:custom"
};

(: MarkLogic Proprietary Error Codes :)
declare
  %rest:path("/marklogic/error/e5/div0")
function e5_1()
{
  1 div 0
};
declare %rest:error("XDMP-DIVBYZERO") function xdmp_divzero() {
  "XDMP-DIVBYZERO"
};

declare
  %rest:path("/marklogic/error/e5/bad-comment")
function e5_2()
{
  comment { "ends with a hyphen -" }
};

declare %rest:error("XDMP-*") function xdmp_wildcard() {
  "XDMP-*"
};

declare
  %rest:path("/marklogic/error/e6/specific")
function e6_1()
{
  fn:error(xs:QName('e6:specific'), 'Something specific')
};

declare
  %rest:path("/marklogic/error/e6/none-specific")
function e6_2()
{
  fn:error(xs:QName('e6:none-specific'), 'Something none-specific')
};

declare
  %rest:error("Q{http://consulting.xmllondon.com/xquery/e6}specific")
function e6_specific() {
  "specific"
};

declare
  %rest:error("Q{http://consulting.xmllondon.com/xquery/e6}*")
function e6_none_specific() {
  "none-specific"
};

declare
  %rest:path("/marklogic/error/e7/1")
function e7_1()
{
  fn:error(xs:QName('e7:params-1'), 'A particular error message.')
};

declare
  %rest:error("e7:params-1")
  %rest:error-param("description", "{$description}")
function params-1($description as xs:string) {
  $description
};

declare
  %rest:path("/marklogic/error/e7/2")
function e7_2()
{
  fn:error(
    xs:QName('e7:params-2'),
    'Another particular error message.',
    'a value'
  )
};

declare
  %rest:error("e7:params-2")
  %rest:error-param-1("code", "{$code}")
  %rest:error-param-2("description", "{$description}")
  %rest:error-param-3("value", "{$value}")
  %rest:error-param-4("module", "{$module}")
  %rest:error-param-5("line-number", "{$line}")
  %rest:error-param-6("column-number", "{$column}")
  %rest:error-param-7("additional", "{$additional}")  
function params-2(
  $code as xs:QName,
  $description as xs:string?,
  $value as item()*,
  $module as xs:string?,
  $line as xs:integer?,
  $column as xs:integer?,
  $additional as item()*) {
  
  <rest:response>
    <http:response status="400" message="Error occurred">
      <http:header name="X-Code" value="{$code}"/>
      <http:header name="X-Description" value="{$description}"/>
      <http:header name="X-Value" value="{$value}"/>
      <http:header name="X-Module" value="{$module}"/>
      <http:header name="X-Line" value="{$line}"/>
      <http:header name="X-Column" value="{$column}"/>
      <http:header name="X-Has-Additional" value="{
        $additional/element() instance of
        element(Q{http://marklogic.com/xdmp/error}error)}"/>
    </http:response>
  </rest:response>,

  
  "code: " || $code || "&#10;" ||
  "description: " || $description || "&#10;" ||
  "value: " || $value || "&#10;" ||
  "module: " || $module || "&#10;" ||
  "line: " || $line || "&#10;" ||
  "column: " || $column || "&#10;" ||
  "additional: " ||
    $additional instance of
    document-node(element(Q{http://marklogic.com/xdmp/error}error))
};
