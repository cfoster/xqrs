package com.xmllondon.restxq.marklogic

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

/** Confirming XQuery 3.0 language is working as well as 1.0-ml **/

class XQuery30 extends RestXQBaseClass {

  spec {
    http("XQuery 3.0 library modules")
      .get("/marklogic/xquery3.0/1?v=hello")
      .check(status is 200)
      .check(bodyString is "v=hello")
  }

}
