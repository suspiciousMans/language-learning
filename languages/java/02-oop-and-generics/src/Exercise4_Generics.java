import java.util.Arrays;
import java.util.List;

class Box<T> {
    private T content;

    public void set(T content) { this.content = content; }
    public T get() { return content; }

    public String describe() {
        return "Box containing a " + (content != null ? content.getClass().getSimpleName() : "null");
    }
}

class Utils {
    public static <T> T first(List<T> list) {
        if (list == null || list.isEmpty()) return null;
        return list.get(0);
    }

    public static <T> void swap(T[] array, int i, int j) {
        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    public static <T extends Comparable<T>> T min(T a, T b) {
        return a.compareTo(b) < 0 ? a : b;
    }
}

public class Exercise4_Generics {
    public static void main(String[] args) {
        Box<String> stringBox = new Box<>();
        stringBox.set("Hello, Generics!");
        System.out.println(stringBox.describe());
        System.out.println("Content: " + stringBox.get());

        Box<Integer> intBox = new Box<>();
        intBox.set(42);
        System.out.println(intBox.describe());
        System.out.println("Content: " + intBox.get());

        Box<Double> doubleBox = new Box<>();
        doubleBox.set(3.14);
        System.out.println("Double box: " + doubleBox.get());

        List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
        String first = Utils.first(names);
        System.out.println("First name: " + first);

        Integer[] numbers = {5, 2, 8, 1, 9};
        System.out.println("Before swap: " + Arrays.toString(numbers));
        Utils.swap(numbers, 0, 3);
        System.out.println("After swap (0 <-> 3): " + Arrays.toString(numbers));

        System.out.println("Min of 10 and 20: " + Utils.min(10, 20));
        System.out.println("Min of 'z' and 'a': " + Utils.min("z", "a"));
    }
}
