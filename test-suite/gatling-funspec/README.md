# Gatling functional tests example project

Example project setup for using the new functional testing functionality coming in Gatling 2.2.0. 

Using it you can writing functional tests in Gatling even easier then before.

Use `sbt test` to run the example

# Example code

From [GatlingFunSpecExample](src/test/scala/io/gatling/funspec/example/GatlingFunSpecExample.scala)


```scala
class GatlingFunSpecExample extends GatlingHttpFunSpec {

  val baseURL = "http://example.com"

  spec {
    http("Example index.html test")
      .get("/index.html")
      .check(h1.exists)
  }

}

object GatlingFunSpecExample {
  def h1 = css("h1")
}
```

# Running the example.

All you need to do to run the example is clone this repository and then in the project root 

* `sbt test` runs `io.gatling.funspec.example.TraditionalUnitTest` in `src/test` with Scalatest
* `sbt gatling:test`runs `io.gatling.funspec.example.GatlingFunSpecExample` in `src/test` with Gatling
* `sbt it:test` runs `io.gatling.funspec.example.TraditionalUnitTest` in `src/it` with Scalatest
* `sbt gatling-it:test`runs `io.gatling.funspec.example.GatlingFunSpecExampleIT` in `src/it` with Gatling

Note: you need to put the `it` scope into the Ivy `projectDependencies` definition in order to make the it tests compile:

    lazy val projectDependencies = Seq(
      "org.scalatest"                   %% "scalatest"                  % "3.0.4"          % "test,it",
      "io.gatling.highcharts"           % "gatling-charts-highcharts"   % "2.3.0"          % "test,it",
      "io.gatling"                      % "gatling-test-framework"      % "2.3.0"          % "test,it"
    )

 # Building from SNAPSHOTs

    # from the gatling-funspec-example directory
    cd ..
    git clone git@github.com:gatling/gatling.git
    cd gatling
    sbt publish-local
    cd ..
    git clone git@github.com:gatling/gatling-sbt.git
    cd gatling-sbt
    sbt publish-local

