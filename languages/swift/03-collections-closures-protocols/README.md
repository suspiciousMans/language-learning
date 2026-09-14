# Project 03: Collections, Closures, and Protocols — Swift

**Difficulty:** beginner/intermediate
**Prerequisites:** Project 01 (Basics), Project 02 (Optionals)

## Goals

- Master Swift's collection types: Arrays, Dictionaries, Sets
- Understand closures: syntax, capturing, escaping, autoclosures
- Learn protocol-oriented programming: protocol requirements, extensions, protocol composition
- Use higher-order functions: `map`, `filter`, `reduce`, `compactMap`, `flatMap`

## Concepts

- **Arrays, Dictionaries, Sets** — Swift's three collection types, all value types
- **Closure syntax** — `{ (params) -> ReturnType in body }`
- **Trailing closure syntax** — when the last parameter is a closure
- **Capturing** — closures capture variables from their enclosing scope
- **Escaping closures** — `@escaping` for closures stored beyond the function call
- **Autoclosures** — `@autoclosure` wraps an expression in a closure automatically
- **Protocols** — Swift's version of interfaces; support inheritance, extensions, and composition
- **Protocol extensions** — provide default implementations
- **Protocol composition** — `protocol<A, B>` or `&` syntax

## Exercises

### Exercise 1: Arrays and Higher-Order Functions

Create `Sources/CollectionsClosuresProtocols/collections.swift`:

```swift
import Foundation

func demonstrateCollections() {
    // Array basics
    var numbers: [Int] = [1, 2, 3, 4, 5]
    numbers.append(6)
    numbers.insert(0, at: 0)
    print("Numbers: \(numbers)")

    // map — transform each element
    let doubled = numbers.map { $0 * 2 }
    print("Doubled: \(doubled)")

    // filter — keep elements matching predicate
    let evens = numbers.filter { $0 % 2 == 0 }
    print("Evens: \(evens)")

    // reduce — accumulate into a single value
    let sum = numbers.reduce(0, +)
    print("Sum: \(sum)")

    // compactMap — transform and unwrap non-nil results
    let strings = ["1", "two", "3", "four", "5"]
    let validInts = strings.compactMap { Int($0) }
    print("Valid ints: \(validInts)")

    // flatMap on arrays — flatten nested arrays
    let nested = [[1, 2], [3, 4], [5]]
    let flat = nested.flatMap { $0 }
    print("Flat: \(flat)")

    // sorted — returns new sorted array
    let unsorted = [5, 2, 8, 1, 9]
    let sorted = unsorted.sorted()
    print("Sorted: \(sorted)")

    // sort vs sorted (in-place vs copy)
    var mutable = [5, 2, 8]
    mutable.sort()
    print("In-place sorted: \(mutable)")
}

demonstrateCollections()
```

**Expected output:**
```
Numbers: [0, 1, 2, 3, 4, 5, 6]
Doubled: [0, 2, 4, 6, 8, 10, 12]
Evens: [0, 2, 4, 6]
Sum: 21
Valid ints: [1, 3, 5]
Flat: [1, 2, 3, 4, 5]
Sorted: [1, 2, 5, 8, 9]
In-place sorted: [2, 5, 8]
```

### Exercise 2: Dictionaries and Sets

Create `Sources/CollectionsClosuresProtocols/dicts_sets.swift`:

```swift
import Foundation

func demonstrateDictionaries() {
    // Dictionary creation
    var ages: [String: Int] = ["Alice": 30, "Bob": 25, "Charlie": 35]

    // Accessing values — returns optional
    if let aliceAge = ages["Alice"] {
        print("Alice is \(aliceAge)")
    }

    // Modifying
    ages["Dave"] = 28
    ages.updateValue(26, forKey: "Bob")
    print("Ages: \(ages)")

    // Dictionary keys/values as collections
    let names = ages.keys.sorted()
    print("Sorted names: \(names)")

    // Filter dictionary
    let young = ages.filter { $0.value < 30 }
    print("Under 30: \(young)")

    // Map dictionary values
    let ageStrings = ages.map { "\($0.key): \($0.value)" }
    print("Age strings: \(ageStrings)")
}

func demonstrateSets() {
    // Set creation — unique elements, unordered
    var fruits: Set<String> = ["apple", "banana", "cherry"]
    fruits.insert("apple")  // duplicate — no effect
    fruits.insert("date")
    print("Fruits: \(fruits)")

    // Set operations
    let setA: Set = [1, 2, 3, 4]
    let setB: Set = [3, 4, 5, 6]

    print("Union: \(setA.union(setB))")
    print("Intersection: \(setA.intersection(setB))")
    print("Subtraction: \(setA.subtracting(setB))")
    print("Symmetric difference: \(setA.symmetricDifference(setB))")

    // Membership testing
    print("Contains 3: \(setA.contains(3))")
    print("Is subset: \(Set([1, 2]).isSubset(of: setA))")
}

demonstrateDictionaries()
demonstrateSets()
```

**Expected output:**
```
Alice is 30
Ages: ["Alice": 30, "Bob": 26, "Charlie": 35, "Dave": 28]
Sorted names: ["Alice", "Bob", "Charlie", "Dave"]
Under 30: ["Bob": 26, "Dave": 28]
Age strings: ["Alice: 30", "Bob: 26", "Charlie: 35", "Dave: 28"]
Fruits: ["banana", "cherry", "apple", "date"]
Union: [1, 2, 3, 4, 5, 6]
Intersection: [3, 4]
Subtraction: [1, 2]
Symmetric difference: [1, 2, 5, 6]
Contains 3: true
Is subset: true
```

### Exercise 3: Closures

Create `Sources/CollectionsClosuresProtocols/closures.swift`:

```swift
import Foundation

func demonstrateClosures() {
    // Basic closure syntax
    let add = { (a: Int, b: Int) -> Int in
        return a + b
    }
    print("Add 3 + 5 = \(add(3, 5))")

    // Type inference — Swift knows the types from context
    let multiply: (Int, Int) -> Int = { a, b in a * b }
    print("Multiply 3 * 5 = \(multiply(3, 5))")

    // Trailing closure syntax
    let numbers = [1, 2, 3, 4, 5]
    let squared = numbers.map { $0 * $0 }
    print("Squared: \(squared)")

    // Capturing — closure captures variables from enclosing scope
    var count = 0
    let incrementer = {
        count += 1
        return count
    }
    print("Increment 1: \(incrementer())")
    print("Increment 2: \(incrementer())")
    print("Count is now: \(count)")

    // Escaping closure — stored beyond function scope
    func asyncOperation(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            sleep(1)
            completion()
        }
    }

    // Using asyncOperation (simplified — we'll just call it synchronously for demo)
    print("Starting async operation...")
    asyncOperation {
        print("Async operation completed!")
    }

    // Autoclosure — automatically wraps expression in closure
    func logIfTrue(_ condition: @autoclosure () -> Bool, message: String) {
        if condition() {
            print("TRUE: \(message)")
        }
    }

    let value = 42
    logIfTrue(value > 40, message: "Value is over 40")
    logIfTrue(value < 10, message: "This won't print")
}

demonstrateClosures()
```

**Expected output:**
```
Add 3 + 5 = 8
Multiply 3 * 5 = 15
Squared: [1, 4, 9, 16, 25]
Increment 1: 1
Increment 2: 2
Count is now: 2
Starting async operation...
Async operation completed!
TRUE: Value is over 40
```

### Exercise 4: Protocols

Create `Sources/CollectionsClosuresProtocols/protocols.swift`:

```swift
import Foundation

// Protocol definition
protocol Vehicle {
    var speed: Double { get set }
    var name: String { get }
    func accelerate(by amount: Double)
    func description() -> String
}

// Protocol with extension providing default implementation
extension Vehicle {
    func description() -> String {
        return "\(name) traveling at \(speed) mph"
    }
}

// Conforming to protocol
class Car: Vehicle {
    var speed: Double = 0
    let name: String

    init(name: String) {
        self.name = name
    }

    func accelerate(by amount: Double) {
        speed += amount
    }
}

// Protocol composition — combining multiple protocols
protocol Flyable {
    var altitude: Double { get }
    func fly(to altitude: Double)
}

class FlyingCar: Vehicle, Flyable {
    var speed: Double = 0
    var altitude: Double = 0
    let name: String

    init(name: String) {
        self.name = name
    }

    func accelerate(by amount: Double) {
        speed += amount
    }

    func fly(to newAltitude: Double) {
        altitude = newAltitude
    }

    // Override default description
    func description() -> String {
        return "\(name) at \(speed) mph, \(altitude) ft altitude"
    }
}

// Protocol as a type — polymorphism
func describe(_ vehicle: Vehicle) {
    print(vehicle.description())
}

func demonstrateProtocols() {
    let car = Car(name: "Toyota Camry")
    car.accelerate(by: 60)
    describe(car)

    let flyingCar = FlyingCar(name: "AeroCar")
    flyingCar.accelerate(by: 100)
    flyingCar.fly(to: 10000)
    describe(flyingCar)

    // Check protocol conformance
    print("FlyingCar is Vehicle: \(flyingCar is Vehicle)")
    print("FlyingCar is Flyable: \(flyingCar is Flyable)")

    // Protocol extension — adding method to all Vehicles
    extension Vehicle {
        func honk() {
            print("\(name) goes beep!")
        }
    }

    car.honk()
    flyingCar.honk()
}

demonstrateProtocols()
```

**Expected output:**
```
Toyota Camry traveling at 60.0 mph
AeroCar at 100.0 mph, 10000.0 ft altitude
FlyingCar is Vehicle: true
FlyingCar is Flyable: true
Toyota Camry goes beep!
AeroCar goes beep!
```

## Completion Checklist

- [ ] You can create and manipulate Arrays, Dictionaries, and Sets
- [ ] You understand `map`, `filter`, `reduce`, `compactMap`, `flatMap` on collections
- [ ] You can write closures with full syntax and shorthand syntax
- [ ] You understand closure capturing and `@escaping`
- [ ] You can use `@autoclosure` for lazy evaluation
- [ ] You can define protocols with properties and methods
- [ ] You can provide default implementations via protocol extensions
- [ ] You understand protocol composition and type checking with `is` and `as`

## Hints

- Swift collections are value types — modifications create copies
- `sorted()` returns a new array; `sort()` mutates in place
- Trailing closure syntax works when the closure is the last parameter
- `$0`, `$1` shorthand works when closure has no explicit parameter names
- Protocol extensions cannot override concrete implementations — they provide defaults
- Use `is` for type checking, `as?` for safe casting, `as!` for force casting
