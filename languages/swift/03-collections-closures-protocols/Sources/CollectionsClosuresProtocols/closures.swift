// Exercise 3: Closures
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

    // Using asyncOperation
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
