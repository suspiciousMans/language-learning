// Exercise 5: defer — cleanup that runs regardless of how scope exits
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

    print("---")

    do {
        let content = try readFile(path: "")
        print("Read: \(content)")
    } catch {
        print("Error: \(error)")
    }
}

demonstrateDefer()
