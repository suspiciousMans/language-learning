// Exercise 3: Result Type — Result<Success, Failure>
import Foundation

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

    // flatMapError for recovery
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
