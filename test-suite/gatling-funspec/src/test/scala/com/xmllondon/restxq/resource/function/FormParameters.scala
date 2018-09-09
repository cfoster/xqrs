package com.xmllondon.restxq.resource.function

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class FormParameters extends RestXQBaseClass {

  // override val baseURL = "http://localhost:9090"

  spec {
    http("Form Parameters - String").
      post("/resource/function/form-parameters/string")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .formParam("my-param", "oranges")
      .check(
        bodyString is "oranges"
      )
  }

  spec {
    http("Form Parameters - Integer").
      post("/resource/function/form-parameters/integer")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .formParam("my-param", "1234")
      .check(
        bodyString is "1234"
      )
  }

  spec {
    http("Form Parameters - Parameter Accepting Zero Sequence").
      post("/resource/function/form-parameters/zero-sequence")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .body(StringBody(""))
      .check(
        bodyString is "zero-sequence"
      )
  }

  spec {
    http("Form Parameters - Zero Sequence, Default Value").
      post("/resource/function/form-parameters/zero-sequence-default")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .body(StringBody(""))
      .check(
        bodyString is "default value"
      )
  }

  spec {
    http("Form Parameters - Combing Path Templates and Form Params").
      post("/resource/function/form-parameters/combine/apples")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .formParam("my-param", "pears")
      .check(
        bodyString is "pears,apples"
      )
  }

  spec {
    http("Form Parameters - Accepting multiple values").
      post("/resource/function/form-parameters/multiple-values")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .multivaluedFormParam("my-param",
        Seq("1", "2", "3", "4", "5", "6", "7", "8", "9", "10")
      )
      .check(
        bodyString is "1,2,3,4,5,6,7,8,9,10"
      )
  }

  spec {
    http("Form Parameters - Multiple values (revert to Default)").
      post("/resource/function/form-parameters/multiple-values")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .body(StringBody(""))
      .check(
        bodyString is "1,2,3,4,5,6,7"
      )
  }

  def build(requestName: String, url: String) = {
    http(requestName).
      post(url)
      .header("Content-Type", "multipart/form-data")
      .bodyPart(
        StringBodyPart("files", "<e>Hello World</e>")
          .contentType("application/xml")
          .fileName("hello-world.xml"))
      .bodyPart(
        StringBodyPart("files", "{\"a\":\"b\"}")
          .contentType("text/json")
          .fileName("object.json"))
      .bodyPart(
        StringBodyPart("files", "<subject> <predicate> <object> .")
          .contentType("text/turtle")
          .fileName("data.ttl"))
      .bodyPart(
        StringBodyPart("files", "Some Plain Text")
          .contentType("text/plain")
          .fileName("text.txt"))
      .bodyPart(
        StringBodyPart("files", "Binary Data")
          .contentType("application/octet-stream")
          .fileName("data.bin"))
      .asMultipartForm
  }

  spec {
    build("Form multipart/form-data upload (filenames)",
      "/resource/function/form-parameters/multipart-form-data/list"
    ).check(
        bodyString is "data.bin,data.ttl,hello-world.xml,object.json,text.txt"
      )
  }

  spec {
    build("Form multipart/form-data upload (content-types)",
      "/resource/function/form-parameters/multipart-form-data/types")
      .check(
        bodyString is "application/octet-stream,text/turtle," +
          "application/xml,text/json,text/plain"
      )
  }

  spec {
    build("Form multipart/form-data upload (value)",
      "/resource/function/form-parameters/multipart-form-data/value/hello-world.xml")
      .check(
        bodyString is "<e>Hello World</e>"
      )
  }

  spec {
    build("Form multipart/form-data upload (value)",
      "/resource/function/form-parameters/multipart-form-data/value/object.json")
      .check(
        bodyString is "{\"a\":\"b\"}"
      )
  }

  spec {
    build("Form multipart/form-data upload (value)",
      "/resource/function/form-parameters/multipart-form-data/value/data.ttl")
      .check(
        bodyString is "<subject> <predicate> <object> ."
      )
  }

  spec {
    build("Form multipart/form-data upload (value)",
      "/resource/function/form-parameters/multipart-form-data/value/text.txt")
      .check(
        bodyString is "Some Plain Text"
      )
  }

  spec {
    build("Form multipart/form-data upload (value)",
      "/resource/function/form-parameters/multipart-form-data/value/data.bin")
      .check(
        bodyString is "Binary Data"
      )
  }

}
