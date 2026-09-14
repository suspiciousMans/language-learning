public class Exercise3_Methods {
    public static void main(String[] args) {
        int sum = add(3, 5);
        System.out.println("3 + 5 = " + sum);

        double sumD = add(3.5, 5.2);
        System.out.println("3.5 + 5.2 = " + sumD);

        int[] minMax = minMax(new int[]{3, 7, 2, 9, 1});
        System.out.println("Min: " + minMax[0] + ", Max: " + minMax[1]);

        int x = 10;
        modifyPrimitive(x);
        System.out.println("After modifyPrimitive: " + x);

        MyClass obj = new MyClass(10);
        modifyObject(obj);
        System.out.println("After modifyObject: " + obj.value);
    }

    public static int add(int a, int b) {
        return a + b;
    }

    public static double add(double a, double b) {
        return a + b;
    }

    public static int[] minMax(int[] numbers) {
        int min = numbers[0];
        int max = numbers[0];
        for (int n : numbers) {
            if (n < min) min = n;
            if (n > max) max = n;
        }
        return new int[]{min, max};
    }

    public static void modifyPrimitive(int value) {
        value = 99;
    }

    public static void modifyObject(MyClass obj) {
        obj.value = 20;
    }

    static class MyClass {
        int value;
        MyClass(int v) { this.value = v; }
    }
}
