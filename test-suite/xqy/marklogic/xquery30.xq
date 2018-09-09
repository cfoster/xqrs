xquery version "3.0";

module namespace xquery30 = "/marklogic-tests/xquery3.0";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/marklogic/xquery3.0/1")
  %rest:query-param("v", "{$v}")
function xq3-1($v as xs:string) {
  "v=" || $v
};
