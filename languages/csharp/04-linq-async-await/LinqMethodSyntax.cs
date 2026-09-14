// LinqMethodSyntax.cs — Project 04, Exercise 1
// Topics: LINQ method syntax, filtering (Where), projection (Select),
//         sorting (OrderBy), aggregation (Count, Average, Min, Max),
//         grouping (GroupBy), deferred execution.
//
// Expected output:
//   Engineers:
//     Alice (age 30)
//     Charlie (age 35)
//     Eve (age 32)
//
//   All names: [Alice, Bob, Charlie, Diana, Eve, Frank]
//
//   Engineers by age: [Alice (30), Eve (32), Charlie (35)]
//
//   Total people: 6
//   Average age: 28.7
//   Youngest: 22
//   Oldest: 40
//
//   By department:
//     Engineering: 3 people
//     Marketing: 2 people
//     Sales: 1 people
//
//   === Deferred Execution ===
//   Count after adding Grace: 4

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
        Console.WriteLine($"\nAverage age: {people.Average(p => p.Age):F1}");
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
