lazy val root = Project("gatling-funspec-example", file("."))
  .enablePlugins(GatlingPlugin)
  .settings(buildSettings: _*)
  .settings(libraryDependencies ++= projectDependencies)
  .settings(scalariformSettings: _*)

lazy val buildSettings = Seq(
  organization := "io.gatling.funspec",
  version := "1.0.0",
  scalaVersion := "2.12.4"
)

lazy val projectDependencies = Seq(
  "org.scalatest"                   %% "scalatest"                  % "3.0.4"          % "test,it",
  "io.gatling.highcharts"           % "gatling-charts-highcharts"   % "2.3.0"          % "test,it",
  "io.gatling"                      % "gatling-test-framework"      % "2.3.0"          % "test,it",
  "org.apache.jena"                 % "apache-jena-libs"            % "3.8.0"          % "test,it",
  "net.sf.saxon"                    % "Saxon-HE"                    % "9.8.0-12"       % "test,it"
)
