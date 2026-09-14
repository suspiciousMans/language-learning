public class Exercise1_BasicExceptions {
    public static void main(String[] args) {
        try {
            int result = divide(10, 0);
            System.out.println("Result: " + result);
        } catch (ArithmeticException e) {
            System.out.println("Caught arithmetic error: " + e.getMessage());
        }

        try {
            int result = divide(10, 2);
            System.out.println("10 / 2 = " + result);
        } catch (ArithmeticException e) {
            System.out.println("Error: " + e.getMessage());
        }

        int[] numbers = {1, 2, 3};
        try {
            System.out.println("Element at index 5: " + numbers[5]);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Array bounds error: " + e.getMessage());
        }

        String text = null;
        try {
            int len = text.length();
            System.out.println("Length: " + len);
        } catch (NullPointerException e) {
            System.out.println("Null pointer: " + e.getMessage());
        }

        int[] data = {10, 20, 30};
        int index = 0;
        try {
            index = 5;
            int value = data[index];
            System.out.println("Got value: " + value);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Catch: " + e.getMessage());
        } finally {
            System.out.println("Finally: index was " + index);
        }

        try {
            int[] arr = new int[5];
            arr[10] = 50;
        } catch (ArrayIndexOutOfBoundsException | NullPointerException e) {
            System.out.println("Multi-catch: " + e.getClass().getSimpleName());
        }

        try {
            parseInteger("not-a-number");
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid input provided", e);
        }
    }

    public static int divide(int a, int b) {
        return a / b;
    }

    public static int parseInteger(String s) {
        return Integer.parseInt(s);
    }
}
