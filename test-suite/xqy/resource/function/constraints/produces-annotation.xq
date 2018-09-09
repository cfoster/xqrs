module namespace produces-annotation =
  "/spec/resource/function/produces-annotation";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/resource/function/produces-annotation")
  %rest:produces('application/json')
function application-json() {
  "application/json"
};

declare
  %rest:path("/resource/function/produces-annotation")
  %rest:produces('application/xml')
function application-xml() {
  "application/xml"
};

declare
  %rest:path("/resource/function/produces-annotation")
  %rest:produces('text/*')
function text-star() {
  "text/*"
};

declare
  %rest:path("/resource/function/produces-annotation")
  %rest:produces('text/plain')
function text-plain() {
  "text/plain"
};

declare
  %rest:path("/resource/function/produces-annotation")
  %rest:produces("text/abc", "text/xyz")
function either-or() {
  "either-or"
};

declare
  %rest:path("/resource/function/produces-annotation")
function no-annotation() {
  "no annotation"
};

declare
  %rest:path("/resource/function/produces-annotation")
  %rest:produces("*/xml")
function star-xml() {
  "*/xml"
};

declare
  %rest:path("/resource/function/produces-annotation/1")
  %rest:produces("*/*")
function star-star() {
  "*/*"
};

(: https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html :)
declare
  %rest:path("/resource/function/produces-annotation/2")
  %rest:produces("text/html;level=1")
function text-html-level-1() {
  "text/html;level=1"
};

declare
  %rest:path("/resource/function/produces-annotation/2")
  %rest:produces("text/html")
function text-html() {
  "text/html"
};

declare
  %rest:path("/resource/function/produces-annotation/2")
  %rest:produces("text/*")
function text-star-2() {
  "text/*"
};

declare
  %rest:path("/resource/function/produces-annotation/2")
  %rest:produces("*/*")
function star-star-2() {
  "*/*"
};

