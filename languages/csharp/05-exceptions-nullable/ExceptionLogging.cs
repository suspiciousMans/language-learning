// Exercise 3: Logging and Monitoring with Exceptions
// Covers: logging exceptions, capturing stack traces, exception filters for
//         logging vs handling, using ExceptionDispatchInfo to preserve stack

using System;
using System.IO;
using System.Runtime.ExceptionServices;

public class ErrorLogger
{
    private readonly string _logPath;

    public ErrorLogger(string logPath) => _logPath = logPath;

    // Log an exception with timestamp and stack trace
    public void Log(Exception ex, string context)
    {
        string entry = $"[{DateTime.UtcNow:yyyy-MM-dd HH:mm:ss}] [{context}] {ex.GetType().Name}: {ex.Message}\n{ex.StackTrace}\n";
        File.AppendAllText(_logPath, entry);
        Console.WriteLine($"  Logged to {_logPath}: {ex.GetType().Name}");
    }
}

// Demonstrates ExceptionDispatchInfo for re-throwing with original stack
public class Reliable Processor
{
    public void Process()
    {
        try
        {
            Console.WriteLine("  Doing risky work...");
            throw new InvalidOperationException("Something went wrong");
        }
        catch (Exception ex)
        {
            // Capture so we can re-throw later with full stack
            ExceptionDispatchInfo capture = ExceptionDispatchInfo.Capture(ex);
            Console.WriteLine("  Caught and will re-throw later");
            // Do other work...
            Console.WriteLine("  Doing cleanup...");
            // Re-throw preserving original stack trace
            capture.Throw();
        }
    }
}

class Program
{
    static void Main()
    {
        // Setup: create a temp log file
        string logPath = Path.Combine(Path.GetTempPath(), "csharp_05_errors.log");
        File.Delete(logPath); // start fresh

        var logger = new ErrorLogger(logPath);

        Console.WriteLine("=== Exception filtering for logging ===");
        try
        {
            Console.WriteLine("  Attempting operation...");
            throw new ArgumentException("Bad argument", nameof(Filename));
        }
        catch (Exception ex) when (ex is ArgumentException)
        {
            // Log all argument errors but don't stop execution
            logger.Log(ex, "InputValidation");
            Console.WriteLine("  Validation error logged; continuing...");
        }
        catch (Exception ex)
        {
            logger.Log(ex, "Unexpected");
            Console.WriteLine("  Unexpected error — aborting");
            return;
        }

        Console.WriteLine("\n=== Preserve stack with ExceptionDispatchInfo ===");
        try
        {
            var processor = new ReliableProcessor();
            processor.Process();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"  Outer catch: {ex.Message}");
            Console.WriteLine($"  Stack trace shows original throw site:");
            Console.WriteLine($"  {ex.StackTrace}");
        }

        Console.WriteLine("\n=== Read back the log ===");
        if (File.Exists(logPath))
        {
            Console.WriteLine(File.ReadAllText(logPath));
        }

        // Cleanup
        File.Delete(logPath);
        Console.WriteLine($"\n  Cleaned up {logPath}");
    }

    static string Filename => "data.csv";
}
