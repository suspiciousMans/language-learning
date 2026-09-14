import java.util.*;
import java.util.stream.*;

public class Exercise4_Collectors {
    record Person(String name, int age, String city, double salary) {}

    public static void main(String[] args) {
        List<Person> people = List.of(
            new Person("Alice", 30, "NYC", 85000),
            new Person("Bob", 25, "LA", 65000),
            new Person("Charlie", 35, "NYC", 95000),
            new Person("Diana", 28, "SF", 75000),
            new Person("Eve", 32, "LA", 70000),
            new Person("Frank", 40, "NYC", 120000)
        );

        List<String> names = people.stream()
            .map(Person::name)
            .toList();
        System.out.println("All names: " + names);

        Map<String, Integer> nameToAge = people.stream()
            .collect(Collectors.toMap(Person::name, Person::age));
        System.out.println("Name to age: " + nameToAge);

        Map<String, List<Person>> byCity = people.stream()
            .collect(Collectors.groupingBy(Person::city));
        System.out.println();
        System.out.println("People by city:");
        byCity.forEach((city, persons) -> {
            System.out.println("  " + city + ": " + persons.stream()
                .map(Person::name).collect(Collectors.joining(", ")));
        });

        Map<String, Long> countByCity = people.stream()
            .collect(Collectors.groupingBy(Person::city, Collectors.counting()));
        System.out.println();
        System.out.println("Count by city: " + countByCity);

        Map<String, Double> avgSalaryByCity = people.stream()
            .collect(Collectors.groupingBy(Person::city,
                Collectors.averagingDouble(Person::salary)));
        System.out.println("Average salary by city: " + avgSalaryByCity);

        Map<Boolean, List<Person>> byAgeThreshold = people.stream()
            .collect(Collectors.partitioningBy(p -> p.age() >= 30));
        System.out.println();
        System.out.println("Age >= 30: " + byAgeThreshold.get(true).stream()
            .map(Person::name).collect(Collectors.joining(", ")));
        System.out.println("Age < 30: " + byAgeThreshold.get(false).stream()
            .map(Person::name).collect(Collectors.joining(", ")));

        String nameList = people.stream()
            .map(Person::name)
            .collect(Collectors.joining(", ", "[", "]"));
        System.out.println();
        System.out.println("Name list: " + nameList);

        DoubleSummaryStatistics salaryStats = people.stream()
            .collect(Collectors.summarizingDouble(Person::salary));
        System.out.println();
        System.out.println("Salary stats:");
        System.out.println("  Count: " + salaryStats.getCount());
        System.out.println("  Sum: " + salaryStats.getSum());
        System.out.println("  Min: " + salaryStats.getMin());
        System.out.println("  Max: " + salaryStats.getMax());
        System.out.println("  Average: " + String.format("%.2f", salaryStats.getAverage()));

        List<String> allCities = people.stream()
            .map(p -> List.of(p.city(), p.city() + "-area"))
            .flatMap(Collection::stream)
            .distinct()
            .toList();
        System.out.println();
        System.out.println("All city references: " + allCities);
    }
}
