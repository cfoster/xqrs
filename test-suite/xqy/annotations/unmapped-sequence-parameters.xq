module namespace unmapped-zero-sequence-parameters =
  "/spec/annotations/unmapped-zero-sequence-parameters";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/annotations/unmapped/1/{$a}")
function unmapped-zero-sequence-parameters-1(
  $a as xs:string,
  $b as xs:string?,
  $c as xs:string?) {
  string-join(($a, $b, $c), ',')
};

declare
  %rest:path("/annotations/unmapped/2/{$b}")
function unmapped-zero-sequence-parameters-2(
  $a as xs:string?,
  $b as xs:string,
  $c as xs:string?) {
  string-join(($a, $b, $c), ',')
};

declare
  %rest:path("/annotations/unmapped/3/{$c}")
function unmapped-zero-sequence-parameters-3(
  $a as xs:string?,
  $b as xs:string?,
  $c as xs:string) {
  string-join(($a, $b, $c), ',')
};

declare
  %rest:path("/annotations/unmapped/4/{$a}/{$c}")
function unmapped-zero-sequence-parameters-4(
  $a as xs:string,
  $b as xs:string?,
  $c as xs:string) {
  string-join(($a, $b, $c), ',')
};

declare
  %rest:path("/annotations/unmapped/5/{$a}/{$c}")
function unmapped-zero-sequence-parameters-5(
  $a as xs:string,
  $b as xs:string*,
  $c as xs:string) {
  string-join(($a, $b, $c), ',')
};

