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
            (c, customerOrders group) => new
            {
                c.Name,
                c.Region,
                OrderCount = group.Count(),
                TotalSpent = group.Sum(o => o.Total),
                Orders = group.ToList()
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
        var allCustomersWithOrders = customers.GroupJoin(
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
// (This is built-in as .NET 6+ IEnumerable<T>.Chunk, reproduced here for learning)
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
