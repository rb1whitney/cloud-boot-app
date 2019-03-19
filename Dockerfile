# Multi-Stage Dockerfile
# 1.) Compiles project with maven and creates required jar file
# 2.) Installs Java 1.8 Headless JDK and runs Spring Boot Application

# Builder Code
FROM maven as builder
RUN mkdir -p /usr/src/build
WORKDIR /usr/src/build

# Use Maven dependency on pom.xml to help docker cache maven artifacts
COPY ./pom.xml /usr/src/build/pom.xml
RUN mvn dependency:go-offline -B

# Copy rest of source files so cache is not changed and compiles code
COPY . /usr/src/build
RUN mvn package -Dpackage_type=jar

# Actual Container Code that will be run
FROM centos

# Override to specify environment name
ENV CBA_ENVIRONMENT local
EXPOSE 8090

# Optional Step in case we want to upgrade packages to latest
# RUN yum -y upgrade

# Install Java 8, cleans up cache, and creates temp folder for Spring Boot
RUN yum -y install java-1.8.0-openjdk-headless && rm -rf /var/cache/* /tmp/* && mkdir -p /tmp

# Install Spring Boot Artifact from build stage
COPY --from=builder /usr/src/build/target/cloud-boot-app.jar /cloud-boot-app.jar

ENTRYPOINT ["java","-jar","/cloud-boot-app.jar"]