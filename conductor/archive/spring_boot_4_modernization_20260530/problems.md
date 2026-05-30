# Problem Statement: Spring Boot 4.0 Migration Barriers

## 1. Systemic Dependency Mismatch
- **Issue**: Attempting to bump `spring-boot-starter-parent` from 3.2.11 to 4.0.6 without aligning the underlying Spring Framework BOM led to internal autoconfiguration conflicts.
- **Symptom**: `IllegalStateException` during test context initialization in `ServletMappingsAutoConfiguration`.
- **Root Cause**: Spring Boot 3.2 Actuator conditions fail to evaluate properly when paired with mismatched Spring 7.x libraries.

## 2. Testing Framework Deprecation
- **Issue**: Spring Boot 4.0 / Spring 7 removed or repackaged core testing annotations.
- **Symptom**: Compilation failures in tests using `@MockBean` and `@AutoConfigureMockMvc`.
- **Impact**: Fragmentation of the test suite (XML tests, Error tests) prevented a clean build under the modern stack.

## 3. Infrastructure & Security Debt
- **Issue**: CI pipeline frequently failed due to GitHub API rate limits during TFLint initialization.
- **Issue**: Lack of advanced search capabilities and security-focused endpoints (SSL check) noted in external advisories.
- **Risk**: SSRF vulnerability in placeholder endpoints and missing input sanitization in new search logic.
