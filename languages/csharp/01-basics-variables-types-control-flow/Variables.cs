// Exercise 1: Variables and Types
// C# types: int, double, string, bool, char, decimal, DateTime, etc.
// var is inferred but always mutable — use explicit types when clarity matters

class Program
{
    static void Main()
    {
        // Constants — compile-time immutable values
        const string LanguageName = "C#";
        const int FirstReleaseYear = 2000;

        // Mutable variable — var is inferred as double, but reassignable
        var version = 8.0;
        version = 9.0;

        // Explicit typing
        string message = $"Learning {LanguageName}";

        Console.WriteLine($"{LanguageName} was released in {FirstReleaseYear} (version {version})");
        Console.WriteLine(message);

        // Value types vs reference types
        int number = 42;
        string text = "Hello";
        bool flag = true;
        char letter = 'C';

        Console.WriteLine($"number={number}, flag={flag}, letter={letter}");

        // Type conversion
        double pi = 3.14159;
        int truncated = (int)pi;
        Console.WriteLine($"pi={pi}, truncated={truncated}");

        // Nullability — C# 8+ nullable reference types
        string? nullableName = null;
        string nonNullName = nullableName ?? "Unknown";
        Console.WriteLine($"Name or default: {nonNullName}");
    }
}
