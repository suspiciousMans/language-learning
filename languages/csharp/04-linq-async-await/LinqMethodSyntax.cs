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
        var query = people.Where(p => p.Age > 25);
        people.Add(new Person("Grace", 40, "HR"));
        Console.WriteLine($"Count after adding Grace: {query.Count()}");
    }
}

record Person(string Name, int Age, string Department);
