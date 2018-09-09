package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class HeaderParameters extends RestXQBaseClass {

  spec {
    http("Header Parameters - String").
      get("/resource/function/header-parameters/string")
      .header("x-my-header", "oranges")
      .check(
        bodyString is "oranges"
      )
  }

  spec {
    http("Header Parameters - Integer").
      get("/resource/function/header-parameters/integer")
      .header("x-my-header", "1234")
      .check(
        bodyString is "1234"
      )
  }

  spec {
    http("Header Parameters - Parameter Accepting Zero Sequence").
      get("/resource/function/header-parameters/zero-sequence")
      .check(
        bodyString is "zero-sequence"
      )
  }

  spec {
    http("Header Parameters - Zero Sequence, Default Value").
      get("/resource/function/header-parameters/zero-sequence-default")
      .check(
        bodyString is "default value"
      )
  }

  spec {
    http("Header Parameters - Combing Path Templates and Header Params").
      get("/resource/function/header-parameters/combine/apples?my-param=pears")
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
      get("/resource/function/header-parameters/multiple-values")
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
      get("/resource/function/header-parameters/multiple-values/string")
      .header("x-my-header", "a, b, c, d, e, f, g, h, i, j")
      .check(
        bodyString is "a,b,c,d,e,f,g,h,i,j"
      )
  }

  spec {
    http("Header Parameters - Multiple values (revert to Default)").
      get("/resource/function/header-parameters/multiple-values")
      .check(
        bodyString is "1,2,3,4,5,6,7"
      )
  }

}
