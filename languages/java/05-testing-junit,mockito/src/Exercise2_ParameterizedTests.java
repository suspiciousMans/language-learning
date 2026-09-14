import org.junit.jupiter.api.*;
import org.junit.jupiter.params.*;
import org.junit.jupiter.params.provider.*;
import static org.junit.jupiter.api.Assertions.*;
import java.util.*;

@DisplayName("Parameterized Tests")
class Exercise2_ParameterizedTests {

    // @ValueSource — simple values
    @ParameterizedTest
    @ValueSource(ints = {1, 2, 3, 5, 8, 13})
    @DisplayName("Fibonacci numbers are positive")
    void testFibonacciPositive(int n) {
        assertTrue(n > 0, n + " should be positive");
    }

    @ParameterizedTest
    @ValueSource(strings = {"racecar", "madam", "level", "radar"})
    @DisplayName("Palindromes read the same forwards and backwards")
    void testPalindromes(String word) {
        String reversed = new StringBuilder(word).reverse().toString();
        assertEquals(word, reversed, word + " should be a palindrome");
    }

    // @CsvSource — comma-separated values
    @ParameterizedTest
    @CsvSource({
        "1, 1, 2",
        "2, 3, 5",
        "10, 20, 30",
        "-5, 5, 0",
        "0, 0, 0"
    })
    @DisplayName("Addition works correctly")
    void testAddition(int a, int b, int expected) {
        assertEquals(expected, a + b, a + " + " + b + " should equal " + expected);
    }

    @ParameterizedTest
    @CsvSource({
        "Alice, alice@example.com, true",
        "Bob, bob@example.com, true",
        "bad-email, bad, false",
        "", ", false"
    })
    @DisplayName("Email validation")
    void testEmailValidation(String name, String email, boolean expectedValid) {
        boolean isValid = name != null && name.contains("@") || email != null && email.contains("@");
        assertEquals(expectedValid, isValid,
            "Email validation for " + name + "/" + email + " should be " + expectedValid);
    }

    // @MethodSource — values from a static method
    static Collection<String> provideWords() {
        return List.of("apple", "banana", "cherry", "date");
    }

    @ParameterizedTest
    @MethodSource("provideWords")
    @DisplayName("Words have length > 0")
    void testWordLength(String word) {
        assertTrue(word.length() > 0, word + " should not be empty");
    }

    // @EnumSource — enum values
    enum Operation { ADD, SUBTRACT, MULTIPLY, DIVIDE }

    @ParameterizedTest
    @EnumSource(Operation.class)
    @DisplayName("All operations exist")
    void testAllOperationsExist(Operation op) {
        assertNotNull(op, "Operation should not be null");
        assertTrue(op.name().length() > 0, "Operation name should not be empty");
    }

    // @CsvFileSource — values from a CSV file resource
    // (Not shown here but easily used with classpath resource)

    // Combination: multiple sources
    @ParameterizedTest
    @ValueSource(ints = {2, 4, 6, 8, 10})
    @DisplayName("Even numbers are divisible by 2")
    void testEvenNumbers(int n) {
        assertEquals(0, n % 2, n + " is even");
    }
}
