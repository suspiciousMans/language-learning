// Exercise 6: Switch Patterns and Where Clauses
import Foundation

func demonstrateSwitchPatterns() {
    // Tuple pattern matching
    let point = (x: 3, y: 4)
    switch point {
    case (0, 0):
        print("Origin")
    case (_, 0):
        print("On x-axis")
    case (0, _):
        print("On y-axis")
    case (let x, let y) where x == y:
        print("On diagonal: (\(x), \(y))")
    case (let x, let y):
        print("Point at (\(x), \(y))")
    }

    // Range pattern in switch
    let score = 87
    switch score {
    case 90...100:
        print("A grade")
    case 80..<90:
        print("B grade")
    case 70..<80:
        print("C grade")
    default:
        print("Below C")
    }

    // where clause on cases
    let numbers = [1, 2, 3, 4, 5, 6]
    for num in numbers {
        switch num {
        case let x where x % 2 == 0:
            print("\(num) is even")
        case let x where x % 2 == 1:
            print("\(num) is odd")
        default:
            print("Unknown")
        }
    }
}

demonstrateSwitchPatterns()
