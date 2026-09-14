import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Exercise5_Arrays {
    public static void main(String[] args) {
        int[] numbers = new int[]{5, 2, 8, 1, 9, 3};
        System.out.println("First element: " + numbers[0]);
        System.out.println("Array length: " + numbers.length);
        numbers[0] = 10;
        System.out.println("After modification: " + Arrays.toString(numbers));

        List<String> tasks = new ArrayList<>();
        tasks.add("read docs");
        tasks.add("write code");
        tasks.add("test");
        tasks.add("deploy");
        System.out.println("Initial tasks: " + tasks);
        tasks.add("review PR");
        tasks.remove(0);
        System.out.println("After remove first and add: " + tasks);

        System.out.print("Uppercase tasks: ");
        for (String task : tasks) {
            System.out.print(task.toUpperCase() + " ");
        }
        System.out.println();

        String[] fruits = {"apple", "banana", "cherry"};
        List<String> fruitList = Arrays.asList(fruits);
        System.out.println("As list: " + fruitList);
    }
}
