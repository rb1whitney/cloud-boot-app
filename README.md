# Cloud Boot Application
[![Status](https://travis-ci.org/rb1whitney/cloud-boot-app.svg?branch=master)](https://travis-ci.org/rb1whitney/cloud-boot-app)

This is a modernized Java Maven Spring Boot 3.2 application designed for cloud deployment. It utilizes Java 21 and features a containerized architecture using Google Distroless for enhanced security and minimal image size.

## Modernization Highlights
- **Framework:** Spring Boot 3.2.11
- **Runtime:** Java 21 (Eclipse Temurin)
- **Container:** Google Distroless Java 21 (Debian 12)
- **API Documentation:** SpringDoc OpenAPI (Swagger UI)
- **Testing:** JUnit 5 (Jupiter)
- **CI/CD:** Modernized Jenkins Dockerfile with Java 21

### Playing with the REST Service

#### System Endpoints:
```bash
# Hello World
curl http://localhost:8090/cloud-boot-app/

# Version Info
curl http://localhost:8090/cloud-boot-app/version

# Swagger UI
http://localhost:8090/cloud-boot-app/swagger-ui/index.html
```

#### CRUD Operations:
```bash
# Create data object
curl -H "Content-Type: application/json" -X POST -d '{ "name" : "Test Data", "description" : "This is a sample description" }' http://localhost:8090/cloud-boot-app/api/v1/data

# Read all data objects
curl -H "Content-Type: application/json" -X GET http://localhost:8090/cloud-boot-app/api/v1/data

# Read single data object
curl -H "Content-Type: application/json" -X GET http://localhost:8090/cloud-boot-app/api/v1/data/1

# Update data object
curl -H "Content-Type: application/json" -X PUT -d '{ "name" : "Updated Data", "description" : "Modified description", "id" : 1 }' http://localhost:8090/cloud-boot-app/api/v1/data/1

# Delete data object
curl -H "Content-Type: application/json" -X DELETE http://localhost:8090/cloud-boot-app/api/v1/data/1
```

## Running the Project

### Local Development
Requires Java 21 and Maven 3.9+.

```bash
# Run with H2 (default)
mvn spring-boot:run

# Run with MySQL profile
mvn spring-boot:run -Dspring-boot.run.profiles=mysql
```

### Running with Podman/Docker
The application uses a multi-stage build and runs on a secure Distroless image.

```bash
# Build the image
podman build -t cloud-boot-app:modernized .

# Run the container
podman run -p 8090:8090 -d cloud-boot-app:modernized
```

## Infrastructure & CI/CD
- **Terraform:** Located in `terraform/` for AWS deployment.
- **Jenkins:** Modernized Dockerfile located in `jenkins/docker/Dockerfile`.
- **Vagrant:** Updated to Ubuntu 22.04 for local environment consistency.

## License
Modified and used from [khoubyari/spring-boot-rest-example](https://github.com/khoubyari/spring-boot-rest-example).
