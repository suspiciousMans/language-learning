// Exercise 2: Control Flow
fun main() {
    val score = 87
    val grade = if (score >= 90) "A" else if (score >= 80) "B" else "C"
    println("Score: $score → Grade: $grade")

    val day = 3
    val dayName = when (day) {
        1 -> "Monday"
        2 -> "Tuesday"
        3 -> "Wednesday"
        4 -> "Thursday"
        5 -> "Friday"
        6, 7 -> "Weekend"
        else -> "Unknown"
    }
    println("Day $day is $dayName")

    print("Counting 1 to 5: ")
    for (i in 1..5) print("$i ")
    println()

    var countdown = 5
    while (countdown > 0) {
        print("$countdown...")
        countdown--
    }
    println("Go!")
}
