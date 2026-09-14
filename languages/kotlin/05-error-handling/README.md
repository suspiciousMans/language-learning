# Project 05: Error Handling — Kotlin

**Difficulty:** intermediate  
**Prerequisites:** Project 04 (Functional Style)

## Goals

- Use Kotlin's Result/Option types for error handling
- Understand when to throw exceptions vs return result types
- Write custom error types and exception hierarchies
- Use `runCatching` and other error-handling scope functions

## Concepts

- **Exceptions** — Kotlin uses Java's exception system: `Throwables`, `RuntimeException`, etc.
- **Result type** — Kotlin 1.5+ has `Result<T>` for success/failure operations
- **`runCatching { ... }`** — wraps code that might throw, returns `Result<T>`
- **Custom exceptions** — extend `Exception` or `RuntimeException`

## Exercises

### Exercise 1: Result Type for Safe Operations

Create `src/result_operations.kt`:

```kotlin
// Simulate operations that can fail

data class User(val id: Int, val name: String, val email: String)

// Returns Result<User> — success or failure
fun findUserById(id: Int): Result<User> {
    return if (id > 0) {
        Result.success(User(id, "User $id", "user$id@example.com"))
    } else {
        Result.failure(Exception("User not found: $id"))
    }
}

// Returns Result<String> — success or failure
fun parseJson(json: String): Result<Map<String, String>> {
    return try {
        // Simulate parsing
        if (json.contains("{")) {
            Result.success(mapOf("parsed" to "ok"))
        } else {
            Result.failure(Exception("Invalid JSON"))
        }
    } catch (e: Exception) {
        Result.failure(e)
    }
}

fun main() {
    // TODO: use findUserById(42), check .isSuccess, print user name if success

    // TODO: use findUserById(-1), check .isFailure, print error message

    // TODO: use .getOrNull() — returns value or null

    // TODO: use .getOrElse { defaultValue } — returns value or default

    // TODO: use .onSuccess { println("Got: $it") } — side effect on success

    // TODO: use .onFailure { println("Failed: ${it.message}") } — side effect on failure

    // TODO: use .fold({ success -> ... }, { error -> ... }) — handle both cases
}
```

Expected output:
```
Got user: User 42
Error: User not found: -1
User via getOrNull: User(42, User 42, user42@example.com)
Default for -1: User(0, Unknown, unknown@example.com)
Fold success: User 42
Fold error: User not found: -1
```

### Exercise 2: Custom Exceptions and Error Classes

Create `src/custom_errors.kt`:

```kotlin
// Custom exception hierarchy
class AppException(message: String) : Exception(message)

class NotFoundException(message: String) : AppException(message)
class ValidationException(message: String, val field: String) : AppException(message)
class DatabaseException(message: String, val errorCode: Int) : AppException(message)

data class ValidationError(val field: String, val message: String)

fun validateUser(name: String?, email: String?): Result<Unit> {
    val errors = mutableListOf<ValidationError>()

    if (name == null || name.isBlank()) {
        errors.add(ValidationError("name", "Name is required"))
    }
    if (email == null || !email.contains("@")) {
        errors.add(ValidationError("email", "Valid email required"))
    }

    return if (errors.isEmpty()) {
        Result.success(Unit)
    } else {
        Result.failure(ValidationException(
            "Validation failed: ${errors.joinToString { "${it.field}: ${it.message}" }}",
            errors.joinToString(",") { it.field }
        ))
    }
}

// TODO: write a function that throws DatabaseException with error code 500
fun connectDatabase(): String {
    TODO()
}

// TODO: write a function that calls connectDatabase and catches DatabaseException
// Returns Result<String> — success or error message
fun safeConnect(): Result<String> {
    TODO()
}

fun main() {
    // TODO: test validateUser with ("Alice", "alice@example.com") — success

    // TODO: test validateUser with (null, "not-an-email") — validation error

    // TODO: test safeConnect — should catch and return error Result
}
```

### Exercise 3: runCatching and Exception Handling

Create `src/runcatching.kt`:

```kotlin
import kotlin.runCatching

// A function that might throw
fun divide(a: Int, b: Int): Int {
    if (b == 0) throw ArithmeticException("Cannot divide by zero")
    return a / b
}

// Another function that might throw
fun readFile(path: String): String {
    if (path.isEmpty()) throw IllegalArgumentException("Empty path")
    return "Contents of $path"
}

fun main() {
    // TODO: use runCatching { divide(10, 2) } — should succeed
    // Print: "10 / 2 = 5"

    // TODO: use runCatching { divide(10, 0) } — should fail
    // Print error message from exception

    // TODO: use runCatching { divide(10, 0) }.getOrElse { 0 } — fallback to 0
    // Print: "Using getOrElse with divide(10,0) = 0"

    // TODO: use .onSuccess { ... } and .onFailure { ... } chained with runCatching

    // TODO: chain multiple runCatching calls:
    // readFile("data.json").let { parseJson(it) }
    // Handle failure at any step
}
```

### Exercise 4: Either Type (Functional Error Handling)

Create `src/either.kt`:

```kotlin
// A simple Either type — Left for error, Right for success
sealed class Either<out L, out R> {
    data class Left<out L>(val value: L) : Either<L, Nothing>()
    data class Right<out R>(val value: R) : Either<Nothing, R>()
}

// Helper for error
fun <L, R> left(value: L): Either<L, R> = Either.Left(value)
// Helper for success
fun <L, R> right(value: R): Either<L, R> = Either.Right(value)

// The "bind" operation — extract value or short-circuit
fun <E, A> Either<E, A>.bind(): A? = when (this) {
    is Either.Left -> null  // In real Either, you'd throw or propagate
    is Either.Right -> value
}

// A computation that uses Either
fun validateAge(age: Int): Either<String, Int> {
    if (age < 0) return left("Age cannot be negative")
    if (age > 150) return left("Age seems unrealistic")
    return right(age)
}

fun validateName(name: String): Either<String, String> {
    if (name.isBlank()) return left("Name required")
    return right(name.trim())
}

fun createUser(age: Int, name: String): Either<String, String> {
    // Chain validations with flatMap
    val ageResult = validateAge(age)
    if (ageResult is Either.Left) return ageResult

    val nameResult = validateName(name)
    if (nameResult is Either.Left) return nameResult

    val validatedAge = ageResult as Either.Right
    val validatedName = nameResult as Either.Right

    return right("User created: $validatedName, age $validatedAge")
}

fun main() {
    // TODO: test createUser(25, "Alice") — success
    // TODO: test createUser(-5, "Bob") — age error
    // TODO: test createUser(25, "  ") — name error

    // TODO: print: "User created: Alice, age 25"
    // TODO: print: "Error: Age cannot be negative"
    // TODO: print: "Error: Name required"
}
```

## Completion Checklist

- [ ] You can wrap operations in `Result<T>` to represent success/failure
- [ ] You can use `.isSuccess`, `.isFailure`, `.getOrNull()`, `.getOrElse()`
- [ ] You can chain `.onSuccess` and `.onFailure` for side effects
- [ ] You can use `runCatching { ... }` to catch exceptions as `Result<T>`
- [ ] You can create custom exception classes with extra data
- [ ] You understand when to use exceptions (unexpected errors) vs result types (expected failures)
- [ ] You can implement a simple `Either<L, R>` type

## Hints

- `Result<T>` is Kotlin's built-in result type — use it for expected failure cases
- Exceptions should be for truly unexpected errors, not expected control flow
- `runCatching` is like try/catch but returns a Result — functional style
- The `Either` type is more general than `Result` — you choose what "Left" means (error, metadata, etc.)
