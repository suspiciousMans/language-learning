# Project 01: Basics — Swift

**Difficulty:** beginner  
**Prerequisites:** Project 00 (Tooling Check)

## Goals

- Understand Swift's basic syntax: variables, constants, types, control flow, functions
- Write and run simple Swift programs
- Compare Swift syntax with other languages (Kotlin, Rust, TypeScript)

## Concepts

- **`let` vs `var`** — immutable constants vs mutable variables
- **Type inference** — Swift infers types from context; explicit annotations optional
- **String interpolation** — `\(expression)` inside strings
- **Control flow** — `if`, `guard`, `switch`, `for-in`, `while`, `repeat-while`
- **Switch is exhaustive** — must cover all cases or have a `default`
- **Functions** — argument labels, default values, multiple return values via tuples
- **Ranges** — `..<` (half-open), `...` (closed)

## Exercises

### Exercise 1: Variables, Constants, and Types

Create `Sources/Basics/main.swift`:

```swift
import Foundation

// Constants (immutable)
let name: String = "Swift"
let year: Int = 2014  // First Swift release

// Variables (mutable)
var version: Double = 5.0
version = 5.9  // Reassigning works

// Type inference — Swift figures out the type
let message = "Learning \(name)"  // inferred as String

print("\(name) was released in \(year) (version \(version))")
print(message)
```

Compile and run:

```bash
swift build
swift run
```

**Expected output:**
```
Swift was released in 2014 (version 5.9)
Learning Swift
```

> Note: A `Double` like `1.9.22` is not valid — Swift is strict about types. This is the same lesson as Kotlin.

### Exercise 2: Control Flow

Create `Sources/Basics/control_flow.swift`:

```swift
import Foundation

func demonstrateControlFlow() {
    let score = 87

    // if-else as an expression via ternary or if/else blocks
    let grade: String
    if score >= 90 {
        grade = "A"
    } else if score >= 80 {
        grade = "B"
    } else {
        grade = "C"
    }
    print("Score: \(score) → Grade: \(grade)")

    // switch — must be exhaustive
    let day = 3
    let dayName: String
    switch day {
    case 1:
        dayName = "Monday"
    case 2:
        dayName = "Tuesday"
    case 3:
        dayName = "Wednesday"
    case 4:
        dayName = "Thursday"
    case 5:
        dayName = "Friday"
    case 6, 7:
        dayName = "Weekend"
    default:
        dayName = "Unknown"
    }
    print("Day \(day) is \(dayName)")

    // for-in loop with ranges
    print("Counting 1 to 5: ", terminator: "")
    for i in 1...5 {
        print("\(i) ", terminator: "")
    }
    print()

    // while loop
    var countdown = 5
    while countdown > 0 {
        print("\(countdown)...", terminator: "")
        countdown -= 1
    }
    print("Go!")
}

demonstrateControlFlow()
```

**Expected output:**
```
Score: 87 → Grade: B
Day 3 is Wednesday
Counting 1 to 5: 1 2 3 4 5 
5...4...3...2...1...Go!
```

### Exercise 3: Functions

Create `Sources/Basics/functions.swift`:

```swift
import Foundation

// Function with argument labels
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}

// Function with external parameter name and default value
func greet(name: String, greeting: String = "Hello") {
    print("\(greeting), \(name)!")
}

// Function returning a tuple (multiple values)
func minMax(of numbers: [Int]) -> (min: Int, max: Int)? {
    guard let first = numbers.first else { return nil }
    var min = first
    var max = first
    for n in numbers {
        if n < min { min = n }
        if n > max { max = n }
    }
    return (min, max)
}

func demonstrateFunctions() {
    print("3 + 5 = \(add(3, 5))")

    greet(name: "Alice")
    greet(name: "Bob", greeting: "Hi")

    let numbers = [3, 7, 2, 9, 1]
    if let result = minMax(of: numbers) {
        print("Min: \(result.min), Max: \(result.max)")
    }
}

demonstrateFunctions()
```

**Expected output:**
```
3 + 5 = 8
Hello, Alice!
Hi, Bob!
Min: 1, Max: 9
```

### Exercise 4: Basic Optionals Intro

```swift
import Foundation

func demonstrateOptionals() {
    // Optional type: String?
    let nullableName: String? = nil

    // Optional binding with if let
    if let name = nullableName {
        print("Name is \(name)")
    } else {
        print("Name is nil")
    }

    // Nil-coalescing operator
    let nameOrDefault = nullableName ?? "Unknown"
    print("Name or default: \(nameOrDefault)")

    // Force unwrap (dangerous — crash if nil)
    let safeName: String? = "Swift"
    print("Length (forced): \(safeName!.count)")

    // Guard statement — early exit
    func processName(_ name: String?) {
        guard let actualName = name, !actualName.isEmpty else {
            print("No valid name provided")
            return
        }
        print("Processing: \(actualName)")
    }

    processName(nil)
    processName("Alice")
}

demonstrateOptionals()
```

**Expected output:**
```
Name is nil
Name or default: Unknown
Length (forced): 5
No valid name provided
Processing: Alice
```

## Completion Checklist

- [ ] You understand `let` vs `var`
- [ ] You can use string interpolation with `\(expression)`
- [ ] You can write `if-else` and understand Swift's optional binding (`if let`)
- [ ] You can write an exhaustive `switch` statement
- [ ] You understand `...` (closed) and `..<` (half-open) ranges
- [ ] You can write `for-in` loops
- [ ] You can write functions with argument labels and default parameters
- [ ] You can return multiple values via tuples
- [ ] You understand optional types (`String?`) and the nil-coalescing operator (`??`)
- [ ] You can use `guard` for early exit

## Hints

- Read the official Swift docs: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/
- Swift switch cases don't fall through by default (no `break` needed)
- `guard` must exit the scope — use `return`, `break`, `continue`, or `throw`
- Argument labels make function calls read naturally: `greet(name: "Alice")` vs `greet("Alice")`
- Optionals are Swift's core innovation — spend time understanding them

### Exercise 5: Ranges and Stride

```swift
import Foundation

func demonstrateRanges() {
    // Closed range: 1...5 = [1, 2, 3, 4, 5]
    print("Closed range 1...5:")
    for i in 1...5 {
        print(i, terminator: " ")
    }
    print()

    // Half-open range: 1..<5 = [1, 2, 3, 4]
    print("Half-open range 1..<5:")
    for i in 1..<5 {
        print(i, terminator: " ")
    }
    print()

    // One-sided ranges
    let numbers = [10, 20, 30, 40, 50]
    print("numbers[2...] = \(Array(numbers[2...]))")
    print("numbers[...2] = \(Array(numbers[...2]))")
    print("numbers[..<3] = \(Array(numbers[..<3]))")

    // stride(from:to:by:) — like Kotlin's step
    print("Stride 0..<10 step 2:")
    for i in stride(from: 0, to: 10, by: 2) {
        print(i, terminator: " ")
    }
    print()

    // stride(from:through:by:) — inclusive end
    print("Stride 0...10 step 3:")
    for i in stride(from: 0, through: 10, by: 3) {
        print(i, terminator: " ")
    }
    print()
}

demonstrateRanges()
```

**Expected output:**
```
Closed range 1...5:
1 2 3 4 5 
Half-open range 1..<5:
1 2 3 4 
numbers[2...] = [30, 40, 50]
numbers[...2] = [10, 20, 30]
numbers[..<3] = [10, 20, 30]
Stride 0..<10 step 2:
0 2 4 6 8 
Stride 0...10 step 3:
0 3 6 9 
```

### Exercise 6: Switch Patterns and Where Clauses

```swift
import Foundation

func demonstrateSwitchPatterns() {
    // Tuple pattern matching
    let point = (x: 3, y: 4)
    switch point {
    case (0, 0):
        print("Origin")
    case (_, 0):
        print("On x-axis")
    case (0, _):
        print("On y-axis")
    case (let x, let y) where x == y:
        print("On diagonal: (\(x), \(y))")
    case (let x, let y):
        print("Point at (\(x), \(y))")
    }

    // Value binding in switch
    let score = 87
    switch score {
    case 90...100:
        print("A grade")
    case 80..<90:
        print("B grade")
    case 70..<80:
        print("C grade")
    default:
        print("Below C")
    }

    // Switch with where clause
    let numbers = [1, 2, 3, 4, 5, 6]
    for num in numbers {
        switch num {
        case let x where x % 2 == 0:
            print("\(num) is even")
        case let x where x % 2 == 1:
            print("\(num) is odd")
        default:
            print("Unknown")
        }
    }
}

demonstrateSwitchPatterns()
```

**Expected output:**
```
Point at (3, 4)
B grade
1 is odd
2 is even
3 is odd
4 is even
5 is odd
6 is even
```

## Completion Checklist (Expanded)

- [ ] You understand `let` vs `var`
- [ ] You can use string interpolation with `\(expression)`
- [ ] You can write `if-else` and understand Swift's optional binding (`if let`)
- [ ] You can write an exhaustive `switch` statement
- [ ] You understand `...` (closed) and `..<` (half-open) ranges
- [ ] You can write `for-in` loops
- [ ] You can write functions with argument labels and default parameters
- [ ] You can return multiple values via tuples
- [ ] You understand optional types (`String?`) and the nil-coalescing operator (`??`)
- [ ] You can use `guard` for early exit
- [ ] You can use one-sided ranges (`array[2...]`, `array[...2]`, `array[..<3]`)
- [ ] You can use `stride(from:to:by:)` and `stride(from:through:by:)`
- [ ] You can pattern-match in `switch` with tuples and `where` clauses

## Hints

- Read the official Swift docs: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/
- Swift switch cases don't fall through by default (no `break` needed)
- `guard` must exit the scope — use `return`, `break`, `continue`, or `throw`
- Argument labels make function calls read naturally: `greet(name: "Alice")` vs `greet("Alice")`
- Optionals are Swift's core innovation — spend time understanding them
