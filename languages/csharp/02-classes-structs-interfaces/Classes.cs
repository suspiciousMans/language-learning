// Exercise 1: Classes and Properties

using System;

class Person
{
    public string Name { get; init; }
    public int Age { get; init; }
    public string City { get; init; }

    private string? _email;
    public string? Email
    {
        get => _email;
        set => _email = value?.ToLower().Trim();
    }

    public Person(string name, int age, string city)
    {
        Name = name;
        Age = age;
        City = city;
    }

    public Person(string name, int age) : this(name, age, "Unknown") { }

    public string Greet() => $"Hello, I'm {Name} from {City}.";

    public override string ToString() => $"{Name} (age {Age}) from {City}";
}

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

    public void GiveRaise(double percentage) => Salary *= (1 + percentage / 100);

    public override string ToString() => $"{base.ToString()}, {JobTitle}, ${Salary:F0}/yr";
}

class Program
{
    static void Main()
    {
        var alice = new Person("Alice", 30, "New York");
        Console.WriteLine(alice);
        Console.WriteLine(alice.Greet());

        var bob = new Person("Bob", 25);
        Console.WriteLine($"Bob: {bob.Name}, City: {bob.City}");

        alice.Email = " Alice@Example.COM ";
        Console.WriteLine($"Alice's email: {alice.Email}");
    }
}
