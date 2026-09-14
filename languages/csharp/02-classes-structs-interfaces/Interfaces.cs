// Exercise 3: Interfaces

using System;
using System.Collections.Generic;

public interface IShape
{
    double Area { get; }
    double Perimeter { get; }
    string Describe();
}

public interface IResizable
{
    void Scale(double factor);
}

public interface IDrawable
{
    void Draw();
}

public class Circle : IShape, IResizable
{
    public double Radius { get; init; }

    public Circle(double radius) => Radius = radius;

    double IShape.Area => Math.PI * Radius * Radius;
    double IShape.Perimeter => 2 * Math.PI * Radius;

    public string Describe() => $"Circle with radius {Radius:F2}";

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

public class DrawableCircle : Circle, IDrawable
{
    public DrawableCircle(double radius) : base(radius) { }
    public void Draw() => Console.WriteLine($"Drawing: {Describe()}");
}

class Program
{
    static void Main()
    {
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

        Circle c = new Circle(10);
        Console.WriteLine($"Circle area via IShape: {(c as IShape)?.Area?.ToString("F2")}");

        var resizableCircle = new Circle(3);
        Console.WriteLine($"Before scale: radius = {resizableCircle.Radius}");
        ((IResizable)resizableCircle).Scale(2);
        Console.WriteLine($"After scale: radius = {resizableCircle.Radius}");

        IDrawable drawable = new DrawableCircle(7);
        drawable.Draw();
    }
}
