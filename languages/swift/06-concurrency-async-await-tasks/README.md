# Project 06: Concurrency — Async/Await and Actors — Swift

**Difficulty:** intermediate/advanced  
**Prerequisites:** Project 04 (Classes, Structs, and Enums), Project 05 (Protocol-Oriented Programming and Generics)

## Goals

- Understand Swift's modern concurrency model: async/await, actors, and structured concurrency
- Write asynchronous code that reads like synchronous code
- Protect shared mutable state with actors
- Use `Task`, `async let`, and `TaskGroup` for concurrent operations
- Understand the difference between threads and Swift's cooperative threading model

## Concepts

- **async/await** — mark functions as async; await their results without callbacks
- **actors** — reference types that protect mutable state from data races
- **Task** — a unit of asynchronous work; structured concurrency
- **async let** — run multiple async operations concurrently and await them together
- **TaskGroup** — dynamic concurrency for running a variable number of tasks
- **Sendable** — types safe to pass across concurrency domains
- **MainActor** — guarantee execution on the main thread (UI)
- **Continuation** — bridge between callback-based and async APIs (`withCheckedContinuation`)

## Exercises

### Exercise 1: Async/Await Basics

Create `Sources/ConcurrencyAsync/basic_async.swift`:

```swift
import Foundation

// A simulated async network call
func fetchUserID(from server: String) async -> Int {
    // Simulate network delay
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    return server == "primary" ? 42 : 99
}

func fetchUsername(for userID: Int) async -> String {
    try? await Task.sleep(nanoseconds: 500_000_000)
    return userID == 42 ? "Alice" : "Unknown"
}

func demonstrateBasicAsync() async {
    print("Fetching user ID...")
    let userID = await fetchUserID(from: "primary")
    print("User ID: \(userID)")

    print("Fetching username...")
    let username = await fetchUsername(for: userID)
    print("Username: \(username)")
}

// Call from a Task
Task {
    await demonstrateBasicAsync()
    print("Done!")
}

// Keep the playground alive
RunLoop.main.run(until: Date(timeIntervalSinceNow: 3))
```

Run: `swift run`

**Expected output:**
```
Fetching user ID...
User ID: 42
Fetching username...
Username: Alice
Done!
```

### Exercise 2: Concurrent Execution with async let

Create `Sources/ConcurrencyAsync/async_let.swift`:

```swift
import Foundation

func fetchProfile(for userID: Int) async -> String {
    try? await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...1_500_000_000))
    return "Profile-\(userID)"
}

func fetchNotifications(for userID: Int) async -> Int {
    try? await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...1_500_000_000))
    return Int.random(in: 0...10)
}

func fetchSettings(for userID: Int) async -> [String: Bool] {
    try? await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...1_500_000_000))
    return ["darkMode": true, "notifications": false]
}

func demonstrateAsyncLet() async {
    let userID = 42

    // Sequential: total time ~3+ seconds
    print("--- Sequential ---")
    let profile1 = await fetchProfile(for: userID)
    let notifications1 = await fetchNotifications(for: userID)
    let settings1 = await fetchSettings(for: userID)
    print("Profile: \(profile1), Notifications: \(notifications1), Settings: \(settings1)")

    // Concurrent with async let: total time ~1-1.5 seconds
    print("\n--- Concurrent (async let) ---")
    async let profile2 = fetchProfile(for: userID)
    async let notifications2 = fetchNotifications(for: userID)
    async let settings2 = fetchSettings(for: userID)

    let (p, n, s) = await (profile2, notifications2, settings2)
    print("Profile: \(p), Notifications: \(n), Settings: \(s)")
}

Task {
    await demonstrateAsyncLet()
    print("Done!")
}
RunLoop.main.run(until: Date(timeIntervalSinceNow: 5))
```

**Expected output:**
```
--- Sequential ---
Profile: Profile-42, Notifications: 3, Settings: ["darkMode": true, "notifications": false]

--- Concurrent (async let) ---
Profile: Profile-42, Notifications: 7, Settings: ["darkMode": true, "notifications": false]
Done!
```

### Exercise 3: Actors for Thread-Safe State

Create `Sources/ConcurrencyAsync/actors.swift`:

```swift
import Foundation

// Actor: protects mutable state from data races
actor BankAccount {
    private var balance: Double
    let owner: String

    init(owner: String, initialBalance: Double) {
        self.owner = owner
        self.balance = initialBalance
    }

    func deposit(_ amount: Double) {
        balance += amount
    }

    func withdraw(_ amount: Double) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        return true
    }

    func currentBalance() -> Double {
        return balance
    }
}

actor SimpleCache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]

    func set(_ value: Value, for key: Key) {
        storage[key] = value
    }

    func get(for key: Key) -> Value? {
        return storage[key]
    }
}

func demonstrateActors() async {
    let account = BankAccount(owner: "Alice", initialBalance: 100.0)

    print("Initial balance: \(await account.currentBalance())")

    await account.deposit(50.0)
    print("After deposit: \(await account.currentBalance())")

    let success = await account.withdraw(30.0)
    print("Withdraw 30: \(success ? "success" : "failed"), balance: \(await account.currentBalance())")

    let failed = await account.withdraw(200.0)
    print("Withdraw 200: \(failed ? "success" : "failed"), balance: \(await account.currentBalance())")

    // Cache actor
    let cache = SimpleCache<String, Int>()
    await cache.set(42, for: "answer")
    await cache.set(99, for: "test")

    if let answer = await cache.get(for: "answer") {
        print("Cached answer: \(answer)")
    }
}

Task {
    await demonstrateActors()
    print("Done!")
}
RunLoop.main.run(until: Date(timeIntervalSinceNow: 3))
```

**Expected output:**
```
Initial balance: 100.0
After deposit: 150.0
Withdraw 30: success, balance: 120.0
Withdraw 200: failed, balance: 120.0
Cached answer: 42
Done!
```

### Exercise 4: TaskGroup for Dynamic Concurrency

Create `Sources/ConcurrencyAsync/task_group.swift`:

```swift
import Foundation

func downloadFile(named name: String) async -> String {
    let duration = UInt64.random(in: 500_000_000...2_000_000_000)
    try? await Task.sleep(nanoseconds: duration)
    return "Downloaded \(name) (\(duration / 1_000_000_000) seconds)"
}

func demonstrateTaskGroup() async {
    let files = ["index.html", "style.css", "app.js", "logo.png", "data.json"]

    print("Downloading \(files.count) files concurrently...")

    // TaskGroup: run a variable number of tasks concurrently
    await withTaskGroup(of: String.self) { group in
        for file in files {
            group.addTask {
                return await downloadFile(named: file)
            }
        }

        // Collect results as they complete
        var results: [String] = []
        for await result in group {
            results.append(result)
            print("  ✓ \(result)")
        }

        print("\nAll \(results.count) files downloaded!")
    }
}

Task {
    await demonstrateTaskGroup()
    print("Done!")
}
RunLoop.main.run(until: Date(timeIntervalSinceNow: 5))
```

**Expected output:**
```
Downloading 5 files concurrently...
  ✓ Downloaded index.html (1 seconds)
  ✓ Downloaded style.css (1 seconds)
  ✓ Downloaded app.js (1 seconds)
  ✓ Downloaded logo.png (1 seconds)
  ✓ Downloaded data.json (1 seconds)

All 5 files downloaded!
Done!
```

### Exercise 5: sendable and @MainActor

Create `Sources/ConcurrencyAsync/sendable.swift`:

```swift
import Foundation

// Sendable: safe to pass across concurrency domains
struct User: Sendable {
    let id: Int
    let name: String
    let email: String
}

// Non-Sendable: has mutable reference type
class Counter {
    var value: Int = 0
}

actor SafeCounter {
    private var count: Int = 0

    func increment() -> Int {
        count += 1
        return count
    }
}

@MainActor
class ViewModel {
    var items: [String] = []
    var isLoading: Bool = false

    func loadItems() async {
        isLoading = true
        // Simulate async work
        try? await Task.sleep(nanoseconds: 500_000_000)
        items = ["Item 1", "Item 2", "Item 3"]
        isLoading = false
    }
}

func demonstrateSendable() async {
    let user = User(id: 1, name: "Alice", email: "alice@example.com")

    // Sendable value can cross actor boundaries safely
    let counter = SafeCounter()
    let newCount = await counter.increment()
    print("Counter: \(newCount)")

    // MainActor isolated — must be called from main actor
    let viewModel = ViewModel()
    await viewModel.loadItems()
    print("Items: \(viewModel.items)")
    print("Loading: \(viewModel.isLoading)")
}

Task {
    await demonstrateSendable()
    print("Done!")
}
RunLoop.main.run(until: Date(timeIntervalSinceNow: 3))
```

**Expected output:**
```
Counter: 1
Items: ["Item 1", "Item 2", "Item 3"]
Loading: false
Done!
```

## Completion Checklist

- [ ] Can write `async` functions and call them with `await`
- [ ] Can use `async let` to run multiple async operations concurrently
- [ ] Can define and use `actor` to protect shared mutable state
- [ ] Can use `TaskGroup` for dynamic concurrency
- [ ] Can mark types as `Sendable` and understand why it matters
- [ ] Can use `@MainActor` to ensure UI-related code runs on the main thread
- [ ] Can bridge callback-based APIs to async using `withCheckedContinuation`

## Hints

- Swift concurrency is based on cooperative threading — the runtime manages threads, not you
- `async let` starts the right-hand side immediately; you don't `await` until you need the result
- Actors serialize access to their mutable state — only one method runs at a time per actor
- `TaskGroup` results come back in completion order, not submission order
- `Sendable` is a marker protocol — compiler checks conformance for safety
- UI frameworks (SwiftUI) require `@MainActor` for state mutations
- Use `Task { }` to enter async context from synchronous code
