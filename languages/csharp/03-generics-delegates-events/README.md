# Project 03: Generics, Delegates, and Events — C#

**Difficulty:** intermediate  
**Prerequisites:** Project 02 (Classes, Structs, Interfaces)

## Goals

- Write generic classes and methods with type parameters
- Understand variance: `in` (contravariant) and `out` (covariant) type parameters
- Use delegates and lambda expressions as first-class values
- Create and consume events with `event` keyword and delegate types

## Concepts

- **Generics** — type parameters `<T>` on classes, methods, interfaces; constrained with `where`
- **Variance** — `out T` (covariant, producer), `in T` (contravariant, consumer) on interfaces and delegates
- **Delegates** — type-safe function references; `Func<T, TResult>`, `Action<T>`, custom delegate types
- **Lambda expressions** — `x => x * 2`, strongly typed via delegate/Func types
- **Events** — `event` keyword wrapper around delegates; publish-subscribe pattern with `+=`/`-=`
- **LINQ** — Language Integrated Query; extension methods on `IEnumerable<T>` (covered in depth in Project 04)

## Exercises

### Exercise 1: Generic Classes and Methods

Create `Generics.cs`:

```csharp
// Exercise 1: Generic Classes and Methods
// Generic type parameters let you write type-safe reusable code

using System;
using System.Collections.Generic;

// Generic class — type parameter T
public class Box<T>
{
    private T _content;

    public Box(T content) => _content = content;

    public T Get() => _content;
    public void Set(T newContent) => _content = newContent;

    public string Describe() => $"Box containing a {typeof(T).Name}";
}

// Generic method — type parameter on a method
public class CollectionUtils
{
    // Return a singleton list of T
    public static List<T> SingletonList<T>(T item) => new List<T> { item };

    // Swap two elements in an array (works for any type)
    public static void Swap<T>(T[] array, int i, int j)
    {
        if (i < 0 || i >= array.Length || j < 0 || j >= array.Length)
            throw new ArgumentOutOfRangeException();

        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

    // Find first element matching predicate
    public static T? FindFirst<T>(IEnumerable<T> source, Func<T, bool> predicate)
    {
        foreach (var item in source)
        {
            if (predicate(item))
                return item;
        }
        return default;
    }
}

// Generic interface with constraints
public interface IRepository<T> where T : class
{
    T? GetById(int id);
    void Save(T item);
    void Delete(int id);
}

// Constrained generic class
public class InMemoryRepository<T> : IRepository<T> where T : class
{
    private readonly Dictionary<int, T> _store = new();

    public T? GetById(int id) => _store.TryGetValue(id, out var item) ? item : null;

    public void Save(T item) => _store[item.GetHashCode()] = item;

    public void Delete(int id) => _store.Remove(id);
}

// Constraint examples:
// where T : class          — T must be a reference type
// where T : struct         — T must be a value type
// where T : new()          — T must have a parameterless constructor
// where T : IComparable<T> — T must implement IComparable<T>
// where T : BaseClass      — T must derive from BaseClass

class Program
{
    static void Main()
    {
        // Box<string>
        var stringBox = new Box<string>("Hello Generics");
        Console.WriteLine(stringBox.Describe());
        Console.WriteLine($"Box contains: {stringBox.Get()}");

        stringBox.Set("Updated content");
        Console.WriteLine($"Box now contains: {stringBox.Get()}");

        // Box<int>
        var intBox = new Box<int>(42);
        Console.WriteLine(intBox.Describe());
        Console.WriteLine($"Int box: {intBox.Get()}");

        // Generic method usage
        var singleInt = CollectionUtils.SingletonList(5);
        var singleString = CollectionUtils.SingletonList("hello");
        Console.WriteLine($"Singleton int list: [{string.Join(", ", singleInt)}]");
        Console.WriteLine($"Singleton string list: [{string.Join(", ", singleString)}]");

        // Swap
        int[] numbers = { 1, 2, 3, 4, 5 };
        Console.WriteLine($"Before swap: [{string.Join(", ", numbers)}]");
        CollectionUtils.Swap(numbers, 0, 4);
        Console.WriteLine($"After swap: [{string.Join(", ", numbers)}]");

        // FindFirst
        var result = CollectionUtils.FindFirst(numbers, n => n > 3);
        Console.WriteLine($"First number > 3: {result}");

        var notFound = CollectionUtils.FindFirst(numbers, n => n > 100);
        Console.WriteLine($"First number > 100: {notFound}");  // null (default for int? when nullable enabled)
    }
}
```

**Expected output:**

```
Box containing a String
Box contains: Hello Generics
Box now contains: Updated content
Box containing a Int32
Int box: 42
Singleton int list: [5]
Singleton string list: [hello]
Before swap: [1, 2, 3, 4, 5]
After swap: [5, 2, 3, 4, 1]
First number > 3: 5
First number > 100:
```

### Exercise 2: Delegates and Lambda Expressions

Create `Delegates.cs`:

```csharp
// Exercise 2: Delegates and Lambda Expressions
// Delegates are type-safe function references — C#'s answer to Kotlin's function types

using System;

// Custom delegate type — declares a function signature
public delegate int MathOperation(int x, int y);

// Built-in delegate types:
// Func<T, TResult>   — returns a value
// Action<T>          — returns void
// Predicate<T>       — returns bool (predicate)
// Comparison<T>      — returns int (comparison result)

class Program
{
    static void Main()
    {
        // Func<T, TResult> — built-in generic delegate
        Func<int, int, int> add = (a, b) => a + b;
        Func<int, int, int> multiply = (a, b) => a * b;

        Console.WriteLine($"3 + 4 = {add(3, 4)}");
        Console.WriteLine($"3 * 4 = {multiply(3, 4)}");

        // Method group conversion — method name converts to delegate automatically
        Func<string, string> toUpper = StringUtils.ToUpper;
        Console.WriteLine($"toUpper(\"hello\") = {toUpper("hello")}");

        // Action — no return value
        Action<string> print = Console.WriteLine;
        print("Hello from Action!");

        // Predicate — returns bool
        Predicate<int> isEven = n => n % 2 == 0;
        Console.WriteLine($"Is 4 even? {isEven(4)}");
        Console.WriteLine($"Is 7 even? {isEven(7)}");

        // Custom delegate type
        MathOperation subtract = (x, y) => x - y;
        Console.WriteLine($"10 - 6 = {subtract(10, 6)}");

        // Higher-order function — takes a delegate as parameter
        int Calculate(int x, int y, MathOperation op) => op(x, y);
        Console.WriteLine($"Calculate(5, 3, add) = {Calculate(5, 3, add)}");
        Console.WriteLine($"Calculate(5, 3, multiply) = {Calculate(5, 3, multiply)}");

        // Function factory — returns a delegate
        Func<int, Func<int, int>> makeMultiplier = n =>
        {
            return x => x * n;
        };

        var doubleFunc = makeMultiplier(2);
        var tripleFunc = makeMultiplier(3);
        Console.WriteLine($"Double 5: {doubleFunc(5)}");
        Console.WriteLine($"Triple 5: {tripleFunc(5)}");

        // Delegate composition — chain delegates with +
        Action combined = Console.Write;
        combined += s => Console.WriteLine();
        combined += s => Console.WriteLine("---");
        combined("Hello");   // calls all three in order
    }
}

// Static helper class for method group example
public static class StringUtils
{
    public static string ToUpper(string s) => s.ToUpper();
}
```

**Expected output:**

```
3 + 4 = 7
3 * 4 = 12
toUpper("hello") = HELLO
Hello from Action!
Is 4 even? True
Is 7 even? False
10 - 6 = 4
Calculate(5, 3, add) = 8
Calculate(5, 3, multiply) = 15
Double 5: 10
Triple 5: 15
Hello
---
```

### Exercise 3: Events

Create `Events.cs`:

```csharp
// Exercise 3: Events
// Events are a special kind of delegate — multicast, wrapped with event keyword
// Publishers raise events; subscribers register handlers with +=

using System;

// 1. Declare a delegate type for the event (or use EventHandler<T>)
// Traditional: public delegate void EventHandler(object sender, EventArgs e);
// Modern: use EventHandler<TEventArgs> from System

// Custom event args — carry data with the event
public class TemperatureEventArgs : EventArgs
{
    public double Temperature { get; }
    public DateTime Timestamp { get; }

    public TemperatureEventArgs(double temperature)
    {
        Temperature = temperature;
        Timestamp = DateTime.Now;
    }
}

// 2. Publisher class — raises events
public class Thermostat
{
    // Event declaration — wrapping a multicast delegate
    // EventHandler<T> is the standard pattern
    public event EventHandler<TemperatureEventArgs>? TemperatureChanged;

    private double _currentTemperature;

    public double CurrentTemperature
    {
        get => _currentTemperature;
        set
        {
            if (_currentTemperature != value)
            {
                _currentTemperature = value;
                // Raise the event — null-safe invocation
                TemperatureChanged?.Invoke(this, new TemperatureEventArgs(value));
            }
        }
    }
}

// Another publisher — uses a custom delegate type
public delegate void StockPriceChangedHandler(string symbol, double oldPrice, double newPrice);

public class StockTracker
{
    // Custom delegate-based event
    public event StockPriceChangedHandler? PriceChanged;

    private Dictionary<string, double> _prices = new();

    public void UpdatePrice(string symbol, double newPrice)
    {
        if (_prices.TryGetValue(symbol, out var oldPrice))
        {
            if (oldPrice != newPrice)
            {
                PriceChanged?.Invoke(symbol, oldPrice, newPrice);
            }
        }
        _prices[symbol] = newPrice;
    }
}

// 3. Subscriber — subscribes to events with lambda or method
public class TemperatureAlert
{
    public TemperatureAlert(Thermostat thermostat, double threshold)
    {
        thermostat.TemperatureChanged += (sender, args) =>
        {
            if (args.Temperature > threshold)
            {
                Console.WriteLine($"ALERT: Temperature {args.Temperature:F1}°C exceeds {threshold}°C at {args.Timestamp:HH:mm:ss}");
            }
        };
    }
}

public class PriceDisplay
{
    public void Subscribe(StockTracker tracker)
    {
        tracker.PriceChanged += (symbol, oldPrice, newPrice) =>
        {
            double change = newPrice - oldPrice;
            string direction = change >= 0 ? "▲" : "▼";
            Console.WriteLine($"Stock {symbol}: {direction} {Math.Abs(change):F2} (old: {oldPrice:F2}, new: {newPrice:F2})");
        };
    }
}

// Subscriber that unsubscribes
public class PriceLogger
{
    private readonly StreamWriter _log;

    public PriceLogger()
    {
        _log = new StreamWriter("prices.log");
    }

    public void Subscribe(StockTracker tracker)
    {
        tracker.PriceChanged += OnPriceChanged;
    }

    public void Unsubscribe(StockTracker tracker)
    {
        tracker.PriceChanged -= OnPriceChanged;
    }

    private void OnPriceChanged(string symbol, double oldPrice, double newPrice)
    {
        _log.WriteLine($"{DateTime.Now}: {symbol} {oldPrice:F2} -> {newPrice:F2}");
    }

    public void Close() => _log.Close();
}

class Program
{
    static void Main()
    {
        // Thermostat example
        Console.WriteLine("=== Thermostat Events ===");
        var thermostat = new Thermostat();
        var alert = new TemperatureAlert(thermostat, 30.0);

        thermostat.CurrentTemperature = 25.0;   // No alert
        thermostat.CurrentTemperature = 32.0;   // Alert!
        thermostat.CurrentTemperature = 28.0;   // No alert
        thermostat.CurrentTemperature = 35.5;   // Alert!

        // Stock tracker example
        Console.WriteLine("\n=== Stock Events ===");
        var tracker = new StockTracker();
        var display = new PriceDisplay();
        display.Subscribe(tracker);

        tracker.UpdatePrice("AAPL", 150.00);
        tracker.UpdatePrice("AAPL", 152.50);
        tracker.UpdatePrice("GOOG", 2800.00);
        tracker.UpdatePrice("AAPL", 149.00);
    }
}
```

**Expected output:**

```
=== Thermostat Events ===
ALERT: Temperature 32.0°C exceeds 30.0°C at HH:MM:SS
ALERT: Temperature 35.5°C exceeds 30.0°C at HH:MM:SS

=== Stock Events ===
Stock AAPL: ▲ 2.50 (old: 150.00, new: 152.50)
Stock GOOG: ▲ 2800.00 (old: 0.00, new: 2800.00)
Stock AAPL: ▼ 3.50 (old: 152.50, new: 149.00)
```

## Completion Checklist

- [ ] You can write a generic class `Box<T>` and generic method `SingletonList<T>`
- [ ] You understand generic constraints (`where T : class`, `where T : IComparable<T>`)
- [ ] You can write a generic interface `IRepository<T>`
- [ ] You can use built-in delegate types: `Func<T, TResult>`, `Action<T>`, `Predicate<T>`
- [ ] You can declare a custom delegate type with `delegate` keyword
- [ ] You can use lambda expressions as delegate values
- [ ] You can use method group conversion (method name → delegate)
- [ ] You can write higher-order functions that take/return delegates
- [ ] You can declare an event with `event` keyword
- [ ] You can raise events safely with `?.Invoke()`
- [ ] You can subscribe/unsubscribe with `+=`/`-=`
- [ ] You can define custom `EventArgs` subclasses

## Hints

- C# `Func<T1, T2, TResult>` is the closest equivalent to Kotlin's `(A, B) -> C` function type
- C# `Action<T>` is the equivalent of Kotlin's `(A) -> Unit` (void-returning function)
- Prefer `EventHandler<T>` for events — it's the .NET standard pattern
- The `?.Invoke()` pattern is thread-safe for events — avoids null reference if no subscribers
- Generic variance (`out`/`in`) is mainly useful for interfaces — delegates have variance too but it's less common
- Don't create custom delegate types unless you need named types for clarity — `Func` and `Action` cover most cases
