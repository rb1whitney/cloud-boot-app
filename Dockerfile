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
RUN yum -y upgrade

# Install Lean Oracle Java 8; Yeah... I know I can use java-1.8.0-openjdk and this is "illegal" docker use. Sue me...
RUN yum -y install wget && \
    wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.tar.gz" -O /tmp/jdk.tar.gz && \
    tar -xzf /tmp/jdk.tar.gz -C /opt && \
    ln -s /opt/$JDK_NAME /opt/java && \
    yum -y remove wget && \
    rm -rf /tmp/jdk.tar.gz \
           /opt/java/*src.zip \
           /opt/java/lib/missioncontrol \
           /opt/java/lib/visualvm \
           /opt/java/lib/*javafx* \
           /opt/java/jre/lib/plugin.jar \
           /opt/java/jre/lib/ext/jfxrt.jar \
           /opt/java/jre/bin/javaws \
           /opt/java/jre/lib/javaws.jar \
           /opt/java/jre/lib/desktop \
           /opt/java/jre/plugin \
           /opt/java/jre/lib/deploy* \
           /opt/java/jre/lib/*javafx* \
           /opt/java/jre/lib/*jfx*


# Install Spring Boot Artifact
COPY target/cloud-boot-app.jar /cloud-boot-app.jar
# Create temp folder for Spring Boot if it doesn't exists
RUN mkdir -p /tmp
ENTRYPOINT ["java","-jar","/cloud-boot-app.jar"]