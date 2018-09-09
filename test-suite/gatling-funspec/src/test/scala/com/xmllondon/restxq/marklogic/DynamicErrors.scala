package com.xmllondon.restxq.marklogic

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

class DynamicErrors extends RestXQBaseClass {

  // override def httpConf: HttpProtocolBuilder =
  // super.httpConf.check(headerRegex("Content-Type", "text/plain"))

  spec {
    http("Path (1) - XQRS003")
      .get("/marklogic/error/path/1/a/1234")
      .check(status is 400)
      .check(regex("XQRS003"))
  }

  spec {
    http("Path (2) - XQRS004")
      .get("/marklogic/error/path/2/a/value")
      .check(status is 400)
      .check(regex("XQRS004"))
  }

  spec {
    http("Path (2) - XQRS004")
      .get("/marklogic/error/path/2/b/value")
      .check(status is 400)
      .check(regex("XQRS004"))
  }

  spec {
    http("Path (2) - XQRS004")
      .get("/marklogic/error/path/2/c/value")
      .check(status is 400)
      .check(regex("XQRS004"))
  }

  spec {
    http("Path (3) - XQRS005")
      .get("/marklogic/error/path/3/a/a")
      .check(status is 400)
      .check(regex("XQRS005"))
  }

  spec {
    http("Path (3) - XQRS002")
      .get("/marklogic/error/path/3/b/a")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Path (4) - XQRS002")
      .get("/marklogic/error/path/4/a/string")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Path (4) - XQRS002")
      .get("/marklogic/error/path/4/b/string")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Path (4) - XQRS002")
      .get("/marklogic/error/path/4/c/string")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Query Param (1) - XQRS007")
      .get("/marklogic/error/query-param/1/a")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("Query Param (1) - XQRS007")
      .get("/marklogic/error/query-param/1/b")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("Header Param (1) - XQRS007")
      .get("/marklogic/error/header-param/1/a")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("Header Param (1) - XQRS007")
      .get("/marklogic/error/header-param/1/b")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("Query Param (2) - XQRS008")
      .get("/marklogic/error/query-param/2/a?a=hello")
      .check(status is 400)
      .check(regex("XQRS008"))
  }

  spec {
    http("Header Param (2) - XQRS008")
      .get("/marklogic/error/header-param/2/a")
      .header("a", "b")
      .check(status is 400)
      .check(regex("XQRS008"))
  }

  spec {
    http("Query Param (3) - XQRS002")
      .get("/marklogic/error/query-param/3/a")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Header Param (3) - XQRS002")
      .get("/marklogic/error/header-param/3/a")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Header Param (4) - XQRS010")
      .get("/marklogic/error/header-param/4/a")
      .check(status is 400)
      .check(regex("XQRS010"))
  }

  spec {
    http("Query Param (5) - XQRS003")
      .get("/marklogic/error/query-param/5/a")
      .check(status is 400)
      .check(regex("XQRS003"))
  }

  spec {
    http("Header Param (5) - XQRS003")
      .get("/marklogic/error/header-param/5/a")
      .check(status is 400)
      .check(regex("XQRS003"))
  }

  spec {
    http("Form Param (1) - XQRS007")
      .get("/marklogic/error/form-param/1/a")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("Form Param (1) - XQRS007")
      .get("/marklogic/error/form-param/1/b")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("Form Param (2) - XQRS008")
      .get("/marklogic/error/form-param/2/a")
      .check(status is 400)
      .check(regex("XQRS008"))
  }

  spec {
    http("Form Param (3) - XQRS002")
      .get("/marklogic/error/form-param/3/a")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Form Param (4) - XQRS010")
      .get("/marklogic/error/form-param/4/a")
      .check(status is 400)
      .check(regex("XQRS010"))
  }

  spec {
    http("Form Param (5) - XQRS003")
      .get("/marklogic/error/form-param/5/a?a=hello")
      .check(status is 400)
      .check(regex("XQRS003"))
  }

  spec {
    http("Cookie Param (1) - XQRS007")
      .get("/marklogic/error/cookie-param/1/a")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("Cookie Param (1) - XQRS007")
      .get("/marklogic/error/cookie-param/1/b")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("Cookie Param (2) - XQRS008")
      .get("/marklogic/error/cookie-param/2/a")
      .check(status is 400)
      .check(regex("XQRS008"))
  }

  spec {
    http("Cookie Param (3) - XQRS002")
      .get("/marklogic/error/cookie-param/3/a")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Cookie Param (3) - XQRS002")
      .get("/marklogic/error/cookie-param/3/b")
      .check(status is 400)
      .check(regex("XQRS002"))
  }

  spec {
    http("Cookie Param (4) - XQRS010")
      .get("/marklogic/error/cookie-param/4/a")
      .check(status is 400)
      .check(regex("XQRS010"))
  }

  spec {
    http("Cookie Param (5) - XQRS003")
      .get("/marklogic/error/cookie-param/5/a")
      .check(status is 400)
      .check(regex("XQRS003"))
  }

  spec {
    http("Output Method Conflicts - XQRS011")
      .get("/marklogic/error/output/1/a")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Output Method Conflicts - XQRS011")
      .get("/marklogic/error/output/1/b")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Output Method Conflicts - XQRS011")
      .get("/marklogic/error/output/1/c")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Output Method Conflicts - XQRS011")
      .get("/marklogic/error/output/1/d")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Output Method Conflicts - XQRS011")
      .get("/marklogic/error/output/1/e")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Output Method Conflicts - XQRS011")
      .get("/marklogic/error/output/1/f")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Output Method Conflicts - XQRS011")
      .get("/marklogic/error/output/1/g")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Output Method Conflicts - XQRS011")
      .get("/marklogic/error/output/1/h")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Output Method Not Supported - XQRS012")
      .get("/marklogic/error/output/2/a")
      .check(status is 400)
      .check(regex("XQRS012"))
  }

  spec {
    http("Output Method Not Supported - XQRS012")
      .get("/marklogic/error/output/2/b")
      .check(status is 400)
      .check(regex("Did you mean")) // does it offer a potential correct value
      .check(regex("XQRS012"))
  }

  spec {
    http("POST annotation must accept a maximum of 1 argument - XQRS007")
      .post("/marklogic/error/post/1/a")
      .body(StringBody("<e />"))
      .header("Content-Type", "text/xml")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("PUT annotation must accept a maximum of 1 argument - XQRS007")
      .put("/marklogic/error/put/1/a")
      .body(StringBody("<e />"))
      .header("Content-Type", "text/xml")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("POST annotation must have valid Annotation Template Syntax - XQRS008")
      .post("/marklogic/error/post/2/a")
      .body(StringBody("<e />"))
      .header("Content-Type", "text/xml")
      .check(status is 400)
      .check(regex("XQRS008"))
  }

  spec {
    http("POST must map to an annotation if specified - XQRS003")
      .post("/marklogic/error/post/3/a")
      .body(StringBody("<e />"))
      .header("Content-Type", "text/xml")
      .check(status is 400)
      .check(regex("XQRS003"))
  }

  spec {
    http("PUT must map to an annotation if specified - XQRS003")
      .put("/marklogic/error/put/3/a")
      .body(StringBody("<e />"))
      .header("Content-Type", "text/xml")
      .check(status is 400)
      .check(regex("XQRS003"))
  }

  spec {
    http("%rest:consumes must have 1 or more arguments - XQRS007")
      .get("/marklogic/error/consumes/1/a")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("%rest:produces must have 1 or more arguments - XQRS007")
      .get("/marklogic/error/produces/1/a")
      .check(status is 400)
      .check(regex("XQRS007"))
  }

  spec {
    http("%rest:consumes must have valid media types - XQRS013")
      .get("/marklogic/error/consumes/2/a")
      .check(status is 400)
      .check(regex("XQRS013"))
  }

  spec {
    http("%rest:produces must have valid media types - XQRS013")
      .get("/marklogic/error/produces/2/a")
      .check(status is 400)
      .check(regex("XQRS013"))
  }

}
