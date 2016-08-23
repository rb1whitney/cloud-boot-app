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
        java -jar -Dspring.profiles.active=mysql target/spring-boot-app-dataservice-0.2.0.war
or
        mvn spring-boot:run -Drun.arguments="spring.profiles.active=mysql"
```
