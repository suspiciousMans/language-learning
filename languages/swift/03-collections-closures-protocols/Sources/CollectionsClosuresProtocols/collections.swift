// Exercise 1: Arrays and Higher-Order Functions
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
