package com.xmllondon.restxq.response.serialization

import java.io.{ ByteArrayOutputStream, StringReader }

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.response.{ ResponseWrapper, StringResponseBody }
import javax.xml.transform.TransformerFactory
import javax.xml.transform.stream.{ StreamResult, StreamSource }
import org.apache.jena.rdf.model.impl.{ PropertyImpl, ResourceImpl, StatementImpl }
import org.apache.jena.rdf.model.{ Model, ModelFactory }

import scala.io.Source

class SerializationParameters extends RestXQBaseClass {

  def toBytes(xs: Int*): Array[Byte] =
    xs.map(_.toByte).toArray

  // override val baseURL = "http://localhost:9090"

  spec {
    http("CData Section Elements").
      post("/response/serialization/parameters/cdata-section-elements")
      .header("Content-Type", "application/xml")
      .body(
        StringBody("<a><b>&lt;x&gt;</b></a>")
      )
      .check(
        bodyString is "<a><b><![CDATA[<x>]]></b></a>"
      )
  }

  spec {
    http("<!DOCTYPE Public").
      get("/response/serialization/parameters/doctype-public")
      .check(
        bodyString is "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
          "<!DOCTYPE e PUBLIC \"-//MAJ//MIN//EN\" \"example.dtd\">\n" +
          "<e>Hello World</e>"
      )
  }

  spec {
    http("<!DOCTYPE System").
      get("/response/serialization/parameters/doctype-system")
      .check(
        bodyString is "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
          "<!DOCTYPE e SYSTEM \"example.dtd\">\n" +
          "<e>Hello World</e>"
      )
  }

  spec {
    http("Encoding = ISO-8859-1").
      get("/response/serialization/parameters/encoding/iso-8859-1")
      .check(
        headerRegex("Content-Type", "ISO-8859-1")
      )
      .check(
        bodyString is "£"
      )
      .check(
        header("Content-Length") is "1"
      )
  }

  spec {
    http("Escape URI Attributes = yes").
      get("/response/serialization/parameters/escape-uri-attributes")
      .check(
        bodyString is "<html><head><meta http-equiv=\"Content-Type\" " +
          "content=\"text/html; charset=UTF-8\"></head><body><a " +
          "href=\"/d/b%C3%A9b%C3%A9.xml\">text</a></body></html>"
      )
  }

  spec {
    http("Include Content Type = yes").
      get("/response/serialization/parameters/include-content-type/yes")
      .check(
        bodyString is "<html><head><meta http-equiv=\"Content-Type\" " +
          "content=\"text/html; charset=UTF-8\" /></head><body/></html>"
      )
  }

  spec {
    http("Include Content Type = no").
      get("/response/serialization/parameters/include-content-type/no")
      .check(
        bodyString is "<html><head/><body/></html>"
      )
  }

  spec {
    http("Indent = yes").
      get("/response/serialization/parameters/indent/yes")
      .check(
        bodyString is "<i>\n" +
          "  <j>\n" +
          "    <k>Hello World</k>\n" +
          "  </j>\n" +
          "</i>"
      )
  }

  spec {
    http("Indent = no").
      get("/response/serialization/parameters/indent/no")
      .check(
        bodyString is "<i><j><k>Hello World</k></j></i>"
      )
  }

  spec {
    http("Item Separator 1").
      get("/response/serialization/parameters/item-separator/1")
      .check(
        bodyString is "AXBXCXD"
      )
  }

  spec {
    http("Item Separator 2").
      get("/response/serialization/parameters/item-separator/2")
      .check(
        bodyString is "<a>Hello</a>...World...1234...2001-01-01"
      )
  }

  spec {
    http("Media Type").
      get("/response/serialization/parameters/media-type")
      .check(
        headerRegex("Content-Type", "text/my-special-text-type")
      )
  }

  spec {
    http("Method = XML").
      get("/response/serialization/parameters/method/xml")
      .check(
        headerRegex("Content-Type", "text/xml")
      )
      .check(
        bodyString is "<e>Hello World</e>"
      )
  }

  spec {
    http("Method = Text").
      get("/response/serialization/parameters/method/text")
      .check(status is 400)
      .check(regex("XQRS011"))
  }

  spec {
    http("Normalization Form = NFC").
      get("/response/serialization/parameters/normalization-form/text")
      .check(
        bodyString is "suçon"
      )
  }

  spec {
    http("Normalization Form = NFC").
      get("/response/serialization/parameters/normalization-form/xml")
      .check(
        bodyString is "<e>suçon</e>"
      )
  }

  spec {
    http("Omit XML Declaration = yes").
      get("/response/serialization/parameters/omit-xml-declaration/yes")
      .check(
        bodyString is "<e>Hello World</e>"
      )
  }

  spec {
    http("Omit XML Declaration = no").
      get("/response/serialization/parameters/omit-xml-declaration/no")
      .check(
        bodyString is "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
          "<e>Hello World</e>"
      )
  }

  spec {
    http("Omit XML Declaration = no (2 items)").
      get("/response/serialization/parameters/omit-xml-declaration/multi")
      .check(
        bodyString is "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
          "<e>A</e>\n" +
          "<e>B</e>"
      )
  }

  spec {
    http("Standalone = yes").
      get("/response/serialization/parameters/standalone/yes")
      .check(
        bodyString is "<?xml version=\"1.0\" encoding=\"UTF-8\" " +
          "standalone=\"yes\"?>\n" +
          "<e>Hello World</e>"
      )
  }

  spec {
    http("Standalone = no").
      get("/response/serialization/parameters/standalone/no")
      .check(
        bodyString is "<?xml version=\"1.0\" encoding=\"UTF-8\" " +
          "standalone=\"no\"?>\n" +
          "<e>Hello World</e>"
      )
  }

}
