# Multi-Stage Dockerfile
# 1.) Compiles project with maven and creates required jar file
# 2.) Runs Spring Boot Application using Google Distroless Java 21

# Builder Code
FROM maven:3-eclipse-temurin-25 AS builder
RUN mkdir -p /usr/src/build
WORKDIR /usr/src/build

# Use Maven dependency on pom.xml to help docker cache maven artifacts
COPY ./pom.xml /usr/src/build/pom.xml
RUN mvn dependency:go-offline -B

# Copy rest of source files and compiles code
# Force jar packaging for the container build
COPY . /usr/src/build
RUN mvn package -Dpackage_type=jar -DskipTests

# Actual Container Code that will be run
FROM gcr.io/distroless/java21-debian12:nonroot

# Override to specify environment name
ENV CBA_ENVIRONMENT local
EXPOSE 8090 8091

# Set the working directory
WORKDIR /app

# Install Spring Boot Artifact from build stage
COPY --from=builder /usr/src/build/target/cloud-boot-app.jar /app/cloud-boot-app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "/app/cloud-boot-app.jar"]
