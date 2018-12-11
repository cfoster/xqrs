module namespace session-testing = "/marklogic-tests/session-testing";

import module namespace sec="http://marklogic.com/xdmp/security"
  at "/MarkLogic/security.xqy";

declare namespace rest = "http://exquery.org/ns/restxq";

declare variable $user := "test-user";
declare variable $pass := "password123";

(:
  Creating a Test User, for the purposes of testing the Session Module and
  logging in via another another use at the application level.
:)
declare
  %rest:path("/marklogic/session/create-user")
  %xdmp:update
function create-user() {
  let $user-exists := function() {
    sec:user-exists($user)
  }

  let $create-user := function() {
    sec:create-user(
      $user,
      "User for XQRS testing purposes",
      $pass,
      "rest-reader",
      (), (: permissions :)
      () (: collections :)
    )
  }

  return if(fn:not(
    xdmp:invoke-function(
      $user-exists,
      map:entry('database', xdmp:security-database())
    ))) then (
  
    let $_ :=
      xdmp:invoke-function(
        $create-user,
        map:entry('database', xdmp:security-database())
      )

    return ()
  ) else (),
  "OK"
};
