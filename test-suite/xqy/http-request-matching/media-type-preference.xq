module namespace media-type-preference =
  "/spec/http-request-matching/media-type-preference";

declare namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/http-request-matching/media-type-preference")
  %rest:consumes("application/xml")
  %rest:POST("{$body}")
function application-xml($body as document-node()) {
  "application/xml"
};

declare
  %rest:path("/http-request-matching/media-type-preference")
  %rest:consumes("application/*")
  %rest:POST("{$body}")
function application-wildcard($body as binary()) {
  "application/*"
};

declare
  %rest:path("/http-request-matching/media-type-preference")
  %rest:consumes("*/xml")
  %rest:POST("{$body}")
function wildcard-xml($body as document-node()) {
  "*/xml"
};
