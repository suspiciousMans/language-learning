// Program.cs — Project 07: File I/O and Serialization
// Entry point: runs all three exercises in sequence.

using System;

class Program
{
    static void Main()
    {
        Console.WriteLine("=== Exercise 1: File Streams ===");
        FileStreamExamples.Run();
        Console.WriteLine();

        Console.WriteLine("=== Exercise 2: Serialization ===");
        SerializationExamples.Run();
        Console.WriteLine();

        Console.WriteLine("=== Exercise 3: Advanced I/O ===");
        AdvancedIOExamples.Run();
    }
}
