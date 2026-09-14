public class Exercise2_ControlFlow {
    public static void main(String[] args) {
        int score = 87;
        String grade;
        if (score >= 90) {
            grade = "A";
        } else if (score >= 80) {
            grade = "B";
        } else {
            grade = "C";
        }
        System.out.println("Score: " + score + " -> Grade: " + grade);

        int day = 3;
        String dayName;
        switch (day) {
            case 1: dayName = "Monday"; break;
            case 2: dayName = "Tuesday"; break;
            case 3: dayName = "Wednesday"; break;
            case 4: dayName = "Thursday"; break;
            case 5: dayName = "Friday"; break;
            case 6:
            case 7: dayName = "Weekend"; break;
            default: dayName = "Unknown";
        }
        System.out.println("Day " + day + " is " + dayName);

        String season = switch (month(7)) {
            case 12, 1, 2 -> "Winter";
            case 3, 4, 5  -> "Spring";
            case 6, 7, 8  -> "Summer";
            case 9, 10, 11 -> "Fall";
            default -> "Unknown";
        };
        System.out.println("Month 7 is in: " + season);

        System.out.print("Counting 1 to 5: ");
        for (int i = 1; i <= 5; i++) {
            System.out.print(i + " ");
        }
        System.out.println();

        String[] fruits = {"apple", "banana", "cherry"};
        System.out.print("Fruits: ");
        for (String fruit : fruits) {
            System.out.print(fruit + " ");
        }
        System.out.println();

        int countdown = 5;
        while (countdown > 0) {
            System.out.print(countdown + "...");
            countdown--;
        }
        System.out.println("Go!");
    }

    private static int month(int m) { return m; }
}
