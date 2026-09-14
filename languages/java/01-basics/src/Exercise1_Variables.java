public class Exercise1_Variables {
    public static void main(String[] args) {
        int year = 1995;
        double version = 17.0;
        boolean isLTS = true;
        String name = "Java";
        var message = name + " was released in " + year;

        System.out.printf("%s released in %d (version %.1f)%n", name, year, version);
        System.out.println(message);
        System.out.println("Is LTS: " + isLTS);

        int codePoint = 65;
        char letter = (char) codePoint;
        System.out.println("Char from code point: " + letter);

        byte small = 127;
        short medium = 32767;
        long big = 9_223_372_036_854_775_807L;
        System.out.println("Big number: " + big);
    }
}
