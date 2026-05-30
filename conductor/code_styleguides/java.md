# Java Style Guide

Standards for writing Java code following Google Java Style Guide and widely-adopted community conventions.

**References:** [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html) | [Effective Java (Bloch)](https://www.oreilly.com/library/view/effective-java/9780134686097/) | [Oracle Code Conventions](https://www.oracle.com/java/technologies/javase/codeconventions-introduction.html)

## Source File Structure

Every `.java` source file follows this order:

1. License or copyright notice
2. Package statement
3. Import statements (no wildcards)
4. Exactly one top-level class

```java
// Copyright notice if applicable

package com.example.myapp.service;

// Static imports first, then regular
import static java.util.Objects.requireNonNull;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import com.example.myapp.model.User;
import com.example.myapp.repository.UserRepository;

/**
 * Service for managing user lifecycle operations.
 *
 * <p>Handles creation, retrieval, and deactivation of user accounts.
 */
public final class UserService {
    // ...
}
```

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Package | `lowercase.dotted` | `com.example.myapp.service` |
| Class/Interface | `UpperCamelCase` | `UserService`, `PaymentProcessor` |
| Method | `lowerCamelCase` verb | `findById`, `processPayment` |
| Variable | `lowerCamelCase` noun | `userId`, `orderItems` |
| Constant | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT_MS` |
| Test class | `{Subject}Test` | `UserServiceTest` |
| Test method | `{method}_{scenario}_{expected}` | `findById_nonExistentId_throwsNotFound` |

**Rules**:
- No single-letter variables except loop counters (`i`, `j`) and streams (`s`, `e`)
- Boolean variables and methods use `is`, `has`, `can` prefix: `isActive`, `hasPermission`
- Avoid abbreviations in names — `request` not `req`, `exception` not `e` in catch blocks

## Formatting

- **Indentation**: 4 spaces (no tabs)
- **Line length**: 120 characters (Google's default is 100 — this project extends to 120)
- **Braces**: Always use braces even for single-statement bodies
- **Blank lines**: One blank line between methods; two blank lines between top-level declarations

```java
// Bad — no braces, compressed
if (user == null)
  throw new IllegalArgumentException();

// Good — explicit braces
if (user == null) {
    throw new IllegalArgumentException("user must not be null");
}

// Block layout — opening brace on same line
public Optional<User> findById(long userId) {
    if (userId <= 0) {
        throw new IllegalArgumentException("userId must be positive, got: " + userId);
    }
    return userRepository.findById(userId);
}
```

## Immutability First

```java
// Bad — mutable state by default
public class UserDto {
    public String name;
    public String email;
}

// Good — immutable record (Java 16+)
public record UserDto(String name, String email) {
    public UserDto {
        requireNonNull(name, "name");
        requireNonNull(email, "email");
    }
}

// Good — immutable class (pre-Java 16)
public final class UserDto {
    private final String name;
    private final String email;

    public UserDto(String name, String email) {
        this.name = requireNonNull(name, "name");
        this.email = requireNonNull(email, "email");
    }

    public String name() { return name; }
    public String email() { return email; }
}
```

## Optionals

```java
// Bad — Optional as field or parameter
private Optional<String> name;                    // never
public void process(Optional<String> input) {}    // never

// Bad — get() without check
String name = user.getName().get();

// Good — orElseThrow, orElse, ifPresent, map
String name = user.getName()
    .orElseThrow(() -> new UserNotFoundException(userId));

String displayName = user.getName().orElse("Anonymous");

user.getEmail().ifPresent(emailService::send);

// Good — Optional with map/filter pipeline
return userRepository.findById(userId)
    .filter(User::isActive)
    .map(UserDto::from)
    .orElseThrow(() -> new UserNotFoundException(userId));
```

## Streams and Lambdas

```java
// Bad — imperative style for collection operations
List<String> result = new ArrayList<>();
for (User user : users) {
    if (user.isActive()) {
        result.add(user.getEmail());
    }
}

// Good — stream pipeline
List<String> activeEmails = users.stream()
    .filter(User::isActive)
    .map(User::getEmail)
    .collect(Collectors.toUnmodifiableList());

// Bad — complex lambda body
users.stream()
    .filter(u -> {
        return u.isActive() && u.getRole() == Role.ADMIN;
    });

// Good — extract complex lambdas to methods
users.stream()
    .filter(this::isActiveAdmin)
    ...

private boolean isActiveAdmin(User user) {
    return user.isActive() && user.getRole() == Role.ADMIN;
}
```

## Exception Handling

```java
// Bad — swallowing exceptions
try {
    processPayment(order);
} catch (Exception e) {
    // silence
}

// Bad — catching Exception broadly
catch (Exception e) {
    log.error("error", e);
}

// Good — catch specific, log with context, rethrow or wrap
try {
    paymentGateway.charge(amount, card);
} catch (PaymentDeclinedException e) {
    log.warn("Payment declined for order {}: {}", orderId, e.getMessage());
    throw new OrderProcessingException("Payment declined", e);
} catch (GatewayTimeoutException e) {
    log.error("Gateway timeout for order {} after {}ms", orderId, timeoutMs, e);
    throw new RetryableException("Payment gateway timeout", e);
}
```

Custom exceptions must:
- Extend the appropriate base (`RuntimeException` for unchecked, `Exception` for checked)
- Provide a message and cause constructor
- End in `Exception` (never `Error` unless it's a JVM-level error)

## Dependency Injection

```java
// Bad — field injection
@Autowired
private UserRepository userRepository;

// Good — constructor injection (testable, immutable)
@Service
public class UserService {
    private final UserRepository userRepository;
    private final EmailService emailService;

    // Spring auto-detects single constructor — @Autowired not needed
    public UserService(UserRepository userRepository, EmailService emailService) {
        this.userRepository = requireNonNull(userRepository);
        this.emailService = requireNonNull(emailService);
    }
}
```

## Logging Conventions

```java
// Bad — string concatenation in log statements (allocates even when disabled)
log.debug("Processing user " + userId + " with order " + orderId);

// Good — parameterized logging
log.debug("Processing user {} with order {}", userId, orderId);

// Good — guard expensive operations
if (log.isTraceEnabled()) {
    log.trace("Full request payload: {}", objectMapper.writeValueAsString(request));
}

// Log levels:
// ERROR — system failures requiring immediate attention
// WARN  — unexpected state that is recoverable
// INFO  — significant business events (user created, order completed)
// DEBUG — developer diagnostic data
// TRACE — request/response payloads, method entry/exit
```

## Testing Standards

```java
// Use JUnit 5 + AssertJ — never assertEquals(expected, actual) style
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    @Test
    void findById_existingUser_returnsDto() {
        // Arrange
        var user = User.builder().id(1L).name("Alice").active(true).build();
        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        // Act
        var result = userService.findById(1L);

        // Assert
        assertThat(result.name()).isEqualTo("Alice");
        assertThat(result.email()).isNotNull();
    }

    @Test
    void findById_nonExistentUser_throwsNotFound() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> userService.findById(99L))
            .isInstanceOf(UserNotFoundException.class)
            .hasMessageContaining("99");
    }
}
```

## Code Review Checklist

- [ ] All fields `final` where possible
- [ ] No field injection — constructor injection only
- [ ] `Optional` not used as field type or method parameter
- [ ] `Optional.get()` never called without prior `isPresent()` or `orElse`
- [ ] No raw types — generics always fully parameterized
- [ ] Lambdas extracted to named methods when they exceed 2 lines
- [ ] Checked exceptions declared in signature or explicitly wrapped
- [ ] No exception swallowing — always log or rethrow
- [ ] Log statements use parameterized format (not concatenation)
- [ ] Test method names follow `{method}_{scenario}_{expected}` pattern
- [ ] Tests use AssertJ (`assertThat()`) not JUnit assertions directly
- [ ] No `Thread.sleep()` in tests — use Awaitility for async assertions

---

*Based on: [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html) and Effective Java (Joshua Bloch, 3rd Edition)*
