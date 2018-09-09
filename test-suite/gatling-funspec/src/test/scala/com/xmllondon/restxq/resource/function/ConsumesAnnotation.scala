package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class ConsumesAnnotation extends RestXQBaseClass {

  spec {
    http("POST text/xml").
      post("/resource/function/consumes-annotation")
      .header("Content-Type", "text/xml")
      .bodyPart(StringBodyPart("<e>apples</e>"))
      .check(
        bodyString is "text/xml"
      )
  }

  spec {
    http("POST application/json").
      post("/resource/function/consumes-annotation")
      .header("Content-Type", "application/json")
      .bodyPart(StringBodyPart("[1, 2, 3]"))
      .check(
        bodyString is "application/json"
      )
  }

  spec {
    http("POST application/binary").
      post("/resource/function/consumes-annotation")
      .header("Content-Type", "application/binary")
      .bodyPart(StringBodyPart("abc"))
      .check(
        bodyString is "application/binary"
      )
  }

  spec {
    http("POST multipart/mixed").
      post("/resource/function/consumes-annotation")
      .header(
        "Content-Type", "multipart/mixed; boundary=\"" + boundary + "\"")
      .body(
        StringBody(s"""--${boundary}
                      |Content-Type: text/xml
                      |
                      |<first-document>number 1</first-document>
                      |
                      |--${boundary}
                      |Content-Type: text/xml
                      |
                      |<second-document>number 2</second-document>
                      |
                      |--${boundary}--"""
          .stripMargin.replaceAll("\r?\n", "\r\n"))
      )
      .check(
        bodyString is "multipart/mixed"
      )
  }

  spec {
    http("POST (either application/xml or application/atom+xml) 1")
      .post("/resource/function/consumes-annotation")
      .header("Content-Type", "application/xml")
      .bodyPart(StringBodyPart("<e>apples</e>"))
      .check(
        bodyString is "either-or"
      )
  }

  spec {
    http("POST (either application/xml or application/atom+xml) 2")
      .post("/resource/function/consumes-annotation")
      .header("Content-Type", "application/atom+xml")
      .bodyPart(StringBodyPart("<e>apples</e>"))
      .check(
        bodyString is "either-or"
      )
  }

}
