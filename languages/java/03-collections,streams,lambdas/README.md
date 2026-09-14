# Project 03: Collections, Streams, and Lambdas — Java

**Difficulty:** intermediate  
**Prerequisites:** Project 02 (OOP and Generics)

## Goals

- Use Java's Collection Framework: List, Set, Map, Queue
- Write lambda expressions and use functional interfaces
- Master the Stream API: filter, map, reduce, collect
- Understand method references and comparator chaining
- Work with collectors: toList, toMap, groupingBy, partitioningBy

## Concepts

- **Collection Framework** — `List`, `Set`, `Map`, `Queue` interfaces and implementations
- **Lambda** — anonymous function: `(x, y) -> x + y`
- **Functional Interface** — interface with one abstract method: `Predicate<T>`, `Function<T,R>`, `Consumer<T>`, `Supplier<T>`, `UnaryOperator<T>`
- **Stream** — pipeline of operations: intermediate (lazy) + terminal (eager)
- **Method Reference** — `ClassName::methodName` shorthand for lambdas
- **Comparator** — functional interface for ordering; can be chained
- **Collectors** — `Collectors.toList()`, `toSet()`, `toMap()`, `groupingBy()`, `partitioningBy()`, `joining()`

## Exercises

### Exercise 1: Collections — List, Set, Map

Create `src/Exercise1_Collections.java`:

```java
import java.util.*;

public class Exercise1_Collections {
    public static void main(String[] args) {
        // ArrayList — ordered, allows duplicates, fast random access
        List<String> tasks = new ArrayList<>();
        tasks.add("read docs");
        tasks.add("write code");
        tasks.add("test");
        tasks.add("deploy");
        System.out.println("Initial tasks: " + tasks);

        // Add and remove
        tasks.add("review PR");
        tasks.remove(0);  // Remove by index
        System.out.println("After add/remove: " + tasks);

        // Collections utility methods
        Collections.sort(tasks);  // Alphabetical sort
        System.out.println("Sorted: " + tasks);

        Collections.reverse(tasks);
        System.out.println("Reversed: " + tasks);

        // Shuffle
        Collections.shuffle(tasks);
        System.out.println("Shuffled: " + tasks);

        // Set — no duplicates, no order (HashSet)
        Set<String> uniqueWords = new HashSet<>();
        uniqueWords.add("apple");
        uniqueWords.add("banana");
        uniqueWords.add("apple");  // Duplicate — ignored
        System.out.println("\nHashSet: " + uniqueWords);

        // TreeSet — sorted set
        Set<Integer> sortedNumbers = new TreeSet<>();
        sortedNumbers.addAll(Arrays.asList(5, 2, 8, 1, 9, 3));
        System.out.println("TreeSet (sorted): " + sortedNumbers);

        // Map — key-value pairs
        Map<String, Integer> ages = new HashMap<>();
        ages.put("Alice", 30);
        ages.put("Bob", 25);
        ages.put("Charlie", 35);
        System.out.println("\nAge map: " + ages);

        // Safe get with default
        int aliceAge = ages.getOrDefault("Alice", 0);
        int daveAge = ages.getOrDefault("Dave", 0);
        System.out.println("Alice age: " + aliceAge + ", Dave age: " + daveAge);

        // Put if absent
        ages.putIfAbsent("Bob", 99);  // Bob already exists — no change
        ages.putIfAbsent("Dave", 40);
        System.out.println("After putIfAbsent: " + ages);

        // Iterate over map entries
        System.out.println("\nMap entries:");
        for (Map.Entry<String, Integer> entry : ages.entrySet()) {
            System.out.printf("  %s: %d%n", entry.getKey(), entry.getValue());
        }

        // Compute — transform values
        Map<String, String> users = new HashMap<>();
        users.put("alice", "alice@example.com");
        users.compute("alice", (k, v) -> v != null ? v.toUpperCase() : "NEW");
        users.compute("bob", (k, v) -> v != null ? v.toUpperCase() : "NEW@EXAMPLE.COM");
        System.out.println("\nUsers after compute: " + users);

        // Merge — combine values
        Map<String, Integer> scores = new HashMap<>();
        scores.put("Alice", 100);
        scores.merge("Alice", 50, Integer::sum);  // Alice's score becomes 150
        scores.merge("Bob", 50, Integer::sum);    // Bob didn't exist — becomes 50
        System.out.println("Scores after merge: " + scores);
    }
}
```

Compile and run. **Expected output:**

```
Initial tasks: [read docs, write code, test, deploy]
After add/remove: [write code, test, deploy, review PR]
Sorted: [deploy, review PR, test, write code]
Reversed: [write code, test, review PR, deploy]
Shuffled: [test, deploy, write code, review PR]  // (varies)

HashSet: [apple, banana]  // (order may vary)

TreeSet (sorted): [1, 2, 3, 5, 8, 9]

Age map: {Alice=30, Bob=25, Charlie=35}
Alice age: 30, Dave age: 0

After putIfAbsent: {Alice=30, Bob=25, Charlie=35, Dave=40}

Map entries:
  Alice: 30
  Bob: 25
  Charlie: 35
  Dave: 40

Users after compute: {alice=ALICE@EXAMPLE.COM, bob=NEW@EXAMPLE.COM}

Scores after merge: {Alice=150, Bob=50}
```

### Exercise 2: Lambda Expressions and Functional Interfaces

Create `src/Exercise2_Lambdas.java`:

```java
import java.util.function.*;

public class Exercise2_Lambdas {
    public static void main(String[] args) {
        // Predicate<T> — boolean test
        Predicate<String> isLong = s -> s.length() > 5;
        System.out.println("isLong('hello'): " + isLong.test("hello"));   // false
        System.out.println("isLong('greetings'): " + isLong.test("greetings")); // true

        // Function<T, R> — transformation
        Function<String, Integer> strLength = String::length;
        System.out.println("Length of 'Java': " + strLength.apply("Java"));

        // Chain functions with andThen
        Function<String, String> toUpper = String::toUpperCase;
        Function<String, String> addExclaim = s -> s + "!!!";
        Function<String, String> pipeline = toUpper.andThen(addExclaim);
        System.out.println("Pipeline 'hello': " + pipeline.apply("hello"));

        // Consumer<T> — side effect, no return
        Consumer<String> printer = System.out::println;
        printer.accept("Hello from Consumer!");

        // Consumer chaining with andThen
        Consumer<String> log = s -> System.out.println("[LOG] " + s);
        Consumer<String> process = s -> System.out.println("[PROCESS] " + s);
        Consumer<String> combined = log.andThen(process);
        combined.accept("test message");

        // Supplier<T> — provides values
        Supplier<LocalDate> today = LocalDate::now;
        System.out.println("Today: " + today.get());

        Supplier<Random> randomSupplier = Random::new;
        Random random = randomSupplier.get();
        System.out.println("Random int: " + random.nextInt(100));

        // UnaryOperator<T> — same type in and out
        UnaryOperator<String> trimAndUpper = s -> s.trim().toUpperCase();
        System.out.println("Trim+Upper '  hello  ': " + trimAndUpper.apply("  hello  "));

        // BinaryOperator<T> — two inputs, same type output
        BinaryOperator<Integer> multiply = (a, b) -> a * b;
        System.out.println("6 * 7 = " + multiply.apply(6, 7));

        // Custom functional interface
        @FunctionalInterface
        interface MathOperation {
            int operate(int a, int b);
        }

        MathOperation add = (a, b) -> a + b;
        MathOperation subtract = (a, b) -> a - b;
        MathOperation multiplyOp = (a, b) -> a * b;

        System.out.println("\nCustom functional interface:");
        System.out.println("add(10, 5): " + add.operate(10, 5));
        System.out.println("subtract(10, 5): " + subtract.operate(10, 5));
        System.out.println("multiply(10, 5): " + multiplyOp.operate(10, 5));
    }
}
```

Compile and run. **Expected output:**

```
isLong('hello'): false
isLong('greetings'): true
Length of 'Java': 4
Pipeline 'hello': HELLO!!!
Hello from Consumer!
[LOG] test message
[PROCESS] test message
Today: 2026-09-14  // (today's date)
Random int: 42  // (varies)
Trim+Upper '  hello  ': HELLO
6 * 7 = 42

Custom functional interface:
add(10, 5): 15
subtract(10, 5): 5
multiply(10, 5): 50
```

### Exercise 3: Stream API — filter, map, reduce

Create `src/Exercise3_Streams.java`:

```java
import java.util.*;
import java.util.stream.*;

public class Exercise3_Streams {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        // filter — keep elements matching predicate
        List<Integer> evens = numbers.stream()
            .filter(n -> n % 2 == 0)
            .toList();
        System.out.println("Even numbers: " + evens);

        // map — transform each element
        List<Integer> doubled = numbers.stream()
            .map(n -> n * 2)
            .toList();
        System.out.println("Doubled: " + doubled);

        // filter + map combined
        List<String> result = numbers.stream()
            .filter(n -> n % 2 == 0)
            .map(n -> "Even: " + n)
            .toList();
        System.out.println("Filter+Map: " + result);

        // reduce — accumulate to single value
        int sum = numbers.stream()
            .reduce(0, Integer::sum);
        System.out.println("Sum: " + sum);  // 55

        int product = numbers.stream()
            .reduce(1, (a, b) -> a * b);
        System.out.println("Product: " + product);  // 3628800

        // reduce with identity and combiner (for parallel)
        String joined = numbers.stream()
            .map(String::valueOf)
            .reduce("", (a, b) -> a + b + ", ");
        System.out.println("Joined: " + joined);

        // sorted
        List<Integer> unsorted = List.of(5, 2, 8, 1, 9, 3);
        List<Integer> sorted = unsorted.stream()
            .sorted()
            .toList();
        System.out.println("Sorted: " + sorted);

        // distinct
        List<String> words = List.of("apple", "banana", "apple", "cherry", "banana");
        List<String> distinct = words.stream()
            .distinct()
            .toList();
        System.out.println("Distinct: " + distinct);

        // limit and skip
        List<Integer> limited = numbers.stream()
            .skip(3)     // skip first 3
            .limit(4)    // take next 4
            .toList();
        System.out.println("Skip 3, limit 4: " + limited);  // [4, 5, 6, 7]

        // anyMatch, allMatch, noneMatch
        boolean hasEven = numbers.stream().anyMatch(n -> n % 2 == 0);
        boolean allPositive = numbers.stream().allMatch(n -> n > 0);
        boolean noNegative = numbers.stream().noneMatch(n -> n < 0);
        System.out.println("Has even: " + hasEven);
        System.out.println("All positive: " + allPositive);
        System.out.println("No negative: " + noNegative);

        // findFirst, findAny
        Optional<Integer> firstEven = numbers.stream()
            .filter(n -> n % 2 == 0)
            .findFirst();
        System.out.println("First even: " + firstEven.orElse(-1));

        // count
        long evenCount = numbers.stream()
            .filter(n -> n % 2 == 0)
            .count();
        System.out.println("Even count: " + evenCount);  // 5
    }
}
```

Compile and run. **Expected output:**

```
Even numbers: [2, 4, 6, 8, 10]
Doubled: [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
Filter+Map: [Even: 2, Even: 4, Even: 6, Even: 8, Even: 10]
Sum: 55
Product: 3628800
Joined: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
Sorted: [1, 2, 3, 5, 8, 9]
Distinct: [apple, banana, cherry]
Skip 3, limit 4: [4, 5, 6, 7]
Has even: true
All positive: true
No negative: true
First even: 2
Even count: 5
```

### Exercise 4: Collectors and Real-World Stream Processing

Create `src/Exercise4_Collectors.java`:

```java
import java.util.*;
import java.util.stream.*;

public class Exercise4_Collectors {
    record Person(String name, int age, String city, double salary) {}

    public static void main(String[] args) {
        List<Person> people = List.of(
            new Person("Alice", 30, "NYC", 85000),
            new Person("Bob", 25, "LA", 65000),
            new Person("Charlie", 35, "NYC", 95000),
            new Person("Diana", 28, "SF", 75000),
            new Person("Eve", 32, "LA", 70000),
            new Person("Frank", 40, "NYC", 120000)
        );

        // toList — simple collection
        List<String> names = people.stream()
            .map(Person::name)
            .toList();
        System.out.println("All names: " + names);

        // toMap — collect into a map
        Map<String, Integer> nameToAge = people.stream()
            .collect(Collectors.toMap(Person::name, Person::age));
        System.out.println("Name to age: " + nameToAge);

        // groupingBy — group by a property
        Map<String, List<Person>> byCity = people.stream()
            .collect(Collectors.groupingBy(Person::city));
        System.out.println("\nPeople by city:");
        byCity.forEach((city, persons) -> {
            System.out.println("  " + city + ": " + persons.stream()
                .map(Person::name).collect(Collectors.joining(", ")));
        });

        // groupingBy with downstream collector
        Map<String, Long> countByCity = people.stream()
            .collect(Collectors.groupingBy(Person::city, Collectors.counting()));
        System.out.println("\nCount by city: " + countByCity);

        // averagingDouble
        Map<String, Double> avgSalaryByCity = people.stream()
            .collect(Collectors.groupingBy(Person::city,
                Collectors.averagingDouble(Person::salary)));
        System.out.println("Average salary by city: " + avgSalaryByCity);

        // partitioningBy — split into two groups
        Map<Boolean, List<Person>> byAgeThreshold = people.stream()
            .collect(Collectors.partitioningBy(p -> p.age() >= 30));
        System.out.println("\nAge >= 30: " + byAgeThreshold.get(true).stream()
            .map(Person::name).collect(Collectors.joining(", ")));
        System.out.println("Age < 30: " + byAgeThreshold.get(false).stream()
            .map(Person::name).collect(Collectors.joining(", ")));

        // joining — concatenate strings
        String nameList = people.stream()
            .map(Person::name)
            .collect(Collectors.joining(", ", "[", "]"));
        System.out.println("\nName list: " + nameList);

        // summarizingDouble — comprehensive stats
        DoubleSummaryStatistics salaryStats = people.stream()
            .collect(Collectors.summarizingDouble(Person::salary));
        System.out.println("\nSalary stats:");
        System.out.println("  Count: " + salaryStats.getCount());
        System.out.println("  Sum: " + salaryStats.getSum());
        System.out.println("  Min: " + salaryStats.getMin());
        System.out.println("  Max: " + salaryStats.getMax());
        System.out.println("  Average: " + String.format("%.2f", salaryStats.getAverage()));

        // FlatMap — one-to-many + flatten
        List<String> allCities = people.stream()
            .map(p -> List.of(p.city(), p.city() + "-area"))
            .flatMap(Collection::stream)
            .distinct()
            .toList();
        System.out.println("\nAll city references: " + allCities);
    }
}
