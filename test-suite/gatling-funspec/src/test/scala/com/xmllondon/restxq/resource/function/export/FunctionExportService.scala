package com.xmllondon.restxq.resource.function.export

import java.io.{ ByteArrayInputStream, File, FileInputStream }

import com.thaiopensource.validate.{ Schema, ValidationDriver, Validator }
import com.thaiopensource.validate.auto.AutoSchemaReader
import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import javax.xml.transform.stream.StreamSource
import org.xml.sax.InputSource

import com.thaiopensource.util.PropertyMapBuilder
import com.thaiopensource.validate.ValidationDriver
import com.thaiopensource.validate.ValidateProperty
import com.thaiopensource.util.PropertyId
import com.thaiopensource.util.PropertyMap
import com.thaiopensource.validate.SchemaReader
import com.thaiopensource.validate.rng.CompactSchemaReader

/**
 * Invoke GET /xqrs-functions
 * Validate the output against the XQRS Function RelaxNG Schema
 */
class FunctionExportService extends RestXQBaseClass {

  val rncPath = getClass.getResource("/xqrs-functions-1.0.rnc").getPath

  def validateRelaxNg() = {
    bodyString.transform(
      (xmlResponse: String) => {
        validate(rncPath)(xmlResponse)
      }
    )
  }

  def validate(rncPath: String)(xml: String): String = {

    val propertyMap = new PropertyMapBuilder().toPropertyMap
    val validationDriver = new ValidationDriver(CompactSchemaReader.getInstance())

    val schemaIS = new InputSource(new FileInputStream(rncPath))
    schemaIS.setSystemId(rncPath)
    schemaIS.setPublicId(rncPath)
    schemaIS.setEncoding("UTF-8")

    validationDriver.loadSchema(schemaIS)
    val xmlIS = new InputSource(new ByteArrayInputStream(xml.getBytes("UTF8")))
    xmlIS.setEncoding("UTF-8")
    xmlIS.setPublicId("/xqrs-functions")
    val valid = validationDriver.validate(xmlIS)

    valid.toString
  }

  spec {
    http("GET /xqrs-functions").
      get("/xqrs-functions").
      check(status is 200).
      check(headerRegex("Content-Type", "text/xml")).
      check(validateRelaxNg() is "true")
  }
}
