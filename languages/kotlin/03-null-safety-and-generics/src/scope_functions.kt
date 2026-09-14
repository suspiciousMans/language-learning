// Exercise 2: Scope Functions - differentiate let, run, with, apply, also
fun main() {
    val mutableList = mutableListOf("apple", "banana", "cherry")

    // let: use it as lambda parameter - good for null checks and transforms
    // TODO: use .let to print size and transform to uppercase

    // run: this as receiver - good for configuring objects
    // TODO: use .run to add "date" and print list

    // with: pass object as receiver to lambda (non-extension)
    // TODO: use with() to print first and last items

    // apply: this as receiver, returns object - good for builders
    // TODO: use .apply to add elderberry and fig, store result

    // also: it as parameter, returns object - good for side effects/log
    // TODO: use .also to log list size
}
