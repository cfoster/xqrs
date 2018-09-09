module namespace insert-get-delete = "/marklogic-tests/insert-get-delete";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/marklogic/insert-get-delete/insert/{$doc}")
  %xdmp:update
function insert-1($doc as xs:string)
{
  xdmp:document-insert("/test/insert-get-delete/" || $doc, <e>{$doc}</e>)
};

declare
  %rest:path("/marklogic/insert-get-delete/get/{$doc}")
function get($doc as xs:string)
{
  fn:doc("/test/insert-get-delete/" || $doc)
};

declare
  %rest:path("/marklogic/insert-get-delete/delete/{$doc}")
  %xdmp:update
function delete($doc as xs:string)
{
  xdmp:document-delete("/test/insert-get-delete/" || $doc)
};

declare
  %rest:path("/marklogic/insert-get-delete/exists/{$doc}")
function exists($doc as xs:string)
{
  fn:doc-available("/test/insert-get-delete/" || $doc)
};

