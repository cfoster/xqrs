module namespace unmapped-zero-sequence-parameters =
  "/spec/annotations/parameter-order";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/annotations/parameter-order/{$a}/{$b}/{$c}")
  %rest:query-param("client", "{$client}", "unknown")
function parameter-order(
  $c as xs:string,
  $a as xs:string,
  $b as xs:string) {
  string-join(($c, $a, $b), ',')
};
