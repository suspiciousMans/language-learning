# Project 02: Classes, Structs, and Interfaces — C#

**Difficulty:** beginner  
**Prerequisites:** Project 01 (Basics)

## Goals

- Define classes with fields, properties, constructors, and methods
- Understand the difference between `class` (reference type) and `struct` (value type)
- Implement interfaces and use them for polymorphism
- Use C# records (immutable data types) and init-only properties

## Concepts

- **Classes** — reference types; inheritance, `base`, `this`, access modifiers
- **Structs** — value types; no inheritance (except `System.ValueType`), copied by value
- **Interfaces** — contracts; a class/struct can implement multiple interfaces
- **Properties** — auto-properties, computed properties, `init` accessors (C# 9+)
- **Records** — immutable data types with value-based equality, `with` expressions (C# 9+)
- **Access modifiers** — `public`, `private`, `protected`, `internal`

## Exercises

### Exercise 1: Classes and Properties

Create `Classes.cs`:

```csharp
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
```

**Expected output:**

```
Alice (age 30) from New York
Hello, I'm Alice from New York.
Bob: Bob, City: Unknown
Alice's email: alice@example.com
```

### Exercise 2: Structs

Create `Structs.cs`:

```csharp
// Exercise 2: Structs
// Structs are value types — copied by value, no null, stack-allocated (usually)

using System;

// Struct — value type, used for small, immutable data
public struct Point2D
{
    public double X { get; }
    public double Y { get; }

    public Point2D(double x, double y)
    {
        X = x;
        Y = y;
    }

    // Method on a struct
    public double DistanceFromOrigin() => Math.Sqrt(X * X + Y * Y);

    // Override ToString
    public override string ToString() => $"({X}, {Y})";
}

// Struct that's mutable (less common, generally discouraged)
public struct MutablePoint
{
    public double X;
    public double Y;

    public void Move(double dx, double dy)
    {
        X += dx;
        Y += dy;
    }
}

// Record struct — C# 10+, value-type record with value equality
public readonly record struct Color(byte R, byte G, byte B);

class Program
{
    static void Main()
    {
        // Struct created on the stack, copied by value
        var p1 = new Point2D(3, 4);
        var p2 = p1;          // COPY — p2 is a separate copy of p1's data
        p2 = new Point2D(5, 12);

        Console.WriteLine($"p1 = {p1}, distance = {p1.DistanceFromOrigin()}");
        Console.WriteLine($"p2 = {p2}, distance = {p2.DistanceFromOrigin()}");
        // p1 is unchanged — struct copy is independent

        // Mutable struct — be careful
        var mp = new MutablePoint { X = 10, Y = 20 };
        mp.Move(5, -3);
        Console.WriteLine($"mp = ({mp.X}, {mp.Y})");

        // Record struct — value equality, useful for small data
        var red = new Color(255, 0, 0);
        var red2 = new Color(255, 0, 0);
        Console.WriteLine($"red == red2: {red == red2}");  // True — value equality

        var blue = new Color(0, 0, 255);
        Console.WriteLine($"red == blue: {red == blue}");  // False
    }
}
```

**Expected output:**

```
p1 = (3, 4), distance = 5
p2 = (5, 12), distance = 13
mp = (15, 17)
red == red2: True
red == blue: False
```

### Exercise 3: Interfaces

Create `Interfaces.cs`:

```csharp
// Exercise 3: Interfaces
// Interfaces define contracts — classes/structs implement them
// A type can implement multiple interfaces

using System;
using System.Collections.Generic;

// Interface — no implementation, just contract
public interface IShape
{
    double Area { get; }
    double Perimeter { get; }
    string Describe();
}

// Interface with method parameters
public interface IResizable
{
    void Scale(double factor);
}

// Class implementing multiple interfaces
public class Circle : IShape, IResizable
{
    public double Radius { get; init; }

    public Circle(double radius) => Radius = radius;

    // Explicit interface implementation — implementation is private to the interface
    double IShape.Area => Math.PI * Radius * Radius;
    double IShape.Perimeter => 2 * Math.PI * Radius;

    // Public member that satisfies the interface
    public string Describe() => $"Circle with radius {Radius:F2}";

    // IResizable implementation
    public void Scale(double factor) => Radius *= factor;
}

public class Rectangle : IShape
{
    public double Width { get; init; }
    public double Height { get; init; }

    public Rectangle(double width, double height)
    {
        Width = width;
        Height = height;
    }

    public double Area => Width * Height;
    public double Perimeter => 2 * (Width + Height);
    public string Describe() => $"Rectangle {Width:F2} x {Height:F2}";
}

// Interface for objects that can be drawn (marker interface pattern)
public interface IDrawable
{
    void Draw();
}

// A class that implements IShape and IDrawable
public class DrawableCircle : Circle, IDrawable
{
    public DrawableCircle(double radius) : base(radius) { }

    public void Draw() => Console.WriteLine($"Drawing: {Describe()}");
}

class Program
{
    static void Main()
    {
        // Interface polymorphism
        IShape[] shapes = new IShape[]
        {
            new Circle(5),
            new Rectangle(4, 6),
            new Circle(2.5)
        };

        foreach (var shape in shapes)
        {
            Console.WriteLine($"Type: {shape.GetType().Name}");
            Console.WriteLine($"  Area: {shape.Area:F2}");
            Console.WriteLine($"  Perimeter: {shape.Perimeter:F2}");
            Console.WriteLine($"  {shape.Describe()}");
        }

        // Explicit interface implementation — access via interface cast
        Circle c = new Circle(10);
        // Console.WriteLine(c.Area);  // Error — not public
        Console.WriteLine($"Circle area via IShape: {(c as IShape)?.Area?.ToString("F2")}");

        // IResizable
        var resizableCircle = new Circle(3);
        Console.WriteLine($"Before scale: radius = {resizableCircle.Radius}");
        ((IResizable)resizableCircle).Scale(2);
        Console.WriteLine($"After scale: radius = {resizableCircle.Radius}");

        // IDrawable
        IDrawable drawable = new DrawableCircle(7);
        drawable.Draw();
    }
}
```

**Expected output:**

```
Type: Circle
  Area: 78.54
  Perimeter: 31.42
  Circle with radius 5.00
Type: Rectangle
  Area: 24.00
  Perimeter: 20.00
  Rectangle 4.00 x 6.00
Type: Circle
  Area: 19.63
  Perimeter: 15.71
  Circle with radius 2.50
Circle area via IShape: 314.16
Before scale: radius = 3
After scale: radius = 6
Drawing: Circle with radius 7.00
```

### Exercise 4: Records

Create `Records.cs`:

```csharp
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
```

**Expected output:**

```
PersonRecord { Name = Alice, Age = 30, City = NYC }
PersonRecord { Name = Bob, Age = 25, City = LA }
alice == alice2: True
Alice is 30 in NYC
Original: PersonRecord { Name = Alice, Age = 30, City = NYC }
Older: PersonRecord { Name = Alice, Age = 31, City = NYC }
p = PointRecord { X = 3, Y = 4 }
p == origin: False
Laptop — 799.99 in
Unique count: 2
```

## Completion Checklist

- [ ] You can define a class with auto-properties, constructors, and methods
- [ ] You can use `init` accessors for immutable-after-construction properties
- [ ] You can create a struct and understand that it's a value type (copied by value)
- [ ] You understand the difference between `class` (reference) and `struct` (value)
- [ ] You can implement one or more interfaces on a class
- [ ] You understand explicit interface implementation
- [ ] You can use interface polymorphism — treat different types through a common interface
- [ ] You can create records with positional syntax
- [ ] You can use `with` expressions to create modified copies
- [ ] You understand record equality (value-based) vs class equality (reference-based)
- [ ] You can deconstruct records and tuples

## Hints

- Prefer `class` for most things — use `struct` only for small, immutable data types
- `record` is C#'s answer to Kotlin's `data class` — use for data containers that need value equality
- `with` expressions are the C# equivalent of Kotlin's `copy` method
- Interface implementations can be implicit (public members) or explicit (private to the interface)
- Init-only properties (`init`) are a middle ground between mutable and fully immutable
