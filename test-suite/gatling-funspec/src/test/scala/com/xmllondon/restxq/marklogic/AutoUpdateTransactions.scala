package com.xmllondon.restxq.marklogic

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

/**
 * XQuery Functions which annotated with %xdmp:updating should execute.
 */
class AutoUpdateTransactions extends RestXQBaseClass {

  spec { // Single Update Transaction
    http("Insert a document").
      get("/marklogic/insert-get-delete/insert/auto").
      check(status is 200)
  }

  spec { // Single Query Transaction
    http("Check that the document exists").
      get("/marklogic/insert-get-delete/exists/auto").
      check(status is 200).
      check(bodyString is "true")
  }

  spec { // Single Query Transaction
    http("Retrieve the document").
      get("/marklogic/insert-get-delete/get/auto").
      check(status is 200).
      check(xpath("/e/string()") is "auto")
  }

  spec { // Single Update Transaction
    http("Delete the document").
      get("/marklogic/insert-get-delete/delete/auto").
      check(status is 200)
  }

  spec { // Single Query Transaction
    http("Confirm the document doesn't exist, after deleting it").
      get("/marklogic/insert-get-delete/exists/auto").
      check(status is 200).
      check(bodyString is "false")
  }

}
