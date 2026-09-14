// Exercise 5: Ranges and Stride
import Foundation

func demonstrateRanges() {
    // Closed range
    print("Closed range 1...5:")
    for i in 1...5 {
        print(i, terminator: " ")
    }
    print()

    // Half-open range
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

    // stride
    print("Stride 0..<10 step 2:")
    for i in stride(from: 0, to: 10, by: 2) {
        print(i, terminator: " ")
    }
    print()

    print("Stride 0...10 step 3:")
    for i in stride(from: 0, through: 10, by: 3) {
        print(i, terminator: " ")
    }
    print()
}

demonstrateRanges()
