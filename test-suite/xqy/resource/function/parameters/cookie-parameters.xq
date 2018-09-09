module namespace cookie-parameters =
  "/spec/resource/function/cookie-parameters";

declare namespace rest = "http://exquery.org/ns/restxq";

(: ======================= Official RestXQ Standard ======================= :)

(: Taking a string :)
declare
  %rest:path("/resource/function/cookie-parameters/string")
  %rest:cookie-param("Cookie-A", "{$xq-var}")
function standard-string($xq-var as xs:string) as xs:string {
  $xq-var
};

(: taking an integer :)
declare
  %rest:path("/resource/function/cookie-parameters/integer")
  %rest:cookie-param("Cookie-A", "{$xq-var}", 5678)
function standard-integer($xq-var as xs:integer) as xs:integer {
  $xq-var
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/cookie-parameters/zero-sequence")
  %rest:cookie-param("Cookie-A", "{$xq-var}")
function zero-sequence($xq-var as xs:string?) {
  ($xq-var, "zero-sequence")[1]
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/cookie-parameters/zero-sequence-default")
  %rest:cookie-param("Cookie-A", "{$xq-var}", "default value")
function zero-sequence-with-default($xq-var as xs:string?) {
  ($xq-var, "should not see this value")[1]
};

(: Combining a Path template and a Cookie Parameter Template :)
declare
  %rest:path("/resource/function/cookie-parameters/combine/{$template}")
  %rest:cookie-param("Cookie-A", "{$my-param}")
function combined-path-and-cookie-params(
  $my-param as xs:string,
  $template as xs:string) {
  $my-param || "," || $template
};

(: taking multiple values :)
declare
  %rest:path("/resource/function/cookie-parameters/multiple-values")
  %rest:cookie-param("Cookie-A", "{$xq-var}", 1, 2, 3, 4, 5, 6, 7)
function multiple-values($xq-var as xs:integer+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

declare
  %rest:path("/resource/function/cookie-parameters/multiple-values/string")
  %rest:cookie-param("Cookie-A", "{$xq-var}")
function multiple-values-string($xq-var as xs:string+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

(: ======================================================================== :)
