// Exercise 4: Null Safety Basics
fun main() {
    val nullableName: String? = null
    val length = nullableName?.length
    println("Length of nullableName: $length")

    val nameOrDefault = nullableName ?: "Unknown"
    println("Name or default: $nameOrDefault")

    val safeName: String? = "Kotlin"
    println("Length (unsafe): ${safeName!!.length}")

    nullableName?.let { name ->
        println("Processing name: $name")
    }
}
