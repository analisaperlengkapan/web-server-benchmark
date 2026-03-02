plugins {
    kotlin("jvm") version "2.3.0"
    kotlin("plugin.serialization") version "2.3.10"
    id("io.github.goooler.shadow") version "8.1.7"
    application
}

group = "com.benchmark"
version = "1.0.0"

repositories {
    mavenCentral()
    gradlePluginPortal()
}

dependencies {
    implementation("io.ktor:ktor-server-core:3.4.0")
    implementation("io.ktor:ktor-server-netty:3.4.0")
    implementation("io.ktor:ktor-server-content-negotiation:3.4.0")
    implementation("io.ktor:ktor-serialization-kotlinx-json:3.4.0")
    implementation("ch.qos.logback:logback-classic:1.5.32")
}

application {
    mainClass.set("com.benchmark.ApplicationKt")
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}
