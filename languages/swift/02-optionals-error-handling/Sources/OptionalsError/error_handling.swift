// Exercise 2: Error Handling — throws, do-catch, try?, try!
import Foundation

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

    // try! force try — crashes on error
    let validData = try! fetchUserData(userId: 10)
    print("Valid data (try!): \(validData)")

    // Custom validation
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
