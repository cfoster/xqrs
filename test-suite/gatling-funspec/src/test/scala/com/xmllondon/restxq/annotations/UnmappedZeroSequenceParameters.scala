/**
 * Implementations of RESTXQ MUST support annotated functions which
 * have additional function parameters which are not annotation mapped,
 * providing the cardinality type of those un-mapped parameters accepts
 * an empty sequence.
 */
package com.xmllondon.restxq.annotations

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class UnmappedZeroSequenceParameters extends RestXQBaseClass {

  spec {
    http("unmapped-zero-sequence-parameters-1").
      get("/annotations/unmapped/1/apples")
      .check(
        bodyString is "apples"
      )
  }

  spec {
    http("unmapped-zero-sequence-parameters-2").
      get("/annotations/unmapped/2/pears")
      .check(
        bodyString is "pears"
      )
  }

  spec {
    http("unmapped-zero-sequence-parameters-3").
      get("/annotations/unmapped/3/bananas")
      .check(
        bodyString is "bananas"
      )
  }

  spec {
    http("unmapped-zero-sequence-parameters-4").
      get("/annotations/unmapped/4/apples/pears")
      .check(
        bodyString is "apples,pears"
      )
  }

  spec {
    http("unmapped-zero-sequence-parameters-5").
      get("/annotations/unmapped/5/apples/pears")
      .check(
        bodyString is "apples,pears"
      )
  }

}
