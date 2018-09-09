package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class MethodAnnotation extends RestXQBaseClass {

  /**
   * spec {
   * http("Empty HEAD").
   * head("/resource/function/method-annotation/empty-head")
   * .check(
   * bodyString is "head"
   * )
   * }
   */

  spec {
    http("Empty GET").
      get("/resource/function/method-annotation/empty")
      .check(
        bodyString is "get"
      )
  }

  spec {
    http("Empty POST").
      post("/resource/function/method-annotation/empty")
      .body(StringBody(""))
      .check(
        bodyString is "post"
      )
  }

  spec {
    http("Empty PUT").
      put("/resource/function/method-annotation/empty")
      .body(StringBody(""))
      .check(
        bodyString is "put"
      )
  }

  spec {
    http("Empty DELETE").
      delete("/resource/function/method-annotation/empty")
      .check(
        bodyString is "delete"
      )
  }

  spec {
    http("Empty OPTIONS").
      options("/resource/function/method-annotation/empty")
      .check(
        bodyString is "options"
      )
  }
  /*
    spec {
      http("Empty PATCH").
        patch("/resource/function/method-annotation/empty")
        .check(
          bodyString is "patch"
        )
    }
  */

  // POST and PUT Requests with a body
  spec {
    http("POST XML Body").
      post("/resource/function/method-annotation/post-body")
      .body(StringBody("<doc>document</doc>"))
      .header("Content-Type", "text/xml")
      .check(
        bodyString is "doc"
      )
  }

  spec {
    http("PUT XML Body").
      put("/resource/function/method-annotation/put-body")
      .body(StringBody("<doc>document</doc>"))
      .header("Content-Type", "text/xml")
      .check(
        bodyString is "doc"
      )
  }

  spec {
    http("POST multipart/mixed (3 x XML documents)").
      post("/resource/function/method-annotation/post/multipart-mixed")
      .header(
        "Content-Type", "multipart/mixed; boundary=\"" + boundary + "\"")
      .body(
        StringBody(s"""--${boundary}
                      |Content-Type: text/xml
                      |
                      |<first-document>number 1</first-document>
                      |
                      |--${boundary}
                      |Content-Type: text/xml
                      |
                      |<second-document>number 2</second-document>
                      |
                      |--${boundary}
                      |Content-Type: text/xml
                      |
                      |<third-document>number 3</third-document>
                      |
                      |--${boundary}--"""
          .stripMargin.replaceAll("\r?\n", "\r\n"))
      )
      .check(
        bodyString is "first-document,second-document,third-document"
      )
  }

  spec {
    http("POST Object Body whilst setting a path segment").
      post("/resource/function/method-annotation/post-text-combine/apples")
      .body(StringBody("pears"))
      .header("Content-Type", "text/plain")
      .check(
        bodyString is "apples,pears"
      )
  }

  spec {
    http("POST text/*").
      post("/resource/function/method-annotation/post-text")
      .body(StringBody("apples"))
      .header("Content-Type", "text/from-another-dimension")
      .check(
        bodyString is "apples"
      )
  }

  spec {
    http("POST application/obj, MarkLogic binary()").
      post("/resource/function/method-annotation/post-marklogic-binary")
      .body(StringBody("hello"))
      .header("Content-Type", "application/from-another-dimension")
      .check(
        headerRegex("Content-Type", "application/octet-stream")
      )
      .check(
        bodyString is "hello"
      )
  }

  spec {
    http("POST application/obj, xs:base64Binary").
      post("/resource/function/method-annotation/post-base64Binary")
      .body(StringBody("hello"))
      .header("Content-Type", "application/from-another-dimension")
      .check(
        headerRegex("Content-Type", "text/plain")
      )
      .check(
        bodyString is "hello"
      )
  }

  spec {
    http("POST RDF (Turtle)").
      post("/resource/function/method-annotation/post-rdf")
      .body(StringBody("<apple> <pear> <banana> ."))
      .header("Content-Type", "text/turtle")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        regex("<apple>\\s+<pear>\\s+<banana>\\s+.").exists
      )
  }

  spec {
    http("POST RDF (N-Quads)").
      post("/resource/function/method-annotation/post-rdf")
      .body(StringBody("<apple> <pear> <banana> <random-graph> ."))
      .header("Content-Type", "application/n-quads")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        regex("<apple>\\s+<pear>\\s+<banana>\\s+.").exists
      )
  }

  spec {
    http("POST RDF (N-Triples)").
      post("/resource/function/method-annotation/post-rdf")
      .body(StringBody("<apple> <pear> <banana> ."))
      .header("Content-Type", "application/n-triples")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        regex("<apple>\\s+<pear>\\s+<banana>\\s+.").exists
      )
  }

  spec {
    http("POST RDF (RDF/XML)").
      post("/resource/function/method-annotation/post-rdf")
      .body(StringBody(
        "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">\n" +
          "  <rdf:Description rdf:about=\"http://apple\">\n" +
          "    <pear xmlns='http://' rdf:resource=\"http://banana\"/>\n" +
          "  </rdf:Description>\n" +
          "</rdf:RDF>"))
      .header("Content-Type", "application/rdf+xml")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(status is 200)
  }

  spec {
    http("POST RDF (RDF/JSON)").
      post("/resource/function/method-annotation/post-rdf")
      .body(StringBody(
        "{\n" +
          "\"apple\" : {\n" +
          "\"pear\" : [ {\n" +
          "      \"value\" : \"banana\",\n" +
          "      \"type\" : \"uri\"\n" +
          "    } ]\n" +
          "  }\n" +
          "}"
      ))
      .header("Content-Type", "application/rdf+json")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        regex("<apple>\\s+<pear>\\s+<banana>\\s+.").exists
      )
  }

  spec {
    http("POST RDF (Notation3)").
      post("/resource/function/method-annotation/post-rdf")
      .body(StringBody("<apple> <pear> <banana> ."))
      .header("Content-Type", "text/n3")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        regex("<apple>\\s+<pear>\\s+<banana>\\s+.").exists
      )
  }

  spec {
    http("POST RDF (TriG)").
      post("/resource/function/method-annotation/post-rdf")
      .body(StringBody("{\n  <apple> <pear> <banana> .\n}"))
      .header("Content-Type", "application/trig")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        regex("<apple>\\s+<pear>\\s+<banana>\\s+.").exists
      )
  }

  spec {
    http("POST RDF (sem:triples)").
      post("/resource/function/method-annotation/post-rdf")
      .body(StringBody(
        "<sem:triples xmlns:sem=\"http://marklogic.com/semantics\">\n" +
          "  <sem:triple>\n" +
          "    <sem:subject>apple</sem:subject>\n" +
          "    <sem:predicate>pear</sem:predicate>\n" +
          "    <sem:object>banana</sem:object>\n" +
          "  </sem:triple>\n" +
          "</sem:triples>"))
      .header("Content-Type", "application/vnd.marklogic.triples+xml")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        regex("<apple>\\s+<pear>\\s+<banana>\\s+.").exists
      )
  }

  spec {
    http("POST multipart/mixed (Mixed Bag of Item Types)").
      post("/resource/function/method-annotation/post/multipart-mixed-bag")
      .header(
        "Content-Type", "multipart/mixed; boundary=\"" + boundary + "\"")
      .body(
        StringBody(s"""--${boundary}
                      |Content-Type: text/xml
                      |
                      |<an-xml-doc>An XML Document</an-xml-doc>
                      |
                      |--${boundary}
                      |Content-Type: text/json
                      |
                      |{\"a\":\"b\"}
                      |
                      |--${boundary}
                      |Content-Type: text/json
                      |
                      |[1, 2, 3, 4, 5]
                      |
                      |--${boundary}
                      |Content-Type: text/whatever
                      |
                      |some text
                      |
                      |--${boundary}
                      |Content-Type: application/a-type-of-binary
                      |
                      |some binary data
                      |
                      |--${boundary}
                      |Content-Type: text/turtle
                      |
                      |<subject> <predicate> <object> .
                      |
                      |--${boundary}--\r\n"""
          .stripMargin.replaceAll("\r?\n", "\r\n"))
      )
      .check(
        bodyString is
          "document-node(element())," +
          "document-node(object-node())," +
          "document-node(array-node())," +
          "xs:string," +
          "binary()," +
          "sem:triple"
      )
  }

  spec {
    http("POST JSON Object Body").
      post("/resource/function/method-annotation/post-body-object")
      .body(StringBody("{\"key\":\"value\"}"))
      .header("Content-Type", "application/json")
      .check(
        bodyString is "{\"key\":\"value\"}"
      )
  }

  spec {
    http("POST JSON Array Body").
      post("/resource/function/method-annotation/post-body-array")
      .body(StringBody("[1, 2, 3, 4, 5]"))
      .header("Content-Type", "application/json")
      .check(
        bodyString is "[1, 2, 3, 4, 5]"
      )
  }

  // Multipart Message POST
  /**
   * spec {
   * http("POST multipart/form-data (3 x XML documents)").
   * post("/resource/function/method-annotation/post/multipart-form-data")
   * .bodyPart(
   * StringBodyPart("name1", "<doc-a>apple</doc-a>").
   * contentType("text/xml").
   * fileName("a.xml"))
   * .bodyPart(
   * StringBodyPart("name1", "<doc-b>pear</doc-b>").
   * contentType("text/xml").
   * fileName("b.xml")
   * )
   * .bodyPart(
   * StringBodyPart("name1", "<doc-c>banana</doc-c>").
   * contentType("text/xml").
   * fileName("c.xml")
   * )
   * .check(
   * bodyString is "doc-a,a.xml,doc-b,b.xml,doc-c,c.xml"
   * )
   * }
   */

}
