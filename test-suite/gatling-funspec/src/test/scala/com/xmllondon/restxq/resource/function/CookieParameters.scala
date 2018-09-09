package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

class CookieParameters extends RestXQBaseClass {

  spec {
    http("Cookie Parameters - String").
      get("/resource/function/cookie-parameters/string")
      .header("Cookie", "Cookie-A=oranges")
      .check(
        bodyString is "oranges"
      )
  }

  spec {
    http("Cookie Parameters - Integer").
      get("/resource/function/cookie-parameters/integer")
      .header("Cookie", "Cookie-A=1234")
      .check(
        bodyString is "1234"
      )
  }

  spec {
    http("Cookie Parameters - Parameter Accepting Zero Sequence").
      get("/resource/function/cookie-parameters/zero-sequence")
      .check(
        bodyString is "zero-sequence"
      )
  }

  spec {
    http("Cookie Parameters - Zero Sequence, Default Value").
      get("/resource/function/cookie-parameters/zero-sequence-default")
      .check(
        bodyString is "default value"
      )
  }

  spec {
    http("Cookie Parameters - Combing Path Templates and Cookie Params").
      get("/resource/function/cookie-parameters/combine/apples")
      .header("Cookie", "Cookie-A=pears")
      .check(
        bodyString is "pears,apples"
      )
  }

  spec {
    http("Cookie Parameters - Accepting multiple values").
      get("/resource/function/cookie-parameters/multiple-values")
      .header("Cookie", "Cookie-A=1, Cookie-A=2, Cookie-A=3, Cookie-A=4, " +
        "Cookie-A=5, Cookie-A=6, Cookie-A=7, Cookie-A=8, " +
        "Cookie-A=9, Cookie-A=10")
      .check(
        bodyString is "1,2,3,4,5,6,7,8,9,10"
      )
  }

  spec {
    http("Cookie Parameters - Multiple values (revert to Default)").
      get("/resource/function/cookie-parameters/multiple-values")
      .check(
        bodyString is "1,2,3,4,5,6,7"
      )
  }

  // Complex Content - for when it gets just a little too spicey
  spec {
    http("Cookie Parameters - Complex Content").
      get("/resource/function/cookie-parameters/string")
      .header("Cookie", "$Version = 1; Cookie-X=\"Good Morning World\"; " +
        "$Path=\"/\"; $Domain=\"localhost\", $Version = 2; " +
        "Cookie-A=\"Hello World\"; $Path=\"/\"; $Domain=\"localhost\", " +
        "$Version = 2; Cookie-B=\"Goodbye World\"; $Path=\"/\"; " +
        "$Domain=\"localhost\"")
      .check(
        bodyString is "Hello World"
      )
  }

}
