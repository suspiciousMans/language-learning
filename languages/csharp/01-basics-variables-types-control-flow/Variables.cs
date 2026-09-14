using System;

class Program
{
    static void Main()
    {
        // Immutable-by-convention: use readonly or const for constants
        const string LanguageName = "C#";
        const int FirstReleaseYear = 2000;

        // Mutable variable (use var for inference, or explicit type)
        var version = 8.0;           // inferred as double
        version = 9.0;              // reassignment is fine — var is not immutable

        // Explicit typing
        string message = $"Learning {LanguageName}";  // string interpolation

        Console.WriteLine($"{LanguageName} was released in {FirstReleaseYear} (version {version})");
        Console.WriteLine(message);

        // Value types vs reference types
        int number = 42;             // value type (int, bool, char, struct)
        string text = "Hello";      // reference type (string, class, array, delegate)
        bool flag = true;
        char letter = 'C';

        Console.WriteLine($"number={number}, flag={flag}, letter={letter}");

        // Type conversion
        double pi = 3.14159;
        int truncated = (int)pi;     // explicit cast — truncates to 3
        Console.WriteLine($"pi={pi}, truncated={truncated}");

        // Nullability (C# 8+ nullable reference types)
        string? nullableName = null;  // compiles with warning unless NRTs enabled
        string nonNullName = nullableName ?? "Unknown";  // null-coalescing operator
        Console.WriteLine($"Name or default: {nonNullName}");
    }
}
