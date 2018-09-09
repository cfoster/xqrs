module namespace query-parameters =
  "/spec/resource/function/query-parameters";

declare namespace rest = "http://exquery.org/ns/restxq";

(: ======================= Official RestXQ Standard ======================= :)

(: Taking a string :)
declare
  %rest:path("/resource/function/query-parameters/string")
  %rest:query-param("my-param", "{$xq-var}")
function standard-string($xq-var as xs:string) as xs:string {
  $xq-var
};

(: taking an integer :)
declare
  %rest:path("/resource/function/query-parameters/integer")
  %rest:query-param("my-param", "{$xq-var}", 5678)
function standard-integer($xq-var as xs:integer) as xs:integer {
  $xq-var
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/query-parameters/zero-sequence")
  %rest:query-param("my-param", "{$xq-var}")
function zero-sequence($xq-var as xs:string?) {
  ($xq-var, "zero-sequence")[1]
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/query-parameters/zero-sequence-default")
  %rest:query-param("my-param", "{$xq-var}", "default value")
function zero-sequence-with-default($xq-var as xs:string?) {
  ($xq-var, "should not see this value")[1]
};

(: Combining a Path template and a Query Parameter Template :)
declare
  %rest:path("/resource/function/query-parameters/combine/{$template}")
  %rest:query-param("my-param", "{$my-param}")
function combined-path-and-query-params(
  $my-param as xs:string,
  $template as xs:string) {
  $my-param || "," || $template
};

(: taking multiple values :)
declare
  %rest:path("/resource/function/query-parameters/multiple-values")
  %rest:query-param("my-param", "{$xq-var}", 1, 2, 3, 4, 5, 6, 7)
function multiple-values($xq-var as xs:integer+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

(: ======================================================================== :)
