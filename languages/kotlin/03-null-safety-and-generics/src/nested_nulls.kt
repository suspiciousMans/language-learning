// Exercise 1: Nested Null Safety Chains
data class Address(val street: String?, val city: String?, val zip: String?)
data class Person(val name: String, val address: Address?)

fun main() {
    val person = Person("Alice", Address("123 Main", "NYC", "10001"))
    // TODO: extract city safely using ?. chain, should be "NYC"

    val noAddress = Person("Bob", null)
    // TODO: extract city from person with no address, should be null

    // TODO: use Elvis ?: to provide "Unknown" default
}
