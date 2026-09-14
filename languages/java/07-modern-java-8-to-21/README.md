# Project 07: Modern Java 8 to 21 — Features Through the Versions

**Difficulty:** intermediate  
**Prerequisites:** Project 06 (Concurrency with Threads and Executors)

## Goals

- Understand the evolution of Java from version 8 to 21
- Use var for local variable type inference (Java 10)
- Use records for immutable data carriers (Java 14)
- Use sealed classes for restricted hierarchies (Java 17)
- Use pattern matching for instanceof and switch (Java 16, 21)
- Use text blocks for multi-line strings (Java 15)
- Use Optional improvements and Stream enhancements
- Use new Date/Time API features
- Use Sequenced Collections (Java 21)
- Understand Preview features: pattern matching for switch, virtual threads

## Concepts

- **Version timeline** — Java 8 (2014), 9 (modules), 10 (var), 11 (HTTP Client), 12-13 (switch expr), 14 (records), 15 (text blocks), 16 (pattern instanceof, sealed), 17 (sealed, LTS), 18-20 (preview features), 21 (pattern switch, virtual threads, sequenced collections, LTS)
- **var** — compiler infers type from initializer
- **Record** — immutable data carrier with auto-generated equals, hashCode, toString, accessor
- **Sealed class** — restricts which classes can extend/implement
- **Pattern matching** — type patterns in instanceof and switch cases
- **Text blocks** — """ multi-line strings with incidental whitespace removal
- **SequencedCollection** — ordered collection with addFirst/addLast, getFirst/getLast (Java 21)
- **Virtual threads** — lightweight threads (Project Loom, Java 21)
- **Switch expressions** — return value from switch, arrow syntax
- **Helpful NullPointerExceptions** — detailed NPE messages (Java 14)

## Exercises

### Exercise 1: Java 8-11 Essentials — Lambdas, Streams, Optional, var

Create `src/Exercise1_Java8To11.java`:

```java
import java.util.*;
import java.util.stream.*;
import java.time.*;
import java.time.format.*;

public class Exercise1_Java8To11 {
    public static void main(String[] args) {
        // Java 8: Lambda + Stream + Optional
        System.out.println("=== Java 8: Lambdas and Streams ===");
        List<String> words = List.of("apple", "banana", "cherry", "date", "elderberry");

        // Stream operations
        List<String> result = words.stream()
            .filter(w -> w.length() > 5)
            .map(String::toUpperCase)
            .sorted()
            .toList();

        System.out.println("Filtered, uppercased, sorted: " + result);

        // Optional
        Optional<String> found = words.stream()
            .filter(w -> w.startsWith("b"))
            .findFirst();

        System.out.println("Found 'b' word: " + found.orElse("not found"));
        System.out.println("If present: " + found.ifPresentOrElse(
            w -> System.out.println("  " + w),
            () -> System.out.println("  Not present")
        ));

        // Java 8: Date/Time API
        System.out.println("\n=== Java 8: Date/Time API ===");
        LocalDateTime now = LocalDateTime.now();
        System.out.println("Now: " + now);

        LocalDate birthday = LocalDate.of(1990, 6, 15);
        System.out.println("Birthday: " + birthday);

        Period age = Period.between(birthday, LocalDate.now());
        System.out.println("Age: " + age.getYears() + " years, " + age.getMonths() + " months");

        // Formatting
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formatted = now.format(formatter);
        System.out.println("Formatted: " + formatted);

        // Period and Duration
        Duration d = Duration.ofHours(2).plusMinutes(30);
        System.out.println("Duration: " + d.toMinutes() + " minutes");

        // Java 9: Collection factory methods
        System.out.println("\n=== Java 9: Factory methods ===");
        List<Integer> list = List.of(1, 2, 3, 4, 5);  // Immutable
        Set<String> set = Set.of("a", "b", "c");
        Map<String, Integer> map = Map.of("one", 1, "two", 2, "three", 3);

        System.out.println("List: " + list);
        System.out.println("Set: " + set);
        System.out.println("Map: " + map);

        // try-with-resources on effectively final variables (Java 9)
        System.out.println("\n=== Java 9: Effectively final in try-with-resources ===");
        InputStream baseStream = new ByteArrayInputStream("Hello World".getBytes());
        try (baseStream;  // Effectively final — no need for new variable
             BufferedReader reader = new BufferedReader(new InputStreamReader(baseStream))) {
            System.out.println("Read: " + reader.readLine());
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Java 10: var — local variable type inference
        System.out.println("\n=== Java 10: var ===");
        var name = "Java";
        var version = 17;
        var list2 = List.of(1, 2, 3);  // Inferred as List<Integer>

        System.out.println("var name: " + name + " (type: " + name.getClass().getSimpleName() + ")");
        System.out.println("var version: " + version + " (type: " + version.getClass().getSimpleName() + ")");
        System.out.println("var list: " + list2);

        // var cannot be used for fields, method parameters, or return types
        // var x;  // ERROR — no initializer
        // var y = null;  // ERROR — no type to infer

        // Java 11: Local variable syntax for lambda parameters
        System.out.println("\n=== Java 11: var in lambdas ===");
        Consumer<String> uppercase = (var s) -> System.out.println(s.toUpperCase());
        uppercase.accept("hello");  // HELLO

        // var can be used for all lambda parameters or none, but not mixed
        BiFunction<Integer, Integer, Integer> add = (var a, var b) -> a + b;
        System.out.println("add(5, 3) = " + add.apply(5, 3));

        // Java 11: String methods
        System.out.println("\n=== Java 11: String improvements ===");
        String str = "  Hello World  ";
        System.out.println("strip(): '" + str.strip() + "'");
        System.out.println("stripLeading(): '" + str.stripLeading() + "'");
        System.out.println("stripTrailing(): '" + str.stripTrailing() + "'");
        System.out.println("isBlank(): " + str.isBlank());
        System.out.println("lines(): " + str.lines().toList());
        System.out.println("repeat(3): " + "na".repeat(3) + " na");

        // Java 11: HTTP Client (basic example)
        System.out.println("\n=== Java 11: HTTP Client ===");
        // (Full example requires network access; showing API structure)
        // HttpClient client = HttpClient.newHttpClient();
        // HttpRequest request = HttpRequest.newBuilder()
        //     .uri(URI.create("https://example.com"))
        //     .GET()
        //     .build();
        // HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
        // System.out.println("Status: " + response.statusCode());

        // Java 11: Predicate.not — negation of predicate
        System.out.println("\n=== Java 11: Predicate.not ===");
        Predicate<String> isLong = s -> s.length() > 5;
        List<String> shortWords = words.stream()
            .filter(Predicate.not(isLong))
            .toList();
        System.out.println("Short words: " + shortWords);
    }
}
""")

write_file(os.path.join(p07, "src", "Exercise1_Java8To11.java"), """import java.util.*;
import java.util.stream.*;
import java.time.*;
import java.time.format.*;
import java.io.*;

public class Exercise1_Java8To11 {
    public static void main(String[] args) {
        System.out.println("=== Java 8: Lambdas and Streams ===");
        List<String> words = List.of("apple", "banana", "cherry", "date", "elderberry");

        List<String> result = words.stream()
            .filter(w -> w.length() > 5)
            .map(String::toUpperCase)
            .sorted()
            .toList();

        System.out.println("Filtered, uppercased, sorted: " + result);

        Optional<String> found = words.stream()
            .filter(w -> w.startsWith("b"))
            .findFirst();

        System.out.println("Found 'b' word: " + found.orElse("not found"));
        found.ifPresentOrElse(
            w -> System.out.println("  " + w),
            () -> System.out.println("  Not present")
        );

        System.out.println();
        System.out.println("=== Java 8: Date/Time API ===");
        LocalDateTime now = LocalDateTime.now();
        System.out.println("Now: " + now);

        LocalDate birthday = LocalDate.of(1990, 6, 15);
        System.out.println("Birthday: " + birthday);

        Period age = Period.between(birthday, LocalDate.now());
        System.out.println("Age: " + age.getYears() + " years, " + age.getMonths() + " months");

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formatted = now.format(formatter);
        System.out.println("Formatted: " + formatted);

        Duration d = Duration.ofHours(2).plusMinutes(30);
        System.out.println("Duration: " + d.toMinutes() + " minutes");

        System.out.println();
        System.out.println("=== Java 9: Factory methods ===");
        List<Integer> list = List.of(1, 2, 3, 4, 5);
        Set<String> set = Set.of("a", "b", "c");
        Map<String, Integer> map = Map.of("one", 1, "two", 2, "three", 3);

        System.out.println("List: " + list);
        System.out.println("Set: " + set);
        System.out.println("Map: " + map);

        System.out.println();
        System.out.println("=== Java 9: Effectively final in try-with-resources ===");
        InputStream baseStream = new ByteArrayInputStream("Hello World".getBytes());
        try (baseStream;
             BufferedReader reader = new BufferedReader(new InputStreamReader(baseStream))) {
            System.out.println("Read: " + reader.readLine());
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println();
        System.out.println("=== Java 10: var ===");
        var name = "Java";
        var version = 17;
        var list2 = List.of(1, 2, 3);

        System.out.println("var name: " + name + " (type: " + name.getClass().getSimpleName() + ")");
        System.out.println("var version: " + version + " (type: " + version.getClass().getSimpleName() + ")");
        System.out.println("var list: " + list2);

        System.out.println();
        System.out.println("=== Java 11: var in lambdas ===");
        Consumer<String> uppercase = (var s) -> System.out.println(s.toUpperCase());
        uppercase.accept("hello");

        BiFunction<Integer, Integer, Integer> add = (var a, var b) -> a + b;
        System.out.println("add(5, 3) = " + add.apply(5, 3));

        System.out.println();
        System.out.println("=== Java 11: String improvements ===");
        String str = "  Hello World  ";
        System.out.println("strip(): '" + str.strip() + "'");
        System.out.println("stripLeading(): '" + str.stripLeading() + "'");
        System.out.println("stripTrailing(): '" + str.stripTrailing() + "'");
        System.out.println("isBlank(): " + str.isBlank());
        System.out.println("lines(): " + str.lines().toList());
        System.out.println("repeat(3): " + "na".repeat(3) + " na");

        System.out.println();
        System.out.println("=== Java 11: Predicate.not ===");
        Predicate<String> isLong = s -> s.length() > 5;
        List<String> shortWords = words.stream()
            .filter(Predicate.not(isLong))
            .toList();
        System.out.println("Short words: " + shortWords);
    }
}
""")

write_file(os.path.join(p07, "src", "Exercise2_RecordsAndSealed.java"), """import java.util.*;

// Sealed class restricts which classes can extend it
sealed class Shape permits Circle, Rectangle, Square {
    // Abstract method — must be implemented by subclasses
    public abstract double area();
    public abstract double perimeter();
}

// Final subclass — cannot be extended further
final class Circle extends Shape {
    private final double radius;

    public Circle(double radius) {
        this.radius = radius;
    }

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }

    @Override
    public double perimeter() {
        return 2 * Math.PI * radius;
    }

    @Override
    public String toString() {
        return "Circle(radius=" + radius + ")";
    }
}

// Non-sealed — allows further extension
non-sealed class Rectangle extends Shape {
    private final double width;
    private final double height;

    public Rectangle(double width, double height) {
        this.width = width;
        this.height = height;
    }

    @Override
    public double area() {
        return width * height;
    }

    @Override
    public double perimeter() {
        return 2 * (width + height);
    }

    @Override
    public String toString() {
        return "Rectangle(width=" + width + ", height=" + height + ")";
    }
}

// Final subclass of non-sealed Rectangle
final class Square extends Rectangle {
    public Square(double side) {
        super(side, side);
    }

    @Override
    public String toString() {
        return "Square(side=" + getWidth() + ")";  // Access parent's width
    }
}

// Record — immutable data carrier (Java 14+)
record Point(int x, int y) {
    // Compact constructor — validates fields
    public Point {
        if (x < 0 || y < 0) {
            throw new IllegalArgumentException("Coordinates must be non-negative");
        }
    }

    // Custom method
    public double distanceFromOrigin() {
        return Math.sqrt(x * x + y * y);
    }

    // Override accessor if needed
    public int x() {
        System.out.println("Accessing x");
        return x;
    }
}

// Record with custom methods
record Person(String name, int age) {
    public Person {
        if (age < 0 || age > 150) {
            throw new IllegalArgumentException("Invalid age: " + age);
        }
    }

    public boolean isAdult() {
        return age >= 18;
    }

    public Person withAge(int newAge) {
        return new Person(name, newAge);
    }
}

public class Exercise2_RecordsAndSealed {
    public static void main(String[] args) {
        // Records
        System.out.println("=== Records ===");
        Point p1 = new Point(3, 4);
        Point p2 = new Point(6, 8);

        System.out.println("Point 1: " + p1);
        System.out.println("Point 2: " + p2);
        System.out.println("p1.x = " + p1.x());
        System.out.println("p1.y = " + p1.y());
        System.out.println("p1 == p2? " + p1.equals(p2));  // equals checks all components
        System.out.println("p1.hashCode() == p2.hashCode()? " + (p1.hashCode() == p2.hashCode()));
        System.out.println("Distance from origin: " + p1.distanceFromOrigin());

        // Record with validation
        System.out.println("\n=== Record validation ===");
        try {
            Person bad = new Person("Test", -1);
        } catch (IllegalArgumentException e) {
            System.out.println("Caught: " + e.getMessage());
        }

        Person alice = new Person("Alice", 30);
        System.out.println("Alice: " + alice);
        System.out.println("Alice is adult? " + alice.isAdult());
        System.out.println("Alice with age 25: " + alice.withAge(25));

        // Records in collections
        System.out.println("\n=== Records in collections ===");
        List<Person> people = List.of(
            new Person("Alice", 30),
            new Person("Bob", 25),
            new Person("Charlie", 35)
        );

        List<String> names = people.stream()
            .map(Person::name)
            .toList();
        System.out.println("Names: " + names);

        Optional<Person> oldest = people.stream()
            .max(Comparator.comparingInt(Person::age));
        oldest.ifPresent(p -> System.out.println("Oldest: " + p));

        // Sealed classes
        System.out.println("\n=== Sealed classes ===");
        List<Shape> shapes = List.of(
            new Circle(5.0),
            new Rectangle(4.0, 6.0),
            new Square(3.0)
        );

        for (Shape shape : shapes) {
            System.out.println(shape + " — area: " + String.format("%.2f", shape.area()) +
                ", perimeter: " + String.format("%.2f", shape.perimeter()));
        }

        // Pattern matching with sealed classes
        System.out.println("\n=== Pattern matching for switch (sealed) ===");
        for (Shape shape : shapes) {
            String description = describeShape(shape);
            System.out.println(description);
        }

        // Serialization of records
        System.out.println("\n=== Record serialization ===");
        // Records are serializable by default
        // (Full example requires implementing Serializable)
    }

    // Pattern matching switch with sealed class
    static String describeShape(Shape shape) {
        return switch (shape) {
            case Circle c -> "A circle with radius " + c.radius();
            case Rectangle r -> "A rectangle " + r.width() + "x" + r.height();
            case Square s -> "A square with side " + s.getWidth();
            // No default needed — sealed exhaustiveness
        };
    }
}
""")

write_file(os.path.join(p07, "src", "Exercise3_PatternMatching.java"), """import java.util.*;

public class Exercise3_PatternMatching {
    // Pattern matching for instanceof (Java 16+)
    public static void main(String[] args) {
        System.out.println("=== Pattern matching for instanceof ===");
        Object[] objects = {
            "Hello",
            42,
            new ArrayList<String>(List.of("a", "b", "c")),
            3.14,
            null,
            new int[]{1, 2, 3}
        };

        for (Object obj : objects) {
            // Old way (pre-Java 16)
            if (obj instanceof String) {
                String s = (String) obj;  // Cast required
                System.out.println("String (old): " + s.toUpperCase());
            }

            // New way (Java 16+) — pattern variable
            if (obj instanceof String s) {
                System.out.println("String (new): " + s.toUpperCase());
            }

            // Pattern variable is scoped to the if block
            if (obj instanceof Integer i) {
                System.out.println("Integer: " + i + ", doubled: " + (i * 2));
            }

            if (obj instanceof List<?> list) {
                System.out.println("List with " + list.size() + " elements: " + list);
            }

            if (obj instanceof Double d) {
                System.out.println("Double: " + d + ", ceiling: " + Math.ceil(d));
            }
        }

        // Pattern matching in switch (Java 21+)
        System.out.println("\n=== Pattern matching in switch (Java 21) ===");
        Object[] items = {
            "text",
            100,
            List.of(1, 2),
            Map.of("key", "value"),
            new ArrayList<>(),
            null
        };

        for (Object item : items) {
            String result = switch (item) {
                case String s when s.length() > 5 ->
                    "Long string: " + s;
                case String s ->
                    "Short string: " + s;
                case Integer i when i > 50 ->
                    "Big number: " + i;
                case Integer i ->
                    "Small number: " + i;
                case List<?> list when !list.isEmpty() ->
                    "Non-empty list: " + list;
                case List<?> list ->
                    "Empty list";
                case Map<?, ?> map ->
                    "Map with " + map.size() + " entries";
                case null ->
                    "Null value";
                case int[] arr ->
                    "Array of length " + arr.length;
                default ->
                    "Unknown type: " + item.getClass().getSimpleName();
            };
            System.out.println("  " + result);
        }

        // Guarded patterns (when clause)
        System.out.println("\n=== Guarded patterns (when) ===");
        Object[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, -1, 0};

        for (Object num : numbers) {
            String category = switch (num) {
                case Integer i when i > 0 && i % 2 == 0 -> "Positive even";
                case Integer i when i > 0 && i % 2 != 0 -> "Positive odd";
                case Integer i when i < 0 -> "Negative";
                case Integer i when i == 0 -> "Zero";
                default -> "Not an integer: " + num;
            };
            System.out.println("  " + num + " -> " + category);
        }

        // Pattern matching with records
        System.out.println("\n=== Pattern matching with records ===");
        record Employee(String name, int department, double salary) {}

        Employee[] employees = {
            new Employee("Alice", 1, 75000),
            new Employee("Bob", 2, 55000),
            new Employee("Charlie", 1, 95000),
            new Employee("Diana", 3, 80000)
        };

        for (Employee emp : employees) {
            String info = switch (emp) {
                case Employee(String name, int dept, double sal)
                    when sal >= 80000 ->
                    String.format("%s (dept %d) is a senior: $%.0f", name, dept, sal);
                case Employee(String name, int dept, double sal)
                    when dept == 1 ->
                    String.format("%s works in dept 1: $%.0f", name, sal);
                case Employee(String name, int dept, double sal) ->
                    String.format("%s (dept %d): $%.0f", name, dept, sal);
            };
            System.out.println("  " + info);
        }

        // Nested pattern matching
        System.out.println("\n=== Nested patterns ===");
        record Box(Object content) {}
        record Wrapper(Object item) {}

        Box box = new Box(new Wrapper("Hello, World!"));

        String result = switch (box) {
            case Box(Wrapper(Object value)) -> "Wrapped value: " + value;
            case Box(Object obj) -> "Box with: " + obj;
        };
        System.out.println("  " + result);
    }
}
""")

write_file(os.path.join(p07, "src", "Exercise4_TextBlocksAndSwitchExpr.java"), """import java.util.*;

public class Exercise4_TextBlocksAndSwitchExpr {
    public static void main(String[] args) {
        // Text blocks (Java 15+)
        System.out.println("=== Text blocks ===");
        String html = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>Example</title>
            </head>
            <body>
                <h1>Hello, World!</h1>
                <p>This is a text block.</p>
            </body>
            </html>
            """;

        System.out.println("HTML:");
        System.out.println(html);

        // Text block with variable interpolation
        String name = "Alice";
        int age = 30;
        String json = """
            {
                "name": "%s",
                "age": %d,
                "active": true
            }
            """.formatted(name, age);

        System.out.println("JSON:");
        System.out.println(json);

        // Text block with escaping
        String quote = """
            She said: "Hello, world!"
            The path is C:\\Users\\Alice
            """;
        System.out.println("Quoted:");
        System.out.println(quote);

        // Text block — incidental whitespace removal
        // The leftmost non-blank line determines the incidental whitespace baseline
        String indented = """
            |Line 1
            |    Line 2 with indent
            |Line 3
            """.replace("|", "");  // | is just for visualization

        System.out.println("Indented text block:");
        System.out.println(indented);

        // Switch expression (Java 14+)
        System.out.println("\n=== Switch expression (Java 14+) ===");
        DayOfWeek day = DayOfWeek.WEDNESDAY;

        // Arrow syntax — no fall-through
        String dayType = switch (day) {
            case MONDAY, FRIDAY -> "Start/End of work week";
            case SATURDAY, SUNDAY -> "Weekend";
            case TUESDAY, WEDNESDAY, THURSDAY -> "Midweek";
        };

        System.out.println(day + " is: " + dayType);

        // Switch with yield (traditional blocks returning values)
        int dayNumber = switch (day) {
            case MONDAY -> {
                System.out.println("Monday");
                yield 1;
            }
            case TUESDAY -> 2;
            case WEDNESDAY -> 3;
            case THURSDAY -> 4;
            case FRIDAY -> 5;
            case SATURDAY -> 6;
            case SUNDAY -> 7;
        };

        System.out.println("Day number: " + dayNumber);

        // Switch on strings
        System.out.println("\n=== Switch on strings ===");
        String command = "START";

        int result = switch (command) {
            case "START" -> 1;
            case "STOP" -> 0;
            case "PAUSE" -> -1;
            case "RESUME" -> 2;
            default -> throw new IllegalArgumentException("Unknown command: " + command);
        };

        System.out.println("Command result: " + result);

        // Switch expression with enum
        System.out.println("\n=== Switch expression with enum ===");
        enum Status { PENDING, APPROVED, REJECTED, DELETED }

        Status status = Status.APPROVED;

        boolean canAct = switch (status) {
            case PENDING -> false;
            case APPROVED -> true;
            case REJECTED, DELETED -> false;
        };

        System.out.println("Can act: " + canAct);

        // Traditional switch with fall-through (still valid)
        System.out.println("\n=== Traditional switch (fall-through) ===");
        int score = 85;

        char grade;
        switch (score / 10) {
            case 10:
            case 9:
                grade = 'A';
                break;
            case 8:
                grade = 'B';
                break;
            case 7:
                grade = 'C';
                break;
            case 6:
                grade = 'D';
                break;
            default:
                grade = 'F';
                break;
        }

        System.out.println("Score " + score + " -> Grade " + grade);

        // Switch expression with multiple conditions
        System.out.println("\n=== Switch with multiple matching values ===");
        String input = "apple";

        String category = switch (input) {
            case "apple", "banana", "cherry" -> "fruit";
            case "carrot", "potato", "broccoli" -> "vegetable";
            case "chicken", "beef", "fish" -> "protein";
            default -> "unknown";
        };

        System.out.println("'" + input + "' is a: " + category);
    }
}
""")

write_file(os.path.join(p07, "src", "Exercise5_SequencedCollectionsAndModernFeatures.java"), """import java.util.*;
import java.util.stream.*;
import java.time.*;
import java.time.chrono.*;
import java.util.spi.*;

public class Exercise5_SequencedCollectionsAndModernFeatures {
    public static void main(String[] args) {
        // Sequenced Collections (Java 21)
        System.out.println("=== Sequenced Collections (Java 21) ===");

        // SequencedSet — LinkedHashSet is sequenced
        SequencedSet<String> sequencedSet = new LinkedHashSet<>();
        sequencedSet.add("first");
        sequencedSet.add("second");
        sequencedSet.add("third");

        System.out.println("SequencedSet first: " + sequencedSet.getFirst());
        System.out.println("SequencedSet last: " + sequencedSet.getLast());
        System.out.println("Reversed: " + sequencedSet.reversed());

        // SequencedMap — LinkedHashMap is sequenced
        SequencedMap<String, Integer> sequencedMap = new LinkedHashMap<>();
        sequencedMap.put("a", 1);
        sequencedMap.put("b", 2);
        sequencedMap.put("c", 3);

        System.out.println("SequencedMap first entry: " + sequencedMap.firstEntry());
        System.out.println("SequencedMap last entry: " + sequencedMap.lastEntry());
        System.out.println("Reversed: " + sequencedMap.reversed());

        // List is already sequenced
        List<String> list = new ArrayList<>(List.of("one", "two", "three"));
        System.out.println("List first: " + list.getFirst());
        System.out.println("List last: " + list.getLast());
        list.addFirst("zero");
        list.addLast("four");
        System.out.println("After addFirst/addLast: " + list);

        // Collectors.toCollection with SequencedSet
        List<String> words = List.of("banana", "apple", "cherry", "apple", "banana");
        SequencedSet<String> unique = words.stream()
            .collect(Collectors.toCollection(LinkedHashSet::new));
        System.out.println("Unique in order: " + unique);

        // Collection.reversed() on various types
        System.out.println("\n=== reversed() on collections ===");
        List<Integer> nums = new ArrayList<>(List.of(1, 2, 3, 4, 5));
        System.out.println("Original list: " + nums);
        System.out.println("Reversed list: " + nums.reversed());

        Set<Integer> numSet = new LinkedHashSet<>(Set.of(5, 2, 8, 1, 9));
        System.out.println("Original set: " + numSet);
        System.out.println("Reversed set: " + numSet.reversed());

        // New stream features
        System.out.println("\n=== Stream enhancements ===");

        // Stream.toList() (Java 16) — convenience method
        List<Integer> doubled = nums.stream()
            .map(n -> n * 2)
            .toList();
        System.out.println("Doubled: " + doubled);

        // Map.stream() (Java 8+)
        Map<String, Integer> map = Map.of("a", 1, "b", 2, "c", 3);
        map.entrySet().stream()
            .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
            .forEach(entry -> System.out.println("  " + entry.getKey() + ": " + entry.getValue()));

        // Stream.flatMap with Optional (Java 8+)
        List<Optional<String>> optionals = List.of(
            Optional.of("hello"),
            Optional.empty(),
            Optional.of("world")
        );

        List<String> presentValues = optionals.stream()
            .flatMap(Optional::stream)
            .toList();
        System.out.println("Present values: " + presentValues);

        // Date/Time enhancements (Java 8+)
        System.out.println("\n=== Date/Time enhancements ===");

        // LocalDate.plusWeeks, minusMonths, etc.
        LocalDate today = LocalDate.now();
        LocalDate nextWeek = today.plusWeeks(1);
        LocalDate lastMonth = today.minusMonths(1);
        System.out.println("Today: " + today);
        System.out.println("Next week: " + nextWeek);
        System.out.println("Last month: " + lastMonth);

        // ZonedDateTime with time zone
        ZonedDateTime nyTime = ZonedDateTime.now(ZoneId.of("America/New_York"));
        ZonedDateTime tokyoTime = ZonedDateTime.now(ZoneId.of("Asia/Tokyo"));
        System.out.println("NY time: " + nyTime);
        System.out.println("Tokyo time: " + tokyoTime);

        // Period and Duration between
        LocalDate start = LocalDate.of(2024, 1, 1);
        LocalDate end = LocalDate.of(2024, 12, 31);
        Period period = Period.between(start, end);
        System.out.println("Period between: " + period.getYears() + "y " +
            period.getMonths() + "m " + period.getDays() + "d");

        // ChronoUnit
        long daysBetween = ChronoUnit.DAYS.between(start, end);
        System.out.println("Days between: " + daysBetween);

        // New Math methods
        System.out.println("\n=== Math enhancements ===");
        System.out.println("Math.clamp(5, 1, 10): " + Math.clamp(5, 1, 10));
        System.out.println("Math.clamp(0, 1, 10): " + Math.clamp(0, 1, 10));
        System.out.println("Math.clamp(15, 1, 10): " + Math.clamp(15, 1, 10));

        // Integer/decimal formatting
        System.out.println("String.formatted: " + "%s %d".formatted("Value", 42));

        // Multi-line strings with .formatted (Java 15+)
        String template = """
            Name: %s
            Age: %d
            Active: %b
            """.formatted("Alice", 30, true);
        System.out.println(template);
    }
}
""")

write_file(os.path.join(p07, "build.gradle"), """plugins {
    id 'java'
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

repositories {
    mavenCentral()
}

dependencies {
    // No external dependencies
}

tasks.withType(JavaCompile) {
    options.encoding = 'UTF-8'
}
""")

print("Project 07 done")
