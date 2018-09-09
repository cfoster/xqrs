
module namespace stock = "http://restxq/stock";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/stock/widget/{$id}")
function widget($id as xs:int) {
  "Widget-" || $id,
  xdmp:get-transaction-mode()
  };

declare
  %rest:path("/stock/widget/{$id}/{$date}")
function widget-abc($id as xs:int, $date as xs:date) {
  $id || ' - ' || $date
};

declare
  %rest:path("/stock/widget2/{$id}")
function widget-x($id as xs:int) {
  "Widget-1234"
};

declare
  %rest:path("/stock/widget3/{$id}")
function widget-update($id as xs:int) {
  xdmp:document-insert("/abc.xml",<a>Hello World</a>)
};

