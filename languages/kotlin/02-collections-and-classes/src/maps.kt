// Exercise 2: Maps
fun main() {
    val ages = mapOf("Alice" to 30, "Bob" to 25, "Charlie" to 35)
    // TODO: print Alice's age safely, print Dave's age with default

    val scores = mutableMapOf<String, Int>()
    // TODO: add Alice=100, Bob=85, overwrite Alice to 101, print

    // TODO: iterate with destructuring, print each entry

    val doubled = scores.mapValues { TODO() }
    println("Doubled: $doubled")
}
