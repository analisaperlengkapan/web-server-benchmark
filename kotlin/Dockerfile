FROM debian:bookworm-slim as builder

# Install Java and curl/zip
RUN apt-get update && apt-get install -y openjdk-17-jdk curl unzip && rm -rf /var/lib/apt/lists/*

# Install Gradle
WORKDIR /opt
RUN curl -L -o gradle.zip https://services.gradle.org/distributions/gradle-8.5-bin.zip && \
    unzip gradle.zip && \
    rm gradle.zip && \
    mv gradle-8.5 gradle

ENV PATH="/opt/gradle/bin:${PATH}"

WORKDIR /app
COPY build.gradle.kts settings.gradle.kts ./
COPY src ./src

# Build shadow jar
RUN gradle shadowJar --no-daemon

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y openjdk-17-jre-headless && rm -rf /var/lib/apt/lists/*
# Copy the shadow jar (it usually has -all.jar suffix)
COPY --from=builder /app/build/libs/*-all.jar /app.jar
EXPOSE 8080
CMD ["java", "-jar", "/app.jar"]
