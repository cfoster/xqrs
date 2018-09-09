package com.xmllondon.restxq.response.serialization

import java.io.{ ByteArrayOutputStream, StringReader }

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.response.{ ResponseWrapper, StringResponseBody }
import javax.xml.transform.{ Transformer, TransformerFactory }
import javax.xml.transform.stream.{ StreamResult, StreamSource }
import org.apache.jena.rdf.model.impl.{ PropertyImpl, ResourceImpl, StatementImpl }
import org.apache.jena.rdf.model.{ Model, ModelFactory }

import scala.io.Source

class SerializationMethodRDF extends RestXQBaseClass {

  //override val baseURL = "http://localhost:9090"

  val statement1 =
    new StatementImpl(
      new ResourceImpl("http://a"),
      new PropertyImpl("http://b"),
      new ResourceImpl("http://c")
    )
  val statement2 =
    new StatementImpl(
      new ResourceImpl("http://x"),
      new PropertyImpl("http://y"),
      new ResourceImpl("http://z")
    )

  def parseTriples(value: String, lang: String): Model = {
    val m: Model = ModelFactory.createDefaultModel

    if (lang != "triplexml")
      m.read(new StringReader(value), null, lang)
    else
      m.read(new StringReader(tripleXML2RDFXML(value)), null, "rdfxml")

  }

  def tripleXML2RDFXML(value: String): String = {
    val output = new ByteArrayOutputStream()
    TransformerFactory.newInstance().newTransformer(
      new StreamSource(
        new StringReader(Source.fromResource("triple2rdfxml.xsl").mkString)
      )
    ).transform(
        new StreamSource(new StringReader(value)),
        new StreamResult(output)
      )
    new String(output.toByteArray, "UTF8")
  }

  def containsExpectedTriples(m: Model): String = {
    if (m.contains(statement1) && m.contains(statement2))
      "true"
    else
      "false"
  }

  def build(message: String, uri: String, rdfFormat: String) = {
    http(message)
      .get(uri)
      .transformResponse {
        case response if response.isReceived =>
          new ResponseWrapper(response) {
            val model = parseTriples(response.body.string, rdfFormat)

            override val body = new StringResponseBody(
              containsExpectedTriples(model),
              java.nio.charset.Charset.forName("UTF8")
            )
          }
      }
  }

  spec {
    build(
      "Triples (Default Serialization)",
      "/response/serialization/method/default",
      "turtle")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    build(
      "N-Triples",
      "/response/serialization/method/n-triples",
      "ntriple")
      .check(
        headerRegex("Content-Type", "application/n-triples")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    build(
      "N-Quads",
      "/response/serialization/method/n-quads",
      "nquad")
      .check(
        headerRegex("Content-Type", "application/n-quads")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    build(
      "Turtle",
      "/response/serialization/method/turtle",
      "turtle")
      .check(
        headerRegex("Content-Type", "text/turtle")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    build(
      "RDF/XML",
      "/response/serialization/method/rdf/xml",
      "rdf/xml")
      .check(
        headerRegex("Content-Type", "application/rdf\\+xml")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    build(
      "Notation3",
      "/response/serialization/method/notation3",
      "n3")
      .check(
        headerRegex("Content-Type", "text/n3")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    build(
      "TriG",
      "/response/serialization/method/trig",
      "trig")
      .check(
        headerRegex("Content-Type", "application/trig")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    build(
      "RDF/JSON",
      "/response/serialization/method/rdf/json",
      "rdfjson")
      .check(
        headerRegex("Content-Type", "application/rdf\\+json")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    build(
      "MarkLogic Triple XML",
      "/response/serialization/method/triple/xml",
      "triplexml")
      .check(
        headerRegex("Content-Type", "application/vnd.marklogic.triples\\+xml")
      )
      .check(
        bodyString is "true"
      )
  }

  spec {
    http("SPARQL Results - XML").
      get("/response/serialization/method/sparql-results/xml")
      .check(
        headerRegex("Content-Type", "application/sparql-results\\+xml")
      )
      .check(
        xpath("/s:sparql",
          List(("s", "http://www.w3.org/2005/sparql-results#")))
      )
  }

  spec {
    http("SPARQL Results - JSON").
      get("/response/serialization/method/sparql-results/json")
      .check(
        headerRegex("Content-Type", "application/sparql-results\\+json")
      )
  }

  spec {
    http("SPARQL Results - CSV").
      get("/response/serialization/method/sparql-results/csv")
      .check(
        headerRegex("Content-Type", "text/csv")
      )
  }

}
