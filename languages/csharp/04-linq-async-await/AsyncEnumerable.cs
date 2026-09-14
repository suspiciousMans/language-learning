// Exercise 4: IAsyncEnumerable and Async LINQ
// Async streaming with IAsyncEnumerable<T> — C# 8+

using System;
using System.Collections.Generic;
using System.Threading.Tasks;

class Program
{
    static async IAsyncEnumerable<int> GenerateNumbersAsync(int count, int delayMs)
    {
        for (int i = 1; i <= count; i++)
        {
            await Task.Delay(delayMs);
            yield return i;
        }
    }

    static async IAsyncEnumerable<int> FilterAsync(IAsyncEnumerable<int> source, Func<int, bool> predicate)
    {
        await foreach (var item in source)
        {
            if (predicate(item))
                yield return item;
        }
    }

    static async Task Main()
    {
        Console.WriteLine("=== Async Enumerable ===");
        await foreach (var num in GenerateNumbersAsync(5, 500))
            Console.WriteLine($"  Received: {num}");

        Console.WriteLine("\n=== Async Filtering ===");
        var allNumbers = GenerateNumbersAsync(10, 300);
        var evens = FilterAsync(allNumbers, n => n % 2 == 0);

        await foreach (var n in evens)
            Console.WriteLine($"  Even number: {n}");

        Console.WriteLine("\n=== Real-world: simulate paginated API ===");
        await foreach (var page in PaginateAsync(3, 1000))
            Console.WriteLine($"  Page {page.PageNumber}: {page.Items.Count} items");
    }
}

record Page(int PageNumber, List<string> Items);

static async IAsyncEnumerable<Page> PaginateAsync(int totalPages, int delayMs)
{
    for (int page = 1; page <= totalPages; page++)
    {
        await Task.Delay(delayMs);
        var items = Enumerable.Range(1, 5)
            .Select(i => $"Item {page}-{i}")
            .ToList();
        yield return new Page(page, items);
    }
}
