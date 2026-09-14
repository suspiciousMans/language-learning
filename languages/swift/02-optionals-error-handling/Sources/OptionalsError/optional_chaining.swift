// Exercise 1: Deep Optional Chaining
import Foundation

struct Address {
    let street: String?
    let city: String?
    let zip: String?
}

struct Person {
    let name: String
    let address: Address?
}

func demonstrateOptionalChaining() {
    let alice = Person(name: "Alice", address: Address(street: "123 Main", city: "NYC", zip: "10001"))
    let bob = Person(name: "Bob", address: nil)

    // Optional chaining
    let aliceCity = alice.address?.city
    print("Alice city: \(aliceCity ?? "Unknown")")

    let bobCity = bob.address?.city
    print("Bob city: \(bobCity ?? "Unknown")")

    // Nil-coalescing on chained result
    let aliceCityOrDefault = alice.address?.city ?? "Unknown"
    print("Alice city or default: \(aliceCityOrDefault)")

    // Map over optional
    let maybeName = alice.name
    let uppercased = maybeName.map { $0.uppercased() }
    print("Uppercased name: \(uppercased ?? "nil")")

    // FlatMap over optional (handles nested optionals)
    let maybeStreet = alice.address?.street
    let streetLength = maybeStreet.flatMap { $0.isEmpty ? nil : Optional($0.count) }
    print("Street length: \(streetLength ?? -1)")

    // CompactMap on array of optionals
    let names: [String?] = ["Alice", nil, "Bob", nil, "Charlie"]
    let validNames = names.compactMap { $0 }
    print("Valid names: \(validNames)")
}

demonstrateOptionalChaining()
