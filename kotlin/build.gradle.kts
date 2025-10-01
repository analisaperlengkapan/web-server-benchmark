plugins {
    kotlin("jvm") version "1.9.21"
    application
}

group = "com.benchmark"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core:2.3.7")
    implementation("io.ktor:ktor-server-netty:2.3.7")
    implementation("io.ktor:ktor-server-content-negotiation:2.3.7")
    implementation("io.ktor:ktor-serialization-kotlinx-json:2.3.7")
    implementation("ch.qos.logback:logback-classic:1.4.14")
}

application {
    mainClass.set("com.benchmark.ApplicationKt")
}

kotlin {
    jvmToolchain(17)
}
