# Project 05: Protocol-Oriented Programming and Generics — Swift

**Difficulty:** intermediate  
**Prerequisites:** Project 04 (Classes, Structs, and Enums)

## Goals

- Understand protocol-oriented programming, Swift's hallmark paradigm
- Write generic functions and types that work with any type
- Compose protocols to build expressive, reusable abstractions

## Concepts

- **Protocol-oriented programming** — start with protocols, extend with extensions
- **Protocol extensions** — provide default implementations for protocol requirements
- **Generics** — type parameters, `where` constraints, associated types
- **Associated types** — protocols that reference a type to be specified by conformer
- **Protocol composition** — conforming to multiple protocols at once
- **`some` (opaque) types** — hide concrete type while preserving protocol conformance
- **Protocol inheritance** — protocols can inherit from other protocols

## Exercises

### Exercise 1: Protocol with Default Implementation via Extension

Create `src/protocol_extension.swift`:

```swift
// A protocol for types that can be described
protocol Describable {
    var name: String { get }
    func describe() -> String
}

// Default implementation via extension — no need to implement in each type
extension Describable {
    func describe() -> String {
        return "This is \(name)"
    }
}

// Struct that only needs to provide the property
struct Planet: Describable {
    let name: String
    let orbitDays: Double
}

struct Star: Describable {
    let name: String
    let temperature: Double  // in Kelvin
}

// Both work without implementing describe() themselves
let earth = Planet(name: "Earth", orbitDays: 365.25)
let sun = Star(name: "Sun", temperature: 5778)

print(earth.describe())
print(sun.describe())

// But we can still override
extension Planet {
    func describe() -> String {
        return "Planet \(name) orbits in \(orbitDays) days"
    }
}

print(earth.describe())  // uses overridden version
```

Run: `swift src/protocol_extension.swift`

**Expected output:**
```
This is Earth
This is Sun
Planet Earth orbits in 365.25 days
```

### Exercise 2: Generic Stack

Create `src/generic_stack.swift`:

```swift
// A generic stack — works with any type T
struct Stack<T> {
    private var items: [T] = []
    
    var isEmpty: Bool { items.isEmpty }
    var count: Int { items.count }
    var top: T? { items.last }
    
    mutating func push(_ item: T) {
        items.append(item)
    }
    
    mutating func pop() -> T? {
        guard !isEmpty else { return nil }
        return items.removeLast()
    }
    
    func peek() -> T? {
        return items.last
    }
}

// Usage with different types
var intStack = Stack<Int>()
intStack.push(10)
intStack.push(20)
intStack.push(30)
print("Int stack: \(intStack.pop() ?? -1), \(intStack.pop() ?? -1), \(intStack.pop() ?? -1)")

var stringStack = Stack<String>()
stringStack.push("hello")
stringStack.push("world")
print("String stack top: \(stringStack.top ?? "empty")")

// Generic function that works with any Stack
func dump<T>(stack: Stack<T>) {
    print("Stack has \(stack.count) items")
}

var empty = Stack<Double>()
dump(stack: empty)
```

Run: `swift src/generic_stack.swift`

**Expected output:**
```
Int stack: 30, 20, 10
String stack top: world
Stack has 0 items
```

### Exercise 3: Protocol with Associated Type

Create `src/associated_type.swift`:

```swift
// A container that holds items of a specific type
protocol Container {
    associatedtype Item
    var count: Int { get }
    mutating func append(_ item: Item)
    var items: [Item] { get }
}

// A generic struct conforming to Container
struct Bag<T>: Container {
    var items: [T] = []
    
    mutating func append(_ item: T) {
        items.append(item)
    }
    
    var count: Int { items.count }
}

// Another container using a different storage strategy
struct Registry<T>: Container {
    private var _items: [T] = []
    var items: [T] { return _items }
    
    mutating func append(_ item: T) {
        _items.append(item)
    }
    
    var count: Int { _items.count }
}

var toys = Bag<String>()
toys.append("ball")
toys.append("doll")
toys.append("blocks")
print("Bag has \(toys.count) items: \(toys.items)")

var registrations = Registry<Int>()
registrations.append(101)
registrations.append(202)
print("Registry has \(registrations.count) items: \(registrations.items)")
```

Run: `swift src/associated_type.swift`

**Expected output:**
```
Bag has 3 items: ["ball", "doll", "blocks"]
Registry has 2 items: [101, 202]
```

### Exercise 4: Protocol Composition

Create `src/protocol_composition.swift`:

```swift
protocol Flyable {
    func fly() -> String
}

protocol Swimmable {
    func swim() -> String
}

protocol Walkable {
    func walk() -> String
}

// A duck can do all three
struct Duck: Flyable, Swimmable, Walkable {
    func fly() -> String { return "flapping wings" }
    func swim() -> String { return "paddling" }
    func walk() -> String { return "waddling" }
}

// A fish can only swim
struct Fish: Swimmable {
    func swim() -> String { return "tail flick" }
}

// Takes any type that can both fly and swim
func migrate<T: Flyable & Swimmable>(creature: T) {
    print("Creature flies by \(creature.fly()) then swims by \(creature.swim())")
}

let duck = Duck()
migrate(creature: duck)

// Fish can't migrate (no Flyable)
let fish = Fish()
print("Fish only swims: \(fish.swim())")
```

Run: `swift src/protocol_composition.swift`

**Expected output:**
```
Creature flies by flapping wings then swims by paddling
Fish only swims: tail flick
```

### Exercise 5: Binary Search with Generics and Constraints

Create `src/binary_search.swift`:

```swift
// Binary search requires Comparable elements
func binarySearch<T: Comparable>(in array: [T], for target: T) -> Int? {
    var low = 0
    var high = array.count - 1
    
    while low <= high {
        let mid = (low + high) / 2
        let midValue = array[mid]
        
        if midValue == target {
            return mid
        } else if midValue < target {
            low = mid + 1
        } else {
            high = mid - 1
        }
    }
    return nil
}

let numbers = [2, 5, 8, 12, 16, 23, 38, 45, 56, 67, 78, 89, 94]
let names = ["Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"]

if let idx = binarySearch(in: numbers, for: 38) {
    print("Found 38 at index \(idx)")
} else {
    print("38 not found")
}

if let idx = binarySearch(in: numbers, for: 100) {
    print("Found 100 at index \(idx)")
} else {
    print("100 not found")
}

if let idx = binarySearch(in: names, for: "Diana") {
    print("Found Diana at index \(idx)")
} else {
    print("Diana not found")
}
```

Run: `swift src/binary_search.swift`

**Expected output:**
```
Found 38 at index 6
100 not found
Found Diana at index 3
```

## Completion Checklist

- [ ] Can explain value type (struct) vs reference type (class) and when each is appropriate
- [ ] Can define a protocol and provide default implementations via extension
- [ ] Can write a generic function or struct with type constraints
- [ ] Can use associated types in protocols
- [ ] Can compose multiple protocols in a single conformance or function constraint
- [ ] Can explain protocol-oriented programming and why Swift favors it over class hierarchies
