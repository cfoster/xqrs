package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class ProducesAnnotation extends RestXQBaseClass {

  override def httpConf = super.httpConf.header("MyHeader", "MyValue")

  spec {
    http("Accept: application/json").
      get("/resource/function/produces-annotation")
      .header("Accept", "application/json")
      .check(
        bodyString is "application/json"
      )
  }

  spec {
    http("Accept: application/xml").
      get("/resource/function/produces-annotation")
      .header("Accept", "application/xml")
      .check(
        bodyString is "application/xml"
      )
  }

  spec {
    http("Accept: text/*").
      get("/resource/function/produces-annotation")
      .header("Accept", "text/*")
      .check(
        bodyString is "either-or"
      )
  }

  spec {
    http("Accept: text/random").
      get("/resource/function/produces-annotation")
      .header("Accept", "text/random")
      .check(
        bodyString is "text/*"
      )
  }

  spec {
    http("Accept: text/plain").
      get("/resource/function/produces-annotation")
      .header("Accept", "text/plain")
      .check(
        bodyString is "text/plain"
      )
  }

  spec {
    http("Accept (either or)").
      get("/resource/function/produces-annotation")
      .header("Accept", "text/abc")
      .check(
        bodyString is "either-or"
      )
  }

  spec {
    http("Accept (either or)").
      get("/resource/function/produces-annotation")
      .header("Accept", "text/xyz")
      .check(
        bodyString is "either-or"
      )
  }

  spec {
    http("Accept: random/random").
      get("/resource/function/produces-annotation")
      .header("Accept", "random/random")
      .check(
        bodyString is "no annotation"
      )
  }

  spec {
    http("Accept: text/xml").
      get("/resource/function/produces-annotation")
      .header("Accept", "text/xml")
      .check(
        bodyString is "text/*"
      )
  }

  spec {
    http("Accept: */*").
      get("/resource/function/produces-annotation/1")
      .header("Accept", "*/*")
      .check(
        bodyString is "*/*"
      )
  }

  spec {
    http("Accept: */*").
      get("/resource/function/produces-annotation/1")
      .header("Accept", "text/plain")
      .check(
        bodyString is "*/*"
      )
  }

  spec {
    http("Accept: */*").
      get("/resource/function/produces-annotation/1")
      .header("Accept", "application/json")
      .check(
        bodyString is "*/*"
      )
  }

  /** This test could be moved into Media Type Preference **/
  /**
   * spec {
   * http("Accept rfc2616-sec14").
   * get("/resource/function/produces-annotation/2")
   * .header("Accept", "text/*, text/html, text/html;level=1, */*")
   * .check(
   * bodyString is "text/html;level=1"
   * )
   * } *
   */

  /** quality factors **/
  spec {
    http("Accept: application/json;q=0.2, application/xml").
      get("/resource/function/produces-annotation")
      .header("Accept", "application/json;q=0.2, application/xml")
      .check(
        bodyString is "application/xml"
      )
  }

  spec {
    http("Accept: application/json, application/xml;q=0.2")
      .get("/resource/function/produces-annotation")
      .header("Accept", "application/json, application/xml;q=0.2")
      .check(
        bodyString is "application/json"
      )
  }

  spec {
    http("Accept: application/json;q=0.4, text/plain;q=0.6, application/xml;q=0.2")
      .get("/resource/function/produces-annotation")
      .header("Accept", "application/json;q=0.4, text/plain;q=0.6, application/xml;q=0.2")
      .check(
        bodyString is "text/plain"
      )
  }

  spec {
    http("Accept: application/json;q=0.4, text/random;q=0.6, application/xml;q=0.2")
      .get("/resource/function/produces-annotation")
      .header("Accept", "application/json;q=0.4, text/random;q=0.6, application/xml;q=0.2")
      .check(
        bodyString is "text/*"
      )
  }

}
