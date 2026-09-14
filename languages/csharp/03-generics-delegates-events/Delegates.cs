// Exercise 2: Delegates
// Delegates are type-safe function references — the foundation of events and lambdas

using System;

// Declare a custom delegate type
public delegate int MathOperation(int a, int b);

public class Program
{
    // Regular method matching delegate signature
    static int Add(int a, int b) => a + b;
    static int Multiply(int a, int b) => a * b;

    // Lambda expressions — anonymous functions
    static void Main()
    {
        // Delegate variable — points to a method
        MathOperation op = Add;
        Console.WriteLine($"Add(3, 5) = {op(3, 5)}");   // 8

        // Reassign to another method
        op = Multiply;
        Console.WriteLine($"Multiply(3, 5) = {op(3, 5)}");  // 15

        // Lambda as delegate value
        MathOperation subtract = (a, b) => a - b;
        Console.WriteLine($"Subtract(10, 4) = {subtract(10, 4)}");  // 6

        // Using built-in delegate types (no custom delegate needed)
        Func<int, int, int> funcAdd = (a, b) => a + b;
        Console.WriteLine($"Func: Add(7, 6) = {funcAdd(7, 6)}");

        Action<string> greet = name => Console.WriteLine($"Hello, {name}!");
        greet("World");

        // Predicate<T> — returns bool (like Kotlin's (T) -> Boolean)
        Predicate<int> isEven = n => n % 2 == 0;
        Console.WriteLine($"Is 7 even? {isEven(7)}");   // False
        Console.WriteLine($"Is 8 even? {isEven(8)}");   // True

        // Higher-order function — takes a delegate
        int ApplyOperation(int a, int b, MathOperation operation)
        {
            Console.WriteLine($"Applying operation: {a} ? {b}");
            return operation(a, b);
        }

        Console.WriteLine($"Apply Add: {ApplyOperation(3, 4, Add)}");        // 7
        Console.WriteLine($"Apply Lambda: {ApplyOperation(3, 4, (a, b) => a * b + 1)}");  // 13

        // Method group conversion — method name implicitly converts to delegate
        Func<int> getRandom = new Random().Next;
        Console.WriteLine($"Random: {getRandom()}");

        // Delegates compose with LINQ
        var numbers = new[] { 1, 2, 3, 4, 5, 6 };
        var evens = numbers.Where(n => n % 2 == 0);
        Console.WriteLine($"Evens: {string.Join(", ", evens)}");
    }
}
