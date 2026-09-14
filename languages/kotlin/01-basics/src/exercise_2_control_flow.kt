/*
 * Exercise 2: Control Flow
 * TODO: Implement a function that takes a score and returns a letter grade (A, B, C, D, F)
 * TODO: Implement a when expression that maps a day number (1-7) to a day name
 * TODO: Use a for loop to print numbers 1-5
 * TODO: Use a while loop to count down from 5 to 1
 */
fun getGrade(score: Int): String {
    TODO("Return A for >= 90, B for >= 80, C for >= 70, D for >= 60, F otherwise")
}

fun dayName(day: Int): String {
    TODO("Return Monday for 1, Tuesday for 2, etc., Weekend for 6/7")
}

fun main() {
    println("Grade 87: ${getGrade(87)}")
    println("Day 3: ${dayName(3)}")
    println("Count 1-5:")
    for (i in 1..5) println(i)
    println("Countdown 5-1:")
    var countdown = 5
    while (countdown > 0) {
        println(countdown)
        countdown--
    }
}
