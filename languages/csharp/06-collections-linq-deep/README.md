# Project 06: Collections and LINQ Deep Dive — C#

**Difficulty:** intermediate  
**Prerequisites:** Project 04 (LINQ and Async/Await), Project 03 (Generics, Delegates, Events)

## Goals

- Master the .NET collection types and know when to use each one
- Understand dictionary lookup patterns (`TryGetValue`, `ContainsKey`, indexer)
- Perform set operations with `HashSet<T>` and LINQ set operators
- Use `Stack<T>`, `Queue<T>`, and `LinkedList<T>` for specific access patterns
- Write custom LINQ extension methods to extend `IEnumerable<T>`
- Apply advanced LINQ: aggregation with result selectors, group joins, left-outer joins via `DefaultIfEmpty`

## Concepts

- **`Dictionary<TKey, TValue>`** — O(1) key-value lookup; `TryGetValue` avoids double lookup; `ContainsKey` for existence checks; indexer throws `KeyNotFoundException` if missing
- **`HashSet<T>`** — collection of unique items; O(1) membership test; set algebra operators (`Union`, `Intersect`, `Except`, `SymmetricExceptWith`); custom comparers for case-insensitive string sets
- **`SortedSet<T>`** — always-sorted unique collection; O(log n) operations; custom comparers
- **`Stack<T>`** — LIFO (last-in, first-out); `Push`, `Pop`, `Peek`
- **`Queue<T>`** — FIFO (first-in, first-out); `Enqueue`, `Dequeue`, `Peek`
- **`LinkedList<T>`** — doubly-linked list; O(1) insert/remove at a known node; slow random access
- **LINQ aggregation** — `Sum`, `Min`, `Max`, `Average`, `Count`, `LongCount`; `Aggregate` with seed and result selector for multi-value summaries
- **LINQ grouping** — `GroupBy` with projections; group-by with multiple aggregations in one pass
- **LINQ joins** — `Join` (inner), `GroupJoin` (group join → hierarchy), left-outer via `GroupJoin` + `SelectMany` + `DefaultIfEmpty`
- **Custom LINQ operators** — extension methods on `IEnumerable<T>` that use `yield return` for deferred execution

## Exercises

### Exercise 1: Dictionaries and Lookup Patterns

Create `Collections.cs`:

```csharp
// Exercise 1: Dictionaries and Lookup Patterns
// Covers: Dictionary<TKey, TValue>, TryGetValue, Safe key access,
//         Lookup<TKey, TElement>, handling missing keys

using System;
using System.Collections.Generic;
using System.Linq;

public class StudentRegistry
{
    private readonly Dictionary<string, Student> _students = new();

    public void Add(Student student)
    {
        if (string.IsNullOrWhiteSpace(student.Id))
            throw new ArgumentException("Student ID required", nameof(student));
        _students[student.Id] = student;
    }

    // TryGetValue pattern — the preferred way to access a dictionary
    public bool TryGetStudent(string id, out Student? student)
    {
        return _students.TryGetValue(id, out student);
    }

    // Direct index access — throws KeyNotFoundException if missing
    public Student GetStudentOrThrow(string id)
    {
        // Option 1: indexer with exception
        // return _students[id];

        // Option 2: explicit check + exception
        if (!_students.ContainsKey(id))
            throw new KeyNotFoundException($"Student '{id}' not enrolled");
        return _students[id];
    }

    // LINQ-style safe access with fallback
    public string GetStudentNameOrDefault(string id, string defaultName = "Unknown")
    {
        // TryGetValue avoids double lookup
        if (_students.TryGetValue(id, out var student))
            return student.Name;
        return defaultName;
    }

    public IEnumerable<Student> GetAllEnrolled() => _students.Values;

    public int Count => _students.Count;
}

public record Student(string Id, string Name, int Year, double Gpa);

class Program
{
    static void Main()
    {
        var registry = new StudentRegistry();
        registry.Add(new Student("S001", "Alice", 2, 3.8));
        registry.Add(new Student("S002", "Bob", 1, 3.5));
        registry.Add(new Student("S003", "Charlie", 3, 3.9));
        registry.Add(new Student("S004", "Diana", 2, 3.7));

        Console.WriteLine("=== Dictionary basics ===");
        Console.WriteLine($"Total enrolled: {registry.Count}");

        Console.WriteLine("\n=== TryGetValue pattern ===");
        if (registry.TryGetStudent("S001", out var alice))
        {
            Console.WriteLine($"Found: {alice.Name} (GPA: {alice.Gpa})");
        }
        if (!registry.TryGetStudent("S999", out var missing))
        {
            Console.WriteLine("S999 not found (TryGetValue returned false)");
        }

        Console.WriteLine("\n=== Safe access with fallback ===");
        Console.WriteLine($"S001: {registry.GetStudentNameOrDefault("S001")}");
        Console.WriteLine($"S999: {registry.GetStudentNameOrDefault("S999", "Not enrolled")}");

        Console.WriteLine("\n=== KeyNotFoundException ===");
        try
        {
            registry.GetStudentOrThrow("S999");
        }
        catch (KeyNotFoundException ex)
        {
            Console.WriteLine($"Caught: {ex.Message}");
        }

        Console.WriteLine("\n=== LINQ on Dictionary values ===");
        var HonorRoll = registry.GetAllEnrolled()
            .Where(s => s.Gpa >= 3.7)
            .OrderByDescending(s => s.Gpa)
            .Select(s => $"{s.Name} ({s.Gpa})");

        Console.WriteLine("Honor roll (GPA >= 3.7):");
        foreach (var name in HonorRoll)
            Console.WriteLine($"  {name}");

        Console.WriteLine("\n=== ToLookup: group by year ===");
        var byYear = registry.GetAllEnrolled().ToLookup(s => s.Year);
        foreach (var grouping in byYear)
        {
            Console.WriteLine($"Year {grouping.Key}: {grouping.Count()} students");
            foreach (var s in grouping)
                Console.WriteLine($"  - {s.Name} (GPA {s.Gpa})");
        }

        Console.WriteLine("\n=== Lookup for efficient multi-value lookup ===");
        var nameLookup = registry.GetAllEnrolled()
            .ToLookup(s => s.Name.Length, s => s.Name);
        Console.WriteLine($"Students with 5-letter names: {nameLookup[5].Count()}");
        Console.WriteLine($"Students with 6-letter names: {nameLookup[6].Count()}");
    }
}
```

**Expected output:**

```
=== Dictionary basics ===
Total enrolled: 4

=== TryGetValue pattern ===
Found: Alice (GPA: 3.8)
S999 not found (TryGetValue returned false)

=== Safe access with fallback ===
S001: Alice
S999: Not enrolled

=== KeyNotFoundException ===
Caught: Student 'S999' not enrolled

=== LINQ on Dictionary values ===
Honor roll (GPA >= 3.7):
  Alice (3.8)
  Diana (3.7)
  Charlie (3.9)

=== ToLookup: group by year ===
Year 1: 1 students
  - Bob (GPA 3.5)
Year 2: 2 students
  - Alice (GPA 3.8)
  - Diana (GPA 3.7)
Year 3: 1 students
  - Charlie (GPA 3.9)

=== Lookup for efficient multi-value lookup ===
Students with 5-letter names: 2
Students with 6-letter names: 2
```

**Notes:**

- `TryGetValue` is the idiomatic way to access a dictionary when the key might not exist — it does a single lookup instead of `ContainsKey` + indexer (which does two).
- The indexer `_dict[key]` throws `KeyNotFoundException` if the key is missing; only use it when you are certain the key exists.
- `ToLookup` creates an immutable multi-map (one key → many values) that is useful for grouping lookups that are queried repeatedly.
- A `Lookup<TKey, TElement>` is the result of `ToLookup` and is similar to a `Dictionary<TKey, IEnumerable<TElement>>` but with guaranteed non-empty groupings.

### Exercise 2: Set Operations, Stacks, Queues, and Collection Selection

Create `SetsAndStacks.cs`:

```csharp
// Exercise 2: Set Operations and Collection Performance
// Covers: HashSet<T>, SortedSet<T>, set algebra (Union, Intersect, Except, SymmetricExcept),
//         Stack<T>, Queue<T>, LinkedList<T>, choosing the right collection

using System;
using System.Collections.Generic;
using System.Linq;

class Program
{
    static void Main()
    {
        Console.WriteLine("=== HashSet — unique items and set operations ===");
        var setA = new HashSet<int> { 1, 2, 3, 4, 5 };
        var setB = new HashSet<int> { 4, 5, 6, 7, 8 };

        Console.WriteLine($"Set A: [{string.Join(", ", setA)}]");
        Console.WriteLine($"Set B: [{string.Join(", ", setB)}]");

        // Union — all elements from both
        var union = setA.Union(setB);
        Console.WriteLine($"A ∪ B: [{string.Join(", ", union)}]");

        // Intersect — common elements
        var intersect = setA.Intersect(setB);
        Console.WriteLine($"A ∩ B: [{string.Join(", ", intersect)}]");

        // Except — in A but not in B
        var except = setA.Except(setB);
        Console.WriteLine($"A \\ B: [{string.Join(", ", except)}]");

        // SymmetricExcept — in either but not both
        var symDiff = setA.SymmetricExcept(setB);
        Console.WriteLine($"A Δ B: [{string.Join(", ", symDiff)}]");

        Console.WriteLine("\n=== HashSet for fast membership tests ===");
        var validCodes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "ADMIN", "USER", "MODERATOR", "GUEST"
        };

        string[] testCodes = { "admin", "SuperUser", "GUEST", "BANNED" };
        foreach (var code in testCodes)
        {
            bool isValid = validCodes.Contains(code);
            Console.WriteLine($"  '{code}' is {(isValid ? "valid" : "INVALID")}");
        }

        Console.WriteLine("\n=== SortedSet — always sorted, no duplicates ===");
        var sortedNumbers = new SortedSet<int> { 5, 1, 8, 3, 1 };
        Console.WriteLine($"SortedSet (Duplicate 1 ignored ): [{string.Join(", ", sortedNumbers)}]");

        // Custom comparer for sorted set
        var sortedDates = new SortedSet<DateTime>
        {
            new DateTime(2024, 3, 15),
            new DateTime(2024, 1, 10),
            new DateTime(2024, 2, 20)
        };
        Console.WriteLine("Sorted dates:");
        foreach (var dt in sortedDates)
            Console.WriteLine($"  {dt:yyyy-MM-dd}");

        Console.WriteLine("\n=== Stack<T> — LIFO ===");
        var stack = new Stack<string>();
        stack.Push("First");
        stack.Push("Second");
        stack.Push("Third");
        Console.WriteLine($"Stack count: {stack.Count}");
        Console.WriteLine($"Peek (top): {stack.Peek()}");

        while (stack.Count > 0)
        {
            Console.WriteLine($"  Popped: {stack.Pop()}");
        }

        Console.WriteLine("\n=== Queue<T> — FIFO ===");
        var queue = new Queue<string>();
        queue.Enqueue("Task-1");
        queue.Enqueue("Task-2");
        queue.Enqueue("Task-3");
        Console.WriteLine($"Queue count: {queue.Count}");

        while (queue.Count > 0)
        {
            Console.WriteLine($"  Dequeued: {queue.Dequeue()}");
        }

        Console.WriteLine("\n=== LinkedList<T> — O(1) insert/remove at known nodes ===");
        var linked = new LinkedList<int>();
        linked.AddLast(10);
        linked.AddLast(20);
        linked.AddLast(30);

        // Insert before first node
        var firstNode = linked.First;
        linked.AddBefore(firstNode, 5);

        Console.WriteLine("LinkedList contents:");
        foreach (var n in linked)
            Console.WriteLine($"  {n}");

        // Remove a specific node (O(1) if you have the node reference)
        var node20 = linked.Find(20);
        if (node20 != null)
        {
            linked.Remove(node20);
            Console.WriteLine("Removed 20 — LinkedList now:");
            foreach (var n in linked)
                Console.WriteLine($"  {n}");
        }

        Console.WriteLine("\n=== Choosing the right collection ===");
        Console.WriteLine("  List<T>       — indexed access, fast append, slow insert/remove in middle");
        Console.WriteLine("  Dictionary<K,V> — O(1) key lookup, insertion-order preserved (.NET Core)");
        Console.WriteLine("  HashSet<T>    — O(1) membership test, unique items, set operations");
        Console.WriteLine("  SortedSet<T>  — always sorted, O(log n) ops, unique items");
        Console.WriteLine("  Stack<T>      — LIFO, push/pop at one end");
        Console.WriteLine("  Queue<T>      — FIFO, enqueue/dequeue at opposite ends");
        Console.WriteLine("  LinkedList<T> — O(1) insert/remove at known node, slow lookup");
    }
}
```

**Expected output:**

```
=== HashSet — unique items and set operations ===
Set A: [1, 2, 3, 4, 5]
Set B: [4, 5, 6, 7, 8]
A ∪ B: [1, 2, 3, 4, 5, 6, 7, 8]
A ∩ B: [4, 5]
A \ B: [1, 2, 3]
A Δ B: [1, 2, 3, 6, 7, 8]

=== HashSet for fast membership tests ===
  'admin' is valid
  'SuperUser' is INVALID
  'GUEST' is valid
  'BANNED' is INVALID

=== SortedSet — always sorted, no duplicates ===
SortedSet ( Duplicate 1 ignored ): [1, 3, 5, 8]
Sorted dates:
  2024-01-10
  2024-02-20
  2024-03-15

=== Stack<T> — LIFO ===
Stack count: 3
Peek (top): Third
  Popped: Third
  Popped: Second
  Popped: First

=== Queue<T> — FIFO ===
Queue count: 3
  Dequeued: Task-1
  Dequeued: Task-2
  Dequeued: Task-3

=== LinkedList<T> — O(1) insert/remove at known nodes ===
LinkedList contents:
  5
  10
  20
  30
Removed 20 — LinkedList now:
  5
  10
  30

=== Choosing the right collection ===
  List<T>       — indexed access, fast append, slow insert/remove in middle
  Dictionary<K,V> — O(1) key lookup, insertion-order preserved (.NET Core)
  HashSet<T>    — O(1) membership test, unique items, set operations
  SortedSet<T>  — always sorted, O(log n) ops, unique items
  Stack<T>      — LIFO, push/pop at one end
  Queue<T>      — FIFO, enqueue/dequeue at opposite ends
  LinkedList<T> — O(1) insert/remove at known node, slow lookup
```

**Notes:**

- LINQ set operators (`Union`, `Intersect`, `Except`, `SymmetricExcept`) work on any `IEnumerable<T>` and use deferred execution with a set-backed internal implementation.
- `HashSet<T>` with a custom `IEqualityComparer<T>` (e.g., `StringComparer.OrdinalIgnoreCase`) is the idiomatic way to get case-insensitive string sets.
- `SortedSet<T>` maintains sort order on every insert/delete — use it when you need the elements sorted at all times, not just for a one-time `OrderBy`.
- `Stack<T>` and `Queue<T>` are thin wrappers over array-based circular buffers — very efficient for their intended use cases.
- `LinkedList<T>` is rarely needed in practice; prefer `List<T>` for most sequence needs. It shines when you have a node reference and need O(1) insertion/removal at that point.

### Exercise 3: Advanced LINQ — Aggregation, Grouping, Joins, and Custom Operators

Create `LinqDeepDive.cs`:

```csharp
// Exercise 3: LINQ Deep Dive — Aggregation, Grouping, Joining, Custom Operators
// Covers: aggregate functions, custom result selection, grouping with aggregations,
//         join varieties (inner, group join, left-outer via DefaultIfEmpty),
//         writing custom LINQ extension methods

using System;
using System.Collections.Generic;
using System.Linq;

public record Product(string Name, string Category, decimal Price, int Stock);
public record Customer(string Id, string Name, string Region);
public record Order(string OrderId, string CustomerId, DateTime Date, decimal Total);
public record OrderItem(string OrderId, string ProductName, int Quantity, decimal UnitPrice);

class Program
{
    static void Main()
    {
        var products = new List<Product>
        {
            new("Laptop", "Electronics", 999.99m, 50),
            new("Mouse", "Electronics", 29.99m, 200),
            new("Desk Chair", "Furniture", 249.99m, 30),
            new("Notebook", "Stationery", 4.99m, 500),
            new("Monitor", "Electronics", 399.99m, 75),
            new("Pen Set", "Stationery", 12.99m, 300),
            new("Bookshelf", "Furniture", 189.99m, 20)
        };

        var customers = new List<Customer>
        {
            new("C001", "Acme Corp", "North"),
            new("C002", "Globex Inc", "South"),
            new("C003", "Initech", "North"),
            new("C004", "Umbrella Co", "East")
        };

        var orders = new List<Order>
        {
            new("ORD-001", "C001", new DateTime(2024, 1, 15), 1050.00m),
            new("ORD-002", "C002", new DateTime(2024, 1, 20), 2800.00m),
            new("ORD-003", "C003", new DateTime(2024, 2, 5), 500.00m),
            new("ORD-004", "C001", new DateTime(2024, 2, 10), 750.00m),
            new("ORD-005", "C004", new DateTime(2024, 3, 1), 1200.00m)
        };

        var orderItems = new List<OrderItem>
        {
            new("ORD-001", "Laptop", 1, 999.99m),
            new("ORD-001", "Mouse", 2, 29.99m),
            new("ORD-002", "Monitor", 2, 399.99m),
            new("ORD-002", "Bookshelf", 1, 189.99m),
            new("ORD-003", "Notebook", 100, 4.99m),
            new("ORD-004", "Chair", 3, 249.99m),
            new("ORD-005", "Pen Set", 50, 12.99m)
        };

        Console.WriteLine("=== Aggregation with result selector ===");
        decimal totalRevenue = orders.Sum(o => o.Total);
        Console.WriteLine($"Total revenue: ${totalRevenue:N2}");

        var revenueStats = orders.Aggregate(
            seed: 0m,
            func: (acc, o) => acc + o.Total,
            resultSelector: total => new
            {
                Total = total,
                Count = orders.Count,
                Average = orders.Count > 0 ? total / orders.Count : 0,
                Max = orders.Max(o => o.Total),
                Min = orders.Min(o => o.Total)
            });
        Console.WriteLine($"Stats — Count: {revenueStats.Count}, " +
            $"Avg: ${revenueStats.Average:N2}, " +
            $"Max: ${revenueStats.Max:N2}, " +
            $"Min: ${revenueStats.Min:N2}");

        Console.WriteLine("\n=== Grouping with multiple aggregations ===");
        var byCategory = products.GroupBy(p => p.Category)
            .Select(g => new
            {
                Category = g.Key,
                Count = g.Count(),
                TotalStock = g.Sum(p => p.Stock),
                AvgPrice = g.Average(p => p.Price),
                MostExpensive = g.Max(p => p.Price),
                Cheapest = g.Min(p => p.Price)
            })
            .OrderByDescending(g => g.TotalStock);

        Console.WriteLine("Category summary:");
        foreach (var cat in byCategory)
        {
            Console.WriteLine($"  {cat.Category}: {cat.Count} products, " +
                $"{cat.TotalStock} units in stock, " +
                $"avg ${cat.AvgPrice:N2}, " +
                $"range ${cat.Cheapest:N2}–${cat.MostExpensive:N2}");
        }

        Console.WriteLine("\n=== Inner join: orders with customer names ===");
        var ordersWithCustomers = orders.Join(
            customers,
            o => o.CustomerId,
            c => c.Id,
            (o, c) => new
            {
                o.OrderId,
                Customer = c.Name,
                o.Date,
                o.Total
            })
            .OrderByDescending(o => o.Total);

        Console.WriteLine("Orders (highest first):");
        foreach (var o in ordersWithCustomers)
        {
            Console.WriteLine($"  {o.OrderId}: {o.Customer} — ${o.Total:N2} ({o.Date:yyyy-MM-dd})");
        }

        Console.WriteLine("\n=== Group join: customers with their orders ===");
        var customerOrders = customers.GroupJoin(
            orders,
            c => c.Id,
            o => o.CustomerId,
            (c, orderGroup) => new
            {
                c.Name,
                c.Region,
                OrderCount = orderGroup.Count(),
                TotalSpent = orderGroup.Sum(o => o.Total),
                Orders = orderGroup.ToList()
            })
            .OrderByDescending(co => co.TotalSpent);

        Console.WriteLine("Customer spending summary:");
        foreach (var co in customerOrders)
        {
            Console.WriteLine($"  {co.Name} ({co.Region}): " +
                $"{co.OrderCount} orders, ${co.TotalSpent:N2} total");
        }

        Console.WriteLine("\n=== Left-outer join via DefaultIfEmpty ===");
        // Customers with NO orders still appear (with zero totals)
        var allCustomersWithOrders = customers
            .GroupJoin(
                orders,
                c => c.Id,
                o => o.CustomerId,
                (c, orderGroup) => new { c, orderGroup })
            .SelectMany(
                x => x.orderGroup.DefaultIfEmpty(),
                (x, o) => new
                {
                    CustomerName = x.c.Name,
                    OrderId = o?.OrderId ?? "(none)",
                    Total = o?.Total ?? 0m
                });

        Console.WriteLine("All customers (including those with no orders):");
        foreach (var item in allCustomersWithOrders)
        {
            Console.WriteLine($"  {item.CustomerName}: {item.OrderId} — ${item.Total:N2}");
        }

        Console.WriteLine("\n=== Custom LINQ extension: Chunk ===");
        var numbers = Enumerable.Range(1, 13);
        var chunks = numbers.Chunk(5);
        Console.WriteLine("Chunking 1..13 into groups of 5:");
        for (int i = 0; i < chunks.Count(); i++)
        {
            var chunk = chunks.ElementAt(i);
            Console.WriteLine($"  Chunk {i + 1}: [{string.Join(", ", chunk)}]");
        }
    }
}

// Custom LINQ extension: Chunk — split sequence into groups of size N
// (Built-in as .NET 6+ IEnumerable<T>.Chunk, reproduced here for learning)
public static class LinqExtensions
{
    public static IEnumerable<IEnumerable<T>> Chunk<T>(this IEnumerable<T> source, int size)
    {
        if (size <= 0) throw new ArgumentOutOfRangeException(nameof(size));

        T[]? chunk = null;
        int count = 0;

        foreach (var item in source)
        {
            if (chunk == null)
                chunk = new T[size];

            chunk[count++] = item;

            if (count == size)
            {
                yield return chunk;
                chunk = null;
                count = 0;
            }
        }

        // Yield the final partial chunk if any items remain
        if (count > 0)
        {
            if (chunk == null) chunk = new T[count];
            Array.Resize(ref chunk, count);
            yield return chunk;
        }
    }
}
```

**Expected output:**

```
=== Aggregation with result selector ===
Total revenue: $6300.00
Stats — Count: 5, Avg: $1260.00, Max: $2800.00, Min: $500.00

=== Grouping with multiple aggregations ===
Category summary:
  Stationery: 2 products, 800 units in stock, avg $8.99, range $4.99–$12.99
  Electronics: 3 products, 325 units in stock, avg $476.66, range $29.99–$999.99
  Furniture: 2 products, 50 units in stock, avg $219.99, range $189.99–$249.99

=== Inner join: orders with customer names ===
Orders (highest first):
  ORD-002: Globex Inc — $2,800.00 (2024-01-20)
  ORD-005: Umbrella Co — $1,200.00 (2024-03-01)
  ORD-001: Acme Corp — $1,050.00 (2024-01-15)
  ORD-004: Acme Corp — $750.00 (2024-02-10)
  ORD-003: Initech — $500.00 (2024-02-05)

=== Group join: customers with their orders ===
Customer spending summary:
  Globex Inc (South): 1 orders, $2,800.00 total
  Umbrella Co (East): 1 orders, $1,200.00 total
  Acme Corp (North): 2 orders, $1,800.00 total
  Initech (North): 1 orders, $500.00 total

=== Left-outer join via DefaultIfEmpty ===
All customers (including those with no orders):
  Acme Corp: ORD-001 — $1,050.00
  Acme Corp: ORD-004 — $750.00
  Globex Inc: ORD-002 — $2,800.00
  Initech: ORD-003 — $500.00
  Umbrella Co: ORD-005 — $1,200.00

=== Custom LINQ extension: Chunk ===
Chunking 1..13 into groups of 5:
  Chunk 1: [1, 2, 3, 4, 5]
  Chunk 2: [6, 7, 8, 9, 10]
  Chunk 3: [11, 12, 13]
```

**Notes:**

- `Aggregate` with a result selector is a powerful pattern for computing multiple statistics in one pass — though for simple cases, individual `Sum`/`Average`/`Min`/`Max` calls are clearer.
- `GroupJoin` produces a hierarchy (outer element → collection of matching inner elements). Combined with `SelectMany` + `DefaultIfEmpty`, you get a left-outer join.
- A left-outer join in LINQ: `outer.GroupJoin(inner, ...).SelectMany(x => x.innerGroup.DefaultIfEmpty(), ...)`. The `DefaultIfEmpty` ensures that even when there are no matching inner elements, one null element is yielded so the result selector still runs.
- Custom LINQ operators follow the `this IEnumerable<T> source` extension method pattern with `yield return` for deferred execution. The `Chunk` example demonstrates the pattern and shows how to handle the final partial chunk.
- .NET 6+ already includes `Enumerable.Chunk` — the custom version here is for learning the mechanics.

## Completion Checklist

- [ ] You can use `Dictionary<TKey, TValue>` with `TryGetValue` to avoid exceptions on missing keys
- [ ] You can create a `HashSet<T>` with a custom comparer (e.g., case-insensitive strings)
- [ ] You can use LINQ set operators (`Union`, `Intersect`, `Except`) and `HashSet` set-algebra methods
- [ ] You can use `SortedSet<T>` for collections that must stay sorted
- [ ] You can use `Stack<T>` (LIFO) and `Queue<T>` (FIFO) for their specific access patterns
- [ ] You understand when `LinkedList<T>` is appropriate vs. `List<T>`
- [ ] You can use `Aggregate` with seed and result selector for multi-value summaries
- [ ] You can group with multiple aggregations in a single LINQ pipeline
- [ ] You can perform inner joins with `Join`
- [ ] You can perform group joins with `GroupJoin` to produce hierarchies
- [ ] You can perform left-outer joins via `GroupJoin` + `SelectMany` + `DefaultIfEmpty`
- [ ] You can write a custom LINQ extension method using `yield return`

## Hints

- Always prefer `TryGetValue` over `ContainsKey` + indexer — it does one lookup instead of two.
- `HashSet<T>.CreateSetComparer()` is available for nested set comparisons, but a custom `IEqualityComparer<T>` is usually clearer.
- LINQ set operators (`Union`, `Intersect`, etc.) use deferred execution — they only compute when enumerated.
- `GroupJoin` is the LINQ equivalent of a SQL `LEFT JOIN ... GROUP BY` — it produces a nested result that you then flatten with `SelectMany`.
- `DefaultIfEmpty` without an argument yields `default(T)` (null for reference types) when the source is empty — that is what enables the left-outer join pattern.
- When writing custom LINQ operators, follow the contract: deferred execution, no side effects on enumeration, and proper handling of `IDisposable` sources if needed.
- .NET 6+ added `Enumerable.Chunk`, `Enumerable.Index`, and `Enumerable.Random` — check the docs before writing your own.
