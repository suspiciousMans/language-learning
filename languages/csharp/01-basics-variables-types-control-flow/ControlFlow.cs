// Exercise 2: Control Flow
// C# has if/else, switch (statement + expression), for, foreach, while, do-while

class Program
{
    static void Main()
    {
        int score = 87;

        // if-else
        string grade;
        if (score >= 90)
            grade = "A";
        else if (score >= 80)
            grade = "B";
        else if (score >= 70)
            grade = "C";
        else
            grade = "F";

        Console.WriteLine($"Score: {score} → Grade: {grade}");

        // Switch expression (C# 8+) — returns a value
        int day = 3;
        string dayName = day switch
        {
            1 => "Monday",
            2 => "Tuesday",
            3 => "Wednesday",
            4 => "Thursday",
            5 => "Friday",
            6 or 7 => "Weekend",
            _ => "Unknown"
        };
        Console.WriteLine($"Day {day} is {dayName}");

        // For loop
        Console.Write("Counting 1 to 5: ");
        for (int i = 1; i <= 5; i++)
        {
            Console.Write($"{i} ");
        }
        Console.WriteLine();

        // Foreach loop
        string[] fruits = { "apple", "banana", "cherry" };
        Console.Write("Fruits: ");
        foreach (var fruit in fruits)
        {
            Console.Write($"{fruit} ");
        }
        Console.WriteLine();

        // While loop
        int countdown = 5;
        while (countdown > 0)
        {
            Console.Write($"{countdown}...");
            countdown--;
        }
        Console.WriteLine("Go!");

        // Pattern matching in switch
        object[] items = { 42, "hello", 3.14, null };
        foreach (var item in items)
        {
            string description = item switch
            {
                int i => $"Integer: {i}",
                string s => $"String: {s}",
                double d => $"Double: {d}",
                null => "Null",
                _ => "Unknown type"
            };
            Console.WriteLine(description);
        }
    }
}
