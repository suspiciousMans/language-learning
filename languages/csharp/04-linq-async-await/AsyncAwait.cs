// Exercise 3: Async/Await Basics
// Asynchronous programming with Task and Task<T>

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    static async Task<string> FetchDataAsync(string url, TimeSpan delay)
    {
        Console.WriteLine($"  Fetching {url}...");
        await Task.Delay(delay);
        return $"Response from {url} (took {delay.TotalMilliseconds}ms)";
    }

    static async Task ProcessItemsAsync(IEnumerable<string> items)
    {
        foreach (var item in items)
        {
            Console.WriteLine($"Processing: {item}");
            await Task.Delay(500);
        }
        Console.WriteLine("All items processed.");
    }

    static async Task Main()
    {
        Console.WriteLine("=== Sequential Async ===");
        var result1 = await FetchDataAsync("API-1", TimeSpan.FromMilliseconds(1000));
        Console.WriteLine($"  Result: {result1}");
        var result2 = await FetchDataAsync("API-2", TimeSpan.FromMilliseconds(800));
        Console.WriteLine($"  Result: {result2}");
        var result3 = await FetchDataAsync("API-3", TimeSpan.FromMilliseconds(600));
        Console.WriteLine($"  Result: {result3}");

        Console.WriteLine("\n=== Concurrent Async (Task.WhenAll) ===");
        var t1 = FetchDataAsync("Service-A", TimeSpan.FromMilliseconds(1500));
        var t2 = FetchDataAsync("Service-B", TimeSpan.FromMilliseconds(1000));
        var t3 = FetchDataAsync("Service-C", TimeSpan.FromMilliseconds(800));

        var results = await Task.WhenAll(t1, t2, t3);
        for (int i = 0; i < results.Length; i++)
            Console.WriteLine($"  Result {i + 1}: {results[i]}");

        Console.WriteLine("\nAll done in ~1500ms (vs ~3300ms sequential)");

        Console.WriteLine("\n=== Async Foreach ===");
        await ProcessItemsAsync(new[] { "A", "B", "C", "D" });

        Console.WriteLine("\n=== Cancellation ===");
        await DemonstrateCancellation();
    }

    static async Task DemonstrateCancellation()
    {
        using var cts = new CancellationTokenSource();
        cts.CancelAfter(TimeSpan.FromMilliseconds(2000));

        try
        {
            await LongRunningOperationAsync(cts.Token);
        }
        catch (OperationCanceledException)
        {
            Console.WriteLine("Operation was cancelled!");
        }
    }

    static async Task LongRunningOperationAsync(CancellationToken token)
    {
        for (int i = 0; i < 10; i++)
        {
            token.ThrowIfCancellationRequested();
            Console.WriteLine($"  Step {i + 1}/10");
            await Task.Delay(500, token);
        }
        Console.WriteLine("Operation completed.");
    }
}
