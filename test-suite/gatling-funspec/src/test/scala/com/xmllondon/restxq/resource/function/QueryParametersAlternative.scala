package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class QueryParametersAlternative extends RestXQBaseClass {

  spec {
    http("Query Parameters - String").
      get("/resource/function/query-parameters-alternative/string?my-param=oranges")
      .check(
        bodyString is "oranges"
      )
  }

  spec {
    http("Query Parameters - Integer").
      get("/resource/function/query-parameters-alternative/integer?my-param=1234")
      .check(
        bodyString is "1234"
      )
  }

  spec {
    http("Query Parameters - Parameter Accepting Zero Sequence").
      get("/resource/function/query-parameters-alternative/zero-sequence")
      .check(
        bodyString is "zero-sequence"
      )
  }

  spec {
    http("Query Parameters - Zero Sequence, Default Value").
      get("/resource/function/query-parameters-alternative/zsd")
      .check(
        bodyString is "default value"
      )
  }

  spec {
    http("Query Parameters - Combing Path Templates and Query Params").
      get("/resource/function/query-parameters-alternative/combine/apples?my-param=pears")
      .check(
        bodyString is "pears,apples"
      )
  }

  spec {
    http("Query Parameters - Accepting multiple values").
      get("/resource/function/query-parameters-alternative/multiple-values?" +
        (1 to 10).map("my-param=" + _ + "&").mkString)
      .check(
        bodyString is "1,2,3,4,5,6,7,8,9,10"
      )
  }

  spec {
    http("Query Parameters - Multiple values (revert to Default)").
      get("/resource/function/query-parameters-alternative/multiple-values")
      .check(
        bodyString is "1,2,3,4,5,6,7"
      )
  }

  spec {
    http("Query Parameters - Many").
      get("/resource/function/query-parameters-alternative/many?" +
        "a=7&b=6&c=5&d=4&e=3&f=2&g=1")
      .check(
        bodyString is "7,6,5,4,3,2,1"
      )
  }

  spec {
    http("Query Parameters - Multi Datatype").
      get("/resource/function/query-parameters-alternative/multi-datatype?" +
        "date=2001-01-01&integer=1234&decimal=1234.5678&string=hello")
      .check(
        bodyString is "2001-01-01,1234,1234.5678,hello"
      )
  }

}
