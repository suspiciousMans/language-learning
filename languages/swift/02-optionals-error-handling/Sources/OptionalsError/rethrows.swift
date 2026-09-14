// Exercise 4: rethrows — functions that throw only when closure throws
import Foundation

func performOperation<T>(_ operation: () throws -> T) rethrows -> T {
    return try operation()
}

enum MathError: Error {
    case overflow
}

func demonstrateRethrows() {
    // Non-throwing closure — no try needed
    let value = performOperation { 42 }
    print("Value: \(value)")

    // Throwing closure — must use try
    do {
        let riskyValue = try performOperation {
            throw MathError.overflow
        }
        print("Risky: \(riskyValue)")
    } catch MathError.overflow {
        print("Caught overflow")
    }
}

demonstrateRethrows()
