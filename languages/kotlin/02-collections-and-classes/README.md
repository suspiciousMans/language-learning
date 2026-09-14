# Project 02: Collections and Classes — Kotlin

**Difficulty:** beginner  
**Prerequisites:** Project 01 (Basics)

## Goals

- Work with Kotlin's collection types: List, Set, Map
- Create classes with properties, methods, and constructors
- Use Kotlin's special class forms: data class, sealed class, enum class
- Destructure data classes

## Concepts

- **List / Set / Map** — Kotlin's immutable-by-default collections
- **data class** — auto-generates equals, hashCode, toString, copy
- **destructuring** — unpack a data class into variables
- **sealed class** — restricted class hierarchy (like Rust enums but for types)
- **companion object** — static-like members in Kotlin

## Exercises

### Exercise 1: Lists and Operations

Create `src/lists.kt`:

```kotlin
// This scaffold shows the structure — fill in your solution below
fun main() {
    val numbers = listOf(5, 2, 8, 1, 9, 3)
    // TODO: filter even numbers, sort, print

    val tasks = mutableListOf("read docs", "write code", "test", "deploy")
    // TODO: add "review PR", remove first task, print

    val upper = tasks.map { TODO() }
    println("Uppercase: $upper")
}
```

Expected output:
```
Even numbers, sorted: [2, 8]
Remaining tasks: [write code, test, deploy]
Uppercase: [WRITE CODE, TEST, DEPLOY]
```

### Exercise 2: Maps

Create `src/maps.kt`:

```kotlin
// Fill in the TODOs
fun main() {
    val ages = mapOf("Alice" to 30, "Bob" to 25, "Charlie" to 35)
    // TODO: print Alice's age safely

    val scores = mutableMapOf<String, Int>()
    // TODO: add Alice=100, Bob=85, overwrite Alice to 101, print

    // TODO: iterate with destructuring, print entries

    val doubled = scores.mapValues { TODO() }
    println("Doubled: $doubled")
}
```

### Exercise 3: Data Class

Create `src/data_class.kt`:

```kotlin
data class Person(val name: String, val age: Int, val city: String)

// TODO: create alice, bob, compare equality, copy, destructure, print
fun main() {
    val alice = TODO()
    val bob = TODO()
    println(alice)

    val alice2 = TODO()
    println("Same person? ${alice == alice2}")

    val olderAlice = TODO()
    println("Alice next year: $olderAlice")

    val (name, age, city) = TODO()
    println("$name is $age years old in $city")
}
```

### Exercise 4: Sealed Class for Result Type

Create `src/result_types.kt`:

```kotlin
sealed class OperationResult {
    data class Success(val value: String) : OperationResult()
    data class Error(val message: String) : OperationResult()
}

// TODO: implement fetchUserData, handleResult, test with main
fun main() {
    TODO()
    TODO()
}
```

## Completion Checklist

- [ ] You can create and transform Lists (`.filter`, `.map`, `.sorted`)
- [ ] You can work with Maps (`mapOf`, `.get`, iteration)
- [ ] You understand immutable vs mutable collections
- [ ] You can create a `data class` and use its auto-generated methods
- [ ] You can destructure a data class with `val (a, b, c) = obj`
- [ ] You understand the `copy` method
- [ ] You can create a `sealed class` with subclasses
- [ ] You know that `when` on sealed classes is exhaustive

## Hints

- Kotlin collections are immutable by default — use `mutableListOf` / `mutableMapOf` for mutable ones
- `data class` is one of Kotlin's best features — use it for data containers
- Sealed classes + `when` are Kotlin's answer to Rust enums + pattern matching
