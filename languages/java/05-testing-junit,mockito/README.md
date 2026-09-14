# Project 05: Testing with JUnit and Mockito — Java

**Difficulty:** intermediate  
**Prerequisites:** Project 04 (Exceptions and Error Handling)

## Goals

- Write unit tests with JUnit 5 (Jupiter)
- Use assertions: assertEquals, assertTrue, assertThrows, assertAll, etc.
- Use lifecycle annotations: @BeforeEach, @AfterEach, @BeforeAll, @AfterAll
- Use parameterized tests with @ParameterizedTest and @ValueSource, @CsvSource
- Mock dependencies with Mockito: @Mock, @InjectMocks, when/thenReturn, verify
- Use ArgumentCaptor to capture method arguments
- Use Mockito's lenient mode and exception stubbing

## Concepts

- **JUnit 5 (Jupiter)** — modern Java testing framework
- **Assertions** — static methods in `org.junit.jupiter.api.Assertions`
- **Lifecycle** — @BeforeEach runs before each test, @AfterEach after; @BeforeAll/@AfterAll once per class (static)
- **Parameterized tests** — run same test with different inputs
- **Mockito** — mocking framework for isolating units under test
- **@Mock** — creates a mock object
- **@InjectMocks** — injects mocks into the class under test
- **when().thenReturn()** — stubbing mock behavior
- **verify()** — verify interactions with mocks
- **ArgumentCaptor** — capture arguments passed to mocks

## Exercises

### Exercise 1: JUnit 5 Basics — Assertions and Lifecycle

Create `src/Exercise1_JUnitBasics.java`:

```java
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;
import java.util.*;

import java.util.concurrent.atomic.AtomicInteger;

@DisplayName("JUnit 5 Fundamentals")
class Exercise1_JUnitBasics {

    private static AtomicInteger testCounter = new AtomicInteger(0);

    @BeforeAll
    static void beforeAll() {
        System.out.println("BeforeAll: Running once before all tests");
        testCounter.set(0);
    }

    @AfterAll
    static void afterAll() {
        System.out.println("AfterAll: Ran " + testCounter.get() + " tests total");
    }

    @BeforeEach
    void beforeEach() {
        testCounter.incrementAndGet();
        System.out.println("BeforeEach: Test #" + testCounter.get());
    }

    @AfterEach
    void afterEach() {
        System.out.println("AfterEach: Test #" + testCounter.get() + " complete");
    }

    @Test
    @DisplayName("1. assertEquals — value equality")
    void testAssertEquals() {
        assertEquals(4, 2 + 2, "2 + 2 should equal 4");
        assertEquals("hello", "hello".toUpperCase().toLowerCase());
        assertEquals(List.of(1, 2, 3), List.of(1, 2, 3), "Lists should be equal");
    }

    @Test
    @DisplayName("2. assertTrue / assertFalse — boolean conditions")
    void testBoolean() {
        assertTrue(5 > 3, "5 is greater than 3");
        assertTrue(List.of(1, 2, 3).contains(2), "List contains 2");
        assertFalse(5 < 3, "5 is not less than 3");
        assertFalse(List.of(1, 2, 3).isEmpty(), "List is not empty");
    }

    @Test
    @DisplayName("3. assertNull / assertNotNull — null checks")
    void testNullChecks() {
        String nullString = null;
        String nonNullString = "hello";

        assertNull(nullString, "This string is null");
        assertNotNull(nonNullString, "This string is not null");
        assertNotNull(nonNullString, "String should not be null: %s", nonNullString);
    }

    @Test
    @DisplayName("4. assertThrows — expected exceptions")
    void testAssertThrows() {
        // Should throw ArithmeticException
        ArithmeticException ex = assertThrows(
            ArithmeticException.class,
            () -> divide(10, 0),
            "Division by zero should throw ArithmeticException"
        );
        assertEquals("/ by zero", ex.getMessage());

        // Should throw NumberFormatException
        assertThrows(
            NumberFormatException.class,
            () -> Integer.parseInt("not-a-number"),
            "Parsing invalid string should throw NumberFormatException"
        );
    }

    @Test
    @DisplayName("5. assertAll — group multiple assertions")
    void testAssertAll() {
        String name = "Alice";
        int age = 30;

        assertAll("Person assertions",
            () -> assertEquals("Alice", name, "Name should be Alice"),
            () -> assertEquals(30, age, "Age should be 30"),
            () -> assertTrue(age >= 18, "Should be adult"),
            () -> assertFalse(name.isEmpty(), "Name should not be empty")
        );
    }

    @Test
    @DisplayName("6. assertArrayEquals — array comparison")
    void testArrayEquals() {
        int[] arr1 = {1, 2, 3};
        int[] arr2 = {1, 2, 3};
        int[] arr3 = {3, 2, 1};

        assertArrayEquals(arr1, arr2, "Arrays should be equal");
        assertNotEquals(arr1, arr3, "Different order should not be equal");
    }

    @Test
    @DisplayName("7. assertIterableEquals — collection comparison")
    void testIterableEquals() {
        List<String> list1 = List.of("a", "b", "c");
        List<String> list2 = new ArrayList<>(List.of("a", "b", "c"));

        assertIterableEquals(list1, list2, "Lists with same elements should match");
    }

    @Test
    @DisplayName("8. assertLinesMatch — line-by-line string comparison")
    void testLinesMatch() {
        List<String> expected = List.of("Hello", "World");
        List<String> actual = List.of("Hello", "World");

        assertLinesMatch(expected, actual);
    }

    @Test
    @DisplayName("9. assertTimeout — time-bound execution")
    void testTimeout() {
        // Should complete within 1 second
        assertTimeout(
            java.time.Duration.ofSeconds(1),
            () -> Thread.sleep(100),
            "Should complete within 1 second"
        );
    }

    @Test
    @DisplayName("10. assertInstanceOf — type checking")
    void testInstanceOf() {
        String str = "hello";
        assertInstanceOf(String.class, str, "String is a String");
        assertInstanceOf(CharSequence.class, str, "String implements CharSequence");
    }

    @Test
    @Disabled("Demonstrating @Disabled — this test is skipped")
    void testDisabled() {
        fail("This should never run because it's disabled");
    }

    @Test
    @DisplayName("11. fail — explicit failure")
    void testFail() {
        boolean condition = false;

        if (!condition) {
            fail("Condition was false — this test should fail");
        }
    }

    // Helper method
    private int divide(int a, int b) {
        return a / b;
    }
}
