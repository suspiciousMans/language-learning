// Exercise 1: Variables and Types
fun main() {
    val name: String = "Kotlin"
    val year: Int = 2011
    var version: Double = 1.9
    version = 1.9  // Note: 1.9.22 is NOT a valid Double

    val message = "Learning " + name
    println("$name was released in $year (version $version)")
    println(message)
}
