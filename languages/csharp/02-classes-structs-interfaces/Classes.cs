// Exercise 1: Classes and Properties
// C# classes: fields, properties, constructors, methods, access modifiers

using System;

class Person
{
    // Auto-properties with init-only setters (C# 9+) — immutable after construction
    public string Name { get; init; }
    public int Age { get; init; }
    public string City { get; init; }

    // Traditional property with backing field
    private string? _email;
    public string? Email
    {
        get => _email;
        set => _email = value?.ToLower().Trim();
    }

    // Constructor
    public Person(string name, int age, string city)
    {
        Name = name;
        Age = age;
        City = city;
    }

    // Overloaded constructor — delegates to primary constructor
    public Person(string name, int age) : this(name, age, "Unknown")
    {
    }

    // Method
    public string Greet() => $"Hello, I'm {Name} from {City}.";

    // Override ToString for display
    public override string ToString() => $"{Name} (age {Age}) from {City}";
}

// Class with inheritance
class Employee : Person
{
    public string JobTitle { get; init; }
    public double Salary { get; private set; }

    public Employee(string name, int age, string city, string title, double salary)
        : base(name, age, city)
    {
        JobTitle = title;
        Salary = salary;
    }

    public void GiveRaise(double percentage)
    {
        Salary *= (1 + percentage / 100);
    }

    public override string ToString() =>
        $"{base.ToString()}, {JobTitle}, ${Salary:F0}/yr";
}

class Program
{
    static void Main()
    {
        var alice = new Person("Alice", 30, "New York");
        Console.WriteLine(alice);
        Console.WriteLine(alice.Greet());

        // Init-only — can't reassign after construction
        // alice.Name = "Bob";  // Error: property or indexer 'Person.Name' cannot be used in this context

        var bob = new Person("Bob", 25);
        Console.WriteLine($"Bob: {bob.Name}, City: {bob.City}");

        // Email with computed setter
        alice.Email = " Alice@Example.COM ";
        Console.WriteLine($"Alice's email: {alice.Email}");
    }
}
