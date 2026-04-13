# Cloud Boot App Architecture

This document describes the high-level architecture and component relationships for the `cloud-boot-app`.

## 1. Overview
The `cloud-boot-app` is a **Spring Boot 3.2.11** application (Java 21) following a clean N-Tier architecture. It is designed to be cloud-ready, supporting both in-memory (H2) and persistent (MySQL) databases.

## 2. Layered Architecture

### Web/Presentation Layer (`com.dataservice.controller`)
- **DataController**: Exposes RESTful endpoints under `/api/v1/data`. Handles HTTP requests, validation, and JSON/XML mapping.
- **VersionController**: Provides versioning and metadata information for the service.
- **Cross-Cutting Concerns**: Integrated with **Spring Security**, **Lombok** (for code brevity), and **Springdoc/Swagger** (for API documentation).

### Service Layer (`com.dataservice.service`)
- **DataService**: The business logic orchestrator. It decouples the web layer from the data access layer, wrapping repository calls and managing domain logic.

### Data Access Layer (`com.dataservice.repository`)
- **DataRepository**: An interface extending `JpaRepository`. Utilizes **Spring Data JPA** to provide automated CRUD operations and paging/sorting support.

### Domain/Persistence Layer (`com.dataservice.domain`)
- **Data**: The primary JPA Entity representing the persistent data model.
- **Database Support**: 
  - **H2 (In-Memory)**: Default for `dev` and `test` profiles.
  - **MySQL**: Supported for production deployments via Spring Profiles.

## 3. Component Relationships

1. **Request Flow**: `Client` → `DataController` → `DataService` → `DataRepository` → `Database`.
2. **Data Flow**: The `Data` entity serves as both the persistence model and the Data Transfer Object (DTO) for API responses.
3. **Dependency Injection**: Spring's `@Autowired` is used to inject the Repository into the Service, and the Service into the Controller.

## 4. Infrastructure & Deployment

- **Packaging**: The application is packaged as a **WAR** file, suitable for deployment in standalone containers or cloud-native environments.
- **Terraform**: The project includes Terraform modules in `cloud-boot-app/terraform/` for managing:
  - Bastion Hosts
  - S3 Buckets
  - Cloud Application Infrastructure
- **Kubernetes (Helm)**: A Helm chart is provided in `cloud-boot-app/helm/cloud-boot-app` for containerized deployments into Kubernetes clusters. It handles:
  - Scalable Deployments with health checks (Actuator).
  - Internal/External Service and Ingress management.
  - Security contexts optimized for Distroless images.
- **CI/CD**: Configuration for automated builds is provided via `.travis.yml`.

## 5. Technology Stack
- **Framework**: Spring Boot 3.2.11
- **Language**: Java 21
- **Build Tool**: Maven
- **Database**: H2 (Dev), MySQL (Prod)
- **APIs**: REST (JSON/XML)
- **Documentation**: Swagger/OpenAPI (Springdoc)

## 6. Infrastructure Architecture (Terraform)

The infrastructure is managed using **Terraform** and follows a modular design for AWS deployments.

### Orchestration Layer
- **Root Module Group (`terraform/module-groups/cloud-boot-app/`)**: The main entry point that links all sub-modules. It defines 18 core variables for cluster configuration, including scaling policies (`asg_min`/`asg_max`), networking ranges (`vpc_cidr_block`), and instance types.

### Core Modules
- **cloud_domain**: Manages high-level networking, specifically `public_subnets` and `vpc_id`.
- **bastion**: 
  - **Resources**: `aws_security_group`, `aws_launch_configuration`, and `aws_autoscaling_group`.
  - **Purpose**: Provides a managed jump box for SSH access, secured via specific CIDR ingress rules.
- **cloud_boot_app**: 
  - **Resources**: Auto Scaling Group (ASG), Elastic Load Balancer (ELB).
  - **Bootstrapping**: Uses `cloud-boot-app-userdata.sh` for runtime configuration.
- **s3_bucket**: Manages AWS S3 resources for object storage.

### Relationship Graph
- **Networking Dependency**: The `bastion` and `cloud_boot_app` modules depend on `cloud_domain` for subnet IDs and VPC configuration.
- **Security Dependency**: `cloud_boot_app` references `module.bastion.bastion_security_group_id` for SSH ingress, enforcing a "no direct access" security model.
