name := """polaris"""
organization := "io.mackerel"

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.13.10"

scalacOptions += "-Ywarn-unused"

libraryDependencies += guice
libraryDependencies += "org.scalatestplus.play" %% "scalatestplus-play" % "5.1.0" % Test
libraryDependencies ++= Seq(
  "com.github.tminglei" %% "slick-pg" % "0.21.1",
  "com.typesafe.play" %% "play-slick" % "5.1.0",
  "com.typesafe.play" %% "play-slick-evolutions" % "5.1.0",
  "com.typesafe.slick" %% "slick-codegen" % "3.4.1",
  "org.postgresql" % "postgresql" % "42.5.2",
)

// Adds additional packages into Twirl
//TwirlKeys.templateImports += "io.mackerel.controllers._"

// Adds additional packages into conf/routes
// play.sbt.routes.RoutesKeys.routesImport += "io.mackerel.binders._"

ThisBuild / scalafixScalaBinaryVersion := "2.13"
ThisBuild / semanticdbEnabled := true
ThisBuild / semanticdbVersion := scalafixSemanticdb.revision

lazy val slick = taskKey[Seq[File]]("Generate Tables.scala.")
slick := {
  val slickDriver = "slick.jdbc.PostgresProfile"
  val jdbcDriver = "org.postgresql.Driver"
  val url = "jdbc:postgresql:polaris"
  val outputDir = (Compile / sourceManaged).value
  val pkg = "models"
  runner.value.run("slick.codegen.SourceCodeGenerator",
    (Compile / dependencyClasspath).value.files,
    Array(slickDriver, jdbcDriver, url, outputDir.getPath, pkg),
    streams.value.log
  ).failed foreach (sys error _.getMessage)
  Seq(outputDir / pkg / "Tables.scala")
}
Compile / sourceGenerators += slick
