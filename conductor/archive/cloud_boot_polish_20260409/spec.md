# Specification: Post-Modernization Polish (CI/CD, Docs, MVC Refactoring)

## Overview
Following the successful upgrade to Java 21 and Spring Boot 3.2, this track aims to "polish" the repository by modernizing the CI/CD pipeline, updating documentation to reflect the new architecture, and refactoring source code to use modern Spring MVC annotations.

## Scope
### 1. Spring MVC Refactoring
- Replace `@RequestMapping(method = RequestMethod.X)` with `@GetMapping`, `@PostMapping`, `@PutMapping`, and `@DeleteMapping` across all controllers.
- Consolidate redundant annotation parameters where applicable.

### 2. CI/CD Modernization
- Update `jenkins/docker/Dockerfile` to use Java 21 (Eclipse Temurin) instead of Java 8.
- Ensure build tools (Maven) are aligned with the project's requirements.

### 3. Documentation Update
- Update `README.md` to remove Java 1.8/8 references.
- Document the new Java 21 / Distroless architecture.
- Update Docker execution examples to use Podman/Docker with the modernized image tag.

### 4. Code Cleanup (Lombok)
- Introduce Project Lombok to reduce boilerplate in `Data.java` and `DataController.java`.
- Replace manual getters, setters, and SLF4J logger definitions with Lombok annotations.

## Success Criteria
- All tests pass after annotation refactoring and Lombok introduction.
- `jenkins/docker/Dockerfile` builds successfully with Java 21.
- `README.md` accurately describes the current state of the project.
- The project compiles and runs without regression.

## Out of Scope
- Adding new functional features.
- Changing database schemas.
- Infrastructure-as-Code (Terraform) modernization (reserved for a future track).
