# Project 04: Exceptions and Error Handling — Java

**Difficulty:** intermediate  
**Prerequisites:** Project 03 (Collections, Streams, Lambdas)

## Goals

- Understand Java's exception hierarchy: checked vs unchecked
- Write try-catch-finally blocks properly
- Create custom exception classes
- Use try-with-resources for AutoCloseable resources
- Handle errors functionally: Optional, Result patterns

## Concepts

- **Throwable** — root of all errors/exceptions
- **Checked exceptions** — must be declared or caught (IOException, SQLException)
- **Unchecked exceptions** — RuntimeException and subclasses (NullPointerException, IllegalArgumentException)
- **Error** — serious JVM problems (OutOfMemoryError, StackOverflowError) — usually not caught
- **Try-with-resources** — automatic resource management (Java 7+)
- **Multi-catch** — catch multiple exception types in one block (Java 7+)
- **Optional<T>** — container for potentially absent values (not for exceptions, but related)
- **Custom exceptions** — extend Exception (checked) or RuntimeException (unchecked)

## Exercises

### Exercise 1: Basic Exception Handling

Create `src/Exercise1_BasicExceptions.java`:

```java
import java.io.*;

public class Exercise1_BasicExceptions {
    public static void main(String[] args) {
        // Division by zero — ArithmeticException (unchecked)
        try {
            int result = divide(10, 0);
            System.out.println("Result: " + result);
        } catch (ArithmeticException e) {
            System.out.println("Caught arithmetic error: " + e.getMessage());
        }

        // Valid division
        try {
            int result = divide(10, 2);
            System.out.println("10 / 2 = " + result);
        } catch (ArithmeticException e) {
            System.out.println("Error: " + e.getMessage());
        }

        // Array access out of bounds — ArrayIndexOutOfBoundsException (unchecked)
        int[] numbers = {1, 2, 3};
        try {
            System.out.println("Element at index 5: " + numbers[5]);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Array bounds error: " + e.getMessage());
        }

        // NullPointerException — accessing method on null
        String text = null;
        try {
            int len = text.length();
            System.out.println("Length: " + len);
        } catch (NullPointerException e) {
            System.out.println("Null pointer: " + e.getMessage());
        }

        // Finally block — always executes
        int[] data = {10, 20, 30};
        int index = 0;
        try {
            index = 5;
            int value = data[index];
            System.out.println("Got value: " + value);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Catch: " + e.getMessage());
        } finally {
            System.out.println("Finally: index was " + index);
        }

        // Multiple exceptions — multi-catch (Java 7+)
        try {
            int[] arr = new int[5];
            arr[10] = 50;  // ArrayIndexOutOfBoundsException
        } catch (ArrayIndexOutOfBoundsException | NullPointerException e) {
            System.out.println("Multi-catch: " + e.getClass().getSimpleName());
        }

        // Rethrowing with additional context
        try {
            parseInteger("not-a-number");
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid input provided", e);
        }
    }

    public static int divide(int a, int b) {
        return a / b;  // Throws ArithmeticException if b == 0
    }

    public static int parseInteger(String s) {
        return Integer.parseInt(s);
    }
}
```

Compile and run. **Expected output:**

```
Caught arithmetic error: / by zero
10 / 2 = 5
Array bounds error: Index 5 out of bounds for length 3
Null pointer: Cannot invoke "String.length()" because "text" is null
Catch: Index 5 out of bounds for length 3
Finally: index was 5
Multi-catch: ArrayIndexOutOfBoundsException
Exception in thread "main" java.lang.IllegalArgumentException: Invalid input provided
  (with cause showing NumberFormatException)
```

### Exercise 2: Checked Exceptions and Try-With-Resources

Create `src/Exercise2_TryWithResources.java`:

```java
import java.io.*;
import java.nio.file.*;

public class Exercise2_TryWithResources {
    public static void main(String[] args) {
        // Try-with-resources — automatically closes the resource
        // Traditional way (Java 6 and earlier): manual close in finally
        System.out.println("=== Traditional resource management ===");
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader("nonexistent.txt"));
            String line = reader.readLine();
            System.out.println("Line: " + line);
        } catch (IOException e) {
            System.out.println("IO error (traditional): " + e.getMessage());
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    System.out.println("Error closing reader: " + e.getMessage());
                }
            }
        }

        // Modern way (Java 7+) — try-with-resources
        System.out.println("\n=== Try-with-resources ===");
        try (BufferedReader reader2 = new BufferedReader(
                new FileReader("nonexistent.txt"))) {
            String line = reader2.readLine();
            System.out.println("Line: " + line);
        } catch (IOException e) {
            System.out.println("IO error (modern): " + e.getMessage());
        }

        // Multiple resources in one try-with-resources
        System.out.println("\n=== Multiple resources ===");
        // Create a temp file with some content
        Path tempFile = null;
        try {
            tempFile = Files.write(Files.createTempFile("sample", ".txt"),
                List.of("Line 1", "Line 2", "Line 3").toArray(new String[0]),
                StandardOpenOption.WRITE);

            try (var reader3 = Files.newBufferedReader(tempFile);
                 var writer = Files.newBufferedWriter(
                     Files.createTempFile("output", ".txt"))) {

                String line;
                while ((line = reader3.readLine()) != null) {
                    writer.write(line.toUpperCase());
                    writer.newLine();
                }
                System.out.println("Copied and transformed lines to output file");
            }

            // Read back and verify
            try (var verify = Files.newBufferedReader(tempFile)) {
                System.out.println("Original file content:");
                verify.lines().forEach(System.out::println);
            }

        } catch (IOException e) {
            System.out.println("IO error: " + e.getMessage());
        } finally {
            // Cleanup temp files
            try {
                if (tempFile != null) Files.deleteIfExists(tempFile);
            } catch (IOException ignored) {}
        }

        // Custom AutoCloseable resource
        System.out.println("\n=== Custom AutoCloseable ===");
        try (MyResource resource = new MyResource("DatabaseConnection")) {
            resource.doWork();
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }

        // Try-with-resources + catch + finally
        System.out.println("\n=== Try-with-resources with catch and finally ===");
        try (var r = new MyResource("FileHandler")) {
            r.doWork();
            throw new RuntimeException("Something went wrong!");
        } catch (RuntimeException e) {
            System.out.println("Caught: " + e.getMessage());
        } finally {
            System.out.println("Cleanup complete");
        }
    }

    // Custom resource that implements AutoCloseable
    static class MyResource implements AutoCloseable {
        private final String name;

        public MyResource(String name) {
            this.name = name;
            System.out.println("Opening: " + name);
        }

        public void doWork() {
            System.out.println(name + " is doing work");
        }

        @Override
        public void close() {
            System.out.println("Closing: " + name);
        }
    }
}
