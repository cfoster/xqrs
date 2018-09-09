module namespace consumes-annotation =
  "/spec/resource/function/consumes-annotation";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/resource/function/consumes-annotation")
  %rest:consumes('text/xml')
function text-xml() {
  "text/xml"
};

declare
  %rest:path("/resource/function/consumes-annotation")
  %rest:consumes('application/json')
function application-json() {
  "application/json"
};

declare
  %rest:path("/resource/function/consumes-annotation")
  %rest:consumes('application/binary')
function application-binary() {
  "application/binary"
};

declare
  %rest:path("/resource/function/consumes-annotation")
  %rest:consumes('multipart/mixed')
function multipart-mixed() {
  "multipart/mixed"
};

declare
  %rest:path("/resource/function/consumes-annotation")
  %rest:consumes("application/xml", "application/atom+xml")
function either-or() {
  "either-or"
};

