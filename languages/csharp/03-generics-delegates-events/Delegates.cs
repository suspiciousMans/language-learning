// Exercise 2: Delegates and Lambda Expressions

using System;

// Custom delegate type
public delegate int MathOperation(int x, int y);

class Program
{
    static void Main()
    {
        Func<int, int, int> add = (a, b) => a + b;
        Func<int, int, int> multiply = (a, b) => a * b;

        Console.WriteLine($"3 + 4 = {add(3, 4)}");
        Console.WriteLine($"3 * 4 = {multiply(3, 4)}");

        Func<string, string> toUpper = StringUtils.ToUpper;
        Console.WriteLine($"toUpper(\"hello\") = {toUpper("hello")}");

        Action<string> print = Console.WriteLine;
        print("Hello from Action!");

        Predicate<int> isEven = n => n % 2 == 0;
        Console.WriteLine($"Is 4 even? {isEven(4)}");
        Console.WriteLine($"Is 7 even? {isEven(7)}");

        MathOperation subtract = (x, y) => x - y;
        Console.WriteLine($"10 - 6 = {subtract(10, 6)}");

        int Calculate(int x, int y, MathOperation op) => op(x, y);
        Console.WriteLine($"Calculate(5, 3, add) = {Calculate(5, 3, add)}");
        Console.WriteLine($"Calculate(5, 3, multiply) = {Calculate(5, 3, multiply)}");

        Func<int, Func<int, int>> makeMultiplier = n =>
        {
            return x => x * n;
        };

        var doubleFunc = makeMultiplier(2);
        var tripleFunc = makeMultiplier(3);
        Console.WriteLine($"Double 5: {doubleFunc(5)}");
        Console.WriteLine($"Triple 5: {tripleFunc(5)}");

        Action combined = Console.Write;
        combined += s => Console.WriteLine();
        combined += s => Console.WriteLine("---");
        combined("Hello");
    }
}

public static class StringUtils
{
    public static string ToUpper(string s) => s.ToUpper();
}
