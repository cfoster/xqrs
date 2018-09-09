package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class QueryParameters extends RestXQBaseClass {

  spec {
    http("Query Parameters - String").
      get("/resource/function/query-parameters/string?my-param=oranges")
      .check(
        bodyString is "oranges"
      )
  }

  spec {
    http("Query Parameters - Integer").
      get("/resource/function/query-parameters/integer?my-param=1234")
      .check(
        bodyString is "1234"
      )
  }

  spec {
    http("Query Parameters - Parameter Accepting Zero Sequence").
      get("/resource/function/query-parameters/zero-sequence")
      .check(
        bodyString is "zero-sequence"
      )
  }

  spec {
    http("Query Parameters - Zero Sequence, Default Value").
      get("/resource/function/query-parameters/zero-sequence-default")
      .check(
        bodyString is "default value"
      )
  }

  spec {
    http("Query Parameters - Combing Path Templates and Query Params").
      get("/resource/function/query-parameters/combine/apples?my-param=pears")
      .check(
        bodyString is "pears,apples"
      )
  }

  spec {
    http("Query Parameters - Accepting multiple values").
      get("/resource/function/query-parameters/multiple-values?" +
        (1 to 10).map("my-param=" + _ + "&").mkString)
      .check(
        bodyString is "1,2,3,4,5,6,7,8,9,10"
      )
  }

  spec {
    http("Query Parameters - Multiple values (revert to Default)").
      get("/resource/function/query-parameters/multiple-values")
      .check(
        bodyString is "1,2,3,4,5,6,7"
      )
  }

}
