# Project 04: LINQ and Async/Await — C#

**Difficulty:** intermediate  
**Prerequisites:** Project 03 (Generics, Delegates, Events)

## Goals

- Master Language Integrated Query (LINQ) for querying collections
- Understand deferred execution vs immediate execution
- Use async/await for asynchronous programming
- Work with Task, Task<T>, and the async state machine
- Combine LINQ with async patterns

## Concepts

- **LINQ** — Language Integrated Query; query syntax and method syntax; `IEnumerable<T>` extension methods
- **Deferred execution** — LINQ queries are not executed until enumerated (foreach, `.ToList()`, etc.)
- **Immediate execution** — operators like `.ToList()`, `.Count()`, `.First()` force immediate evaluation
- **async/await** — C#'s asynchronous programming model; `Task` and `Task<T>` represent ongoing operations
- **Task** — represents an asynchronous operation; can be awaited; does not block threads
- **CancellationToken** — cooperative cancellation for async operations
- **IAsyncEnumerable<T>** — async streaming; asynchronous version of `IEnumerable<T>` (C# 8+)

## Setup

No additional packages needed for Projects 04-04. For later projects you may need:

```bash
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package xunit
dotnet add package Moq
dotnet add package Microsoft.AspNetCore.App
```

## Exercises

### Exercise 1: LINQ Method Syntax

Create `LinqMethodSyntax.cs`:

```csharp
// Exercise 1: LINQ Method Syntax
// LINQ operators as extension methods on IEnumerable<T>

using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main()
    {
        var people = new List<Person>
        {
            new Person("Alice", 30, "Engineering"),
            new Person("Bob", 25, "Marketing"),
            new Person("Charlie", 35, "Engineering"),
            new Person("Diana", 28, "Marketing"),
            new Person("Eve", 32, "Engineering"),
            new Person("Frank", 22, "Sales")
        };

        // Filter: where — only engineers
        var engineers = people.Where(p => p.Department == "Engineering");
        Console.WriteLine("Engineers:");
        foreach (var p in engineers)
            Console.WriteLine($"  {p.Name} (age {p.Age})");

        // Projection: select — project to a new shape
        var names = people.Select(p => p.Name);
        Console.WriteLine($"\nAll names: [{string.Join(", ", names)}]");

        // Chaining: filter + sort + project
        var sortedEngineers = people
            .Where(p => p.Department == "Engineering")
            .OrderBy(p => p.Age)
            .Select(p => $"{p.Name} ({p.Age})");
        Console.WriteLine($"\nEngineers by age: [{string.Join(", ", sortedEngineers)}]");

        // Aggregation: count, sum, average, min, max
        Console.WriteLine($"\nTotal people: {people.Count()}");
        Console.WriteLine($"Average age: {people.Average(p => p.Age):F1}");
        Console.WriteLine($"Youngest: {people.Min(p => p.Age)}");
        Console.WriteLine($"Oldest: {people.Max(p => p.Age)}");

        // Grouping: group by department
        var byDepartment = people.GroupBy(p => p.Department);
        Console.WriteLine("\nBy department:");
        foreach (var group in byDepartment)
        {
            Console.WriteLine($"  {group.Key}: {group.Count()} people");
        }

        // Deferred execution demo
        Console.WriteLine("\n=== Deferred Execution ===");
        var query = people.Where(p => p.Age > 25);  // nothing executed yet
        people.Add(new Person("Grace", 40, "HR"));   // modify the source
        Console.WriteLine($"Count after adding Grace: {query.Count()}");  // 4, not 3
    }
}

record Person(string Name, int Age, string Department);
```

**Expected output:**

```
Engineers:
  Alice (age 30)
  Charlie (age 35)
  Eve (age 32)

All names: [Alice, Bob, Charlie, Diana, Eve, Frank]

Engineers by age: [Alice (30), Eve (32), Charlie (35)]

Total people: 6
Average age: 28.7
Youngest: 22
Oldest: 40

By department:
  Engineering: 3 people
  Marketing: 2 people
  Sales: 1 people

=== Deferred Execution ===
Count after adding Grace: 4
```

### Exercise 2: LINQ Query Syntax

Create `LinqQuerySyntax.cs`:

```csharp
// Exercise 2: LINQ Query Syntax
// SQL-like query syntax — compiles to the same method calls as method syntax

using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main()
    {
        var products = new List<Product>
        {
            new Product("Laptop", "Electronics", 999.99m, 50),
            new Product("Mouse", "Electronics", 29.99m, 200),
            new Product("Desk Chair", "Furniture", 249.99m, 30),
            new Product("Notebook", "Stationery", 4.99m, 500),
            new Product("Monitor", "Electronics", 399.99m, 75),
            new Product("Pen Set", "Stationery", 12.99m, 300),
            new Product("Bookshelf", "Furniture", 189.99m, 20)
        };

        // Basic query syntax: from, where, select
        var cheapProducts = from p in products
                            where p.Price < 50
                            select p;

        Console.WriteLine("Products under $50:");
        foreach (var p in cheapProducts)
            Console.WriteLine($"  {p.Name}: ${p.Price}");

        // Multiple conditions + ordering
        var affordableElectronics = from p in products
                                     where p.Category == "Electronics"
                                        && p.Price < 500
                                     orderby p.Price descending
                                     select p;

        Console.WriteLine("\nAffordable electronics (under $500), price descending:");
        foreach (var p in affordableElectronics)
            Console.WriteLine($"  {p.Name}: ${p.Price}");

        // Join — like SQL join
        var suppliers = new List<Supplier>
        {
            new Supplier("TechCorp", "Electronics"),
            new Supplier("OfficeSupplies Inc", "Stationery"),
            new Supplier("FurnitureWorld", "Furniture")
        };

        var productWithSupplier = from p in products
                                   join s in suppliers on p.Category equals s.Category
                                   select new { p.Name, s.CompanyName };

        Console.WriteLine("\nProducts with suppliers:");
        foreach (var item in productWithSupplier)
            Console.WriteLine($"  {item.Name} → {item.CompanyName}");

        // Group by + into (continuing a group query)
        var categorized = from p in products
                          group p by p.Category into g
                          where g.Count() >= 2
                          select new
                          {
                              Category = g.Key,
                              Count = g.Count(),
                              TotalValue = g.Sum(p => p.Price * p.Stock)
                          };

        Console.WriteLine("\nCategories with 2+ products:");
        foreach (var cat in categorized)
            Console.WriteLine($"  {cat.Category}: {cat.Count} products, total value ${cat.TotalValue:F2}");

        // Let — store intermediate computation
        var withDiscount = from p in products
                           let discountedPrice = p.Price * 0.9m
                           where discountedPrice < 100
                           select new
                           {
                               p.Name,
                               Original = p.Price,
                               Discounted = discountedPrice
                           };

        Console.WriteLine("\nProducts under $100 after 10% discount:");
        foreach (var item in withDiscount)
            Console.WriteLine($"  {item.Name}: ${item.Original} → ${item.Discounted:F2}");
    }
}

record Product(string Name, string Category, decimal Price, int Stock);
record Supplier(string CompanyName, string Category);
```

**Expected output:**

```
Products under $50:
  Mouse: $29.99
  Notebook: $4.99
  Pen Set: $12.99

Affordable electronics (under $500), price descending:
  Monitor: $399.99
  Mouse: $29.99

Products with suppliers:
  Laptop → TechCorp
  Mouse → TechCorp
  Monitor → TechCorp
  Notebook → OfficeSupplies Inc
  Pen Set → OfficeSupplies Inc
  Desk Chair → FurnitureWorld
  Bookshelf → FurnitureWorld

Categories with 2+ products:
  Electronics: 3 products, total value $128490.75
  Stationery: 2 products, total value $18247.00
  Furniture: 2 products, total value $11599.40

Products under $100 after 10% discount:
  Mouse: $29.99 → $26.99
  Notebook: $4.99 → $4.49
  Pen Set: $12.99 → $11.69
```

### Exercise 3: Async/Await Basics

Create `AsyncAwait.cs`:

```csharp
// Exercise 3: Async/Await Basics
// Asynchronous programming with Task and Task<T>

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
```

**Expected output (timings will vary):**

```
=== Sequential Async ===
  Fetching API-1...
  Result: Response from API-1 (took 1000ms)
  Fetching API-2...
  Result: Response from API-2 (took 800ms)
  Fetching API-3...
  Result: Response from API-3 (took 600ms)

=== Concurrent Async (Task.WhenAll) ===
  Fetching Service-A...
  Fetching Service-B...
  Fetching Service-C...
  Result 1: Response from Service-A (took 1500ms)
  Result 2: Response from Service-B (took 1000ms)
  Result 3: Response from Service-C (took 800ms)

All done in ~1500ms (vs ~3300ms sequential)

=== Async Foreach ===
Processing: A
Processing: B
Processing: C
Processing: D
All items processed.

=== Cancellation ===
  Step 1/10
  Step 2/10
  Step 3/10
  Step 4/10
Operation was cancelled!
```

### Exercise 4: IAsyncEnumerable and Async LINQ

Create `AsyncEnumerable.cs`:

```csharp
// Exercise 4: IAsyncEnumerable and Async LINQ
// Async streaming with IAsyncEnumerable<T> — C# 8+

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
        var collected = await numbers.ToListAsync();  // requires System.Linq.Async or manual
        Console.WriteLine($"  Collected: [{string.Join(", ", collected)}]");

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
```

**Expected output:**

```
=== Async Enumerable ===
  Received: 1
  Received: 2
  Received: 3
  Received: 4
  Received: 5

=== Async Filtering ===
  Even number: 2
  Even number: 4
  Even number: 6
  Even number: 8
  Even number: 10

=== Async LINQ with ToList (materialize) ===
  Collected: [1, 2, 3, 4, 5, 6, 7]

=== Real-world: simulate paginated API ===
  Page 1: 5 items
  Page 2: 5 items
  Page 3: 5 items
```

## Completion Checklist

- [ ] You can write LINQ queries using method syntax (`.Where()`, `.Select()`, `.OrderBy()`)
- [ ] You can write LINQ queries using query syntax (`from ... where ... select`)
- [ ] You understand deferred execution and how `.ToList()` forces immediate evaluation
- [ ] You can use aggregation operators: `.Count()`, `.Sum()`, `.Average()`, `.Min()`, `.Max()`
- [ ] You can use `.GroupBy()` and `.Join()`
- [ ] You can write async methods with `async Task<T>` and `await`
- [ ] You can run tasks concurrently with `Task.WhenAll`
- [ ] You can use `CancellationToken` for cooperative cancellation
- [ ] You can use `IAsyncEnumerable<T>` for async streaming
- [ ] You understand the difference between `Task` (void-returning async) and `Task<T>` (value-returning async)

## Hints

- Prefer method syntax for simple queries; query syntax shines with joins and complex projections
- LINQ uses deferred execution — the query runs when you enumerate (foreach, `.ToList()`, etc.)
- `await Task.Delay(ms)` is the async equivalent of `Thread.Sleep(ms)` — it doesn't block the thread
- Always prefer `async Task` over `async void` — only use `async void` for event handlers
- `Task.WhenAll` runs tasks concurrently — the total time is the longest task, not the sum
- Use `CancellationToken.ThrowIfCancellationRequested()` to make your code cooperative
- For real projects, consider the `System.Linq.Async` NuGet package for async LINQ operators
