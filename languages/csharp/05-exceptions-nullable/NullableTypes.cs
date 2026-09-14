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
