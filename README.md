# Cloud Boot Application for Tomcat

This is a basic Java Maven Spring Boot Application that will be put into the cloud. Intention is to either use an in-memory database or mysql data back end so moving parts in the cloud can be tested. Code was modified and used from https://github.com/khoubyari/spring-boot-rest-example

### Playing with the REST Service

```
POST /api/v1/data
Accept: application/json
Content-Type: application/json

{
"name" : "Test Data",
"description" : "This is a sample description"
}

RESPONSE: HTTP 201 (Created)
Location header: http://localhost:8080/api/v1/data/1
```

### Retrieve a paginated list of data

```
http://localhost:8080/api/v1/data?page=0&size=10

Response: HTTP 200
Content: paginated list
```

### Update a data resource

```
PUT /api/v1/data/1
Accept: application/json
Content-Type: application/json

{
"name" : "Test Data",
"description" : "This is a sample description"
}

RESPONSE: HTTP 204 (No Content)
```

# Running the project with MySQL

This project by default uses h2 in-memory database so that I don't have to install a database in order to run it. However, converting it to run with another relational database such as MySQL is a simple matter of changing the application profile

### Then run is using the 'mysql' profile:

```
        java -jar -Dspring.profiles.active=mysql target/spring-boot-app-dataservice-0.2.0.war
or
        mvn spring-boot:run -Drun.arguments="spring.profiles.active=mysql"
```

spring:
  profiles: mysql
spring.datasource:
  driverClassName: com.mysql.jdbc.Driver
    url: jdbc:mysql://127.0.0.1/bootexample
    username: myadmin
    password: myadmin
spring.jpa:
  hibernate:
    dialect: org.hibernate.dialect.MySQLInnoDBDialect
    ddl-auto: update

# Attaching to the app remotely from your IDE

Run the service with these command line options:

```
mvn spring-boot:run -Drun.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
```
and then you can connect to it remotely using your IDE. For dataservice, from IntelliJ You have to add remote debug configuration: Edit configuration -> Remote.




