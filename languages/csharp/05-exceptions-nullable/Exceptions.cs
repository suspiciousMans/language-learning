// Exercise 1: Exception Handling — try, catch, finally, throw
// Covers: try-catch-finally blocks, catch filtering, wrapping exceptions,
//         custom exception types, when to use exceptions vs error codes

using System;

// Custom exception — derive from Exception or a more specific base
public class InvalidTemperatureException : Exception
{
    public double Value { get; }

    public InvalidTemperatureException(double value, string message)
        : base(message)
    {
        Value = value;
    }
}

// Business logic class that raises exceptions for invalid state
public class Thermometer
{
    private double _lastReading;

    // Throws on physically impossible temperatures
    public void RecordReading(double celsius)
    {
        if (celsius < -273.15)
            throw new InvalidTemperatureException(celsius,
                $"Temperature {celsius}°C is below absolute zero");
        if (celsius > 1_000_000)
            throw new ArgumentException($"Unreasonably high temperature: {celsius}°C",
                nameof(celsius));

        _lastReading = celsius;
    }

    public double LastReading => _lastReading;

    // Demonstrates try-catch-finally for resource cleanup
    public void ProcessWithCleanup()
    {
        try
        {
            Console.WriteLine("  Acquiring resource...");
            // Simulate work that might fail
            RecordReading(25.0);
            Console.WriteLine($"  Reading: {_lastReading}°C");
            // Uncomment to see catch in action:
            // RecordReading(-300);
        }
        catch (InvalidTemperatureException ex)
        {
            Console.WriteLine($"  Invalid reading caught: {ex.Message}");
            throw; // re-throw to let caller decide
        }
        finally
        {
            Console.WriteLine("  Releasing resource (always runs)");
        }
    }
}

class Program
{
    static void Main()
    {
        var thermometer = new Thermometer();

        Console.WriteLine("=== Basic try-catch ===");
        try
        {
            thermometer.RecordReading(-300);
        }
        catch (InvalidTemperatureException ex)
        {
            Console.WriteLine($"Caught: {ex.Message}");
            Console.WriteLine($"  Value was: {ex.Value}°C");
        }

        Console.WriteLine("\n=== catch with when filter ===");
        try
        {
            thermometer.RecordReading(999999);
        }
        catch (ArgumentException ex) when (ex.ParamName == "celsius")
        {
            Console.WriteLine($"Filtered catch: {ex.Message}");
        }

        Console.WriteLine("\n=== try-catch-finally ===");
        try
        {
            thermometer.ProcessWithCleanup();
        }
        catch (InvalidTemperatureException)
        {
            Console.WriteLine("  Caller caught re-thrown exception");
        }

        Console.WriteLine("\n=== Exception wrapping (preserve stack) ===");
        try
        {
            try
            {
                thermometer.RecordReading(-500);
            }
            catch (InvalidTemperatureException inner)
            {
                // Wrap with context but preserve original stack
                throw new InvalidOperationException(
                    "Sensor subsystem failed", inner);
            }
        }
        catch (InvalidOperationException ex)
        {
            Console.WriteLine($"Outer: {ex.Message}");
            Console.WriteLine($"  Inner: {ex.InnerException?.Message}");
        }

        Console.WriteLine("\n=== Avoid exceptions for control flow ===");
        // Bad: using exceptions for expected validation
        // Good: validate first, then proceed
        double[] inputs = { 20.0, -300.0, 25.0 };
        foreach (var input in inputs)
        {
            if (input < -273.15)
            {
                Console.WriteLine($"  Skipping invalid input: {input} (validated, no exception)");
                continue;
            }
            thermometer.RecordReading(input);
            Console.WriteLine($"  Recorded: {input}°C");
        }
    }
}
