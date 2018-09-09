module namespace function-mapping = "/marklogic-tests/function-mapping";

declare namespace rest = "http://exquery.org/ns/restxq";

(: MarkLogic Function Mapping complications :)

(:
  If $v exists, this should execute
  If $v does not exist, MarkLogic should return a 400 in this case
:)
declare
  %rest:path("/marklogic/function-mapping/1")
  %rest:query-param("v", "{$v}")
function marklogic-function-mapping-1($v as xs:string) {
  "v=" || $v
};

(:
  MarkLogic Function Mapping complication
  If $v exists, this should execute
  If $v does not exist, this should still execute
:)
declare
  %rest:path("/marklogic/function-mapping/2")
  %rest:query-param("v", "{$v}")
function marklogic-function-mapping-2($v as xs:string?) {
  "v=" || $v
};
