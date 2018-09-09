package com.xmllondon.restxq.http.request.matching

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class ConstraintPreference extends RestXQBaseClass {

  spec {
    http("Test 1")
      .post("/http-request-matching/constraint-preference/1")
      .header("Content-Type", "text/xml")
      .body(StringBody("<e>document</e>"))
      .check(bodyString is "1c")
  }

  spec {
    http("Test 2")
      .post("/http-request-matching/constraint-preference/2")
      .header("Content-Type", "text/xml")
      .body(StringBody("<e>document</e>"))
      .check(bodyString is "2c")
  }

  spec {
    http("Test 3")
      .post("/http-request-matching/constraint-preference/3")
      .header("Content-Type", "text/xml")
      .body(StringBody("<e>document</e>"))
      .check(bodyString is "3c")
  }

  spec {
    http("Test 4")
      .get("/http-request-matching/constraint-preference/4")
      .header("Accept", "random/stuff")
      .check(bodyString is "4a")
  }

}
