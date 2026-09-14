// Exercise 3: Functions — argument labels, default values, tuples
import Foundation

// Simple function
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}

// Function with external parameter name and default value
func greet(name: String, greeting: String = "Hello") {
    print("\(greeting), \(name)!")
}

// Function returning a tuple
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
