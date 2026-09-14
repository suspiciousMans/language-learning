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
