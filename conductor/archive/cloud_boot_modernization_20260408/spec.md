# Specification: Update cloud-boot-app to Java 21 and Spring Boot 3.2

## Overview
This track involves a major version upgrade of the `cloud-boot-app` project from Java 1.8 and Spring Boot 1.5 to Java 21 and Spring Boot 3.2. This includes updating the Maven configuration, migrating source code to the Jakarta EE namespace, replacing deprecated libraries, and modernizing the Dockerized deployment using Google Distroless images.

## Functional Requirements
- **Java 21 Upgrade:** Update `pom.xml` to use Java 21 as the source and target version.
- **Spring Boot 3.2 Upgrade:** Update the parent POM to Spring Boot 3.2.x and align all managed dependencies.
- **Jakarta EE Migration:** Perform a project-wide replacement of `javax.*` imports (Persistence, Servlet, etc.) with `jakarta.*` to support Spring Boot 3's requirement for Jakarta EE 10.
- **OpenAPI Migration:** Remove `springfox-swagger2` and `springfox-swagger-ui` (incompatible with Spring Boot 3) and replace them with `springdoc-openapi-starter-webmvc-ui`.
- **Database Driver Updates:**
    - Update MySQL connector to `mysql-connector-j`.
    - Update H2 and HSQLDB to versions compatible with Hibernate 6 (used by Spring Boot 3).
- **Modernize Dockerfile:**
    - Update the build stage to use a Java 21 Maven image.
    - Update the runtime stage to use the `gcr.io/distroless/java21-debian12` image for enhanced security and minimal footprint.
    - Adjust the entrypoint for compatibility with the distroless image.

## Non-Functional Requirements
- **Security:** Use Distroless images to reduce the attack surface of the container.
- **Performance:** Leverage Java 21 performance improvements and Spring Boot 3's optimized startup.
- **Maintainability:** Align with current industry standards (LTS versions).

## Acceptance Criteria
- [ ] The application compiles successfully using Java 21.
- [ ] All unit tests pass under the new Spring Boot 3.2 environment.
- [ ] The application starts successfully and exposes the `/swagger-ui.html` (or equivalent SpringDoc endpoint).
- [ ] The Docker image builds successfully and the container runs using the Java 21 distroless base.
- [ ] Verified connectivity to H2/HSQLDB and MySQL (if configured) using the new drivers.

## Out of Scope
- Architectural refactoring (e.g., moving to Microservices or adding new features).
- Changing the underlying operating system for the build environment (Maven/Linux).
