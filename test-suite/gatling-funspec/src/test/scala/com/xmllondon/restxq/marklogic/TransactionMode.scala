package com.xmllondon.restxq.marklogic

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class TransactionMode extends RestXQBaseClass {

  spec {
    http("%xdmp:update('true')").
      get("/marklogic/transaction-mode/update/true").
      check(status is 200).
      check(bodyString is "update-auto-commit")
  }

  spec {
    http("%xdmp:update('false')").
      get("/marklogic/transaction-mode/update/false").
      check(status is 200).
      check(bodyString is "query-single-statement")
  }

  spec {
    http("%xdmp:update('auto')").
      get("/marklogic/transaction-mode/update/auto").
      check(status is 200).
      check(bodyString is "query-single-statement")
  }

  spec {
    http("%xdmp:update").
      get("/marklogic/transaction-mode/update/no-argument").
      check(status is 200).
      check(bodyString is "update-auto-commit")
  }

  spec {
    http("No %xdmp:update annotation").
      get("/marklogic/transaction-mode/no-update-annotation").
      check(status is 200).
      check(bodyString is "query-single-statement")
  }

  spec {
    http("Trying to perform an update in a read-only transaction").
      get("/marklogic/transaction-mode/read-only-insert").
      check(status is 400)
  }

}
