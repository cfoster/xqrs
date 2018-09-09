module namespace header-parameters-alternative =
  "/spec/resource/function/header-parameters-alternative";

declare namespace rest = "http://exquery.org/ns/restxq";

(: ========================== Alternative method ========================== :)
(: Taking a string :)
declare
  %rest:path("/resource/function/header-parameters-alternative/string")
  %rest:header-param-1("x-my-header", "{$xq-var}", "unknown")
function standard-string($xq-var as xs:string) as xs:string {
  $xq-var
};

(: taking an integer :)
declare
  %rest:path("/resource/function/header-parameters-alternative/integer")
  %rest:header-param-1("x-my-header", "{$xq-var}", 1234)
function standard-integer($xq-var as xs:integer) as xs:integer {
  $xq-var
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/header-parameters-alternative/zero-sequence")
  %rest:header-param-1("x-my-header", "{$xq-var}")
function zero-sequence($xq-var as xs:string?) {
  ($xq-var, "zero-sequence")[1]
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/header-parameters-alternative/zsd")
  %rest:header-param-1("x-my-header", "{$xq-var}", "default value")
function zero-sequence-with-default($xq-var as xs:string?) {
  ($xq-var, "should not see this value")[1]
};

(: Combining a Path template and a Header Parameter Template :)
declare
  %rest:path("/resource/function/header-parameters-alternative/combine/{$t}")
  %rest:header-param-1("x-my-header", "{$my-param}")
function combined-path-and-header-params(
  $my-param as xs:string,
  $t as xs:string) {
  $my-param || "," || $t
};

(: taking multiple values 
   an implementation MUST extract each value from the comma separated
   list into an item in the sequence provided to the function parameter.
:)
declare
  %rest:path("/resource/function/header-parameters-alternative/multiple-values")
  %rest:header-param-1("x-my-header", "{$xq-var}", 1, 2, 3, 4, 5, 6, 7)
function multiple-values($xq-var as xs:integer+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

(: an implementation MUST extract each value from the comma separated
   list into an item in the sequence provided to the function parameter.
:)
declare
  %rest:path("/resource/function/header-parameters-alternative/multiple-values/string")
  %rest:header-param-1("X-My-Header", "{$xq-var}")
function multiple-values-string($xq-var as xs:string+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

declare
  %rest:path("/resource/function/header-parameters-alternative/many")
  %rest:header-param-1("a", "{$a}")
  %rest:header-param-2("b", "{$b}")
  %rest:header-param-3("c", "{$c}")
  %rest:header-param-4("d", "{$d}")
  %rest:header-param-5("e", "{$e}")
  %rest:header-param-6("f", "{$f}")
  %rest:header-param-7("g", "{$g}")
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
  %rest:path("/resource/function/header-parameters-alternative/multi-datatype")
  %rest:header-param-1("date", "{$date}")
  %rest:header-param-2("integer", "{$integer}")
  %rest:header-param-3("decimal", "{$decimal}")
  %rest:header-param-4("string", "{$string}")
function multi-datatype(
  $date as xs:date,
  $integer as xs:integer,
  $decimal as xs:decimal,
  $string as xs:string) as xs:string {
  string-join((string($date), string($integer), string($decimal), $string), ',')
};

(: ======================================================================== :)
