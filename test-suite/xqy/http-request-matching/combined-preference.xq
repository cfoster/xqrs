module namespace global-preference =
  "/spec/http-request-matching/combined-preference";

declare namespace rest = "http://exquery.org/ns/restxq";

(:

The specificity of a Resource Function is governed by the
following rules, which MUST be applied in order.

1. Constraint Preference
2. Path Preference
3. Media Type Preference
:)

declare
  %rest:path("/http-request-matching/combined-preference/1")
  %rest:GET
function function-a() {
  "a" (: correct answer :)
};


declare
  %rest:path("/{$x}/combined-preference/1")
function function-b($x) {
  "b"
};


declare
  %rest:path("/http-request-matching/combined-preference/2")
  %rest:GET
function function-c() {
  "c" (: correct answer :)
};


declare
  %rest:path("/http-request-matching/combined-preference/2")
function function-d($x) {
  "d"
};

declare
  %rest:path("/{$x}/combined-preference/3")
  %rest:GET
function function-e($x as xs:string) {
  "e" (: correct answer :)
};


declare
  %rest:path("/http-request-matching/combined-preference/3")
function function-f() {
  "f"
};


declare
  %rest:path("/{$x}/combined-preference/4")
  %rest:consumes('text/xml')
function function-g($x as xs:string) {
  "g" (: correct answer :)
};


declare
  %rest:path("/http-request-matching/combined-preference/4")
function function-h() {
  "h" 
};

declare
  %rest:GET
  %rest:path("/http-request-matching/combined-preference/5/a/b/c")
  %rest:consumes("application/xml")
function function-i() {
  "i"
};

declare
  %rest:GET
  %rest:path("/http-request-matching/combined-preference/5/a/b/c")
function function-j() {
  "j"
};

