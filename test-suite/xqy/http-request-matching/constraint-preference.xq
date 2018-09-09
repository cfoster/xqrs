module namespace constraint-preference =
  "/spec/http-request-matching/constraint-preference";

declare namespace rest = "http://exquery.org/ns/restxq";

(:
1. Path, Method, Media Type
2. Path, Method
3. Path, Media Type
4. Path
5. Method, Media Type
6. Method
7. Media Type
:)

declare
  %rest:path("/http-request-matching/constraint-preference/1")
function function-1a() {
  "1a"
};

declare
  %rest:path("/http-request-matching/constraint-preference/1")
  %rest:POST("{$body}")
function function-1b($body as document-node()?) {
  "1b"
};

declare
  %rest:path("/http-request-matching/constraint-preference/1")
  %rest:POST("{$body}")
  %rest:consumes("text/xml")
function function-1c($body as document-node()?) {
  "1c" (: should be the correct result :)
};


declare
  %rest:path("/http-request-matching/constraint-preference/2")
function function-2a() {
  "2a"
};

declare
  %rest:path("/http-request-matching/constraint-preference/2")
  %rest:consumes("text/xml")
function function-2b($body as document-node()?) {
  "2b"
};

declare
  %rest:path("/http-request-matching/constraint-preference/2")
  %rest:POST("{$body}")
  %rest:consumes("text/xml")
function function-2c($body as document-node()?) {
  "2c" (: should be the correct result :)
};


declare
  %rest:path("/http-request-matching/constraint-preference/3")
function function-3a() {
  "3a"
};

declare
  %rest:path("/http-request-matching/constraint-preference/3")
  %rest:consumes("text/xml")
function function-3b($body as document-node()?) {
  "3b"
};

declare
  %rest:path("/http-request-matching/constraint-preference/3")
  %rest:POST("{$body}")
function function-3c($body as document-node()?) {
  "3c" (: should be the correct result :)
};


declare
  %rest:path("/http-request-matching/constraint-preference/4")
function function-4a() {
  "4a" (: should be the correct result :)
};

declare
  %rest:produces("random/stuff")
function function-4b() {
  "4b"
};

declare
  %rest:GET
function function-4c() {
  "4c"
};

declare
  %rest:produces("random/stuff")
  %rest:GET
function function-4d() {
  "4d"
};
