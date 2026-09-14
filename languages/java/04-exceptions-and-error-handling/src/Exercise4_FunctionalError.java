import java.util.function.*;
import java.util.Optional;

public class Exercise4_FunctionalError {
    // Optional — for "no result" not "error"
    public static Optional<String> findUserEmail(int id) {
        java.util.Map<Integer, String> db = java.util.Map.of(
            1, "alice@example.com",
            2, "bob@example.com"
        );
        return Optional.ofNullable(db.get(id));
    }

    // Function that might throw — wrap in Optional
    public static Optional<Integer> parseAge(String input) {
        try {
            int age = Integer.parseInt(input);
            if (age < 0 || age > 150) {
                return Optional.empty();  // Invalid range
            }
            return Optional.of(age);
        } catch (NumberFormatException e) {
            return Optional.empty();  // Not a number
        }
    }

    // Chain Optional operations
    public static void main(String[] args) {
        // Basic Optional usage
        Optional<String> email1 = findUserEmail(1);
        System.out.println("User 1 email: " + email1.orElse("unknown@example.com"));

        Optional<String> email2 = findUserEmail(999);
        System.out.println("User 999 email: " + email2.orElse("unknown@example.com"));

        // isPresent / ifPresent
        Optional<String> email3 = findUserEmail(2);
        if (email3.isPresent()) {
            System.out.println("User 2 has email: " + email3.get());
        }
        email3.ifPresent(e -> System.out.println("IfPresent: " + e));

        // orElseGet — lazy evaluation
        Optional<String> empty = Optional.empty();
        System.out.println("Empty or default: " + empty.orElseGet(() -> generateDefaultEmail()));

        // orElseThrow — fail fast
        try {
            empty.orElseThrow(() -> new IllegalArgumentException("No email found"));
        } catch (IllegalArgumentException e) {
            System.out.println("orElseThrow: " + e.getMessage());
        }

        // map and flatMap on Optional
        Optional<String> upperEmail = findUserEmail(1)
            .map(String::toUpperCase);
        System.out.println("Upper email: " + upperEmail.orElse("N/A"));

        // parseAge with Optional
        Optional<Integer> age1 = parseAge("25");
        Optional<Integer> age2 = parseAge("-5");
        Optional<Integer> age3 = parseAge("not-a-number");

        System.out.println("Age '25': " + age1.map(String::valueOf).orElse("Invalid"));
        System.out.println("Age '-5': " + age2.map(String::valueOf).orElse("Invalid"));
        System.out.println("Age 'abc': " + age3.map(String::valueOf).orElse("Invalid"));

        // Chain: parse age, then check voting eligibility
        String input = "20";
        boolean canVote = parseAge(input)
            .filter(age -> age >= 18)
            .isPresent();
        System.out.println("Can vote (age 20): " + canVote);

        String input2 = "16";
        canVote = parseAge(input2)
            .filter(age -> age >= 18)
            .isPresent();
        System.out.println("Can vote (age 16): " + canVote);

        // Optional with ifPresentOrElse (Java 9+)
        findUserEmail(1).ifPresentOrElse(
            email -> System.out.println("Found email: " + email),
            () -> System.out.println("No email found")
        );

        findUserEmail(999).ifPresentOrElse(
            email -> System.out.println("Found email: " + email),
            () -> System.out.println("No email found")
        );
    }

    private static String generateDefaultEmail() {
        System.out.println("  Generating default email...");
        return "default@example.com";
    }
}
