package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class HeaderParametersAlternative extends RestXQBaseClass {

  spec {
    http("Header Parameters - String").
      get("/resource/function/header-parameters-alternative/string")
      .header("x-my-header", "oranges")
      .check(
        bodyString is "oranges"
      )
  }

  spec {
    http("Header Parameters - Integer").
      get("/resource/function/header-parameters-alternative/integer")
      .header("x-my-header", "1234")
      .check(
        bodyString is "1234"
      )
  }

  spec {
    http("Header Parameters - Parameter Accepting Zero Sequence").
      get("/resource/function/header-parameters-alternative/zero-sequence")
      .check(
        bodyString is "zero-sequence"
      )
  }

  spec {
    http("Header Parameters - Zero Sequence, Default Value").
      get("/resource/function/header-parameters-alternative/zsd")
      .check(
        bodyString is "default value"
      )
  }

  spec {
    http("Header Parameters - Combing Path Templates and Header Params").
      get("/resource/function/header-parameters-alternative/combine/apples")
      .header("x-my-header", "pears")
      .check(
        bodyString is "pears,apples"
      )
  }

  /**
   * an implementation MUST extract each value from the comma separated
   * list into an item in the sequence provided to the function parameter.
   */
  spec {
    http("Header Parameters - Accepting multiple values").
      get("/resource/function/header-parameters-alternative/multiple-values")
      .header("x-my-header", "1, 2, 3, 4, 5, 6, 7, 8, 9, 10")
      .check(
        bodyString is "1,2,3,4,5,6,7,8,9,10"
      )
  }

  /**
   * an implementation MUST extract each value from the comma separated
   * list into an item in the sequence provided to the function parameter.
   */
  spec {
    http("Header Parameters - Accepting multiple values").
      get("/resource/function/header-parameters-alternative/multiple-values/string")
      .header("x-my-header", "a, b, c, d, e, f, g, h, i, j")
      .check(
        bodyString is "a,b,c,d,e,f,g,h,i,j"
      )
  }

  spec {
    http("Header Parameters - Multiple values (revert to Default)").
      get("/resource/function/header-parameters-alternative/multiple-values")
      .check(
        bodyString is "1,2,3,4,5,6,7"
      )
  }

  spec {
    http("Header Parameters - Many").
      get("/resource/function/header-parameters-alternative/many")
      .header("a", "7")
      .header("b", "6")
      .header("c", "5")
      .header("d", "4")
      .header("e", "3")
      .header("f", "2")
      .header("g", "1")
      .check(
        bodyString is "7,6,5,4,3,2,1"
      )
  }

  spec {
    http("Header Parameters - Multi Datatype").
      get("/resource/function/header-parameters-alternative/multi-datatype")
      .header("date", "2001-01-01")
      .header("integer", "1234")
      .header("decimal", "1234.5678")
      .header("string", "hello")
      .check(
        bodyString is "2001-01-01,1234,1234.5678,hello"
      )
  }

}
