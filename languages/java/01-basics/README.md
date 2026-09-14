# Project 01: Basics — Java

**Difficulty:** beginner  
**Prerequisites:** Project 00 (Tooling Check)

## Goals

- Understand Java's basic syntax: variables, types, control flow, methods
- Write and run simple Java programs
- Learn the difference between primitive and reference types
- Practice String manipulation and StringBuilder

## Concepts

- **Variables** — `int`, `double`, `boolean`, `String`, `var` (Java 10+)
- **Type system** — primitives (int, double, boolean) vs reference types (String, objects)
- **Control flow** — `if-else`, `switch`, `for`, `while`, enhanced `for` (for-each)
- **Methods** — parameters, return types, method overloading
- **String** — immutable, use `StringBuilder` for efficient concatenation
- **Array** — fixed-size, zero-based indexing

## Exercises

### Exercise 1: Variables and Types

Create `src/Exercise1_Variables.java`:

```java
public class Exercise1_Variables {
    public static void main(String[] args) {
        // Primitive types
        int year = 1995;           // Java's first release
        double version = 17.0;     // Java 17 LTS
        boolean is LTS = true;

        // Reference type
        String name = "Java";

        // var (Java 10+) — type inferred from initializer
        var message = name + " was released in " + year;

        // Print with formatted output
        System.out.printf("%s released in %d (version %.1f)%n", name, year, version);
        System.out.println(message);
        System.out.println("Is LTS: " + isLTS);

        // Type conversion
        int codePoint = 65;
        char letter = (char) codePoint;  // explicit cast
        System.out.println("Char from code point: " + letter);

        // Numeric types
        byte small = 127;       // 8-bit signed
        short medium = 32767;   // 16-bit signed
        long big = 9_223_372_036_854_775_807L;  // 64-bit, underscore for readability
        System.out.println("Big number: " + big);
    }
}
```

Compile and run:

```bash
javac src/Exercise1_Variables.java -d out
java -cp out Exercise1_Variables
```

**Expected output:**

```
Java released in 1995 (version 17.0)
Java was released in 1995
Is LTS: true
Char from code point: A
Big number: 9223372036854775807
```

### Exercise 2: Control Flow

Create `src/Exercise2_ControlFlow.java`:

```java
public class Exercise2_ControlFlow {
    public static void main(String[] args) {
        int score = 87;

        // if-else (classic statement, not expression)
        String grade;
        if (score >= 90) {
            grade = "A";
        } else if (score >= 80) {
            grade = "B";
        } else {
            grade = "C";
        }
        System.out.println("Score: " + score + " -> Grade: " + grade);

        // switch (traditional)
        int day = 3;
        String dayName;
        switch (day) {
            case 1: dayName = "Monday"; break;
            case 2: dayName = "Tuesday"; break;
            case 3: dayName = "Wednesday"; break;
            case 4: dayName = "Thursday"; break;
            case 5: dayName = "Friday"; break;
            case 6:
            case 7: dayName = "Weekend"; break;
            default: dayName = "Unknown";
        }
        System.out.println("Day " + day + " is " + dayName);

        // Enhanced switch (Java 14+) — returns a value
        String season = switch (month(7)) {
            case 12, 1, 2 -> "Winter";
            case 3, 4, 5  -> "Spring";
            case 6, 7, 8  -> "Summer";
            case 9, 10, 11 -> "Fall";
            default -> "Unknown";
        };
        System.out.println("Month 7 is in: " + season);

        // for loop (classic)
        System.out.print("Counting 1 to 5: ");
        for (int i = 1; i <= 5; i++) {
            System.out.print(i + " ");
        }
        System.out.println();

        // for-each loop
        String[] fruits = {"apple", "banana", "cherry"};
        System.out.print("Fruits: ");
        for (String fruit : fruits) {
            System.out.print(fruit + " ");
        }
        System.out.println();

        // while loop
        int countdown = 5;
        while (countdown > 0) {
            System.out.print(countdown + "...");
            countdown--;
        }
        System.out.println("Go!");
    }

    private static int month(int m) { return m; }
}
```

Compile and run. **Expected output:**

```
Score: 87 -> Grade: B
Day 3 is Wednesday
Month 7 is in: Summer
Counting 1 to 5: 1 2 3 4 5 
Fruits: apple banana cherry 
5...4...3...2...1...Go!
```

### Exercise 3: Methods and Overloading

Create `src/Exercise3_Methods.java`:

```java
public class Exercise3_Methods {
    public static void main(String[] args) {
        // Basic method call
        int sum = add(3, 5);
        System.out.println("3 + 5 = " + sum);

        // Method overloading — same name, different parameters
        double sumD = add(3.5, 5.2);
        System.out.println("3.5 + 5.2 = " + sumD);

        // Method with multiple returns via array/object
        int[] minMax = minMax(new int[]{3, 7, 2, 9, 1});
        System.out.println("Min: " + minMax[0] + ", Max: " + minMax[1]);

        // Pass-by-value demonstration
        int x = 10;
        modifyPrimitive(x);
        System.out.println("After modifyPrimitive: " + x);  // Still 10!

        MyClass obj = new MyClass(10);
        modifyObject(obj);
        System.out.println("After modifyObject: " + obj.value);  // Changed to 20
    }

    // Method overloading: int version
    public static int add(int a, int b) {
        return a + b;
    }

    // Method overloading: double version
    public static double add(double a, double b) {
        return a + b;
    }

    // Returns min and max via array
    public static int[] minMax(int[] numbers) {
        int min = numbers[0];
        int max = numbers[0];
        for (int n : numbers) {
            if (n < min) min = n;
            if (n > max) max = n;
        }
        return new int[]{min, max};
    }

    // Java is pass-by-value: primitives are copied
    public static void modifyPrimitive(int value) {
        value = 99;  // Only modifies the local copy
    }

    // But object references are passed by value — the reference copy still points to same object
    public static void modifyObject(MyClass obj) {
        obj.value = 20;  // Modifies the object's field
    }

    static class MyClass {
        int value;
        MyClass(int v) { this.value = v; }
    }
}
```

Compile and run. **Expected output:**

```
3 + 5 = 8
3.5 + 5.2 = 8.7
Min: 1, Max: 9
After modifyPrimitive: 10
After modifyObject: 20
```

### Exercise 4: String and StringBuilder

Create `src/Exercise4_String.java`:

```java
public class Exercise4_String {
    public static void main(String[] args) {
        // String is immutable — every operation creates a new String
        String greet = "Hello";
        String name = "Alice";
        String message = greet + ", " + name + "!";  // Creates new String
        System.out.println(message);

        // String methods
        String text = "  Java Programming  ";
        System.out.println("Trimmed: '" + text.trim() + "'");
        System.out.println("Upper: " + text.toUpperCase());
        System.out.println("Contains 'Java': " + text.contains("Java"));
        System.out.println("Substring (5,10): " + text.substring(5, 10));
        System.out.println("Replace 'Java' with 'Kotlin': " + text.replace("Java", "Kotlin"));
        System.out.println("Split by space: " + String.join(", ", text.trim().split("\\s+")));

        // StringBuilder for efficient concatenation (mutable)
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= 1000; i++) {
            sb.append(i).append(", ");
        }
        String result = sb.toString();
        System.out.println("First 50 chars of concatenated: " + result.substring(0, 50) + "...");

        // String formatting
        String formatted = String.format("Pi is approximately %.5f", Math.PI);
        System.out.println(formatted);

        // String comparison — use .equals(), NOT ==
        String a = new String("hello");
        String b = new String("hello");
        System.out.println("a == b: " + (a == b));           // false — different references
        System.out.println("a.equals(b): " + a.equals(b));   // true — same content
    }
}
```

Compile and run. **Expected output:**

```
Hello, Alice!
Trimmed: 'Java Programming'
Upper:   JAVA PROGRAMMING  
Contains 'Java': true
Substring (5,10): Progr
Replace 'Java' with 'Kotlin':   Kotlin Programming  
Split by space: Java, Programming
First 50 chars of concatenated: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, ...
Pi is approximately 3.14159
a == b: false
a.equals(b): true
```

### Exercise 5: Arrays and ArrayList

Create `src/Exercise5_Arrays.java`:

```java
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Exercise5_Arrays {
    public static void main(String[] args) {
        // Fixed-size array
        int[] numbers = new int[]{5, 2, 8, 1, 9, 3};
        System.out.println("First element: " + numbers[0]);
        System.out.println("Array length: " + numbers.length);

        // Modify array element
        numbers[0] = 10;
        System.out.println("After modification: " + Arrays.toString(numbers));

        // Dynamic array with ArrayList
        List<String> tasks = new ArrayList<>();
        tasks.add("read docs");
        tasks.add("write code");
        tasks.add("test");
        tasks.add("deploy");
        System.out.println("Initial tasks: " + tasks);

        tasks.add("review PR");
        tasks.remove(0);  // Remove first element (index-based)
        System.out.println("After remove first and add: " + tasks);

        // For-each over ArrayList
        System.out.print("Uppercase tasks: ");
        for (String task : tasks) {
            System.out.print(task.toUpperCase() + " ");
        }
        System.out.println();

        // Converting array to List
        String[] fruits = {"apple", "banana", "cherry"};
        List<String> fruitList = Arrays.asList(fruits);
        System.out.println("As list: " + fruitList);

        // Note: Arrays.asList returns a fixed-size list — add/remove will throw
        // Use new ArrayList<>(Arrays.asList(...)) for a mutable copy
    }
}
```

Compile and run. **Expected output:**

```
First element: 5
Array length: 6
After modification: [10, 2, 8, 1, 9, 3]
Initial tasks: [read docs, write code, test, deploy]
After remove first and add: [write code, test, deploy, review PR]
Uppercase tasks: WRITE CODE TEST DEPLOY REVIEW PR 
As list: [apple, banana, cherry]
```

## Completion Checklist

- [ ] You understand primitive types (int, double, boolean, char, byte, short, long)
- [ ] You understand reference types (String, objects, arrays)
- [ ] You can write `if-else` and `switch` statements
- [ ] You can use classic `for`, enhanced `for` (for-each), and `while` loops
- [ ] You understand method overloading
- [ ] You know Java is pass-by-value (primitives get copied, object references are copied but point to same object)
- [ ] You understand String immutability and use `StringBuilder` for efficient concatenation
- [ ] You know to use `.equals()` for String comparison, not `==`
- [ ] You can work with arrays and `ArrayList`

## Hints

- Read the official Java Tutorial: https://docs.oracle.com/javase/tutorial/
- `var` was introduced in Java 10 — use it when the type is obvious from the initializer
- The enhanced switch (arrow syntax) was finalized in Java 14 — use it for cleaner code
- String concatenation in a loop creates many temporary objects — prefer `StringBuilder`
- `==` compares references for objects; use `.equals()` to compare content
- `Arrays.toString()` is great for debugging array contents
- `ArrayList` is the go-to dynamic collection — prefer over raw arrays for most use cases
