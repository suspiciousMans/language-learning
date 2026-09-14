public class Exercise4_String {
    public static void main(String[] args) {
        String greet = "Hello";
        String name = "Alice";
        String message = greet + ", " + name + "!";
        System.out.println(message);

        String text = "  Java Programming  ";
        System.out.println("Trimmed: '" + text.trim() + "'");
        System.out.println("Upper: " + text.toUpperCase());
        System.out.println("Contains 'Java': " + text.contains("Java"));
        System.out.println("Substring (5,10): " + text.substring(5, 10));
        System.out.println("Replace 'Java' with 'Kotlin': " + text.replace("Java", "Kotlin"));
        System.out.println("Split by space: " + String.join(", ", text.trim().split("\\s+")));

        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= 1000; i++) {
            sb.append(i).append(", ");
        }
        String result = sb.toString();
        System.out.println("First 50 chars: " + result.substring(0, 50) + "...");

        String formatted = String.format("Pi is approximately %.5f", Math.PI);
        System.out.println(formatted);

        String a = new String("hello");
        String b = new String("hello");
        System.out.println("a == b: " + (a == b));
        System.out.println("a.equals(b): " + a.equals(b));
    }
}
