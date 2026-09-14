// Exercise 2: Custom Attributes — Creating, Applying, and Consuming
// Covers: defining custom attribute classes, [AttributeUsage] restrictions,
//         named/positional parameters, multi-use attributes, Attribute.GetCustomAttributes,
//         attribute inheritance, using attributes to drive runtime behavior

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

// --- Custom attributes ---

// [Version] — a simple version stamp on types and methods
[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = false, Inherited = true)]
public class VersionAttribute : Attribute
{
    public string Version { get; }
    public VersionAttribute(string version) => Version = version;
}

// [Validate] — marks properties that should be validated with a max length
[AttributeUsage(AttributeTargets.Property, AllowMultiple = true)]
public class ValidateAttribute : Attribute
{
    public string Rule { get; }
    public int? MaxLength { get; set; }
    public bool Required { get; set; } = false;

    public ValidateAttribute(string rule) => Rule = rule;
}

// [Command] — marks methods as CLI commands with a name and description
[AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
public class CommandAttribute : Attribute
{
    public string Name { get; }
    public string Description { get; }
    public CommandAttribute(string name, string description)
    {
        Name = name;
        Description = description;
    }
}

// --- Sample API controller with attribute-annotated members ---

[Version("1.2.0")]
[Description("UserAccount handles user profile operations")]
public class UserAccount
{
    [Validate("email", MaxLength = 256, Required = true)]
    public string Email { get; set; } = "";

    [Validate("name", MaxLength = 100, Required = true)]
    public string DisplayName { get; set; } = "";

    [Validate("bio")]
    public string Bio { get; set; } = "";

    [Command("create", "Create a new user account")]
    public void CreateAccount(string email, string displayName)
    {
        Console.WriteLine($"Creating account for {displayName} ({email})");
    }

    [Command("update", "Update an existing user profile")]
    public void UpdateProfile(string displayName, string? bio = null)
    {
        Console.WriteLine($"Updating profile: {displayName}, bio: {bio ?? "(none)"}");
    }

    [Command("delete", "Delete a user account")]
    [Obsolete("Use SoftDelete instead")]
    public void DeleteAccount()
    {
        Console.WriteLine("Deleting account (hard delete)");
    }

    [Command("soft-delete", "Mark account as deleted")]
    public void SoftDelete()
    {
        Console.WriteLine("Marking account as deleted (soft delete)");
    }

    // Method without [Command] — should not show up in command discovery
    public void InternalMaintenance()
    {
        Console.WriteLine("Running internal maintenance (not a CLI command)");
    }
}

// --- Attribute discovery and consumption ---

class Program
{
    static void Main()
    {
        Console.WriteLine("=== Discovering [Command] methods ===\n");

        var commands = DiscoverCommands(typeof(UserAccount));
        Console.WriteLine($"Found {commands.Count} commands:\n");

        foreach (var (methodName, commandName, description) in commands)
        {
            Console.WriteLine($"  {commandName,-15} → {methodName} — {description}");
        }

        Console.WriteLine("\n=== Simulating CLI dispatch ===\n");

        // Discover and invoke a command by name
        var method = typeof(UserAccount).GetMethod("CreateAccount");
        if (method != null)
        {
            var cmdAttr = method.GetCustomAttribute<CommandAttribute>();
            Console.WriteLine($"Dispatching command: {cmdAttr?.Name ?? "(no attr)"}");
            method.Invoke(new UserAccount(), new object[] { "user@example.com", "Alice" });
        }

        Console.WriteLine("\n=== Validating properties via [Validate] attributes ===\n");

        var account = new UserAccount
        {
            Email = "a".PadRight(300, 'a'),  // too long
            DisplayName = "Bob",
            Bio = ""
        };

        var errors = ValidateObject(account);
        if (errors.Count > 0)
        {
            Console.WriteLine("Validation errors:");
            foreach (var (propName, error) in errors)
            {
                Console.WriteLine($"  {propName}: {error}");
            }
        }
        else
        {
            Console.WriteLine("All properties valid.");
        }

        // Fix and re-validate
        account.Email = "bob@example.com";
        errors = ValidateObject(account);
        Console.WriteLine($"\nAfter fix — errors: {errors.Count}");

        Console.WriteLine("\n=== Reading [Version] from type and methods ===\n");

        var typeVersion = typeof(UserAccount).GetCustomAttribute<VersionAttribute>();
        Console.WriteLine($"UserAccount version: {typeVersion?.Version ?? "unknown"}");

        foreach (var method in typeof(UserAccount).GetMethods())
        {
            if (method.DeclaringType == typeof(object)) continue;
            var methodVersion = method.GetCustomAttribute<VersionAttribute>();
            if (methodVersion != null)
            {
                Console.WriteLine($"  {method.Name}: version {methodVersion.Version}");
            }
        }

        Console.WriteLine("\n=== Attribute inheritance ===\n");

        // Define a derived type to demonstrate Inherited = true
        // (Inherited = true means the attribute propagates to derived classes)
        var derivedType = typeof(DerivedUserAccount);
        var inheritedVersion = derivedType.GetCustomAttribute<VersionAttribute>();
        Console.WriteLine($"DerivedUserAccount inherits [Version]: {inheritedVersion?.Version ?? "not inherited"}");
    }

    /// <summary>
    /// Discovers all methods marked with [Command] and returns their metadata.
    /// </summary>
    static List<(string MethodName, string CommandName, string Description)> DiscoverCommands(Type type)
    {
        return type.GetMethods(BindingFlags.Public | BindingFlags.Instance)
            .Select(m => (Method: m, Attribute: m.GetCustomAttribute<CommandAttribute>()))
            .Where(x => x.Attribute != null)
            .Select(x => (x.Method.Name, x.Attribute!.Name, x.Attribute.Description))
            .ToList();
    }

    /// <summary>
    /// Validates object properties based on [Validate] attributes.
    /// </summary>
    static List<(string PropertyName, string Error)> ValidateObject(object obj)
    {
        var errors = new List<(string, string)>();
        var type = obj.GetType();

        foreach (var prop in type.GetProperties())
        {
            var validators = prop.GetCustomAttributes<ValidateAttribute>();
            foreach (var validator in validators)
            {
                var value = prop.GetValue(obj) as string;

                if (validator.Required && string.IsNullOrEmpty(value))
                {
                    errors.Add((prop.Name, $"Required but was empty"));
                    continue;
                }

                if (validator.MaxLength.HasValue && value?.Length > validator.MaxLength.Value)
                {
                    errors.Add((prop.Name, $"Exceeds max length {validator.MaxLength} (actual: {value?.Length})"));
                }
            }
        }

        return errors;
    }
}

// Derived class — demonstrates Inherited = true on VersionAttribute
[Version("2.0.0")]  // Explicit version on derived class
public class DerivedUserAccount : UserAccount
{
}
