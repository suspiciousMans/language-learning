// Exercise 1: Struct vs Class Behavior
import Foundation

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
