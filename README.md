# Cloud Boot Application for Tomcat
[![Status](https://travis-ci.org/rb1whitney/cloud-boot-app.svg?branch=master)](https://travis-ci.org/rb1whitney/cloud-boot-app)

This is a basic Java Maven Spring Boot Application that will be put into the cloud. Intention is to either use an in-memory database or mysql data back end so moving parts in the cloud can be tested. Code was modified and used from https://github.com/khoubyari/spring-boot-rest-example

### Playing with the REST Service

There are several operations you can use with this application. They are:

System:
```
Hello World: curl http://localhost:10191/cloud-boot-app
Version Servlet: curl http://localhost:10191/cloud-boot-app/version
```

CRUD:
```
Create data object: curl -H "Content-Type: application/json" -X POST -d '{ "name" : "Test Data", "description" : "This is a sample description" }' http://localhost:10191/cloud-boot-app/api/v1/data
Read all data object: curl -H "Content-Type: application/json" -X GET http://localhost:10191/cloud-boot-app/api/v1/data
Read single data object: curl -H "Content-Type: application/json" -X GET http://localhost:10191/cloud-boot-app/api/v1/data/1
Update data object: curl -H "Content-Type: application/json" -X PUT -d '{ "name" : "Test Data", "description" : "This is a modified description", "id" : "1" }' http://localhost:10191/cloud-boot-app/api/v1/data/1
Delete data object: curl -H "Content-Type: application/json" -X DELETE http://localhost:10191/cloud-boot-app/api/v1/data/1
```

# Running the project with MySQL

This project by default uses h2 in-memory database so that I don't have to install a database in order to run it. However, converting it to run with another relational database such as MySQL is a simple matter of changing the application profile with mysql profile:

```
        java -jar -Dspring.profiles.active=mysql target/cloud-boot-app-0.0.1.war
or
        mvn spring-boot:run -Drun.arguments="spring.profiles.active=mysql"
or
        add -Dspring.profiles.active=mysql to application container
```

# Running with docker
When running with docker, I package the war as a jar with:
mvn package -Dpackage_type=jar
docker build -t cloud-boot-app:0.2 .
docker run -p 8090:8090 -d cloud-boot-app:0.2

or run it in interactive mode with to toy with files:
docker run -it -p 8090:8090 -d cloud-boot-app:0.2 /bin/bash

# Using Official Oracle JDK
Using Java Oracle 8 is pretty bloated, but if you want to use it replace OpenJDK with a slimmed down first. Yeah... this is technically "illegal" docker use but do we really care?

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