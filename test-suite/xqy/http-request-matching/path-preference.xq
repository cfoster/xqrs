module namespace path-preference =
  "/spec/http-request-matching/path-preference";

declare namespace rest = "http://exquery.org/ns/restxq";

(:
  1. Path Segment Length

  calling /a/b/c must invoke 1c
  calling /a/b must invoke 1b
  calling /a must invoke 1a
:)
declare
  %rest:path("/http-request-matching/path-preference/1/a")
function function-1a() {
  "a"
};

declare
  %rest:path("/http-request-matching/path-preference/1/a/b")
function function-1b() {
  "b"
};

declare
  %rest:path("/http-request-matching/path-preference/1/a/b/c")
function function-1c() {
  "c"
};

(:
  2. Path Selection

  Calling /a/b must invoke 2a
  Calling /a/y must invoke 2b
  Calling /y/b must invoke 2c
  Calling /y/z must invoke 2d
:)

declare
  %rest:path("/http-request-matching/path-preference/2/a/b")
function function-2a() {
  "a"
};

declare
  %rest:path("/http-request-matching/path-preference/2/a/{$x}")
function function-2b($x as xs:string) {
  "b"
};

declare
  %rest:path("/http-request-matching/path-preference/2/{$x}/b")
function function-2c($x as xs:string) {
  "c"
};

declare
  %rest:path("/http-request-matching/path-preference/2/{$x}/{$y}")
function function-2d($x as xs:string, $y as xs:string) {
  "d"
};
