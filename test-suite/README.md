# XQRS Test Suite

The XQRS Test suite is written in [Scala](https://scala-lang.org) and [XQuery](https://www.w3.org/TR/xquery-31/). The Scala part acts as a client, submitting Requests against a remote HTTP Server, checking that the responses match what's expected. The tests are built paying great attention to the wording found in the [RESTXQ specification document](http://exquery.github.io/exquery/exquery-restxq-specification/restxq-1.0-specification.html). There are also additional tests for MarkLogic particulars. At the time of writing this document **there are 414+ tests**.

The Scala Tests make use of the [Gatling](http://gatling.io) framework to submit HTTP Requests to URI locations at a MarkLogic Server. These tests can easily be modified into load and performance tests if they need to be.

Before any test is ran, the [xqrs.xqy](../xqrs.xqy) is copied to `xqrs-test.xqy` with the imports found in [test-suite-imports.xq](test-suite-imports.xq) injected in. When tests have completed, this `xqrs-test.xqy` is deleted.

## Requirements

1. Ensure MarkLogic is installed.
2. Ensure Scala + SBT are installed.

## Setting up the MarkLogic Side

1. Create a MarkLogic HTTP Server on port `9013`
2. Set the `root` property to be the local directory containing `xqrs.xqy`
3. Set the `modules` property to be `(file system)`
4. Set the `url rewriter` property to be `xqrs-test.xqy`
5. Set the 'authentication' property to 'application-level'
6. Set the 'default user' property to 'admin'

## Setting up the client side

1. On the console navigate to `test-suite/gatling-funspec`
2. Get into SBT by typing `sbt`

To run **all** tests, type `gatling:test`

To run a specific test/class you can use `gatling:testOnly com.xmllondon.restxq.resource.function.PathAnnotation`
