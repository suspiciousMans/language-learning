# Project 03: Null Safety and Generics — Kotlin

**Difficulty:** intermediate  
**Prerequisites:** Project 02 (Collections and Classes)

## Goals

- Master Kotlin's null safety system: safe calls, Elvis, scope functions
- Write generic functions and classes
- Understand variance: `in`, `out`, star projections
- Use Kotlin's type-safe builders

## Concepts

- **Safe call `?.`** — returns null if left side is null
- **Elvis operator `?:`** — provides default if null
- **Scope functions: `let`, `run`, `with`, `apply`, `also`** — execute code in context of an object
- **Generic functions** — type parameters on functions
- **Variance** — `in` (consumer), `out` (producer), `*` (star projection)

## Exercises

### Exercise 1: Nested Null Safety Chains

Create `src/nested_nulls.kt`:

```kotlin
data class Address(val street: String?, val city: String?, val zip: String?)
data class Person(val name: String, val address: Address?)

fun main() {
    // TODO: given a Person?, extract the city as String?
    // Use safe calls to chain through nullable properties
    val person = Person("Alice", Address("123 Main", "NYC", "10001"))
    val city = TODO()  // Should be "NYC"
    println("City: $city")

    val noAddress = Person("Bob", null)
    val city2 = TODO()  // Should be null
    println("City: $city2")

    // TODO: use Elvis to provide "Unknown" as default
    val cityOrDefault = TODO()
    println("City or default: $cityOrDefault")
}
```

Expected output:
```
City: NYC
City: null
City or default: Unknown
```

### Exercise 2: Scope Functions

Create `src/scope_functions.kt`:

```kotlin
// Differentiate let, run, with, apply, also
fun main() {
    val mutableList = mutableListOf("apple", "banana", "cherry")

    // let: use it as a lambda parameter — good for null checks and transformations
    mutableList.let { list ->
        println("Count: ${list.size}")
        list.map { it.uppercase() }  // return value
    }.let { transformed ->
        println("Transformed: $transformed")
    }

    // run: this as receiver, good for configuring objects
    mutableList.run {
        add("date")
        println("After adding date: $this")
    }

    // with: pass object as receiver to lambda (non-extension)
    with(mutableList) {
        println("First item: ${first()}")
        println("Last item: ${last()}")
    }

    // apply: this as receiver, returns the object (good for builders)
    val config = mutableList.apply {
        add(" elderberry")
        add("fig")
    }
    println("Config: $config")

    // also: it as parameter, returns the object (good for side effects/log)
    mutableList.also {
        println("Logging list size: ${it.size}")
    }
}
```

### Exercise 3: Generic Functions

Create `src/generics.kt`:

```kotlin
// Generic function — works with any type T
fun <T> singletonList(item: T): List<T> {
    return listOf(item)
}

// Generic function with reified type parameter (inline required)
inline fun <reified T> getTypeDescription() {
    println("This function works with type: ${T::class.simpleName}")
}

// Generic class
class Box<T>(private var content: T) {
    fun get(): T = content
    fun set(newContent: T) { content = newContent }
    fun describe(): String = "Box containing a ${content::class.simpleName}"
}

fun main() {
    // TODO: use singletonList with Int and String, print results

    getTypeDescription<String>()
    getTypeDescription<Int>()

    // TODO: create Box<String>, Box<Int>, get/set/describe
    val stringBox = TODO()
    println(stringBox.describe())

    val intBox = TODO()
    intBox.set(42)
    println("Int box contains: ${intBox.get()}")
}
```

### Exercise 4: Variance (in/out)

Create `src/variance.kt`:

```kotlin
// out T: this type is only produced (returned), never consumed
interface Producer<out T> {
    fun produce(): T
}

// in T: this type is only consumed (taken as parameter), never returned
interface Consumer<in T> {
    fun consume(item: T)
}

// Star projection: accepts any T
fun processAnyList(list: List<*>) {
    // Can read but not write (since we don't know T)
    if (list.isNotEmpty()) {
        println("First: ${list.first()}")
    }
}

// TODO: implement concrete Producer<String>, Consumer<Int>

fun main() {
    // TODO: create producer, get value, print
    // TODO: create consumer, feed values, verify

    val mixedList = listOf("hello", 42, true)
    processAnyList(mixedList)
}
```

## Completion Checklist

- [ ] You can chain nullable property accesses with `?.`
- [ ] You can provide defaults with `?:`
- [ ] You understand when to use `let` vs `run` vs `with` vs `apply` vs `also`
- [ ] You can write a generic function with `<T>`
- [ ] You can write a generic class with `<T>`
- [ ] You understand `out T` (producer) vs `in T` (consumer)
- [ ] You know when to use star projection `List<*>`

## Hints

- The scope functions differ in: what `this`/`it` refers to, and what they return
- `let`/`also` use `it` as parameter, `run`/`with`/`apply` use `this` as receiver
- `let`/`also` return the lambda result, `run`/`with`/`apply` return the object (for `apply`) or lambda result
- `inline` + `reified` lets you access the actual type at runtime — very useful for generic functions
