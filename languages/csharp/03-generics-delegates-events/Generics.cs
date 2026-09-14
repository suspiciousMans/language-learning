// Exercise 1: Generics
// Generic classes and methods — type parameters that are resolved at usage time

using System;
using System.Collections.Generic;

// Generic class — type parameter T is specified when constructing
public class Box<T>
{
    public T? Value { get; set; }

    public Box(T? value)
    {
        Value = value;
    }

    public override string ToString() => $"Box({Value})";
}

// Generic class with multiple type parameters
public class KeyValue<TKey, TValue>
{
    public TKey Key { get; }
    public TValue Value { get; }

    public KeyValue(TKey key, TValue value)
    {
        Key = key;
        Value = value;
    }

    public override string ToString() => $"[{Key}] = {Value}";
}

// Generic method — type parameter inferred from arguments
public static class Utils
{
    public static T SingletonList<T>(T item) => new List<T> { item };
    public static void Swap<T>(ref T a, ref T b)
    {
        var temp = a;
        a = b;
        b = temp;
    }
}

// Generic interface
public interface IRepository<T>
{
    void Add(T item);
    IEnumerable<T> GetAll();
    bool Contains(T item);
}

// Generic class with constraint: T must be a reference type (class)
public class StringBox : Box<string>
{
    public StringBox(string? value) : base(value) { }
}

// Generic class with constraint: T must implement IComparable<T>
public class SortedBox<T> where T : IComparable<T>
{
    private List<T> _items = new();

    public void Add(T item) => _items.Add(item);
    public IEnumerable<T> GetSorted() => _items.OrderBy(x => x);
}

class Program
{
    static void Main()
    {
        // Box<int>
        var intBox = new Box<int>(42);
        Console.WriteLine(intBox);

        // Box<string>
        var stringBox = new Box<string>("Hello");
        Console.WriteLine(stringBox);

        // KeyValue<string, double>
        var stock = new KeyValue<string, double>("AAPL", 150.25);
        Console.WriteLine(stock);

        // SingletonList — type inferred
        var list1 = Utils.SingletonList(42);      // List<int>
        var list2 = Utils.SingletonList("hi");    // List<string>
        Console.WriteLine($"Singleton: {list1[0]}");
        Console.WriteLine($"Singleton: {list2[0]}");

        // Swap — ref types
        int x = 10, y = 20;
        Utils.Swap(ref x, ref y);
        Console.WriteLine($"After swap: x={x}, y={y}");

        // IRepository<int>
        IRepository<int> numbers = new ListRepository<int>();
        numbers.Add(1);
        numbers.Add(2);
        numbers.Add(3);
        Console.WriteLine($"Repository has {numbers.GetAll().Count()} items");

        // SortedBox<int> — constraint proven
        var sorted = new SortedBox<int>();
        sorted.Add(3);
        sorted.Add(1);
        sorted.Add(2);
        Console.WriteLine("Sorted: " + string.Join(", ", sorted.GetSorted()));
    }
}

// Simple implementation of IRepository<T>
public class ListRepository<T> : IRepository<T>
{
    private List<T> _items = new();
    public void Add(T item) => _items.Add(item);
    public IEnumerable<T> GetAll() => _items;
    public bool Contains(T item) => _items.Contains(item);
}
