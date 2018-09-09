module namespace form-parameters-alternative =
  "/spec/resource/function/form-parameters-alternative";

declare namespace rest = "http://exquery.org/ns/restxq";

(: ========================== Alternative method ========================== :)
(: Taking a string :)
declare
  %rest:path("/resource/function/form-parameters-alternative/string")
  %rest:form-param-1("my-param", "{$xq-var}")
function standard-string($xq-var as xs:string) as xs:string {
  $xq-var
};

(: taking an integer :)
declare
  %rest:path("/resource/function/form-parameters-alternative/integer")
  %rest:form-param-1("my-param", "{$xq-var}", 5678)
function standard-integer($xq-var as xs:integer) as xs:integer {
  $xq-var
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/form-parameters-alternative/zero-sequence")
  %rest:form-param-1("my-param", "{$xq-var}")
function zero-sequence($xq-var as xs:string?) {
  ($xq-var, "zero-sequence")[1]
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/form-parameters-alternative/zero-sequence-default")
  %rest:form-param-1("my-param", "{$xq-var}", "default value")
function zero-sequence-with-default($xq-var as xs:string?) {
  ($xq-var, "should not see this value")[1]
};

(: Combining a Path template and a Form Parameter Template :)
declare
  %rest:path("/resource/function/form-parameters-alternative/combine/{$template}")
  %rest:form-param-1("my-param", "{$my-param}")
function combined-path-and-form-params(
  $my-param as xs:string,
  $template as xs:string) {
  $my-param || "," || $template
};

(: taking multiple values :)
declare
  %rest:path("/resource/function/form-parameters-alternative/multiple-values")
  %rest:form-param-1("my-param", "{$xq-var}", 1, 2, 3, 4, 5, 6, 7)
function multiple-values($xq-var as xs:integer+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

declare
  %rest:path("/resource/function/form-parameters-alternative/many")
  %rest:form-param-1("a", "{$a}")
  %rest:form-param-2("b", "{$b}")
  %rest:form-param-3("c", "{$c}")
  %rest:form-param-4("d", "{$d}")
  %rest:form-param-5("e", "{$e}")
  %rest:form-param-6("f", "{$f}")
  %rest:form-param-7("g", "{$g}")
function many(
  $a as xs:string,
  $b as xs:string,
  $c as xs:string,
  $d as xs:string,
  $e as xs:string,
  $f as xs:string,
  $g as xs:string) as xs:string {
  string-join(($a, $b, $c, $d, $e, $f, $g), ",")
};

declare
  %rest:path("/resource/function/form-parameters-alternative/multi-datatype")
  %rest:form-param-1("date", "{$date}")
  %rest:form-param-2("integer", "{$integer}")
  %rest:form-param-3("decimal", "{$decimal}")
  %rest:form-param-4("string", "{$string}")
function multi-datatype(
  $date as xs:date,
  $integer as xs:integer,
  $decimal as xs:decimal,
  $string as xs:string) as xs:string {
  string-join((string($date), string($integer), string($decimal), $string), ',')
};


(: ======================================================================== :)

(:
  Content-Type: multipart/form-data
  For HTML5, "multiple" attribute when Uploading files.  
:)
declare
  %rest:path("/resource/function/form-parameters-alternative/multipart-form-data/list")
  %rest:POST
  %rest:form-param-1("files", "{$files}")
function list-multipart-form-data($files as map:map) {
  string-join(
    for $key in map:keys($files)
    order by $key
    return $key
  , ",")
};

declare
  %rest:path("/resource/function/form-parameters-alternative/multipart-form-data/types")
  %rest:POST
  %rest:form-param-1("files", "{$files}")
function types-multipart-form-data($files as map:map) {
  string-join(
    for $key in map:keys($files)
    order by $key
    return
      substring-before(map:get(map:get($files, $key), "content-type"), ';')
  , ",")
};

declare
  %rest:path("/resource/function/form-parameters-alternative/multipart-form-data/value/{$filename}")
  %rest:POST
  %rest:form-param-1("files", "{$files}")
function body-and-mixed(
  $files as map:map,
  $filename as xs:string) {
  map:get(map:get($files, $filename), "body") 
};
