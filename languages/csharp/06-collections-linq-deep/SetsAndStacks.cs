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
        Console.WriteLine($"SortedSet ( Duplicate 1 ignored ): [{string.Join(", ", sortedNumbers)}]");

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
