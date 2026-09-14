# Project 05: Exceptions and Nullable Reference Types — C#

**Difficulty:** intermediate  
**Prerequisites:** Project 04 (LINQ and Async/Await)

## Goals

- Handle errors gracefully with `try`, `catch`, `finally`, and `throw`
- Create custom exception types that convey meaningful error context
- Understand exception filters and when to wrap vs. re-throw
- Enable and use Nullable Reference Types (NRTs) to eliminate null reference exceptions at compile time
- Apply null-coalescing (`??`), null-conditional (`?.`), and throw helpers idiomatically

## Concepts

- **Exceptions** — structured error propagation; `try`/`catch`/`finally` blocks; exception hierarchy (`System.Exception` and subclasses)
- **Custom exceptions** — derive from `Exception` (or a domain-specific base); include relevant data as properties
- **Exception filters** — `catch (T ex) when (condition)` — catch only when predicate matches without unwinding stack
- **Exception wrapping** — catch a low-level exception and wrap it in a higher-level one while preserving the inner exception
- **Nullable Reference Types (NRTs)** — compiler feature (C# 8+) that distinguishes `string` (non-nullable) from `string?` (nullable); enables compile-time null-safety analysis
- **Null-coalescing (`??`)** — provide a fallback when a value is null
- **Null-conditional (`?.`)** — safe member access that short-circuits to null
- **`ArgumentNullException.ThrowIfNull`** — C# 10+ helper to throw on null arguments without boilerplate
- **Null-forgiving operator (`!`)** — suppress NRT warnings when you know more than the compiler

## Exercises

### Exercise 1: Exception Handling — try, catch, finally, throw

Create `Exceptions.cs`:

```csharp
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
```

**Expected output:**

```
=== Basic try-catch ===
Caught: Temperature -300°C is below absolute zero
  Value was: -300°C

=== catch with when filter ===
Filtered catch: Unreasonably high temperature: 999999°C

=== try-catch-finally ===
  Acquiring resource...
  Reading: 25°C
  Releasing resource (always runs)

=== Exception wrapping (preserve stack) ===
Outer: Sensor subsystem failed
  Inner: Temperature -500°C is below absolute zero

=== Avoid exceptions for control flow ===
  Recorded: 20°C
  Skipping invalid input: -300 (validated, no exception)
  Recorded: 25°C
```

**Notes:**

- `try-catch-finally` ensures cleanup code runs regardless of whether an exception occurred.
- Catch specific exception types first; catch `Exception` last as a safety net.
- Use `when` filters to differentiate between exceptions of the same type based on context (e.g., parameter name).
- Wrap low-level exceptions in domain-appropriate types but always pass the original as the `innerException` parameter — this preserves the full stack trace for debugging.
- Exceptions are expensive. Use them for truly exceptional conditions, not for expected validation paths. Check first, throw second.

### Exercise 2: Nullable Reference Types (NRTs)

Create `NullableTypes.cs`:

```csharp
// Exercise 2: Nullable Reference Types (NRTs)
// Covers: string? vs string, null-coalescing (??), null-conditional (?.),
//         ArgumentNullException, ArgumentNullException.ThrowIfNull (C# 10+),
//         pattern: "null object" vs "throw on null"

using System;

public class UserService
{
    // NRT enabled: this string cannot be null from the compiler's perspective
    public string ServiceName { get; } = "UserService";

    // NRT: nullable — caller must handle null
    public string? GetUserEmail(int userId)
    {
        // Simulate database lookup that might not find user
        if (userId <= 0) return null;
        return $"user{userId}@example.com";
    }

    // NRT: non-nullable return — must never return null
    public string GetDisplayName(int userId)
    {
        // Pattern 1: null-coalescing with fallback
        string? email = GetUserEmail(userId);
        return email ?? $"User_{userId}";
    }

    // Pattern 2: throw on null (C# 10+ helper)
    public void UpdateEmail(int userId, string? newEmail)
    {
        // ArgumentNullException.ThrowIfNull is the modern idiom
        ArgumentNullException.ThrowIfNull(newEmail);

        // In real code: validate, save to DB, etc.
        Console.WriteLine($"  Updated email for user {userId}: {newEmail}");
    }

    // Pattern 3: null-conditional access
    public int? GetDomainLength(int userId)
    {
        string? email = GetUserEmail(userId);
        // ?. only evaluates if not null; returns null if email is null
        return email?.Split('@')?.Last()?.Length;
    }
}

// A class that uses NRTs across its API surface
public class Order
{
    public int OrderId { get; init; }
    public string? Notes { get; set; }  // nullable — orders may have no notes
    public DateTime? ShippedDate { get; set; }  // nullable — not yet shipped

    // Non-nullable after construction: use ! to suppress warning if you know it's set
    public string CustomerName { get; init; } = "";

    public bool IsShipped => ShippedDate.HasValue;

    public void PrintSummary()
    {
        Console.WriteLine($"Order #{OrderId} — {CustomerName}");
        // ?. with ?? for display
        Console.WriteLine($"  Notes: {Notes ?? "(none)"}");
        Console.WriteLine($"  Shipped: {ShippedDate?.ToString("yyyy-MM-dd") ?? "Not yet"}");
    }

    // Show the null-forgiving operator (!) — use sparingly
    public void AssertShipped()
    {
        // You know this is only called when shipped; suppress the warning
        var shipDate = ShippedDate;
        if (shipDate == null)
            throw new InvalidOperationException("Order not shipped");
        // shipDate! — suppresses NRT warning if you must pass to a non-nullable param
        Console.WriteLine($"  Shipped on: {shipDate.Value:yyyy-MM-dd}");
    }
}

class Program
{
    static void Main()
    {
        var userService = new UserService();

        Console.WriteLine("=== Nullable return values ===");
        string? email1 = userService.GetUserEmail(5);
        Console.WriteLine($"  User 5 email: {email1}");

        string? email2 = userService.GetUserEmail(-1);
        Console.WriteLine($"  User -1 email: {email2}");

        Console.WriteLine("\n=== Null-coalescing fallback ===");
        string display = userService.GetDisplayName(-1); // returns fallback
        Console.WriteLine($"  Display name for missing user: {display}");

        Console.WriteLine("\n=== Null-conditional chaining ===");
        int? domainLen = userService.GetDomainLength(5); // user5@example.com → 11
        Console.WriteLine($"  Domain length for user 5: {domainLen}");
        int? domainLenMissing = userService.GetDomainLength(-1); // null → null
        Console.WriteLine($"  Domain length for missing user: {domainLenMissing}");

        Console.WriteLine("\n=== Throw on null ===");
        try
        {
            userService.UpdateEmail(1, null);
        }
        catch (ArgumentNullException ex)
        {
            Console.WriteLine($"  Caught: {ex.Message} (param: {ex.ParamName})");
        }
        userService.UpdateEmail(1, "newemail@example.com");

        Console.WriteLine("\n=== Order with nullable properties ===");
        var order = new Order
        {
            OrderId = 1001,
            CustomerName = "Alice",
            Notes = "Rush delivery",
            ShippedDate = new DateTime(2024, 3, 15)
        };
        order.PrintSummary();

        var pendingOrder = new Order
        {
            OrderId = 1002,
            CustomerName = "Bob"
            // Notes = null (default), ShippedDate = null (default)
        };
        pendingOrder.PrintSummary();
    }
}
```

**Expected output:**

```
=== Nullable return values ===
  User 5 email: user5@example.com
  User -1 email:

=== Null-coalescing fallback ===
  Display name for missing user: User_-1

=== Null-conditional chaining ===
  Domain length for user 5: 11
  Domain length for missing user:

=== Throw on null ===
  Caught: Value cannot be null. (Parameter 'newEmail')
  Updated email for user 1: newemail@example.com

=== Order with nullable properties ===
Order #1001 — Alice
  Notes: Rush delivery
  Shipped: 2024-03-15
Order #1002 — Bob
  Notes: (none)
  Shipped: Not yet
```

**Notes:**

- NRTs are enabled by default in .NET 6+ SDK-style projects via `<Nullable>enable</Nullable>`.
- The compiler issues warnings (not errors) when you assign null to a non-nullable reference or dereference a possibly-null value.
- `??` provides a fallback value; `?.` safely accesses members; both work together to eliminate most null reference exceptions.
- `ArgumentNullException.ThrowIfNull(arg)` (C# 10+) is the modern replacement for the old `if (arg is null) throw new ArgumentNullException(...)` pattern.
- The null-forgiving operator (`!`) suppresses warnings — use it only when you are certain the value is non-null at runtime, e.g., after a manual check.

### Exercise 3: Exception Logging and Stack Preservation

Create `ExceptionLogging.cs`:

```csharp
// Exercise 3: Logging and Monitoring with Exceptions
// Covers: logging exceptions, capturing stack traces, exception filters for
//         logging vs handling, using ExceptionDispatchInfo to preserve stack

using System;
using System.IO;

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
public class ReliableProcessor
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
```

**Expected output:**

```
=== Exception filtering for logging ===
  Attempting operation...
  Logged to /tmp/csharp_05_errors.log: ArgumentException
  Validation error logged; continuing...

=== Preserve stack with ExceptionDispatchInfo ===
  Doing risky work...
  Caught and will re-throw later
  Doing cleanup...
  Outer catch: Something went wrong
  Stack trace shows original throw site:
  at ReliableProcessor.Process()

=== Read back the log ===
[2024-...] [InputValidation] ArgumentException: Bad argument
   at Program.Main()

  Cleaned up /tmp/csharp_05_errors.log
```

**Notes:**

- Exception filters (`when`) let you log specific exception types without catching and re-throwing (which would reset the stack).
- `ExceptionDispatchInfo.Capture(ex).Throw()` preserves the original stack trace when you need to catch, do cleanup, and re-throw later. A plain `throw` inside a catch block resets the stack to the re-throw point.
- For production logging, consider structured logging frameworks (Serilog, NLog, Microsoft.Extensions.Logging) and always log the exception object itself (not just `Message`) so the stack trace is captured.

## Completion Checklist

- [ ] You can write `try`/`catch`/`finally` blocks and understand the execution order
- [ ] You can create a custom exception type with additional properties
- [ ] You can catch specific exception types and use `when` filters
- [ ] You can wrap low-level exceptions while preserving the inner exception
- [ ] You can use `try`-with-resources pattern (via `using` / `using var`) for deterministic cleanup
- [ ] You understand when NOT to use exceptions (expected validation paths — check first)
- [ ] You can enable and use Nullable Reference Types (`string?` vs `string`)
- [ ] You can apply null-coalescing (`??`) and null-conditional (`?.`) operators idiomatically
- [ ] You can use `ArgumentNullException.ThrowIfNull` (C# 10+) for argument validation
- [ ] You can preserve stack traces when re-throwing via `ExceptionDispatchInfo`
- [ ] You know the difference between `throw ex;` (resets stack) and `throw;` (preserves stack)

## Hints

- Always catch the most specific exception type first; `catch (Exception)` should be a last resort.
- In C#, `throw;` (with no expression) re-throws the current exception and preserves the original stack trace. `throw ex;` resets the stack to the current location.
- The `finally` block runs whether or not an exception occurred — ideal for cleanup (closing streams, releasing locks).
- NRTs are a compile-time analysis feature; they don't change runtime behavior. A `string?` can still hold a non-null value and vice versa if you use the `!` operator.
- Prefer nullable reference types over `null` object patterns (e.g., `NullUser`) when the absence of a value is truly exceptional and callers should handle it explicitly.
- Use `??` for fallback values and `?.` for safe navigation — they compose well: `obj?.Property?.NestedValue ?? defaultValue`.
- `ArgumentNullException.ThrowIfNull` is terser and more readable than the old `if (x is null) throw` pattern.
- C# 11 introduced `required` members as an alternative to null-forgiving for required properties — consider using them for mandatory data.
