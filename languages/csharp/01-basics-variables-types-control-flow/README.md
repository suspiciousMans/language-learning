# Project 01: Basics — C#

**Difficulty:** beginner  
**Prerequisites:** Project 00 (Tooling Check)

## Goals

- Understand C#'s basic syntax: variables, types, control flow, functions
- Write and run simple C# console programs
- Compare C# syntax with Kotlin (if you know it)

## Concepts

- **`var` vs explicit types** — C#'s `var` is inferred but mutable; C# has no `val`/`var` immutability distinction
- **String interpolation** — `$"text {variable} text"` (C# 6+)
- **`if`/`else`**, **`switch`** expressions (C# 8+), **`switch`** statements
- **Methods** — static vs instance, `void` vs return type, optional parameters, expression-bodied members
- **Top-level statements** — no `Main` boilerplate needed in C# 9+ console apps

## Exercises

### Exercise 1: Variables and Types

Create `Variables.cs`:

```csharp
// Exercise 1: Variables and Types
// C# types: int, double, string, bool, char, decimal, DateTime, etc.
// var is inferred but always mutable — use explicit types when clarity matters

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
```

**Compile and run:**

```bash
dotnet new console -n Basics -o .
# Replace Program.cs content with Variables.cs content, or rename
dotnet run
```

**Expected output:**

```
C# was released in 2000 (version 9.0)
Learning C#
number=42, flag=True, letter=C
pi=3.14159, truncated=3
Name or default: Unknown
```

**Note:** C# `var` is **not** immutable like Kotlin's `val`. It's just type inference. To make a variable that can't be reassigned, use `readonly` fields or `const` for compile-time constants.

### Exercise 2: Control Flow

Create `ControlFlow.cs`:

```csharp
// Exercise 2: Control Flow
// C# has if/else, switch (statement + expression), for, foreach, while, do-while

class Program
{
    static void Main()
    {
        int score = 87;

        // if-else (statement — no expression form in C#, no direct value return)
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

        // Switch expression (C# 8+) — returns a value, like Kotlin's when
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

        // For loop with traditional syntax
        Console.Write("Counting 1 to 5: ");
        for (int i = 1; i <= 5; i++)
        {
            Console.Write($"{i} ");
        }
        Console.WriteLine();

        // Foreach loop (idiomatic in C# for collections)
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

        // Pattern matching in switch (C# 8+)
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
```

**Compile and run.**

**Expected output:**

```
Score: 87 → Grade: B
Day 3 is Wednesday
Counting 1 to 5: 1 2 3 4 5
Fruits: apple banana cherry
5...4...3...2...1...Go!
Integer: 42
String: hello
Double: 3.14
Null
```

### Exercise 3: Methods (Functions)

Create `Methods.cs`:

```csharp
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
```

**Compile and run.**

**Expected output:**

```
3 + 5 = 8
Hello, Alice!
Hi, Bob!
Min: 1, Max: 9
Average of 1,2,3,4,5 = 3
Average of 10,20 = 15
Word count: 5
```

## Completion Checklist

- [ ] You understand `var` (type inference) vs explicit types in C#
- [ ] You understand that C# `var` is mutable — there's no `val`/`var` immutability distinction
- [ ] You can use string interpolation `$"text {expr}"`
- [ ] You can write `if`/`else` chains
- [ ] You can use `switch` expressions (C# 8+)
- [ ] You can use `for`, `foreach`, `while` loops
- [ ] You can write static and instance methods
- [ ] You can write expression-bodied members `=> expr`
- [ ] You can use optional parameters
- [ ] You can return and deconstruct tuples
- [ ] You understand nullable reference types (`string?`) and the null-coalescing operator (`??`)

## Hints

- Read the official C# docs: https://learn.microsoft.com/dotnet/csharp/
- C# `switch` expressions are the closest equivalent to Kotlin's `when` — they return a value
- `foreach` is the idiomatic iteration construct in C# — prefer it over `for` when walking collections
- Tuples `(int, string)` and deconstruction `var (a, b) = tuple` are C#'s answer to Kotlin's `Pair` and destructuring
- Extension methods let you "add" methods to existing types — they're static methods with `this` on the first parameter
