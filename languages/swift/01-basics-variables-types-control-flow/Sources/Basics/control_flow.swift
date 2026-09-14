// Exercise 2: Control Flow — if, switch, for-in, while
import Foundation

func demonstrateControlFlow() {
    let score = 87

    // if-else
    let grade: String
    if score >= 90 {
        grade = "A"
    } else if score >= 80 {
        grade = "B"
    } else {
        grade = "C"
    }
    print("Score: \(score) → Grade: \(grade)")

    // switch — exhaustive
    let day = 3
    let dayName: String
    switch day {
    case 1:
        dayName = "Monday"
    case 2:
        dayName = "Tuesday"
    case 3:
        dayName = "Wednesday"
    case 4:
        dayName = "Thursday"
    case 5:
        dayName = "Friday"
    case 6, 7:
        dayName = "Weekend"
    default:
        dayName = "Unknown"
    }
    print("Day \(day) is \(dayName)")

    // for-in with ranges
    print("Counting 1 to 5: ", terminator: "")
    for i in 1...5 {
        print("\(i) ", terminator: "")
    }
    print()

    // while loop
    var countdown = 5
    while countdown > 0 {
        print("\(countdown)...", terminator: "")
        countdown -= 1
    }
    print("Go!")
}

demonstrateControlFlow()
