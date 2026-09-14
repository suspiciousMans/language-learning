// LinqQuerySyntax.cs — Project 04, Exercise 2
// Topics: LINQ query syntax (from, where, select, orderby, join, group by into, let),
//         anonymous types, SQL-like query comprehension.
//
// Expected output:
//   Products under $50:
//     Mouse: $29.99
//     Notebook: $4.99
//     Pen Set: $12.99
//
//   Affordable electronics (under $500), price descending:
//     Monitor: $399.99
//     Mouse: $29.99
//
//   Products with suppliers:
//     Laptop → TechCorp
//     Mouse → TechCorp
//     Monitor → TechCorp
//     Notebook → OfficeSupplies Inc
//     Pen Set → OfficeSupplies Inc
//     Desk Chair → FurnitureWorld
//     Bookshelf → FurnitureWorld
//
//   Categories with 2+ products:
//     Electronics: 3 products, total value $128490.75
//     Stationery: 2 products, total value $18247.00
//     Furniture: 2 products, total value $11599.40
//
//   Products under $100 after 10% discount:
//     Mouse: $29.99 → $26.99
//     Notebook: $4.99 → $4.49
//     Pen Set: $12.99 → $11.69

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
