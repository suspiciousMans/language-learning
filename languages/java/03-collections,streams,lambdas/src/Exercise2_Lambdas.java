import java.util.function.*;
import java.time.LocalDate;
import java.util.Random;

public class Exercise2_Lambdas {
    public static void main(String[] args) {
        Predicate<String> isLong = s -> s.length() > 5;
        System.out.println("isLong('hello'): " + isLong.test("hello"));
        System.out.println("isLong('greetings'): " + isLong.test("greetings"));

        Function<String, Integer> strLength = String::length;
        System.out.println("Length of 'Java': " + strLength.apply("Java"));

        Function<String, String> toUpper = String::toUpperCase;
        Function<String, String> addExclaim = s -> s + "!!!";
        Function<String, String> pipeline = toUpper.andThen(addExclaim);
        System.out.println("Pipeline 'hello': " + pipeline.apply("hello"));

        Consumer<String> printer = System.out::println;
        printer.accept("Hello from Consumer!");

        Consumer<String> log = s -> System.out.println("[LOG] " + s);
        Consumer<String> process = s -> System.out.println("[PROCESS] " + s);
        Consumer<String> combined = log.andThen(process);
        combined.accept("test message");

        Supplier<LocalDate> today = LocalDate::now;
        System.out.println("Today: " + today.get());

        Supplier<Random> randomSupplier = Random::new;
        Random random = randomSupplier.get();
        System.out.println("Random int: " + random.nextInt(100));

        UnaryOperator<String> trimAndUpper = s -> s.trim().toUpperCase();
        System.out.println("Trim+Upper '  hello  ': " + trimAndUpper.apply("  hello  "));

        BinaryOperator<Integer> multiply = (a, b) -> a * b;
        System.out.println("6 * 7 = " + multiply.apply(6, 7));

        @FunctionalInterface
        interface MathOperation {
            int operate(int a, int b);
        }

        MathOperation add = (a, b) -> a + b;
        MathOperation subtract = (a, b) -> a - b;
        MathOperation multiplyOp = (a, b) -> a * b;

        System.out.println();
        System.out.println("Custom functional interface:");
        System.out.println("add(10, 5): " + add.operate(10, 5));
        System.out.println("subtract(10, 5): " + subtract.operate(10, 5));
        System.out.println("multiply(10, 5): " + multiplyOp.operate(10, 5));
    }
}
