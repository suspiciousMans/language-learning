// Exercise 1: Generic Classes and Methods

using System;
using System.Collections.Generic;

public class Box<T>
{
    private T _content;

    public Box(T content) => _content = content;
    public T Get() => _content;
    public void Set(T newContent) => _content = newContent;
    public string Describe() => $"Box containing a {typeof(T).Name}";
}

public class CollectionUtils
{
    public static List<T> SingletonList<T>(T item) => new List<T> { item };

    public static void Swap<T>(T[] array, int i, int j)
    {
        if (i < 0 || i >= array.Length || j < 0 || j >= array.Length)
            throw new ArgumentOutOfRangeException();

        T temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }

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

public interface IRepository<T> where T : class
{
    T? GetById(int id);
    void Save(T item);
    void Delete(int id);
}

public class InMemoryRepository<T> : IRepository<T> where T : class
{
    private readonly Dictionary<int, T> _store = new();

    public T? GetById(int id) => _store.TryGetValue(id, out var item) ? item : null;
    public void Save(T item) => _store[item.GetHashCode()] = item;
    public void Delete(int id) => _store.Remove(id);
}

class Program
{
    static void Main()
    {
        var stringBox = new Box<string>("Hello Generics");
        Console.WriteLine(stringBox.Describe());
        Console.WriteLine($"Box contains: {stringBox.Get()}");
        stringBox.Set("Updated content");
        Console.WriteLine($"Box now contains: {stringBox.Get()}");

        var intBox = new Box<int>(42);
        Console.WriteLine(intBox.Describe());
        Console.WriteLine($"Int box: {intBox.Get()}");

        var singleInt = CollectionUtils.SingletonList(5);
        var singleString = CollectionUtils.SingletonList("hello");
        Console.WriteLine($"Singleton int list: [{string.Join(", ", singleInt)}]");
        Console.WriteLine($"Singleton string list: [{string.Join(", ", singleString)}]");

        int[] numbers = { 1, 2, 3, 4, 5 };
        Console.WriteLine($"Before swap: [{string.Join(", ", numbers)}]");
        CollectionUtils.Swap(numbers, 0, 4);
        Console.WriteLine($"After swap: [{string.Join(", ", numbers)}]");

        var result = CollectionUtils.FindFirst(numbers, n => n > 3);
        Console.WriteLine($"First number > 3: {result}");

        var notFound = CollectionUtils.FindFirst(numbers, n => n > 100);
        Console.WriteLine($"First number > 100: {notFound}");
    }
}
