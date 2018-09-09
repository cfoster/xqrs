module namespace form-parameters =
  "/spec/resource/function/form-parameters";

declare namespace rest = "http://exquery.org/ns/restxq";

(: ======================= Official RestXQ Standard ======================= :)

(: Taking a string :)
declare
  %rest:path("/resource/function/form-parameters/string")
  %rest:form-param("my-param", "{$xq-var}")
function standard-string($xq-var as xs:string) as xs:string {
  $xq-var
};

(: taking an integer :)
declare
  %rest:path("/resource/function/form-parameters/integer")
  %rest:form-param("my-param", "{$xq-var}", 5678)
function standard-integer($xq-var as xs:integer) as xs:integer {
  $xq-var
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/form-parameters/zero-sequence")
  %rest:form-param("my-param", "{$xq-var}")
function zero-sequence($xq-var as xs:string?) {
  ($xq-var, "zero-sequence")[1]
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/form-parameters/zero-sequence-default")
  %rest:form-param("my-param", "{$xq-var}", "default value")
function zero-sequence-with-default($xq-var as xs:string?) {
  ($xq-var, "should not see this value")[1]
};

(: Combining a Path template and a Form Parameter Template :)
declare
  %rest:path("/resource/function/form-parameters/combine/{$template}")
  %rest:form-param("my-param", "{$my-param}")
function combined-path-and-form-params(
  $my-param as xs:string,
  $template as xs:string) {
  $my-param || "," || $template
};

(: taking multiple values :)
declare
  %rest:path("/resource/function/form-parameters/multiple-values")
  %rest:form-param("my-param", "{$xq-var}", 1, 2, 3, 4, 5, 6, 7)
function multiple-values($xq-var as xs:integer+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

(: ======================================================================== :)

(:
  Content-Type: multipart/form-data
  For HTML5, "multiple" attribute when Uploading files.  
:)
declare
  %rest:path("/resource/function/form-parameters/multipart-form-data/list")
  %rest:POST
  %rest:form-param("files", "{$files}")
function list-multipart-form-data($files as map:map) {
  string-join(
    for $key in map:keys($files)
    order by $key
    return $key
  , ",")
};

declare
  %rest:path("/resource/function/form-parameters/multipart-form-data/types")
  %rest:POST
  %rest:form-param("files", "{$files}")
function types-multipart-form-data($files as map:map) {
  string-join(
    for $key in map:keys($files)
    order by $key
    return
      substring-before(map:get(map:get($files, $key), "content-type"), ';')
  , ",")
};

declare
  %rest:path("/resource/function/form-parameters/multipart-form-data/value/{$filename}")
  %rest:POST
  %rest:form-param("files", "{$files}")
function body-and-mixed(
  $files as map:map,
  $filename as xs:string) {
  map:get(map:get($files, $filename), "body") 
};
