package com.xmllondon.restxq.http.request.matching

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class MediaTypePreference extends RestXQBaseClass {

  spec {
    http("POST application/xml")
      .post("/http-request-matching/media-type-preference")
      .header("Content-Type", "application/xml")
      .body(StringBody("<e>document</e>"))
      .check(
        bodyString is "application/xml"
      )
  }

  spec {
    http("POST application/binary")
      .post("/http-request-matching/media-type-preference")
      .header("Content-Type", "application/binary")
      .body(StringBody("<e>document</e>"))
      .check(
        bodyString is "application/*"
      )
  }

  spec {
    http("POST text/xml")
      .post("/http-request-matching/media-type-preference")
      .header("Content-Type", "text/xml")
      .body(StringBody("<e>document</e>"))
      .check(
        bodyString is "*/xml"
      )
  }

  spec {
    http("POST text/unknown")
      .post("/http-request-matching/media-type-preference")
      .header("Content-Type", "text/unknown")
      .body(StringBody("<e>document</e>"))
      .check(
        status not 200
      )
  }

}
