import java.util.*;
import java.util.stream.*;

public class Exercise3_Streams {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        List<Integer> evens = numbers.stream()
            .filter(n -> n % 2 == 0)
            .toList();
        System.out.println("Even numbers: " + evens);

        List<Integer> doubled = numbers.stream()
            .map(n -> n * 2)
            .toList();
        System.out.println("Doubled: " + doubled);

        List<String> result = numbers.stream()
            .filter(n -> n % 2 == 0)
            .map(n -> "Even: " + n)
            .toList();
        System.out.println("Filter+Map: " + result);

        int sum = numbers.stream()
            .reduce(0, Integer::sum);
        System.out.println("Sum: " + sum);

        int product = numbers.stream()
            .reduce(1, (a, b) -> a * b);
        System.out.println("Product: " + product);

        String joined = numbers.stream()
            .map(String::valueOf)
            .reduce("", (a, b) -> a + b + ", ");
        System.out.println("Joined: " + joined);

        List<Integer> unsorted = List.of(5, 2, 8, 1, 9, 3);
        List<Integer> sorted = unsorted.stream()
            .sorted()
            .toList();
        System.out.println("Sorted: " + sorted);

        List<String> words = List.of("apple", "banana", "apple", "cherry", "banana");
        List<String> distinct = words.stream()
            .distinct()
            .toList();
        System.out.println("Distinct: " + distinct);

        List<Integer> limited = numbers.stream()
            .skip(3)
            .limit(4)
            .toList();
        System.out.println("Skip 3, limit 4: " + limited);

        boolean hasEven = numbers.stream().anyMatch(n -> n % 2 == 0);
        boolean allPositive = numbers.stream().allMatch(n -> n > 0);
        boolean noNegative = numbers.stream().noneMatch(n -> n < 0);
        System.out.println("Has even: " + hasEven);
        System.out.println("All positive: " + allPositive);
        System.out.println("No negative: " + noNegative);

        Optional<Integer> firstEven = numbers.stream()
            .filter(n -> n % 2 == 0)
            .findFirst();
        System.out.println("First even: " + firstEven.orElse(-1));

        long evenCount = numbers.stream()
            .filter(n -> n % 2 == 0)
            .count();
        System.out.println("Even count: " + evenCount);
    }
}
