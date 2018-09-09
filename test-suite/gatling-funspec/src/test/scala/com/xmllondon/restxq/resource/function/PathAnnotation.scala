package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class PathAnnotation extends RestXQBaseClass {

  spec {
    http("Basic RESTXQ Path Template")
      .get("/resource/function/path-annotation/1/a1/b2/c3/d4")
      .check(
        bodyString is "a1,b2,c3,d4"
      )
  }

  spec {
    http("RegEx [0-9]+ along with Basic Path Template")
      .get("/resource/function/path-annotation/2/1234/hello")
      .check(
        bodyString is "1234,hello"
      )
  }

  spec {
    http("RegEx Not conforming to RegEx along with Basic Path Template")
      .get("/resource/function/path-annotation/2/string/hello")
      .check(
        status is 404
      )
  }

  spec {
    http("RegEx with catch all .+ part at end")
      .get("/resource/function/path-annotation/3/1234/world/how/are/you")
      .check(
        bodyString is "1234,world/how/are/you"
      )
  }

  spec {
    http("Two .+ catch expressions in one path")
      .get("/resource/function/path-annotation/4/hello/world")
      .check(
        bodyString is "hello,world"
      )
  }

  spec {
    http("selecting a function based on a RegEx")
      .get("/resource/function/path-annotation/5/1234")
      .check(
        bodyString is "integer=1234"
      )
  }

  spec {
    http("selecting a function based on a RegEx")
      .get("/resource/function/path-annotation/5/HelloWorld")
      .check(
        bodyString is "string=HelloWorld"
      )
  }

  spec {
    http("selecting a function based on a RegEx")
      .get("/resource/function/path-annotation/5/2001-01-01")
      .check(
        bodyString is "date=2001-01-01"
      )
  }

  spec {
    http("selecting a function based on a RegEx")
      .get("/resource/function/path-annotation/5/£!")
      .check(
        status is 404
      )
  }

  spec {
    http("No prefix slash is allowed")
      .get("/resource/no-prefix-slash")
      .check(
        status is 200
      )
      .check(
        bodyString is "No Prefix Slash is working"
      )
  }

}
