package com.xmllondon.restxq.http.request.matching

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class PathPreference extends RestXQBaseClass {

  spec {
    http("GET 1/a/b/c")
      .get("/http-request-matching/path-preference/1/a/b/c")
      .check(
        bodyString is "c"
      )
  }

  spec {
    http("GET 1/a/b/c")
      .get("/http-request-matching/path-preference/1/a/b")
      .check(
        bodyString is "b"
      )
  }

  spec {
    http("GET 1/a")
      .get("/http-request-matching/path-preference/1/a")
      .check(
        bodyString is "a"
      )
  }

  spec {
    http("GET 2/a/b")
      .get("/http-request-matching/path-preference/2/a/b")
      .check(
        bodyString is "a"
      )
  }

  spec {
    http("GET 2/a/y")
      .get("/http-request-matching/path-preference/2/a/y")
      .check(
        bodyString is "b"
      )
  }

  spec {
    http("GET 2/y/b")
      .get("/http-request-matching/path-preference/2/y/b")
      .check(
        bodyString is "c"
      )
  }

  spec {
    http("GET 2/y/z")
      .get("/http-request-matching/path-preference/2/y/z")
      .check(
        bodyString is "d"
      )
  }

}
