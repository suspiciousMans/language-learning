// Exercise 3: Functions
fun add(a: Int, b: Int): Int = a + b

fun greet(name: String, greeting: String = "Hello") {
    println("$greeting, $name!")
}

fun minMax(list: List<Int>): Pair<Int, Int> {
    return list.minOrNull() to list.maxOrNull()
}

fun main() {
    println("3 + 5 = ${add(3, 5)}")
    greet("Alice")
    greet("Bob", "Hi")
    val numbers = listOf(3, 7, 2, 9, 1)
    val (min, max) = minMax(numbers)
    println("Min: $min, Max: $max")
}
