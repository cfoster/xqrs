module namespace cookie-parameters-alternative =
  "/spec/resource/function/cookie-parameters-alternative";

declare namespace rest = "http://exquery.org/ns/restxq";

(: ========================== Alternative method ========================== :)

(: Taking a string :)
declare
  %rest:path("/resource/function/cookie-parameters-alternative/string")
  %rest:cookie-param-1("Cookie-A", "{$xq-var}")
function standard-string($xq-var as xs:string) as xs:string {
  $xq-var
};

(: taking an integer :)
declare
  %rest:path("/resource/function/cookie-parameters-alternative/integer")
  %rest:cookie-param-1("Cookie-A", "{$xq-var}", 5678)
function standard-integer($xq-var as xs:integer) as xs:integer {
  $xq-var
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/cookie-parameters-alternative/zero-sequence")
  %rest:cookie-param-1("Cookie-A", "{$xq-var}")
function zero-sequence($xq-var as xs:string?) {
  ($xq-var, "zero-sequence")[1]
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/cookie-parameters-alternative/zero-sequence-default")
  %rest:cookie-param-1("Cookie-A", "{$xq-var}", "default value")
function zero-sequence-with-default($xq-var as xs:string?) {
  ($xq-var, "should not see this value")[1]
};

(: Combining a Path template and a Cookie Parameter Template :)
declare
  %rest:path("/resource/function/cookie-parameters-alternative/combine/{$template}")
  %rest:cookie-param-1("Cookie-A", "{$my-param}")
function combined-path-and-cookie-params(
  $my-param as xs:string,
  $template as xs:string) {
  $my-param || "," || $template
};

(: taking multiple values :)
declare
  %rest:path("/resource/function/cookie-parameters-alternative/multiple-values")
  %rest:cookie-param-1("Cookie-A", "{$xq-var}", 1, 2, 3, 4, 5, 6, 7)
function multiple-values($xq-var as xs:integer+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

declare
  %rest:path("/resource/function/cookie-parameters-alternative/multiple-values/string")
  %rest:cookie-param-1("Cookie-A", "{$xq-var}")
function multiple-values-string($xq-var as xs:string+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

declare
  %rest:path("/resource/function/cookie-parameters-alternative/many")
  %rest:cookie-param-1("a", "{$a}")
  %rest:cookie-param-2("b", "{$b}")
  %rest:cookie-param-3("c", "{$c}")
  %rest:cookie-param-4("d", "{$d}")
  %rest:cookie-param-5("e", "{$e}")
  %rest:cookie-param-6("f", "{$f}")
  %rest:cookie-param-7("g", "{$g}")
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
  %rest:path("/resource/function/cookie-parameters-alternative/multi-datatype")
  %rest:cookie-param-1("date", "{$date}")
  %rest:cookie-param-2("integer", "{$integer}")
  %rest:cookie-param-3("decimal", "{$decimal}")
  %rest:cookie-param-4("string", "{$string}")
function multi-datatype(
  $date as xs:date,
  $integer as xs:integer,
  $decimal as xs:decimal,
  $string as xs:string) as xs:string {
  string-join((string($date), string($integer), string($decimal), $string), ',')
};


(: ======================================================================== :)
