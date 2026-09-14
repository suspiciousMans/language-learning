import java.util.*;

public class Exercise1_Collections {
    public static void main(String[] args) {
        List<String> tasks = new ArrayList<>();
        tasks.add("read docs");
        tasks.add("write code");
        tasks.add("test");
        tasks.add("deploy");
        System.out.println("Initial tasks: " + tasks);

        tasks.add("review PR");
        tasks.remove(0);
        System.out.println("After add/remove: " + tasks);

        Collections.sort(tasks);
        System.out.println("Sorted: " + tasks);

        Collections.reverse(tasks);
        System.out.println("Reversed: " + tasks);

        Collections.shuffle(tasks);
        System.out.println("Shuffled: " + tasks);

        Set<String> uniqueWords = new HashSet<>();
        uniqueWords.add("apple");
        uniqueWords.add("banana");
        uniqueWords.add("apple");
        System.out.println();
        System.out.println("HashSet: " + uniqueWords);

        Set<Integer> sortedNumbers = new TreeSet<>();
        sortedNumbers.addAll(Arrays.asList(5, 2, 8, 1, 9, 3));
        System.out.println("TreeSet (sorted): " + sortedNumbers);

        Map<String, Integer> ages = new HashMap<>();
        ages.put("Alice", 30);
        ages.put("Bob", 25);
        ages.put("Charlie", 35);
        System.out.println();
        System.out.println("Age map: " + ages);

        int aliceAge = ages.getOrDefault("Alice", 0);
        int daveAge = ages.getOrDefault("Dave", 0);
        System.out.println("Alice age: " + aliceAge + ", Dave age: " + daveAge);

        ages.putIfAbsent("Bob", 99);
        ages.putIfAbsent("Dave", 40);
        System.out.println("After putIfAbsent: " + ages);

        System.out.println();
        System.out.println("Map entries:");
        for (Map.Entry<String, Integer> entry : ages.entrySet()) {
            System.out.printf("  %s: %d%n", entry.getKey(), entry.getValue());
        }

        Map<String, String> users = new HashMap<>();
        users.put("alice", "alice@example.com");
        users.compute("alice", (k, v) -> v != null ? v.toUpperCase() : "NEW");
        users.compute("bob", (k, v) -> v != null ? v.toUpperCase() : "NEW@EXAMPLE.COM");
        System.out.println();
        System.out.println("Users after compute: " + users);

        Map<String, Integer> scores = new HashMap<>();
        scores.put("Alice", 100);
        scores.merge("Alice", 50, Integer::sum);
        scores.merge("Bob", 50, Integer::sum);
        System.out.println("Scores after merge: " + scores);
    }
}
