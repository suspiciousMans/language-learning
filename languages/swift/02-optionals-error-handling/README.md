# Project 02: Optionals and Error Handling — Swift

**Difficulty:** beginner/intermediate  
**Prerequisites:** Project 01 (Basics)

## Goals

- Master Swift's optional system: chaining, mapping, flatMapping, guard
- Understand `try/catch/throw` and Swift's error handling model
- Use `Result` type for functional error handling
- Write custom error types with `enum`

## Concepts

- **Optionals** — `T?` is an enum with `.some(T)` or `.none`
- **Optional chaining** — `a?.b?.c` returns optional of the final type
- **`map` / `flatMap` on Optionals** — transform optional values
- **`guard let`** — early exit pattern for unwrapping
- **`try?` / `try!`** — convert throwing functions to optional / force-unwrap
- **`do-catch`** — structured error handling
- **`Result<Success, Failure>`** — Swift's built-in result type (since Swift 5)
- **Error protocol** — Swift errors are `enum`s conforming to `Error`

## Exercises

### Exercise 1: Deep Optional Chaining

Create `Sources/OptionalsError/optional_chaining.swift`:

```swift
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

    // Optional chaining: city through optional address
    let aliceCity = alice.address?.city
    print("Alice city: \(aliceCity ?? "Unknown")")

    let bobCity = bob.address?.city
    print("Bob city: \(bobCity ?? "Unknown")")

    // Optional chaining with default via ?? (nil-coalescing)
    let aliceCityOrDefault = alice.address?.city ?? "Unknown"
    print("Alice city or default: \(aliceCityOrDefault)")

    // Map over optional: transform if non-nil
    let maybeName = alice.name
    let uppercased = maybeName.map { $0.uppercased() }
    print("Uppercased name: \(uppercased ?? "nil")")

    // FlatMap over optional: returns optional (handles nested optionals)
    let maybeStreet = alice.address?.street
    let streetLength = maybeStreet.flatMap { $0.isEmpty ? nil : Optional($0.count) }
    print("Street length: \(streetLength ?? -1)")

    // CompactMap on array of optionals
    let names: [String?] = ["Alice", nil, "Bob", nil, "Charlie"]
    let validNames = names.compactMap { $0 }
    print("Valid names: \(validNames)")
}

demonstrateOptionalChaining()
```

**Expected output:**
```
Alice city: NYC
Bob city: Unknown
Alice city or default: NYC
Uppercased name: ALICE
Street length: 9
Valid names: ["Alice", "Bob", "Charlie"]
```

### Exercise 2: Error Handling with throws/catch

Create `Sources/OptionalsError/error_handling.swift`:

```swift
import Foundation

// Custom error enum
enum NetworkError: Error, CustomStringConvertible {
    case invalidURL
    case noData
    case serverError(Int)

    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .serverError(let code):
            return "Server error: \(code)"
        }
    }
}

enum ValidationError: Error {
    case emptyName
    case invalidEmail
}

func fetchUserData(userId: Int) throws -> String {
    guard userId > 0 else {
        throw NetworkError.serverError(404)
    }
    return "User data for \(userId)"
}

func parseJSON(_ json: String) throws -> [String: String] {
    guard json.contains("{") else {
        throw NetworkError.invalidURL
    }
    return ["parsed": "ok"]
}

func demonstrateErrorHandling() {
    // do-catch
    do {
        let data = try fetchUserData(userId: 42)
        print("Fetched: \(data)")
    } catch NetworkError.serverError(let code) {
        print("Server error with code: \(code)")
    } catch {
        print("Unknown error: \(error)")
    }

    // try? converts throwing function to optional
    if let data = try? fetchUserData(userId: -1) {
        print("Got data: \(data)")
    } else {
        print("Failed to fetch (try? returned nil)")
    }

    // try! force tries — crashes on error
    let validData = try! fetchUserData(userId: 10)
    print("Valid data (try!): \(validData)")

    // Function that throws
    func validateUser(name: String?, email: String?) throws {
        guard let name = name, !name.isEmpty else {
            throw ValidationError.emptyName
        }
        guard let email = email, email.contains("@") else {
            throw ValidationError.invalidEmail
        }
        print("User validated: \(name), \(email)")
    }

    do {
        try validateUser(name: "Alice", email: "alice@example.com")
    } catch ValidationError.emptyName {
        print("Validation: name is required")
    } catch ValidationError.invalidEmail {
        print("Validation: valid email required")
    }

    do {
        try validateUser(name: nil, email: "bad")
    } catch {
        print("Caught validation error: \(error)")
    }
}

demonstrateErrorHandling()
```

**Expected output:**
```
Fetched: User data for 42
Failed to fetch (try? returned nil)
Valid data (try!): User data for 10
User validated: Alice, alice@example.com
Caught validation error: emptyName
```

### Exercise 3: Result Type

Create `Sources/OptionalsError/result_type.swift`:

```swift
import Foundation

// Swift's built-in Result type: Result<Success, Failure>
// where Failure: Error

enum AppError: Error {
    case notFound
    case unauthorized
    case serverError(String)
}

func fetchUser(id: Int) -> Result<String, AppError> {
    if id <= 0 {
        return .failure(.notFound)
    }
    return .success("User \(id)")
}

func parseResponse(_ data: String) -> Result<[String: String], AppError> {
    if data.isEmpty {
        return .failure(.serverError("Empty response"))
    }
    return .success(["data": data])
}

func demonstrateResultType() {
    // Success case
    let result = fetchUser(id: 42)
    switch result {
    case .success(let user):
        print("Got user: \(user)")
    case .failure(let error):
        print("Error: \(error)")
    }

    // Failure case
    let badResult = fetchUser(id: -1)
    switch badResult {
    case .success(let user):
        print("Got user: \(user)")
    case .failure(let error):
        print("Error: \(error)")
    }

    // map on Result
    let mapped = fetchUser(id: 42).map { "Hello, \($0)!" }
    if case .success(let msg) = mapped {
        print("Mapped: \(msg)")
    }

    // mapError
    let mappedError = fetchUser(id: -1).mapError { AppError.serverError("\($0)") }
    if case .failure(let err) = mappedError {
        print("Mapped error: \(err)")
    }

    // get() — returns value or throws
    do {
        let user = try fetchUser(id: 42).get()
        print("Via get(): \(user)")
    } catch {
        print("get() threw: \(error)")
    }

    // Chaining: fetch then parse
    let chained = fetchUser(id: 42)
        .flatMap { parseResponse($0) }

    switch chained {
    case .success(let parsed):
        print("Chained result: \(parsed)")
    case .failure(let err):
        print("Chained failed: \(err)")
    }

    // flatMapError
    let recovered = fetchUser(id: -1)
        .flatMapError { error -> Result<String, AppError> in
            if case .notFound = error {
                return .success("Default User")
            }
            return .failure(error)
        }
    if case .success(let user) = recovered {
        print("Recovered: \(user)")
    }
}

demonstrateResultType()
```

**Expected output:**
```
Got user: User 42
Error: notFound
Mapped: Hello, User 42!
Mapped error: serverError( "")
Chained result: ["data": "User 42"]
Recovered: Default User
```

### Exercise 4: rethrows and Generic Error Handling

```swift
import Foundation

// rethrows: function that throws only if the passed function throws
func performOperation<T>(_ operation: () throws -> T) rethrows -> T {
    return try operation()
}

func demonstrateRethrows() {
    // Non-throwing closure — no need for do-catch
    let value = performOperation { 42 }
    print("Value: \(value)")

    // Throwing closure — must use try
    enum MathError: Error { case overflow }

    do {
        let riskyValue = try performOperation {
            if true { throw MathError.overflow }
            return 0
        }
        print("Risky: \(riskyValue)")
    } catch MathError.overflow {
        print("Caught overflow")
    }
}

demonstrateRethrows()
```

### Exercise 5: Defer and Error Propagation

```swift
import Foundation

func demonstrateDefer() {
    func readFile(path: String) throws -> String {
        print("Opening file: \(path)")
        defer {
            print("Closing file: \(path)")
        }

        guard !path.isEmpty else {
            throw NSError(domain: "FileError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Empty path"])
        }

        return "Contents of \(path)"
    }

    do {
        let content = try readFile(path: "data.txt")
        print("Read: \(content)")
    } catch {
        print("Error reading file: \(error)")
    }

    // defer always runs, even on error
    do {
        let content = try readFile(path: "")
        print("Read: \(content)")
    } catch {
        print("Error: \(error)")
    }
}

demonstrateDefer()
```

## Completion Checklist

- [ ] You can chain optionals with `?.`
- [ ] You can use `map` and `flatMap` on optionals
- [ ] You can use `compactMap` to filter nil from arrays
- [ ] You can use `if let`, `guard let`, and `??` for optional handling
- [ ] You can define custom error enums conforming to `Error`
- [ ] You can use `do-catch` for error handling
- [ ] You can use `try?`, `try!`, and `try` appropriately
- [ ] You can use Swift's `Result<Success, Failure>` type
- [ ] You can chain `Result` with `map`, `flatMap`, `mapError`, `flatMapError`
- [ ] You understand `rethrows`
- [ ] You can use `defer` for cleanup

## Hints

- Swift errors use `enum` with associated values — much cleaner than Java/Kotlin exceptions
- `try?` silently converts errors to `nil` — useful but can hide bugs
- `Result` is great for async operations; `do-catch` is great for synchronous code
- `defer` runs when scope exits, regardless of how (return, throw, etc.)
