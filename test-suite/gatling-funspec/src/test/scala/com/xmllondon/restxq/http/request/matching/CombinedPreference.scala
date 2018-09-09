package com.xmllondon.restxq.http.request.matching

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class CombinedPreference extends RestXQBaseClass {

  spec {
    http("Test 1")
      .get("/http-request-matching/combined-preference/1")
      .check(bodyString is "a")
  }

  spec {
    http("Test 2")
      .get("/http-request-matching/combined-preference/2")
      .check(bodyString is "c")
  }

  spec {
    http("Test 3")
      .get("/http-request-matching/combined-preference/3")
      .check(bodyString is "e")
  }

  spec {
    http("Test 4")
      .post("/http-request-matching/combined-preference/4")
      .header("Content-Type", "text/xml")
      .body(StringBody("<e>document</e>"))
      .check(
        bodyString is "g"
      )
  }

  spec {
    http("Test 5")
      .get("/http-request-matching/combined-preference/5/a/b/c")
      .header("Content-Type", "application/xml")
      .body(StringBody("<e>document</e>"))
      .check(
        bodyString is "i"
      )
  }

  spec {
    http("Test 5")
      .get("/http-request-matching/combined-preference/5/a/b/c")
      .header("Content-Type", "text/xml")
      .body(StringBody("<e>document</e>"))
      .check(
        bodyString is "j"
      )
  }

}
