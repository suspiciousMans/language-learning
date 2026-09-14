# Project 04: Classes, Structs, and Enums — Swift

**Difficulty:** beginner  
**Prerequisites:** Project 03 (Collections, Closures, and Protocols)

## Goals

- Understand Swift's approach to data modeling: classes, structs, and enums
- Learn when to use each type and why Swift favors value types
- Practice inheritance, protocol conformance, and enum associated values

## Concepts

- **`struct`** — value type; copied on assignment, thread-safe by default
- **`class`** — reference type; shared on assignment, supports inheritance
- **`enum`** — closed set of cases; can carry associated values and conform to protocols
- **Value vs reference semantics** — structs are copied, classes are shared
- **Mutating methods** — structs need `mutating` keyword to modify `self`
- **Initializers** — `init()`, designated vs convenience, `required` for subclasses
- **Access control** — `public`, `internal`, `fileprivate`, `private`

## Exercises

### Exercise 1: Struct vs Class Behavior

Create `src/struct_vs_class.swift`:

```swift
// Structs are value types — assignment copies
struct Point {
    var x: Double
    var y: Double
}

// Classes are reference types — assignment shares
class Person {
    var name: String
    init(name: String) { self.name = name }
}

var p1 = Point(x: 1.0, y: 2.0)
var p2 = p1          // p2 is a COPY of p1
p2.x = 5.0
print("p1: (\(p1.x), \(p1.y))")  // p1 unchanged
print("p2: (\(p2.x), \(p2.y))")  // p2 changed

let alice = Person(name: "Alice")
let bob = alice       // bob SHARES alice's data
bob.name = "Bob"
print("alice.name: \(alice.name)")  // alice changed too!
print("bob.name: \(bob.name)")
```

Run: `swift src/struct_vs_class.swift`

**Expected output:**
```
p1: (1.0, 2.0)
p2: (5.0, 2.0)
alice.name: Bob
bob.name: Bob
```

### Exercise 2: Enum with Associated Values

Create `src/enums.swift`:

```swift
// Enum can carry data per case
enum Message {
    case text(String)
    case image(url: String, caption: String?)
    case reaction(emoji: String, count: Int)
}

func describe(_ msg: Message) -> String {
    switch msg {
    case .text(let content):
        return "Text: \(content)"
    case .image(let url, let caption):
        return "Image: \(url)" + (caption != nil ? " — \(caption!)" : "")
    case .reaction(let emoji, let count):
        return "\(emoji) ×\(count)"
    }
}

let messages: [Message] = [
    .text("Hello, Swift!"),
    .image(url: "https://example.com/photo.jpg", caption: "Sunset"),
    .reaction(emoji: "❤️", count: 42),
    .text("Swift is expressive"),
    .image(url: "https://example.com/code.png", caption: nil),
]

for msg in messages {
    print(describe(msg))
}
```

Run: `swift src/enums.swift`

**Expected output:**
```
Text: Hello, Swift!
Image: https://example.com/photo.jpg — Sunset
❤️ ×42
Text: Swift is expressive
Image: https://example.com/_code.png
```

### Exercise 3: Protocol with Struct Conformance

Create `src/protocol_conformance.swift`:

```swift
// A protocol describing anything that can be serialized
protocol Serializable {
    func toJSON() -> String
}

// Struct conforming to protocol
struct Book: Serializable {
    let title: String
    let author: String
    let year: Int
    
    func toJSON() -> String {
        let encoded = #"{"title":"\#(title)","author":"\#(author)","year":\#(year)}"#
        return encoded
    }
}

// Another struct
struct Album: Serializable {
    let artist: String
    let title: String
    let tracks: Int
}

// Generic function working with any Serializable
func printJSON<T: Serializable>(item: T) {
    print(item.toJSON())
}

let dune = Book(title: "Dune", author: "Frank Herbert", year: 1965)
let thriller = Album(artist: "Michael Jackson", title: "Thriller", tracks: 9)

printJSON(item: dune)
printJSON(item: thriller)
```

Run: `swift src/protocol_conformance.swift`

**Expected output:**
```
{"title":"Dune","author":"Frank Herbert","year":1965}
{"title":"Thriller","artist":"Michael Jackson","tracks":9}
```

### Exercise 4: Inheritance and Overrides

Create `src/inheritance.swift`:

```swift
// Base class
class Shape {
    let color: String
    init(color: String) { self.color = color }
    func area() -> Double { return 0 }
    func describe() -> String { return "A \(color) shape" }
}

// Subclass
class Circle: Shape {
    let radius: Double
    init(radius: Double, color: String) {
        self.radius = radius
        super.init(color: color)
    }
    override func area() -> Double {
        return Double.pi * radius * radius
    }
    override func describe() -> String {
        return "A \(color) circle with radius \(radius)"
    }
}

// Another subclass
class Rectangle: Shape {
    let width: Double
    let height: Double
    init(width: Double, height: Double, color: String) {
        self.width = width
        self.height = height
        super.init(color: color)
    }
    override func area() -> Double {
        return width * height
    }
}

let shapes: [Shape] = [
    Circle(radius: 5.0, color: "red"),
    Rectangle(width: 4.0, height: 6.0, color: "blue"),
    Circle(radius: 2.5, color: "green"),
]

for shape in shapes {
    print("\(shape.describe()) → area: \(shape.area())")
}
```

Run: `swift src/inheritance.swift`

**Expected output:**
```
A red circle with radius 5.0 → area: 78.5398163397448
A blue rectangle with width 4.0 and height...[truncated]
