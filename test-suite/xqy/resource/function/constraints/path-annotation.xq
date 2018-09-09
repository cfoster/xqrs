module namespace path-annotation =
  "/spec/resource/function/path-annotation";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/resource/function/path-annotation/1/{$a}/{$b}/{$c}/{$d}")
function basic-template(
  $d as xs:string,
  $c as xs:string,
  $b as xs:string,
  $a as xs:string) as xs:string {
  string-join(($a, $b, $c, $d), ',')
};

declare
  %rest:path("/resource/function/path-annotation/2/{$a=[0-9]+}/{$b}")
function regex-1($a as xs:integer, $b as xs:string) as xs:string {
  string-join((string($a), $b), ',')
};

declare
  %rest:path("/resource/function/path-annotation/3/{$a}/{$b=.+}")
function regex-2($a as xs:integer, $b as xs:string) as xs:string {
  string-join((string($a), $b), ',')
};

declare
  %rest:path("/resource/function/path-annotation/4/{$a=.+}/{$b=.+}")
function regex-3($a as xs:string, $b as xs:string) as xs:string {
  string-join(($a, $b), ',')
};

declare
  %rest:path("/resource/function/path-annotation/5/{$a=[0-9]+}")
function regex-types-1($a as xs:integer) as xs:string {
  'integer=' || $a
};

declare
  %rest:path("/resource/function/path-annotation/5/{$a=[0-9]+-[0-9]+-[0-9]+}")
function regex-types-2($a as xs:date) as xs:string {
  'date=' || $a
};

declare
  %rest:path("/resource/function/path-annotation/5/{$a=[a-zA-Z]+}")
function regex-types-3($a as xs:string) as xs:string {
  'string=' || $a
};

declare
  %rest:path("resource/no-prefix-slash")
function no-prefix-slash() as xs:string {
  "No Prefix Slash is working"
};

(:
declare
  %rest:path("/resource/function/path-annotation/5/{$a=[a-zsdfsdfs")
function regex-types-4($a as xs:string) as xs:string {
  'string=' || $a
};
:)