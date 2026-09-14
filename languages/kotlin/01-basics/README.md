# Project 01: Basics — Kotlin

**Difficulty:** beginner  
**Prerequisites:** Project 00 (Tooling Check)

## Goals

- Understand Kotlin's basic syntax: variables, types, control flow, functions
- Write and run simple Kotlin programs
- Compare Kotlin syntax with Java (if you know it)

## Concepts

- **`val` vs `var`** — immutable vs mutable variables
- **Type inference** — Kotlin figures out types from context
- **String templates** — string interpolation with `$variable` and `${expression}`
- **When expressions** — Kotlin's enhanced `switch`
- **Functions** — single-expression functions, default parameters

## Exercises

### Exercise 1: Variables and Types

Create `src/main.kt`:

```kotlin
fun main() {
    // Immutable variable (cannot be reassigned)
    val name: String = "Kotlin"
    val year: Int = 2011  // First Kotlin release
    
    // Mutable variable (can be reassigned)
    var version: Double = 1.9
    version = 1.9.22  // Reassigning
    
    // Type inference — Kotlin figures out the type
    val message = "Learning " + name  // inferred as String
    
    println("$name was released in $year (version $version)")
    println(message)
}
```

Compile: `kotlinc src/main.kt -include-runtime -d out.jar && java -jar out.jar`

**Expected output:**
```
Kotlin was released in 2011 (version 1.9.22)
Learning Kotlin
```

**Note:** The `Double` assignment to `1.9.22` will fail — that's a compile error. Fix it to `version = 1.9` before compiling. This teaches you that Kotlin is strict about types.

### Exercise 2: Control Flow

Create `src/control_flow.kt`:

```kotlin
fun main() {
    val score = 87
    
    // if-else as an expression (returns a value!)
    val grade = if (score >= 90) "A" else if (score >= 80) "B" else "C"
    println("Score: $score → Grade: $grade")
    
    // when expression (like switch, but better)
    val day = 3
    val dayName = when (day) {
        1 -> "Monday"
        2 -> "Tuesday"
        3 -> "Wednesday"
        4 -> "Thursday"
        5 -> "Friday"
        6, 7 -> "Weekend"
        else -> "Unknown"
    }
    println("Day $day is $dayName")
    
    // for loop with ranges
    print("Counting 1 to 5: ")
    for (i in 1..5) {
        print("$i ")
    }
    println()
    
    // while loop
    var countdown = 5
    while (countdown > 0) {
        print("$countdown...")
        countdown--
    }
    println("Go!")
}
```

Compile and run. **Expected output:**
```
Score: 87 → Grade: B
Day 3 is Wednesday
Counting 1 to 5: 1 2 3 4 5 
5...4...3...2...1...Go!
```

### Exercise 3: Functions

Create `src/functions.kt`:

```kotlin
// Single-expression function (no braces needed)
fun add(a: Int, b: Int): Int = a + b

// Function with default parameter
fun greet(name: String, greeting: String = "Hello") {
    println("$greeting, $name!")
}

// Function with multiple return values (returns a Pair)
fun minMax(list: List<Int>): Pair<Int, Int> {
    return list.minOrNull() to list.maxOrNull()
}

fun main() {
    println("3 + 5 = ${add(3, 5)}")
    
    greet("Alice")
    greet("Bob", "Hi")
    
    val numbers = listOf(3, 7, 2, 9, 1)
    val (min, max) = minMax(numbers)  // Destructuring declaration
    println("Min: $min, Max: $max")
}
```

Compile and run. **Expected output:**
```
3 + 5 = 8
Hello, Alice!
Hi, Bob!
Min: 1, Max: 9
```

### Exercise 4: Null Safety Basics

Create `src/null_safety.kt`:

```kotlin
fun main() {
    // Nullable type: String?
    val nullableName: String? = null
    
    // Safe call operator: returns null if left side is null
    val length = nullableName?.length  // null, not a crash!
    println("Length of nullableName: $length")
    
    // Elvis operator: provide default if null
    val nameOrDefault = nullableName ?: "Unknown"
    println("Name or default: $nameOrDefault")
    
    // Not null assertion (careful! crashes if null)
    val safeName: String? = "Kotlin"
    println("Length (unsafe): ${safeName!!.length}")  // OK — not null here
    
    // You can also use .let to scope a nullable value
    nullableName?.let { name ->
        println("Processing name: $name")  // Only runs if not null
    }
}
```

Compile and run. **Expected output:**
```
Length of nullableName: null
Name or default: Unknown
Length (unsafe): 6
```

## Completion Checklist

- [ ] You understand `val` vs `var`
- [ ] You can use string templates with `$variable` and `${expression}`
- [ ] You can write `if-else` as an expression
- [ ] You can use `when` as an expression
- [ ] You understand `..` ranges and `for` loops
- [ ] You can write single-expression functions
- [ ] You understand default parameters
- [ ] You understand nullable types (`String?`) and the safe call operator (`?.`)
- [ ] You can use the Elvis operator (`?:`)

## Hints

- Read the official Kotlin docs: https://kotlinlang.org/docs/getting-started.html
- If you get stuck on null safety, think: "What happens if this value is null?"
- Single-expression functions are a Kotlin specialty — watch for them in real code
