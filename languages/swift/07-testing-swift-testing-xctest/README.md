# Project 07: Testing — Swift Testing and XCTest — Swift

**Difficulty:** intermediate  
**Prerequisites:** Project 04 (Classes, Structs, and Enums), Project 06 (Concurrency)

## Goals

- Learn Swift's testing ecosystem: XCTest (legacy) and the new Swift Testing framework
- Write unit tests, integration tests, and performance tests
- Use test fixtures, setUp/tearDown, and test discovery
- Mock dependencies and test async code
- Understand the difference between the two testing frameworks and when to use each

## Concepts

- **XCTest** — Apple's established testing framework; class-based, `setUpWithError()`, `test*` methods, `XCTAssert*` macros
- **Swift Testing** — the new language-integrated testing framework (Swift 6+); `@Test` functions, `#expect` / `#require` macros, `withAnimation` testers
- **Test discovery** — both frameworks auto-discover tests; Swift Testing uses a more modern approach
- **Fixtures** — `setUp`/`tearDown` (XCTest) vs `init`/`deinit` or `beforeEach`-style helpers (Swift Testing)
- **Async testing** — both frameworks support async tests; Swift Testing handles it natively
- **Performance testing** — XCTest has `measure`; Swift Testing has `measure` blocks
- **Parameterized tests** — Swift Testing's `@Test` with arguments vs XCTest's `test` repetition
- **Mocking** — protocols + fakes; no built-in mocking in either framework

## Exercises

### Exercise 1: Swift Testing Basics

Create `Sources/TestingXCTest/math_tests.swift`:

```swift
import Testing

// Swift Testing: functions marked with @Test are automatically discovered
@Test func testAdd() {
    let result = add(2, 3)
    #expect(result == 5)
}

@Test func testAddNegative() {
    let result = add(-1, 1)
    #expect(result == 0)
}

@Test func testAddZero() {
    let result = add(0, 0)
    #expect(result == 0)
}

// The code under test (normally in a separate module)
func add(_ a: Int, _ b: Int) -> Int {
    return a + b
}
```

Run: `swift test`

**Expected output:**
```
Test Suite 'All tests' passed at ...:
    Test Suite 'TestingXCTestTests' passed at ...:
        Test Suite 'math_tests.swift' passed at ...:
            testAdd ... passed
            testAddNegative ... passed
            testAddZero ... passed
```

### Exercise 2: XCTest Equivalents

Create `Tests/TestingXCTestTests/xctest_math.swift`:

```swift
import XCTest
@testable import TestingXCTest

final class MathTests: XCTestCase {
    func testAdd() {
        XCTAssertEqual(add(2, 3), 5)
    }

    func testAddNegative() {
        XCTAssertEqual(add(-1, 1), 0)
    }

    func testAddZero() {
        XCTAssertEqual(add(0, 0), 0)
    }
}
```

Run: `swift test`

### Exercise 3: Testing Async Code

Create `Sources/TestingXCTest/async_tests.swift`:

```swift
import Testing

// Async test: Swift Testing handles this natively
@Test func testFetchUserID() async {
    let id = await fetchUserID(from: "primary")
    #expect(id == 42)
}

@Test func testFetchUserIDFails() async {
    let id = await fetchUserID(from: "unknown")
    #expect(id == 99)
}

func fetchUserID(from server: String) async -> Int {
    try? await Task.sleep(nanoseconds: 100_000_000)
    return server == "primary" ? 42 : 99
}

// XCTest version
@MainActor
final class AsyncTests: XCTestCase {
    func testFetchUserID() async {
        let id = await fetchUserID(from: "primary")
        XCTAssertEqual(id, 42)
    }
}
```

Run: `swift test`

### Exercise 4: Parameterized Tests

Create `Sources/TestingXCTest/parameterized_tests.swift`:

```swift
import Testing

// Swift Testing: parameterized tests via arguments
@Test(arguments: [1, 2, 3, 4, 5])
func testIsEven(_ value: Int) {
    let result = isEven(value)
    #expect(result == (value % 2 == 0))
}

// Multiple argument sets
@Test(arguments: [
    (1, 2, 3),
    (0, 0, 0),
    (-1, 1, 0),
    (100, 200, 300)
])
func testAddThree(_ a: Int, _ b: Int, _ expected: Int) {
    #expect(addThree(a, b) == expected)
}

func isEven(_ n: Int) -> Bool { n % 2 == 0 }
func addThree(_ a: Int, _ b: Int) -> Int { a + b }
```

Run: `swift test`

### Exercise 5: Setup/Teardown and Fixtures

Create `Sources/TestingXCTest/fixtures.swift`:

```swift
import Testing

// Swift Testing uses init for setup and deinit for teardown
struct DatabaseTests {
    private var db: MockDatabase

    init() {
        db = MockDatabase()
        db.connect()
    }

    deinit {
        db.disconnect()
    }

    @Test func testInsert() {
        db.insert("users", ["name": "Alice"])
        #expect(db.count("users") == 1)
    }

    @Test func testFind() {
        db.insert("users", ["name": "Bob"])
        let result = db.find("users", id: 1)
        #expect(result?["name"] == "Bob")
    }
}

// XCTest equivalent
final class DatabaseXCTest: XCTestCase {
    var db: MockDatabase!

    override func setUp() {
        super.setUp()
        db = MockDatabase()
        db.connect()
    }

    override func tearDown() {
        db.disconnect()
        super.tearDown()
    }

    func testInsert() {
        db.insert("users", ["name": "Alice"])
        XCTAssertEqual(db.count("users"), 1)
    }
}

// Mock
class MockDatabase {
    private var data: [String: [[String: String]]] = [:]

    func connect() {}
    func disconnect() { data.removeAll() }

    func insert(_ table: String, _ row: [String: String]) {
        if data[table] == nil { data[table] = [] }
        data[table]!.append(row)
    }

    func count(_ table: String) -> Int { data[table]?.count ?? 0 }

    func find(_ table: String, id: Int) -> [String: String]? {
        guard let rows = data[table], id > 0, id <= rows.count else { return nil }
        return rows[id - 1]
    }
}
```

Run: `swift test`

### Exercise 6: Expectations and Requirement

Create `Sources/TestingXCTest/expectations.swift`:

```swift
import Testing

// #expect — boolean condition; test continues on failure
@Test func testExpect() {
    #expect(1 + 1 == 2)
    #expect(2 * 3 == 6)
}

// #require — fails immediately (throws) on failure; useful for unwrapping
@Test func testRequire() throws {
    let value = try #require(Int("42"), "Failed to parse")
    #expect(value == 42)

    // This would fail the test immediately
    // let bad = try #require(Int("abc"), "Won't parse")
}

// Testing error conditions
enum ParseError: Error { case invalidFormat }

func parse(_ input: String) throws -> Int {
    guard let n = Int(input) else { throw ParseError.invalidFormat }
    return n
}

@Test func testThrows() throws {
    let result = try #require(throwParseError("42"))
    #expect(result == 42)
}

@Test func testThrowsInvalid() throws {
    let error = try #require(throwParseError("abc"))
    // error is a ParseError.invalidFormat
}

func throwParseError(_ input: String) throws -> Int {
    return try parse(input)
}
```

Run: `swift test`

### Exercise 7: Performance Testing

Create `Sources/TestingXCTest/performance.swift`:

```swift
import Testing

// Swift Testing: performance measurements
@Test func measureSort() {
    let numbers = (0..<10000).map { _ in Int.random(in: 0...1000) }

    await #measure {
        _ = numbers.sorted()
    }
}

// XCTest: measure block
// override func testPerformanceExample() {
//     measure { var nums = (0..<10000).map { _ in Int.random(in: 0...1000) }; _ = nums.sorted() }
// }
```

Run: `swift test`

## Completion Checklist

- [ ] Can write tests with Swift Testing's `@Test` and `#expect`
- [ ] Can write equivalent tests with XCTest's `XCTAssert*` macros
- [ ] Can test async code in both frameworks
- [ ] Can write parameterized tests with argument sets
- [ ] Can set up and tear down test fixtures
- [ ] Can use `#require` for fatal assertions and unwrapping
- [ ] Can measure performance of code
- [ ] Can test error conditions with `throws` and `Error` types

## Hints

- Swift Testing is the modern choice for new Swift 6+ projects; XCTest still ships with Xcode and is widely used
- `#expect` records failure but continues; `#require` throws and stops the test
- Swift Testing test functions can be `static` or instance methods in a `struct` or `class`
- XCTest test classes must inherit from `XCTestCase` and methods must start with `test`
- Both frameworks auto-discover tests — no manual registration needed
- Use `@MainActor` on XCTest classes when testing UI or main-thread-bound code
- For mocking, define a protocol and a fake implementation — no framework needed
