package com.xmllondon.restxq.marklogic

/**
 * Session Testing
 */

import com.xmllondon.restxq.RestXQBaseClass
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class Session extends RestXQBaseClass {

  spec {
    http("Ensuring Test User is created")
      .get("/marklogic/session/create-user")
      .check(status is 200)
      .check(bodyString is "OK")
  }

  spec {
    http("Login and receive Session Cookie")
      .post("/session/login")
      .header("Content-Type", "application/json")
      .body(StringBody(
        "{ \"user\" : \"test-user\", \"pass\" : \"password123\" }"
      )).check(status is 200)
  }

  spec {
    http("Confirm logged in as Test User")
      .get("/session/status")
      .header("Accept", "text/xml")
      .check(status is 200)
      .check(bodyString is "<info><user>test-user</user></info>")
  }

  spec {
    http("Logout and destroy Session Cookie")
      .get("/session/logout")
      .check(status is 200)
  }

  spec {
    http("Confirm Test User was logged out")
      .get("/session/status")
      .header("Accept", "text/xml")
      .check(status is 200)
      .check(bodyString not "<info><user>test-user</user></info>")
  }

}
