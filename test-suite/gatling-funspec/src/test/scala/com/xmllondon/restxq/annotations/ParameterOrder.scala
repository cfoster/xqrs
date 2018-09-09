/**
 * Implementors MUST not enforce the order of function parameters.
 * Whether mapped by annotations or not is unimportant, as annotations
 * explicitly name the parameters to which they are mapped.
 */

package com.xmllondon.restxq.annotations

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class ParameterOrder extends RestXQBaseClass {

  spec {
    http("parameter-order").
      get("/annotations/parameter-order/apples/pears/bananas")
      .check(
        bodyString is "bananas,apples,pears"
      )
  }
}
/*
object ParameterOrder {

  def h1 = css("h1")

}
*/ 