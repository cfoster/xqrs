module namespace query-parameters =
  "/spec/resource/function/query-parameters-alternative";

declare namespace rest = "http://exquery.org/ns/restxq";

(: ========================== Alternative method ========================== :)
(: Taking a string :)
declare
  %rest:path("/resource/function/query-parameters-alternative/string")
  %rest:query-param-1("my-param", "{$xq-var}", "unknown")
function standard-string($xq-var as xs:string) as xs:string {
  $xq-var
};

(: taking an integer :)
declare
  %rest:path("/resource/function/query-parameters-alternative/integer")
  %rest:query-param-1("my-param", "{$xq-var}", 1234)
function standard-integer($xq-var as xs:integer) as xs:integer {
  $xq-var
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/query-parameters-alternative/zero-sequence")
  %rest:query-param-1("my-param", "{$xq-var}")
function zero-sequence($xq-var as xs:string?) {
  ($xq-var, "zero-sequence")[1]
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/query-parameters-alternative/zsd")
  %rest:query-param-1("my-param", "{$xq-var}", "default value")
function zero-sequence-with-default($xq-var as xs:string?) {
  ($xq-var, "should not see this value")[1]
};

(: Combining a Path template and a Query Parameter Template :)
declare
  %rest:path("/resource/function/query-parameters-alternative/combine/{$t}")
  %rest:query-param-1("my-param", "{$my-param}")
function combined-path-and-query-params(
  $my-param as xs:string,
  $t as xs:string) {
  $my-param || "," || $t
};

(: taking multiple values :)
declare
  %rest:path("/resource/function/query-parameters-alternative/multiple-values")
  %rest:query-param-1("my-param", "{$xq-var}", 1, 2, 3, 4, 5, 6, 7)
function multiple-values($xq-var as xs:integer+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

declare
  %rest:path("/resource/function/query-parameters-alternative/many")
  %rest:query-param-1("a", "{$a}")
  %rest:query-param-2("b", "{$b}")
  %rest:query-param-3("c", "{$c}")
  %rest:query-param-4("d", "{$d}")
  %rest:query-param-5("e", "{$e}")
  %rest:query-param-6("f", "{$f}")
  %rest:query-param-7("g", "{$g}")
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
  %rest:path("/resource/function/query-parameters-alternative/multi-datatype")
  %rest:query-param-1("date", "{$date}")
  %rest:query-param-2("integer", "{$integer}")
  %rest:query-param-3("decimal", "{$decimal}")
  %rest:query-param-4("string", "{$string}")
function multi-datatype(
  $date as xs:date,
  $integer as xs:integer,
  $decimal as xs:decimal,
  $string as xs:string) as xs:string {
  string-join((string($date), string($integer), string($decimal), $string), ',')
};

(: ======================================================================== :)
