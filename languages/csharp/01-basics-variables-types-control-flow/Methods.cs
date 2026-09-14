// Exercise 3: Methods
// C# methods: static, instance, expression-bodied, optional params, ref/out, extension methods

using System;

class Program
{
    // Expression-bodied method (C# 6+) — single expression, no braces
    static int Add(int a, int b) => a + b;

    // Method with optional parameter
    static void Greet(string name, string greeting = "Hello")
    {
        Console.WriteLine($"{greeting}, {name}!");
    }

    // Method returning a tuple (C# 7+) — like Kotlin's Pair
    static (int min, int max) MinMax(int[] numbers)
    {
        if (numbers == null || numbers.Length == 0)
            return (0, 0);

        int min = numbers[0];
        int max = numbers[0];
        foreach (var n in numbers)
        {
            if (n < min) min = n;
            if (n > max) max = n;
        }
        return (min, max);
    }

    // Method with params array (variable arguments)
    static double Average(params double[] values)
    {
        if (values.Length == 0) return 0;
        double sum = 0;
        foreach (var v in values)
            sum += v;
        return sum / values.Length;
    }

    // Extension method — appears as instance method on the extended type
    static int WordCount(this string s)
    {
        return s.Split(new[] { ' ', '\t', '\n' }, StringSplitOptions.RemoveEmptyEntries).Length;
    }

    static void Main()
    {
        Console.WriteLine($"3 + 5 = {Add(3, 5)}");

        Greet("Alice");
        Greet("Bob", "Hi");

        int[] numbers = { 3, 7, 2, 9, 1 };
        var (min, max) = MinMax(numbers);   // deconstruction — like Kotlin destructuring
        Console.WriteLine($"Min: {min}, Max: {max}");

        Console.WriteLine($"Average of 1,2,3,4,5 = {Average(1, 2, 3, 4, 5)}");
        Console.WriteLine($"Average of 10,20 = {Average(10, 20)}");

        string sentence = "The quick brown fox jumps";
        Console.WriteLine($"Word count: {sentence.WordCount()}");
    }
}
