// Exercise 4: Records

using System;

public record PersonRecord(string Name, int Age, string City);
public record EmployeeRecord(string Name, int Age, string City, string Title)
{
    public override string ToString() => $"{Name} — {Title} in {City}";
}
public readonly record struct PointRecord(double X, double Y);
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
        var alice = new PersonRecord("Alice", 30, "NYC");
        var bob = new PersonRecord("Bob", 25, "LA");
        Console.WriteLine(alice);
        Console.WriteLine(bob);

        var alice2 = new PersonRecord("Alice", 30, "NYC");
        Console.WriteLine($"alice == alice2: {alice == alice2}");

        var (name, age, city) = alice;
        Console.WriteLine($"{name} is {age} in {city}");

        var olderAlice = alice with { Age = 31 };
        Console.WriteLine($"Original: {alice}");
        Console.WriteLine($"Older: {olderAlice}");

        var origin = new PointRecord(0, 0);
        var p = new PointRecord(3, 4);
        Console.WriteLine($"p = {p}");
        Console.WriteLine($"p == origin: {p == origin}");

        var laptop = new Product { Name = "Laptop", Price = 999.99m, Stock = 50 };
        var discountedLaptop = laptop with { Price = 799.99m };
        Console.WriteLine(discountedLaptop);

        var people = new List<PersonRecord> { alice, bob, alice2 };
        var uniquePeople = new HashSet<PersonRecord>(people);
        Console.WriteLine($"Unique count: {uniquePeople.Count}");
    }
}
