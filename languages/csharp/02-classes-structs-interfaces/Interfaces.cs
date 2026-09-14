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
