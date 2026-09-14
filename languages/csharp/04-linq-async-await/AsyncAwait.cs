// AsyncAwait.cs — Project 04, Exercise 3
// Topics: async Task, async Task<T>, await, Task.Delay, Task.WhenAll,
//         CancellationTokenSource, CancellationToken, OperationCanceledException,
//         cooperative cancellation with ThrowIfCancellationRequested.
//
// Expected output (timings will vary):
//
//   === Sequential Async ===
//     Fetching API-1...
//     Result: Response from API-1 (took 1000ms)
//     Fetching API-2...
//     Result: Response from API-2 (took 800ms)
//     Fetching API-3...
//     Result: Response from API-3 (took 600ms)
//
//   === Concurrent Async (Task.WhenAll) ===
//     Fetching Service-A...
//     Fetching Service-B...
//     Fetching Service-C...
//     Result 1: Response from Service-A (took 1500ms)
//     Result 2: Response from Service-B (took 1000ms)
//     Result 3: Response from Service-C (took 800ms)
//
//   All done in ~1500ms (vs ~3300ms sequential)
//
//   === Async Foreach ===
//   Processing: A
//   Processing: B
//   Processing: C
//   Processing: D
//   All items processed.
//
//   === Cancellation ===
//     Step 1/10
//     Step 2/10
//     Step 3/10
//     Step 4/10
//   Operation was cancelled!

using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

class Program
{
    // Simulate an async I/O operation (e.g., web API call)
    static async Task<string> FetchDataAsync(string url, TimeSpan delay)
    {
        Console.WriteLine($"  Fetching {url}...");
        await Task.Delay(delay);  // non-blocking wait
        return $"Response from {url} (took {delay.TotalMilliseconds}ms)";
    }

    // Async method that returns void (event handler pattern — avoid in general code)
    static async Task ProcessItemsAsync(IEnumerable<string> items)
    {
        foreach (var item in items)
        {
            Console.WriteLine($"Processing: {item}");
            await Task.Delay(500);  // simulate work
        }
        Console.WriteLine("All items processed.");
    }

    static async Task Main()
    {
        Console.WriteLine("=== Sequential Async ===");
        // Sequential — each awaits the previous
        var result1 = await FetchDataAsync("API-1", TimeSpan.FromMilliseconds(1000));
        Console.WriteLine($"  Result: {result1}");
        var result2 = await FetchDataAsync("API-2", TimeSpan.FromMilliseconds(800));
        Console.WriteLine($"  Result: {result2}");
        var result3 = await FetchDataAsync("API-3", TimeSpan.FromMilliseconds(600));
        Console.WriteLine($"  Result: {result3}");

        Console.WriteLine("\n=== Concurrent Async (Task.WhenAll) ===");
        // Concurrent — start all, then await all
        var t1 = FetchDataAsync("Service-A", TimeSpan.FromMilliseconds(1500));
        var t2 = FetchDataAsync("Service-B", TimeSpan.FromMilliseconds(1000));
        var t3 = FetchDataAsync("Service-C", TimeSpan.FromMilliseconds(800));

        var results = await Task.WhenAll(t1, t2, t3);
        for (int i = 0; i < results.Length; i++)
            Console.WriteLine($"  Result {i + 1}: {results[i]}");

        Console.WriteLine($"\nAll done in ~1500ms (vs ~3300ms sequential)");

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
            token.ThrowIfCancellationRequested();  // cooperative cancellation
            Console.WriteLine($"  Step {i + 1}/10");
            await Task.Delay(500, token);  // pass token to Delay
        }
        Console.WriteLine("Operation completed.");
    }
}
