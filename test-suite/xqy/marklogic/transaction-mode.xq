module namespace transaction-mode = "/marklogic-tests/transaction-mode";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/marklogic/transaction-mode/update/true")
  %xdmp:update('true')
function update-true() {
  xdmp:get-transaction-mode()
};

declare
  %rest:path("/marklogic/transaction-mode/update/false")
  %xdmp:update('false')
function update-false() {
  xdmp:get-transaction-mode()
};

declare
  %rest:path("/marklogic/transaction-mode/update/auto")
  %xdmp:update('auto')
function update-auto() {
  xdmp:get-transaction-mode()
};

declare
  %rest:path("/marklogic/transaction-mode/update/no-argument")
  %xdmp:update
function update-default() {
  xdmp:get-transaction-mode()
};

declare
  %rest:path("/marklogic/transaction-mode/no-update-annotation")
function no-update-annotation() {
  xdmp:get-transaction-mode()
};

declare
  %rest:path("/marklogic/transaction-mode/read-only-insert")
  %xdmp:update('false')
function read-only-insert() {
  xdmp:document-insert('/a.xml', <e>Hello World</e>), "OK"
};
