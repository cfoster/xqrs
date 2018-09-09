package com.xmllondon.restxq

import java.io.{ File, FileOutputStream }

import io.gatling.core.structure.PopulationBuilder
import io.gatling.http.funspec.GatlingHttpFunSpec

import scala.io.Source

abstract class RestXQBaseClass extends GatlingHttpFunSpec {

  val baseURL = "http://localhost:9013"
  val boundary: String = "simple boundary";

  override def httpConf = super.httpConf

  val xqrsFile = "../../xqrs.xqy";
  val testImportsFile = "../test-suite-imports.xq"
  val xqrsTestFile = "../../xqrs-test.xqy";

  val injectModulesRegex = "\\(:\\s+-{5,}.+\\s+-{5,}\\s+:\\)".r

  val originalXQueryContent = Source.fromFile(xqrsFile).mkString
  val testModuleImports = Source.fromFile(testImportsFile).mkString
  val xqrsTestXQuery =
    injectModulesRegex.replaceAllIn(originalXQueryContent, testModuleImports)

  before {
    val os = new FileOutputStream(xqrsTestFile)
    os.write(xqrsTestXQuery.getBytes("UTF8"))
    os.close()
  }

  after {
    val tempFile = new java.io.File(xqrsTestFile)
    if (tempFile.exists)
      tempFile.delete()
  }
}
