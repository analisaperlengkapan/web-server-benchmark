FROM maven:3-eclipse-temurin-25 as builder
WORKDIR /app
COPY pom.xml ./
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:25-jre
COPY --from=builder /app/target/java-server-1.0.0.jar /app.jar
EXPOSE 8080
# Optimize JVM for containers
CMD ["java", "-Xmx512m", "-Xms512m", "-XX:+UseParallelGC", "-jar", "/app.jar"]
