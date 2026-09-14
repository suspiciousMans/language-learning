// Custom exception hierarchy

class AppException extends Exception {
    public AppException(String message) {
        super(message);
    }
}

class NotFoundException extends AppException {
    public NotFoundException(String message) {
        super(message);
    }
}

class ValidationException extends AppException {
    private final String field;

    public ValidationException(String message, String field) {
        super(message);
        this.field = field;
    }

    public String getField() { return field; }
}

class DatabaseException extends AppException {
    private final int errorCode;

    public DatabaseException(String message, int errorCode) {
        super(message);
        this.errorCode = errorCode;
    }

    public int getErrorCode() { return errorCode; }
}

// A simple User class
record User(int id, String name, String email) {}

public class Exercise3_CustomExceptions {
    // Simulated database
    private static final java.util.Map<Integer, User> DB = new java.util.HashMap<>();

    static {
        DB.put(1, new User(1, "Alice", "alice@example.com"));
        DB.put(2, new User(2, "Bob", "bob@example.com"));
    }

    // Method that throws checked exception
    public static User findUserById(int id) throws NotFoundException {
        User user = DB.get(id);
        if (user == null) {
            throw new NotFoundException("User not found with id: " + id);
        }
        return user;
    }

    // Method that validates and throws ValidationException
    public static void validateUser(String name, String email) throws ValidationException {
        if (name == null || name.isBlank()) {
            throw new ValidationException("Name is required", "name");
        }
        if (email == null || !email.contains("@")) {
            throw new ValidationException("Valid email required", "email");
        }
    }

    // Method that simulates database connection failure
    public static void connectDatabase() throws DatabaseException {
        boolean connected = Math.random() > 0.3;  // 70% success rate
        if (!connected) {
            throw new DatabaseException("Connection timed out", 500);
        }
        System.out.println("Database connected successfully");
    }

    // Safe wrapper that catches and returns Result-like pattern
    public static record Result<T>(boolean success, T value, String error) {
        public static <T> Result<T> ok(T value) {
            return new Result<>(true, value, null);
        }
        public static <T> Result<T> fail(String error) {
            return new Result<>(false, null, error);
        }
    }

    public static Result<User> safeFindUser(int id) {
        try {
            return Result.ok(findUserById(id));
        } catch (NotFoundException e) {
            return Result.fail(e.getMessage());
        }
    }

    public static void main(String[] args) {
        // Test findUserById — success
        try {
            User alice = findUserById(1);
            System.out.println("Found: " + alice);
        } catch (NotFoundException e) {
            System.out.println("Error: " + e.getMessage());
        }

        // Test findUserById — not found
        try {
            User ghost = findUserById(999);
            System.out.println("Found: " + ghost);
        } catch (NotFoundException e) {
            System.out.println("Error: " + e.getMessage());
        }

        // Test validation
        System.out.println();
        try {
            validateUser("Alice", "alice@example.com");
            System.out.println("Validation passed for Alice");
        } catch (ValidationException e) {
            System.out.println("Validation error on " + e.getField() + ": " + e.getMessage());
        }

        try {
            validateUser("", "not-an-email");
            System.out.println("Validation passed");
        } catch (ValidationException e) {
            System.out.println("Validation error on " + e.getField() + ": " + e.getMessage());
        }

        // Test database connection
        System.out.println();
        for (int i = 0; i < 5; i++) {
            try {
                connectDatabase();
            } catch (DatabaseException e) {
                System.out.println("DB error (code " + e.getErrorCode() + "): " + e.getMessage());
            }
        }

        // Test safe wrapper
        System.out.println();
        Result<User> result1 = safeFindUser(1);
        System.out.println("Safe find 1: " + (result1.success() ? "Success: " + result1.value() : "Failed: " + result1.error()));

        Result<User> result2 = safeFindUser(999);
        System.out.println("Safe find 999: " + (result2.success() ? "Success: " + result2.value() : "Failed: " + result2.error()));
    }
}
