# Project 04: Functional Style — Kotlin

**Difficulty:** intermediate  
**Prerequisites:** Project 03 (Null Safety and Generics)

## Goals

- Write Kotlin in a functional style: higher-order functions, lambdas, immutability
- Use Kotlin's collection transformation functions fluently
- Understand function types and lambdas as parameters
- Write custom higher-order functions (map, filter, fold over custom data)

## Concepts

- **Lambda expressions** — anonymous functions: `{ x: Int -> x * 2 }`
- **Function types** — `(Int, Int) -> Int`
- **Higher-order functions** — functions that take/return functions
- **Tail recursion** — `@tailrec` annotation for optimized recursion
- **Immutability** — prefer `val`, use `List` over `MutableList` for functional style

## Exercises

### Exercise 1: Higher-Order Functions (map, filter, fold)

Create `src/collection_ops.kt`:

```kotlin
// TODO: implement these functions using recursion or collection operations

// Filter a list to only elements matching the predicate
fun <T> customFilter(list: List<T>, predicate: (T) -> Boolean): List<T> {
    TODO()
}

// Map each element through the function
fun <T, R> customMap(list: List<T>, transform: (T) -> R): List<R> {
    TODO()
}

// Fold/reduce: accumulate a result by applying function to each element
fun <T, R> fold(list: List<T>, initial: R, combine: (R, T) -> R): R {
    TODO()
}

fun main() {
    val numbers = listOf(1, 2, 3, 4, 5, 6)
    
    // Use customFilter to get even numbers
    val evens = TODO()
    println("Evens: $evens")  // [2, 4, 6]
    
    // Use customMap to double
    val doubled = TODO()
    println("Doubled: $doubled")  // [2, 4, 6, 8, 10, 12]
    
    // Use fold to sum
    val sum = TODO()
    println("Sum: $sum")  // 21
    
    // Use fold to join strings
    val joined = TODO()
    println("Joined: $joined")  // "1-2-3-4-5-6"
}
```

### Exercise 2: Function Types and Lambdas

Create `src/function_types.kt`:

```kotlin
// Function type: (Int, Int) -> Int
val add: (Int, Int) -> Int = { a, b -> a + b }
val multiply: (Int, Int) -> Int = { a, b -> a * b }

// Higher-order function that takes a function type
fun calculate(x: Int, y: Int, op: (Int, Int) -> Int): Int {
    return op(x, y)
}

// Function that returns a function (factory)
fun makeGreeter(greeting: String): (String) -> String {
    return { name -> "$greeting, $name!" }
}

// TODO: use calculate with add and multiply, print results

// TODO: use makeGreeter to create a "Hello" greeter, call with "Alice", print

// TODO: create a function that returns a function which multiplies by n
// fun makeMultiplier(n: Int): (Int) -> Int = ...

// TODO: use it to create double (n=2) and triple (n=3), test with 5
```

Expected output:
```
7 (3+4 via add)
12 (3*4 via multiply)
Hello, Alice!
Doubled 5: 10
Tripled 5: 15
```

### Exercise 3: Tail Recursion

Create `src/tail_rec.kt`:

```kotlin
import kotlin.tailrec

// Regular recursion (stack grows — can overflow on large inputs)
fun factorial(n: Int): Int {
    return if (n <= 1) 1 else n * factorial(n - 1)
}

// Tail recursion (compiler optimizes to loop)
@tailrec
fun factorialTail(n: Int, accumulator: Int = 1): Int {
    return if (n <= 1) accumulator else factorialTail(n - 1, n * accumulator)
}

// TODO: test factorial(5) — should be 120

// TODO: test factorialTail(5) — should be 120

// TODO: write a tail-recursive function to compute Fibonacci(n)
// fun fib(n: Int, a: Int = 0, b: Int = 1): Int = ...

// TODO: test fib(10) — should be 55
```

### Exercise 4: Function Composition

Create `src/composition.kt`:

```kotlin
// Function type alias
typealias Transform<A, B> = (A) -> B

// Compose two functions: f(g(x))
fun <A, B, C> compose(f: (B) -> C, g: (A) -> B): (A) -> C {
    return { x -> f(g(x)) }
}

fun main() {
    // TODO: create functions: toInt (String -> Int), double (Int -> Int), toString (Int -> String)
    // TODO: compose them: parseAndDoubleToString = toString ∘ double ∘ toInt
    // TODO: use composed function on "5" — should print "10"

    // TODO: create a function that takes a list and a transform, applies transform to each
    // fun <T, R> transformAll(list: List<T>, transform: (T) -> R): List<R>

    // TODO: use transformAll with a lambda to square each number in listOf(1,2,3,4,5)
}
```

## Completion Checklist

- [ ] You can write and use lambda expressions
- [ ] You understand function types `(A, B) -> C`
- [ ] You can write higher-order functions that take functions as parameters
- [ ] You can write functions that return functions
- [ ] You can use `@tailrec` for optimized recursion
- [ ] You can compose functions
- [ ] You prefer immutable collections in functional style

## Hints

- Kotlin lambdas: `{ params -> body }` or `{ it -> body }` (single param is `it`)
- Function types are just values — pass them around like any other value
- `@tailrec` is a compiler check — if your function isn't tail-recursive, compilation fails
- Function composition is common in functional programming — `f(g(x))` means apply g first, then f
