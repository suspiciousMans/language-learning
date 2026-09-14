// Exercise 4: Records
// Records are reference types (class records) or value types (struct records)
// They have auto-generated: Equals, GetHashCode, ToString, deconstruction, with expressions

using System;

// Positional record — primary constructor syntax (C# 9+)
public record PersonRecord(string Name, int Age, string City);

// Record with additional members
public record EmployeeRecord(string Name, int Age, string City, string Title)
{
    public override string ToString() => $"{Name} — {Title} in {City}";
}

// Record struct (C# 10+)
public readonly record struct PointRecord(double X, double Y);

// Normal class record (no positional syntax)
public record Product
{
    public string Name { get; init; }
    public decimal Price { get; init; }
    public int Stock { get; init; }
}

class Program
{
    static void Main()
    {
        // Create records with positional syntax
        var alice = new PersonRecord("Alice", 30, "NYC");
        var bob = new PersonRecord("Bob", 25, "LA");

        Console.WriteLine(alice);
        Console.WriteLine(bob);

        // Value equality — two records with same data are equal
        var alice2 = new PersonRecord("Alice", 30, "NYC");
        Console.WriteLine($"alice == alice2: {alice == alice2}");  // True

        // Deconstruction — like Kotlin destructuring
        var (name, age, city) = alice;
        Console.WriteLine($"{name} is {age} in {city}");

        // With expression — create modified copy (immutability)
        var olderAlice = alice with { Age = 31 };
        Console.WriteLine($"Original: {alice}");
        Console.WriteLine($"Older: {olderAlice}");

        // Record struct — value type record
        var origin = new PointRecord(0, 0);
        var p = new PointRecord(3, 4);
        Console.WriteLine($"p = {p}");
        Console.WriteLine($"p == origin: {p == origin}");

        // Normal record class
        var laptop = new Product
        {
            Name = "Laptop",
            Price = 999.99m,
            Stock = 50
        };
        var discountedLaptop = laptop with { Price = 799.99m };
        Console.WriteLine(discountedLaptop);

        // Record in a collection
        var people = new List<PersonRecord> { alice, bob, alice2 };
        var uniquePeople = new HashSet<PersonRecord>(people);
        Console.WriteLine($"Unique count: {uniquePeople.Count}");  // 2 (alice == alice2)
    }
}
