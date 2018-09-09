package com.xmllondon.restxq.marklogic

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class Errors extends RestXQBaseClass {

  spec {
    http("Error (e1)")
      .get("/marklogic/error/e1/1")
      .check(status is 400)
      .check(bodyString is "e1:error1")

  }

  spec {
    http("Error (e1)")
      .get("/marklogic/error/e1/2")
      .check(status is 400)
      .check(bodyString is "e1:error2")

  }

  spec {
    http("Error (e1)")
      .get("/marklogic/error/e1/3")
      .check(status is 400)
      .check(bodyString is "e1:error3")

  }

  spec {
    http("Error (e1)")
      .get("/marklogic/error/e1/4")
      .check(status is 400)
      .check(bodyString is "e1:*")

  }

  spec {
    http("Error (e2)")
      .get("/marklogic/error/e2/1")
      .check(status is 400)
      .check(bodyString is "e2:error1")

  }

  spec {
    http("Error (e2)")
      .get("/marklogic/error/e2/2")
      .check(status is 400)
      .check(bodyString is "e2:error2")

  }

  spec {
    http("Error (e2)")
      .get("/marklogic/error/e2/3")
      .check(status is 400)
      .check(bodyString is "e2:error3")

  }

  spec {
    http("Error (e2)")
      .get("/marklogic/error/e2/4")
      .check(status is 400)
      .check(bodyString is "e2:*")

  }

  spec {
    http("Error (e3)")
      .get("/marklogic/error/e3/1")
      .check(status is 400)
      .check(bodyString is "*:error1")

  }

  spec {
    http("Error (e3)")
      .get("/marklogic/error/e3/2")
      .check(status is 400)
      .check(bodyString is "*:error2")

  }

  spec {
    http("Error (e3)")
      .get("/marklogic/error/e3/3")
      .check(status is 400)
      .check(bodyString is "*:error3")

  }

  spec {
    http("Error (e3)")
      .get("/marklogic/error/e3/4")
      .check(status is 400)
      .check(bodyString is "*:errorX")

  }

  spec {
    http("Error (e4)")
      .get("/marklogic/error/e4/custom-serialization-and-error-code")
      .check(status is 418)
      .check(header("X-Custom-Header") is "My Value")
      .check(headerRegex("Content-Type", "text/my-special-text-type"))
      .check(bodyString is "e4:custom")
  }

  spec {
    http("Error (e5)")
      .get("/marklogic/error/e5/div0")
      .check(status is 400)
      .check(bodyString is "XDMP-DIVBYZERO")

  }

  spec {
    http("Error (e5)")
      .get("/marklogic/error/e5/bad-comment")
      .check(status is 400)
      .check(bodyString is "XDMP-*")
  }

  spec {
    http("Error (e6)")
      .get("/marklogic/error/e6/specific")
      .check(status is 400)
      .check(bodyString is "specific")

  }

  spec {
    http("Error (e6)")
      .get("/marklogic/error/e6/none-specific")
      .check(status is 400)
      .check(bodyString is "none-specific")
  }

  spec {
    http("Error (e7)")
      .get("/marklogic/error/e7/1")
      .check(status is 400)
      .check(bodyString is "A particular error message.")
  }

  spec {
    http("Error (e7)")
      .get("/marklogic/error/e7/2")
      .check(status is 400)
      .check(header("X-Code") is "e7:params-2")
      .check(header("X-Description") is "Another particular error message.")
      .check(header("X-Value") is "a value")
      .check(header("X-Module") is "/test-suite/xqy/marklogic/errors.xq")
      .check(headerRegex("X-Line", "^[0-9]+$"))
      .check(headerRegex("X-Column", "^[0-9]+$"))
      .check(header("X-Has-Additional") is "true")
  }

}
