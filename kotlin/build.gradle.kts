plugins {
    kotlin("jvm") version "2.2.21"
    application
}

group = "com.benchmark"
version = "1.0.0"

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.ktor:ktor-server-core:3.3.3")
    implementation("io.ktor:ktor-server-netty:3.3.3")
    implementation("io.ktor:ktor-server-content-negotiation:3.3.3")
    implementation("io.ktor:ktor-serialization-kotlinx-json:3.3.3")
    implementation("ch.qos.logback:logback-classic:1.5.21")
}

application {
    mainClass.set("com.benchmark.ApplicationKt")
}

kotlin {
    jvmToolchain(17)
}
