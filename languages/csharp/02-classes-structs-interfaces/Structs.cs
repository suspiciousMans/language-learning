// Exercise 2: Structs

using System;

public struct Point2D
{
    public double X { get; }
    public double Y { get; }

    public Point2D(double x, double y)
    {
        X = x;
        Y = y;
    }

    public double DistanceFromOrigin() => Math.Sqrt(X * X + Y * Y);

    public override string ToString() => $"({X}, {Y})";
}

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

public readonly record struct Color(byte R, byte G, byte B);

class Program
{
    static void Main()
    {
        var p1 = new Point2D(3, 4);
        var p2 = p1;
        p2 = new Point2D(5, 12);

        Console.WriteLine($"p1 = {p1}, distance = {p1.DistanceFromOrigin()}");
        Console.WriteLine($"p2 = {p2}, distance = {p2.DistanceFromOrigin()}");

        var mp = new MutablePoint { X = 10, Y = 20 };
        mp.Move(5, -3);
        Console.WriteLine($"mp = ({mp.X}, {mp.Y})");

        var red = new Color(255, 0, 0);
        var red2 = new Color(255, 0, 0);
        Console.WriteLine($"red == red2: {red == red2}");

        var blue = new Color(0, 0, 255);
        Console.WriteLine($"red == blue: {red == blue}");
    }
}
