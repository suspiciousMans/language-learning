// AsyncEnumerable.cs — Project 04, Exercise 4
// Topics: IAsyncEnumerable<T>, async iterators with yield return,
//         await foreach, async filtering, async streaming,
//         simulating paginated API responses.
//
// Expected output:
//
//   === Async Enumerable ===
//     Received: 1
//     Received: 2
//     Received: 3
//     Received: 4
//     Received: 5
//
//   === Async Filtering ===
//     Even number: 2
//     Even number: 4
//     Even number: 6
//     Even number: 8
//     Even number: 10
//
//   === Async LINQ with ToList (materialize) ===
//     Collected: [1, 2, 3, 4, 5, 6, 7]
//
//   === Real-world: simulate paginated API ===
//     Page 1: 5 items
//     Page 2: 5 items
//     Page 3: 5 items
//
// NOTE: The "Async LINQ with ToList" section uses a manual ToListAsync
// implementation because System.Linq.Async is not included. The README
// spec shows `numbers.ToListAsync()` which would require the package.
// The implementation below uses a simple await foreach to collect.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

class Program
{
    // Async generator — yields values over time
    static async IAsyncEnumerable<int> GenerateNumbersAsync(int count, int delayMs)
    {
        for (int i = 1; i <= count; i++)
        {
            await Task.Delay(delayMs);
            yield return i;
        }
    }

    // Async LINQ-style filtering
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

        Console.WriteLine("\n=== Async LINQ with ToList (materialize) ===");
        var numbers = GenerateNumbersAsync(7, 200);
        var collected = await ToListAsync(numbers);
        Console.WriteLine($"  Collected: [{string.Join(", ", collected)}]");

        Console.WriteLine("\n=== Real-world: simulate paginated API ===");
        await foreach (var page in PaginateAsync(3, 1000))
            Console.WriteLine($"  Page {page.PageNumber}: {page.Items.Count} items");
    }

    // Manual ToListAsync to avoid external package dependency
    static async Task<List<int>> ToListAsync(IAsyncEnumerable<int> source)
    {
        var list = new List<int>();
        await foreach (var item in source)
            list.Add(item);
        return list;
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
