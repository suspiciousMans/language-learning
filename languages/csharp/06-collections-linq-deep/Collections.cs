// Exercise 1: Dictionaries and Lookup
// Covers: Dictionary<TKey, TValue>, Lookup<TKey, TElement>, TryGetValue,
//         Safe key access, LINQ ToLookup, handling missing keys

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
