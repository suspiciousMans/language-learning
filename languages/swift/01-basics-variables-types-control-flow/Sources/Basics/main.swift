// Exercise 1: Variables, Constants, and Types
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
