// Exercise 4: Sealed Class for Result Type
sealed class OperationResult {
    data class Success(val value: String) : OperationResult()
    data class Error(val message: String) : OperationResult()
}

// TODO: implement fetchUserData(userId): OperationResult

// TODO: implement handleResult(result: OperationResult)

fun main() {
    // TODO: test with userId=42 (success) and userId=-1 (error)
}
