# Project 06: Testing — Kotlin

**Difficulty:** intermediate  
**Prerequisites:** Project 05 (Error Handling)

## Goals

- Write unit tests with JUnit 5
- Use MockK for mocking dependencies
- Write test cases for edge cases: empty input, null, boundary values
- Structure tests: Arrange-Act-Assert pattern

## Concepts

- **JUnit 5** — `@Test`, `@BeforeEach`, `@AfterEach`, `@DisplayName`, assertions
- **MockK** — mocking library: `mockk()`, `every { ... } returns ...`, `verify { ... }`
- **AssertJ** — fluent assertions: `assertThat(x).isEqualTo(y)`
- **Test structure** — Arrange (setup), Act (call), Assert (verify)

## Exercises

### Exercise 1: JUnit 5 Basics

Create `src/Calculator.kt`:

```kotlin
class Calculator {
    fun add(a: Int, b: Int): Int = a + b
    fun subtract(a: Int, b: Int): Int = a - b
    fun multiply(a: Int, b: Int): Int = a * b
    fun divide(a: Int, b: Int): Int {
        if (b == 0) throw ArithmeticException("Division by zero")
        return a / b
    }
}
```

Create `test/CalculatorTest.kt`:

```kotlin
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.DisplayName

class CalculatorTest {
    private val calculator = Calculator()

    @Test
    @DisplayName("add returns sum of two positive numbers")
    fun `add returns sum`() {
        // Arrange
        val a = 5
        val b = 3

        // Act
        val result = calculator.add(a, b)

        // Assert
        assertEquals(8, result)
    }

    @Test
    @DisplayName("subtract returns difference")
    fun `subtract returns difference`() {
        assertEquals(2, calculator.subtract(5, 3))
    }

    @Test
    @DisplayName("multiply returns product")
    fun `multiply returns product`() {
        assertEquals(15, calculator.multiply(5, 3))
    }

    @Test
    @DisplayName("divide by zero throws ArithmeticException")
    fun `divide by zero throws`() {
        // assertThrows returns the thrown exception
        val exception = assertThrows<ArithmeticException> {
            calculator.divide(5, 0)
        }
        assertEquals("Division by zero", exception.message)
    }
}
```

### Exercise 2: MockK Mocks

Create `src/UserRepository.kt`:

```kotlin
interface UserRepository {
    fun findById(id: Int): User?
    fun save(user: User): User
    fun delete(id: Int): Boolean
}

class UserService(private val repo: UserRepository) {
    fun getUser(id: Int): User? = repo.findById(id)
    fun createUser(name: String, email: String): User {
        val user = User(0, name, email, listOf())
        return repo.save(user)
    }
    fun deleteUser(id: Int): Boolean = repo.delete(id)
}
```

Create `test/UserServiceTest.kt`:

```kotlin
import io.mockk.*
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*

class UserServiceTest {
    private lateinit var mockRepo: UserRepository
    private lateinit var service: UserService

    @BeforeEach
    fun setUp() {
        mockRepo = mockk()
        service = UserService(mockRepo)
    }

    @Test
    fun `getUser returns user when found`() {
        // Arrange
        val user = User(1, "Alice", "alice@example.com", listOf())
        every { mockRepo.findById(1) } returns user

        // Act
        val result = service.getUser(1)

        // Assert
        assertEquals(user, result)
        verify(exactly = 1) { mockRepo.findById(1) }
    }

    @Test
    fun `getUser returns null when not found`() {
        every { mockRepo.findById(999) } returns null
        assertNull(service.getUser(999))
    }

    @Test
    fun `createUser saves and returns user`() {
        val newUser = User(1, "Bob", "bob@example.com", listOf())
        every { mockRepo.save(any()) } returns newUser

        val result = service.createUser("Bob", "bob@example.com")

        assertEquals("Bob", result.name)
        verify { mockRepo.save(any()) }
    }
}
```

### Exercise 3: Property-Based Testing (jqwik)

Create `src/Reverse.kt`:

```kotlin
// A function to test: reverse a string
fun reverse(s: String): String {
    return s.reversed()
}

// Property: reverse(reverse(s)) == s
fun reverseIsInvolutive(s: String): Boolean {
    return reverse(reverse(s)) == s
}

// Property: reverse of empty string is empty
fun reverseEmptyIsEmpty(): Boolean {
    return reverse("").isEmpty()
}
```

Create `test/ReverseTest.kt`:

```kotlin
import net.jqwik.api.*
import org.junit.jupiter.api.Assertions.*

class ReversePropertyTest {
    @Property
    fun `reverse is involutive`(@ForAll s: String) {
        assertEquals(s, reverse(reverse(s)))
    }

    @Property
    fun `reverse of palindrome is same`(@ForAll s: String) {
        if (s == s.reversed()) {
            assertEquals(s, reverse(s))
        }
    }

    @Test
    fun `reverse of empty is empty`() {
        assertTrue(reverse("").isEmpty())
    }
}
```

### Exercise 4: Integration Test with File System

Create `src/FileStats.kt`:

```kotlin
import java.io.File

data class FileStats(
    val lines: Int,
    val words: Int,
    val chars: Int
)

fun computeFileStats(path: String): FileStats {
    val content = File(path).readText()
    return FileStats(
        lines = content.lines().size,
        words = content.split("\\s+".toRegex()).filter { it.isNotBlank() }.size,
        chars = content.length
    )
}

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println("Usage: provide a file path")
        return
    }
    val stats = computeFileStats(args[0])
    println("Lines: ${stats.lines}, Words: ${stats.words}, Chars: ${stats.chars}")
}
```

Create `test/FileStatsTest.kt`:

```kotlin
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test
import java.io.File
import java.nio.file.Files
import java.nio.file.Path

class FileStatsTest {
    @Test
    fun `compute stats on simple file`() {
        // Create temp file
        val tempFile = Files.createTempFile("test", ".txt").toFile()
        tempFile.writeText("hello world\nfoo bar\n")

        try {
            val stats = computeFileStats(tempFile.absolutePath)
            assertEquals(2, stats.lines)
            assertEquals(4, stats.words)
            assertEquals(17, stats.chars)  // "hello world\nfoo bar\n" = 17 chars
        } finally {
            tempFile.delete()
        }
    }

    @Test
    fun `compute stats on empty file`() {
        val tempFile = Files.createTempFile("empty", ".txt").toFile()
        tempFile.writeText("")

        val stats = computeFileStats(tempFile.absolutePath)
        assertEquals(0, stats.lines)
        assertEquals(0, stats.words)
        assertEquals(0, stats.chars)

        tempFile.delete()
    }
}
```

## Completion Checklist

- [ ] You can write basic JUnit 5 tests with `@Test`, `@BeforeEach`
- [ ] You can use AssertJ or Kotlin's `assert*` for assertions
- [ ] You can structure tests with Arrange-Act-Assert pattern
- [ ] You can mock interfaces with MockK (`mockk()`, `every`, `verify`)
- [ ] You can test error cases: exceptions, null returns
- [ ] You can write property-based tests with jqwik (optional)
- [ ] You can write integration tests that use the file system

## Hints

- Test names should describe *what* is being tested, not *how*
- Use `@DisplayName` to write readable test descriptions in backtick identifiers
- MockK's `any()` matches any argument — use `any<Int>()` for typed matchers
- Always clean up resources (files, connections) in tests — use `@AfterEach` or `try/finally`
