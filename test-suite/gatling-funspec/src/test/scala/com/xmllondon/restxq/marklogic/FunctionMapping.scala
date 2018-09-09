package com.xmllondon.restxq.marklogic

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class FunctionMapping extends RestXQBaseClass {

  spec {
    http("MarkLogic Function Mapping (1)")
      .get("/marklogic/function-mapping/1?v=hello")
      .check(status is 200)
      .check(bodyString is "v=hello")
  }

  spec {
    http("MarkLogic Function Mapping (1)")
      .get("/marklogic/function-mapping/1")
      .check(status is 400)
  }

  spec {
    http("MarkLogic Function Mapping (2)")
      .get("/marklogic/function-mapping/2?v=hello")
      .check(status is 200)
      .check(bodyString is "v=hello")
  }

  spec {
    http("MarkLogic Function Mapping (2)")
      .get("/marklogic/function-mapping/2")
      .check(status is 200)
      .check(bodyString is "v=")
  }

}
