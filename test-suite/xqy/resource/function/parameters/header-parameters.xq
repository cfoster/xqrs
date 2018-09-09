module namespace header-parameters =
  "/spec/resource/function/header-parameters";

declare namespace rest = "http://exquery.org/ns/restxq";

(: ======================= Official RestXQ Standard ======================= :)

(: Taking a string :)
declare
  %rest:path("/resource/function/header-parameters/string")
  %rest:header-param("X-My-Header", "{$xq-var}")
function standard-string($xq-var as xs:string) as xs:string {
  $xq-var
};

(: taking an integer :)
declare
  %rest:path("/resource/function/header-parameters/integer")
  %rest:header-param("X-My-Header", "{$xq-var}", 5678)
function standard-integer($xq-var as xs:integer) as xs:integer {
  $xq-var
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/header-parameters/zero-sequence")
  %rest:header-param("X-My-Header", "{$xq-var}")
function zero-sequence($xq-var as xs:string?) {
  ($xq-var, "zero-sequence")[1]
};

(: zero sequence should be allowed :)
declare
  %rest:path("/resource/function/header-parameters/zero-sequence-default")
  %rest:header-param("X-My-Header", "{$xq-var}", "default value")
function zero-sequence-with-default($xq-var as xs:string?) {
  ($xq-var, "should not see this value")[1]
};

(: Combining a Path template and a Header Parameter Template :)
declare
  %rest:path("/resource/function/header-parameters/combine/{$template}")
  %rest:header-param("X-My-Header", "{$my-param}")
function combined-path-and-header-params(
  $my-param as xs:string,
  $template as xs:string) {
  $my-param || "," || $template
};

(: taking multiple values 
   an implementation MUST extract each value from the comma separated
   list into an item in the sequence provided to the function parameter.
:)
declare
  %rest:path("/resource/function/header-parameters/multiple-values")
  %rest:header-param("X-My-Header", "{$xq-var}", 1, 2, 3, 4, 5, 6, 7)
function multiple-values($xq-var as xs:integer+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};

(: an implementation MUST extract each value from the comma separated
   list into an item in the sequence provided to the function parameter.
:)
declare
  %rest:path("/resource/function/header-parameters/multiple-values/string")
  %rest:header-param("X-My-Header", "{$xq-var}")
function multiple-values-string($xq-var as xs:string+) as xs:string {
  string-join(for $x in $xq-var order by $x ascending return string($x), ',')
};


(: ======================================================================== :)
