package com.xmllondon.restxq.marklogic

/**
 * Multi-statement Transactions in MarkLogic
 */

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.http.funspec.GatlingHttpFunSpec

class MultiStatementTransaction extends RestXQBaseClass {

  override def httpConf =
    super.httpConf.header("MyHeader", "MyValue")
      .disableFollowRedirect

  def start(): Unit = {
    spec {
      http("Starting an Update Transaction")
        .post("/transaction/start").body(StringBody(""))
        .check(status is 303)
        .check(header("Location").exists)
        .check(headerRegex("Location", "/transaction/[0-9]+"))
        .check(headerRegex("Set-Cookie", "XQRS-Session-ID=([^;]+)"))
    }
  }

  def insert(v: String): Unit = {
    spec {
      http(s"Inserting Document ${v}")
        .get(s"/marklogic/insert-get-delete/insert/tx-${v}")
        .check(status is 200)
    }
  }

  def delete(v: String): Unit = {
    spec {
      http(s"Deleting Document ${v}")
        .get(s"/marklogic/insert-get-delete/delete/tx-${v}")
        .check(status is 200)
    }
  }

  def doesNotExist(v: String): Unit = {
    spec {
      http(s"Document ${v} should NOT exist")
        .get(s"/marklogic/insert-get-delete/exists/tx-${v}")
        .check(status is 200)
        .check(bodyString is "false")
    }
  }

  def exists(v: String): Unit = {
    spec {
      http(s"Document ${v} SHOULD exist")
        .get(s"/marklogic/insert-get-delete/exists/tx-${v}")
        .check(status is 200)
        .check(bodyString is "true")
    }
  }

  def rollback(): Unit = {
    spec {
      http("Rolling back the Transaction")
        .post("/transaction/rollback").body(StringBody(""))
        .check(status is 200)
        .check(headerRegex("Set-Cookie", "XQRS-Session-ID=([^;]+).*max-age=0"))
    }
  }

  def commit(): Unit = {
    spec {
      http("Commit the Transaction")
        .post("/transaction/commit").body(StringBody(""))
        .check(status is 200)
        .check(headerRegex("Set-Cookie", "XQRS-Session-ID=([^;]+).*max-age=0"))
    }
  }

  val docs = List("a", "b", "c", "d", "e", "f", "g")

  start()
  docs.foreach(insert(_))
  docs.foreach(exists(_))
  rollback()
  docs.foreach(doesNotExist(_))

  start()
  docs.foreach(insert(_))
  commit()
  docs.foreach(exists(_))

  docs.foreach(delete(_))

}
