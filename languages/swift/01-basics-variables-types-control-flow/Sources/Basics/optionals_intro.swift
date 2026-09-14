// Exercise 4: Basic Optionals — if let, ??, guard, force unwrap
import Foundation

func demonstrateOptionals() {
    let nullableName: String? = nil

    // Optional binding
    if let name = nullableName {
        print("Name is \(name)")
    } else {
        print("Name is nil")
    }

    // Nil-coalescing
    let nameOrDefault = nullableName ?? "Unknown"
    print("Name or default: \(nameOrDefault)")

    // Force unwrap (careful!)
    let safeName: String? = "Swift"
    print("Length (forced): \(safeName!.count)")

    // Guard for early exit
    func processName(_ name: String?) {
        guard let actualName = name, !actualName.isEmpty else {
            print("No valid name provided")
            return
        }
        print("Processing: \(actualName)")
    }

    processName(nil)
    processName("Alice")
}

demonstrateOptionals()
