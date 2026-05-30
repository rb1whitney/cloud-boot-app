# Implementation Plan: Modernize cloud-boot-app (Java 21 & Spring Boot 3.2)

This plan outlines the major version upgrade of the `cloud-boot-app` project, including dependency updates, Jakarta EE migration, and Docker modernization.

## Phase 1: Build & Dependency Baseline
**Goal:** Update Maven configuration and identify initial breakage.

- [x] Task: Update `pom.xml` to Java 21 and Spring Boot 3.2.x `[x]` db2f4e9
- [x] Task: Replace Springfox with `springdoc-openapi-starter-webmvc-ui` `[x]` d3eb083
- [x] Task: Update MySQL, H2, and HSQLDB dependency coordinates `[x]` d38ba14
- [x] Task: Conductor - User Manual Verification 'Phase 1: Build & Dependency Baseline' (Protocol in workflow.md) `[x]`
...
## Phase 2: Jakarta EE & Code Migration
**Goal:** Migrate source code to Jakarta EE namespace and resolve breaking changes.

- [x] Task: Perform bulk replacement of `javax.*` imports with `jakarta.*` `[x]` d8ba737
- [x] Task: Resolve Spring Security configuration breaking changes (v1.5 to v3.2) `[x]` 7697877
- [x] Task: Update JPA entity mappings for Hibernate 6 compatibility `[x]` d8ba737
- [x] Task: Fix breaking changes in Controller and Service logic for Spring Boot 3 compatibility `[x]` d8ba737
- [x] Task: Conductor - User Manual Verification 'Phase 2: Jakarta EE & Code Migration' (Protocol in workflow.md) `[x]`

## Phase 3: Testing & Validation (TDD)
**Goal:** Ensure all functionality is preserved under the new stack.

- [x] Task: Write failing unit tests for core API endpoints (Red Phase) `[x]` d8ba737
- [x] Task: Implement necessary logic to pass unit tests (Green Phase) `[x]` 9e7d1d3
- [x] Task: Verify OpenAPI/Swagger UI endpoint (`/swagger-ui/index.html`) `[x]` 70cf56f
- [x] Task: Conductor - User Manual Verification 'Phase 3: Testing & Validation (TDD)' (Protocol in workflow.md) `[x]`

## Phase 4: Containerization & Finalization
**Goal:** Modernize Dockerfile to use Google Distroless Java 21.

- [x] Task: Update `Dockerfile` build stage to use Maven with Java 21 `[x]`
- [x] Task: Update `Dockerfile` runtime stage to `gcr.io/distroless/java21-debian12` `[x]`
- [x] Task: Adjust Docker entrypoint and exposure for Distroless compatibility `[x]`
- [x] Task: Perform final end-to-end build and run verification `[x]` fb85600
- [x] Task: Conductor - User Manual Verification 'Phase 4: Containerization & Finalization' (Protocol in workflow.md) `[x]`
