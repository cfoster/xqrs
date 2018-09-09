package com.xmllondon.restxq.response

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class ResponseFormat extends RestXQBaseClass {

  spec {
    http("empty-sequence() - not even a rest:response").
      get("/response/response-format/empty-sequence")
      .check(
        header("Content-Length") is "0"
      )
      .check(
        header("Content-Type") notExists
      )
  }

  spec {
    http("201").
      get("/response/response-format/205/hello-there")
      .check(status is 205)
      .check(header("X-A") is "Value 1")
      .check(header("X-B") is "Value 2")
      .check(header("X-C") is "Value 3")
      .check(header("Content-Length") is "0")
      .check(header("Content-Type") notExists)
  }

  spec {
    http("405").
      get("/response/response-format/405/hello-there")
      .check(header("X-A") is "Value 1")
      .check(header("X-B") is "Value 2")
      .check(header("X-C") is "Value 3")
      .check(status is 405)
      .check(header("Content-Length") is "0")
      .check(header("Content-Type") notExists)
  }

  spec {
    http("506").
      get("/response/response-format-doc/506/hello-there")
      .check(status is 506)
      .check(header("X-A") is "Value 1")
      .check(header("Content-Length") is "0")
      .check(header("Content-Type") notExists)
  }

  spec {
    http("404 - with content (text)").
      get("/response/response-format/with-content/text")
      .check(status is 404)
      .check(headerRegex("Content-Type", "text/plain"))
      .check(header("X-A") is "Value 1")
      .check(bodyString is "Come back later\n" +
        "Might be back then.")
  }

  spec {
    http("404 - with content (xml)").
      get("/response/response-format/with-content/xml")
      .check(status is 404)
      .check(headerRegex("Content-Type", "text/xml"))
      .check(header("X-A") is "Value 1")
      .check(bodyString is "<message>Come back later. " +
        "Might be back then.</message>")
  }

}
