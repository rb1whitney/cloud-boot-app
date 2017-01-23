FROM centos

# Setting Current Version of Java
ENV JAVA_VERSION 8u111
ENV BUILD_VERSION b14
ENV JDK_NAME jdk1.8.0_111
ENV JAVA_HOME /opt/java
ENV PATH ${PATH}:${JAVA_HOME}/bin

# Default Port 8090
EXPOSE 8090

# Optional Step in case we want to upgrade packages to latest
#RUN yum -y upgrade

# Install Java 8
RUN yum -y install java-1.8.0-openjdk-headless && \
    rm -rf /var/cache/* /tmp/*

# Install Spring Boot Artifact
COPY target/cloud-boot-app.jar /cloud-boot-app.jar
# Create temp folder for Spring Boot if it doesn't exists
RUN mkdir -p /tmp
ENTRYPOINT ["java","-jar","/cloud-boot-app.jar"]