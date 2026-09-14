// Exercise 2: Dictionaries and Sets
import Foundation

func demonstrateDictionaries() {
    // Dictionary creation
    var ages: [String: Int] = ["Alice": 30, "Bob": 25, "Charlie": 35]

    // Accessing values — returns optional
    if let aliceAge = ages["Alice"] {
        print("Alice is \(aliceAge)")
    }

    // Modifying
    ages["Dave"] = 28
    ages.updateValue(26, forKey: "Bob")
    print("Ages: \(ages)")

    // Dictionary keys/values as collections
    let names = ages.keys.sorted()
    print("Sorted names: \(names)")

    // Filter dictionary
    let young = ages.filter { $0.value < 30 }
    print("Under 30: \(young)")

    // Map dictionary values
    let ageStrings = ages.map { "\($0.key): \($0.value)" }
    print("Age strings: \(ageStrings)")
}

func demonstrateSets() {
    // Set creation — unique elements, unordered
    var fruits: Set<String> = ["apple", "banana", "cherry"]
    fruits.insert("apple")  // duplicate — no effect
    fruits.insert("date")
    print("Fruits: \(fruits)")

    // Set operations
    let setA: Set = [1, 2, 3, 4]
    let setB: Set = [3, 4, 5, 6]

    print("Union: \(setA.union(setB))")
    print("Intersection: \(setA.intersection(setB))")
    print("Subtraction: \(setA.subtracting(setB))")
    print("Symmetric difference: \(setA.symmetricDifference(setB))")

    // Membership testing
    print("Contains 3: \(setA.contains(3))")
    print("Is subset: \(Set([1, 2]).isSubset(of: setA))")
}

demonstrateDictionaries()
demonstrateSets()
