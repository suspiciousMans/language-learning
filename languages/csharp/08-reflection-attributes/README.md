# Project 08: Reflection, Attributes, and Metadata — C#

**Difficulty:** intermediate  
**Prerequisites:** Project 03 (Generics, Delegates, Events), Project 07 (File I/O and Serialization)

## Goals

- Inspect types at runtime using `Type`, `TypeInfo`, and `typeof(T)`
- Read and apply custom attributes to classes, methods, and properties
- Create instances and invoke members dynamically via reflection
- Discover types by interface and load plugins using attributes as metadata
- Build a simple reflection-based object mapper with cached property mappings
- Understand the performance implications of reflection and when to cache or avoid it

## Concepts

- **`System.Reflection`** — namespace for inspecting metadata, types, members, and attributes at runtime
- **`Type` and `TypeInfo`** — represent type declarations; `typeof(T)` for compile-time known types; `obj.GetType()` for runtime types
- **`MemberInfo`, `PropertyInfo`, `MethodInfo`, `ConstructorInfo`, `FieldInfo`** — representations of type members discoverable via reflection
- **`BindingFlags`** — filter which members are returned (`Public`, `NonPublic`, `Instance`, `Static`, `DeclaredOnly`)
- **`Activator.CreateInstance`** — create instances via reflection; supports parameterless and parameterized constructors
- **`MethodInfo.Invoke` and `PropertyInfo.GetValue`/`SetValue`** — dynamically call methods and read/write properties
- **`GetCustomAttributes` and `GetCustomAttribute<T>`** — read attributes applied to a type or member
- **`AttributeUsage`** — control where an attribute can be applied (`AttributeTargets`), whether it can be applied multiple times (`AllowMultiple`), and whether it is inherited by derived types (`Inherited`)
- **Custom attributes** — derive from `Attribute`; support positional parameters (constructor args) and named parameters (property setters)
- **Attribute inheritance** — `Inherited = true` means the attribute propagates to derived types; `false` means it does not
- **Cached reflection** — store `PropertyInfo`, `MethodInfo`, etc. in static dictionaries to avoid repetitive `GetProperties()` / `GetMethod()` calls in hot paths
- **Dynamic plugin discovery** — scan assemblies for types implementing an interface and decorated with a metadata attribute; instantiate and invoke via reflection or interface casting
- **Object mapping via reflection** — match source/destination properties by name and type compatibility; cache the mapping for repeated use
- **Performance considerations** — reflection is slower than direct calls; use caching, compiled expressions (`Expression` trees), or source generators for performance-critical paths

## Exercises

### Exercise 1: Reflection Basics — Type Inspection, Properties, Methods, Constructors

Create `AttributeReflection.cs`:

```csharp
// Exercise 1: Reflection Basics — Type Inspection, Properties, Methods, Constructors
// Covers: typeof(T), Object.GetType(), TypeInfo, getting properties/methods/constructors,
//         reading attributes via reflection, invoking methods dynamically

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

// Sample class with various members and attributes to inspect
[Description("A simple product representation")]
public class Product
{
    [DisplayName("Product ID")]
    public int Id { get; set; }

    [DisplayName("Product Name")]
    public string Name { get; set; } = "";

    [DisplayName("Unit Price")]
    public decimal Price { get; set; }

    [DisplayName("Stock Count")]
    public int Stock { get; set; }

    [Obsolete("Use Price instead")]
    public decimal Cost => Price;

    public Product() { }

    public Product(int id, string name, decimal price, int stock)
    {
        Id = id;
        Name = name;
        Price = price;
        Stock = stock;
    }

    public string GetSummary() =>
        $"{Name} (ID {Id}): {Price:C} each, {Stock} in stock";

    public decimal ApplyDiscount(decimal percent)
    {
        if (percent < 0 || percent > 100)
            throw new ArgumentOutOfRangeException(nameof(percent), "0–100");
        return Price * (1 - percent / 100m);
    }

    public static Product CreateDefault() =>
        new(0, "Default Product", 0m, 0);
}

// Custom attribute for display metadata
[AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false)]
public class DisplayNameAttribute : Attribute
{
    public string Name { get; }
    public DisplayNameAttribute(string name) => Name = name;
}

// Custom attribute for class-level descriptions
[AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
public class DescriptionAttribute : Attribute
{
    public string Text { get; }
    public DescriptionAttribute(string text) => Text = text;
}

class Program
{
    static void Main()
    {
        Console.WriteLine("=== 1. Inspecting a Type ===\n");

        Type productType = typeof(Product);
        Console.WriteLine($"Type: {productType.FullName}");
        Console.WriteLine($"Namespace: {productType.Namespace}");
        Console.WriteLine($"IsClass: {productType.IsClass}");
        Console.WriteLine($"IsValueType: {productType.IsValueType}");
        Console.WriteLine($"IsAbstract: {productType.IsAbstract}");
        Console.WriteLine($"IsGenericType: {productType.IsGenericType}");
        Console.WriteLine($"Assembly: {productType.Assembly.FullName}\n");

        // Get class-level attributes
        var descriptionAttr = productType.GetCustomAttribute<DescriptionAttribute>();
        Console.WriteLine($"Class description: {descriptionAttr?.Text ?? "(none)"}\n");

        Console.WriteLine("=== 2. Properties ===\n");

        foreach (var prop in productType.GetProperties())
        {
            var displayAttr = prop.GetCustomAttribute<DisplayNameAttribute>();
            string displayName = displayAttr?.Name ?? prop.Name;
            Console.WriteLine($"Property: {prop.Name}");
            Console.WriteLine($"  Display name: {displayName}");
            Console.WriteLine($"  Type: {prop.PropertyType.Name}");
            Console.WriteLine($"  CanRead: {prop.CanRead}, CanWrite: {prop.CanWrite}");
            Console.WriteLine($"  DeclaringType: {prop.DeclaringType?.Name}");
            Console.WriteLine($"  Custom attributes: {string.Join(", ", prop.GetCustomAttributes().Select(a => a.GetType().Name))}");
            Console.WriteLine();
        }

        Console.WriteLine("=== 3. Methods ===\n");

        foreach (var method in productType.GetMethods(BindingFlags.Public | BindingFlags.Instance | BindingFlags.Static))
        {
            // Skip inherited Object methods for clarity
            if (method.DeclaringType == typeof(object)) continue;

            Console.WriteLine($"Method: {method.Name}");
            Console.WriteLine($"  Return type: {method.ReturnType.Name}");
            Console.WriteLine($"  IsStatic: {method.IsStatic}");
            Console.WriteLine($"  IsAbstract: {method.IsAbstract}");
            Console.WriteLine($"  Parameters:");

            foreach (var param in method.GetParameters())
            {
                Console.WriteLine($"    {param.Name} ({param.ParameterType.Name}){param.DefaultValue != null ? $" = {param.DefaultValue}" : ""}");
            }

            var obsoleteAttr = method.GetCustomAttribute<ObsoleteAttribute>();
            if (obsoleteAttr != null)
                Console.WriteLine($"  [Obsolete]: {obsoleteAttr.Message}");

            Console.WriteLine();
        }

        Console.WriteLine("=== 4. Constructors ===\n");

        foreach (var ctor in productType.GetConstructors())
        {
            Console.WriteLine($"Constructor: {ctor.Name}");
            Console.WriteLine($"  Parameter count: {ctor.GetParameters().Length}");
            Console.WriteLine($"  Parameters:");

            foreach (var param in ctor.GetParameters())
            {
                Console.WriteLine($"    {param.Name} ({param.ParameterType.Name}) — {(param.HasDefaultValue ? "has default" : "required")}");
            }
            Console.WriteLine();
        }

        Console.WriteLine("=== 5. Creating instances via reflection ===\n");

        // Activator.CreateInstance — simple factory
        var defaultInstance = Activator.CreateInstance(productType);
        Console.WriteLine($"Created default instance via Activator: {defaultInstance?.GetType().Name}");

        // Constructor with arguments
        var specificCtor = productType.GetConstructor(new[] { typeof(int), typeof(string), typeof(decimal), typeof(int) });
        if (specificCtor != null)
        {
            var instance = specificCtor.Invoke(new object[] { 42, "Test Product", 9.99m, 100 });
            Console.WriteLine($"Created via specific constructor: {instance?.GetType().Name}");
        }

        Console.WriteLine("\n=== 6. Reading and writing properties dynamically ===\n");

        var product = new Product(1, "Widget", 19.99m, 50);

        // Read property via reflection
        var nameProp = productType.GetProperty(nameof(Product.Name));
        var nameValue = nameProp?.GetValue(product);
        Console.WriteLine($"product.Name via reflection: {nameValue}");

        // Write property via reflection
        var priceProp = productType.GetProperty(nameof(Product.Price));
        priceProp?.SetValue(product, 24.99m);
        Console.WriteLine($"product.Price after reflection set: {product.Price:C}");

        // Get all property values as a dictionary
        var propertyValues = productType.GetProperties()
            .Where(p => p.CanRead)
            .ToDictionary(p => p.Name, p => p.GetValue(product));
        Console.WriteLine("\nAll property values:");
        foreach (var (name, value) in propertyValues)
        {
            Console.WriteLine($"  {name}: {value}");
        }

        Console.WriteLine("\n=== 7. Invoking methods dynamically ===\n");

        var applyDiscountMethod = productType.GetMethod(nameof(Product.ApplyDiscount));
        if (applyDiscountMethod != null)
        {
            decimal discounted = (decimal)applyDiscountMethod.Invoke(product, new object[] { 20 });
            Console.WriteLine($"ApplyDiscount(20) via reflection: {discounted:C} (original: {product.Price:C})");
        }

        var getSummaryMethod = productType.GetMethod(nameof(Product.GetSummary));
        if (getSummaryMethod != null)
        {
            string summary = (string)getSummaryMethod.Invoke(product, null);
            Console.WriteLine($"GetSummary via reflection: {summary}");
        }

        Console.WriteLine("\n=== 8. Inspecting an existing object's type at runtime ===\n");

        object obj = product;
        Type runtimeType = obj.GetType();
        Console.WriteLine($"Runtime type of obj: {runtimeType.FullName}");
        Console.WriteLine($"Is Product: {runtimeType == typeof(Product)}");
        Console.WriteLine($"Base type: {runtimeType.BaseType?.FullName}");

        // Walk the inheritance chain
        Console.WriteLine("\nInheritance chain:");
        Type? t = runtimeType;
        while (t != null)
        {
            Console.WriteLine($"  {t.FullName} {(t == typeof(object) ? "(root)" : "")}");
            t = t.BaseType;
        }
    }
}
```

**Expected output:**

```
=== 1. Inspecting a Type ===

Type: Product
Namespace: 
IsClass: True
IsValueType: False
IsAbstract: False
IsGenericType: False
Assembly: ReflectionBasics, Version=...

Class description: A simple product representation

=== 2. Properties ===

Property: Id
  Display name: Product ID
  Type: Int32
  CanRead: True, CanWrite: True
  DeclaringType: Product
  Custom attributes: DisplayNameAttribute

Property: Name
  Display name: Product Name
  Type: String
  CanRead: True, CanWrite: True
  DeclaringType: Product
  Custom attributes: DisplayNameAttribute

Property: Price
  Display name: Unit Price
  Type: Decimal
  CanRead: True, CanWrite: True
  DeclaringType: Product
  Custom attributes: DisplayNameAttribute

Property: Stock
  Display name: Stock Count
  Type: Int32
  CanRead: True, CanWrite: True
  DeclaringType: Product
  Custom attributes: DisplayNameAttribute

Property: Cost
  Display name: Cost
  Type: Decimal
  CanRead: True, CanWrite: False
  DeclaringType: Product
  Custom attributes: 

=== 3. Methods ===

Method: GetSummary
  Return type: String
  IsStatic: False
  IsAbstract: False
  Parameters:

Method: ApplyDiscount
  Return type: Decimal
  IsStatic: False
  IsAbstract: False
  Parameters:
    percent (Decimal)

Method: CreateDefault
  Return type: Product
  IsStatic: True
  IsAbstract: False
  Parameters:

Method: GetType
  Return type: Type
  IsStatic: False
  IsAbstract: False
  Parameters:

... (Object methods omitted for brevity)

=== 4. Constructors ===

Constructor: .ctor
  Parameter count: 0
  Parameters:

Constructor: .ctor
  Parameter count: 4
  Parameters:
    id (Int32) — required
    name (String) — required
    price (Decimal) — required
    stock (Int32) — required

=== 5. Creating instances via reflection ===

Created default instance via Activator: Product
Created via specific constructor: Product

=== 6. Reading and writing properties dynamically ===

product.Name via reflection: Widget
product.Price after reflection set: $24.99

All property values:
  Id: 1
  Name: Widget
  Price: 24.99
  Stock: 50
  Cost: 24.99

=== 7. Invoking methods dynamically ===

ApplyDiscount(20) via reflection: $19.99 (original: $24.99)
GetSummary via reflection: Widget (ID 1): $24.99 each, 50 in stock

=== 8. Inspecting an existing object's type at runtime ===

Runtime type of obj: Product
Is Product: True
Base type: System.Object

Inheritance chain:
  Product (root)
  System.Object (root)
```

**Notes:**

- `typeof(T)` is resolved at compile time; use it when you know the type statically. `obj.GetType()` resolves at runtime and handles inheritance — use it when the concrete type may vary.
- `GetProperties()`, `GetMethods()`, and `GetConstructors()` return members from the type and its base types by default. Use `BindingFlags.DeclaredOnly` to get only members declared on the specific type.
- `GetCustomAttribute<T>()` returns the first matching attribute; `GetCustomAttributes()` returns all. Use the generic version when you expect a specific attribute type.
- `Activator.CreateInstance` is the simplest way to create instances via reflection, but for frequent creation of the same type, cache the `ConstructorInfo` and invoke it directly.
- `MethodInfo.Invoke` returns `object?` — cast to the expected type. For value-type returns, unbox carefully.
- `PropertyInfo.GetValue` and `SetValue` work with boxed values — no casting needed for reference types; for value types, the value is boxed/unboxed automatically.

### Exercise 2: Custom Attributes — Creating, Applying, and Consuming

Create `ReflectiveDispatch.cs`:

```csharp
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
```

**Expected output:**

```
=== Discovering [Command] methods ===

Found 4 commands:

  create          → CreateAccount — Create a new user account
  update          → UpdateProfile — Update an existing user profile
  delete          → DeleteAccount — Delete a user account
  soft-delete     → SoftDelete — Mark account as deleted

=== Simulating CLI dispatch ===

Dispatching command: create
Creating account for Alice (user@example.com)

=== Validating properties via [Validate] attributes ===

Validation errors:
  Email: Exceeds max length 256 (actual: 300)

After fix — errors: 0

=== Reading [Version] from type and methods ===

UserAccount version: 1.2.0

=== Attribute inheritance ===

DerivedUserAccount inherits [Version]: 2.0.0
```

**Notes:**

- `AttributeUsage` controls where an attribute can be applied: `AttributeTargets.Class`, `AttributeTargets.Method`, `AttributeTargets.Property`, etc. Combine with `|` for multiple targets.
- `AllowMultiple = true` allows the same attribute to be applied more than once to a single target — useful for `[Validate]` where multiple rules apply.
- `Inherited = true` means derived classes automatically inherit the attribute from their base class. This is useful for attributes like `[Version]` where you want the version to propagate. Setting it to `false` (the default) means only the exact type is checked.
- Positional parameters are passed via the attribute constructor; named parameters are public properties or fields settable via property syntax in the attribute usage: `[Validate("email", MaxLength = 256)]`.
- Custom attributes are consumed at runtime via `GetCustomAttribute<T>()` or `GetCustomAttributes()`. They are not enforced at compile time — the consuming code must check for their presence.
- The `[Obsolete]` attribute is a built-in attribute that produces compiler warnings when the annotated member is used. It's a good example of an attribute that affects both compile-time and runtime behavior.

### Exercise 3: Real-World Reflection — Object Mappers, Plugins, and Metadata-Driven Code

Create `PluginReflection.cs`:

```csharp
// Exercise 3: Real-World Reflection — Object Mappers, Plugins, and Metadata-Driven Code
// Covers: building a simple object-to-object mapper using reflection,
//         loading assemblies dynamically (Assembly.LoadFrom), discovering types by interface,
//         late binding with delegates, performance considerations (cached reflection)

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

// --- Interfaces for plugin discovery ---

public interface IPlugin
{
    string Name { get; }
    string Description { get; }
    void Execute();
}

public interface IDataTransform
{
    string Transform(string input);
}

// --- Plugin implementations (in the same assembly for this exercise;
//     in real code these would live in separate assemblies loaded at runtime) ---

[PluginInfo("Uppercase Transform", "Converts text to uppercase")]
public class UppercaseTransform : IDataTransform
{
    public string Transform(string input) => input.ToUpperInvariant();
}

[PluginInfo("Reverse Transform", "Reverses the input string")]
public class ReverseTransform : IDataTransform
{
    public string Transform(string input)
    {
        char[] chars = input.ToCharArray();
        Array.Reverse(chars);
        return new string(chars);
    }
}

[PluginInfo("Word Count", "Counts words in the input")]
public class WordCountTransform : IDataTransform
{
    public string Transform(string input)
    {
        int count = input.Split((char[])null, StringSplitOptions.RemoveEmptyEntries).Length;
        return $"Word count: {count}";
    }
}

// --- Custom attribute for plugin metadata ---

[AttributeUsage(AttributeTargets.Class, AllowMultiple = false)]
public class PluginInfoAttribute : Attribute
{
    public string Name { get; }
    public string Description { get; }
    public PluginInfoAttribute(string name, string description)
    {
        Name = name;
        Description = description;
    }
}

// --- Reflection-based object mapper ---

/// <summary>
/// Simple object-to-object mapper using reflection.
/// Copies properties with matching names and compatible types.
/// In production, use AutoMapper or manual mapping — this is for learning.
/// </summary>
public class ReflectionMapper
{
    // Cache type mappings to avoid repeated reflection
    private readonly Dictionary<(Type Source, Type Dest), List<(PropertyInfo Source, PropertyInfo Dest)>> _propertyMapCache
        = new();

    public TDest Map<TSource, TDest>(TSource source) where TDest : new()
    {
        var dest = new TDest();
        MapProperties(source, dest);
        return dest;
    }

    public void MapProperties<TSource, TDest>(TSource source, TDest dest)
    {
        var sourceType = typeof(TSource);
        var destType = typeof(TDest);
        var key = (sourceType, destType);

        // Get or build the cached property mapping
        if (!_propertyMapCache.TryGetValue(key, out var mappings))
        {
            mappings = sourceType.GetProperties()
                .Join(destType.GetProperties(),
                    s => s.Name,
                    d => d.Name,
                    (s, d) => (Source: s, Dest: d))
                .Where(p =>
                    p.Source.CanRead &&
                    p.Dest.CanWrite &&
                    (p.Source.PropertyType.IsAssignableFrom(p.Dest.PropertyType) ||
                     p.Dest.PropertyType.IsAssignableFrom(p.Source.PropertyType)))
                .ToList();
            _propertyMapCache[key] = mappings;
        }

        foreach (var (sourceProp, destProp) in mappings)
        {
            var value = sourceProp.GetValue(source);
            destProp.SetValue(dest, value);
        }
    }
}

// --- Source/destination types for mapping demo ---

public class ProductDto
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public decimal Price { get; set; }
    public int Stock { get; set; }
}

public class ProductViewModel
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
    public decimal Price { get; set; }
    public int Stock { get; set; }
    public string DisplayPrice => $"{Price:C}";
}

class Program
{
    static void Main()
    {
        Console.WriteLine("=== 1. Reflection-Based Object Mapper ===\n");

        var mapper = new ReflectionMapper();

        var dto = new ProductDto
        {
            Id = 42,
            Name = "Super Widget",
            Price = 39.99m,
            Stock = 100
        };

        var viewModel = mapper.Map<ProductDto, ProductViewModel>(dto);
        Console.WriteLine($"Mapped ProductViewModel:");
        Console.WriteLine($"  Id: {viewModel.Id}");
        Console.WriteLine($"  Name: {viewModel.Name}");
        Console.WriteLine($"  Price: {viewModel.Price:C}");
        Console.WriteLine($"  Stock: {viewModel.Stock}");
        Console.WriteLine($"  DisplayPrice (computed): {viewModel.DisplayPrice}");

        Console.WriteLine("\n=== 2. Plugin Discovery via Attributes ===\n");

        var transforms = DiscoverTransforms();
        Console.WriteLine($"Discovered {transforms.Count} IDataTransform implementations:\n");

        foreach (var (type, name, description) in transforms)
        {
            Console.WriteLine($"  {name}: {description} (type: {type.Name})");
        }

        Console.WriteLine("\n=== 3. Using discovered plugins dynamically ===\n");

        var input = "hello world";
        Console.WriteLine($"Input: \"{input}\"");

        foreach (var (type, _, _) in transforms)
        {
            // Create instance via reflection
            var instance = Activator.CreateInstance(type);
            if (instance is IDataTransform transform)
            {
                string result = transform.Transform(input);
                Console.WriteLine($"  {type.Name}.Transform → \"{result}\"");
            }
        }

        Console.WriteLine("\n=== 4. Reflection Performance — cached vs uncached ===\n");

        var sw = System.Diagnostics.Stopwatch.StartNew();
        for (int i = 0; i < 10000; i++)
        {
            mapper.Map<ProductDto, ProductViewModel>(dto);
        }
        sw.Stop();
        Console.WriteLine($"Cached mapper: 10,000 mappings in {sw.ElapsedMilliseconds}ms");

        var uncachedSw = System.Diagnostics.Stopwatch.StartNew();
        for (int i = 0; i < 10000; i++)
        {
            UncachedMap(dto);
        }
        uncachedSw.Stop();
        Console.WriteLine($"Uncached mapping: 10,000 mappings in {uncachedSw.ElapsedMilliseconds}ms");

        Console.WriteLine("\n=== 5. Reflection tips and cautions ===\n");

        Console.WriteLine("  - Cache reflection results (PropertyInfo, MethodInfo) for hot paths");
        Console.WriteLine("  - Use nameof() for compile-time-checked property/method names");
        Console.WriteLine("  - Reflection is slower than direct calls — avoid in tight loops");
        Console.WriteLine("  - DynamicInvoke is much slower than compiled delegates");
        Console.WriteLine("  - Consider expression trees or source-generated serializers for performance");
        Console.WriteLine("  - Always handle MissingMethodException, AmbiguousMatchException");
        Console.WriteLine("  - Reflection can access internal/private members — use with caution");
    }

    /// <summary>
    /// Discovers all types in the current assembly that implement IDataTransform
    /// and have a [PluginInfo] attribute.
    /// </summary>
    static List<(Type Type, string Name, string Description)> DiscoverTransforms()
    {
        var currentAssembly = Assembly.GetExecutingAssembly();
        var transformTypes = currentAssembly.GetTypes()
            .Where(t => typeof(IDataTransform).IsAssignableFrom(t) && !t.IsInterface && !t.IsAbstract)
            .Select(t =>
            {
                var pluginAttr = t.GetCustomAttribute<PluginInfoAttribute>();
                return (Type: t, Name: pluginAttr?.Name ?? t.Name, Description: pluginAttr?.Description ?? "");
            })
            .ToList();

        return transformTypes;
    }

    /// <summary>
    /// Uncached (naive) reflection mapping — for performance comparison.
    /// </summary>
    static ProductViewModel UncachedMap(ProductDto source)
    {
        var dest = new ProductViewModel();
        var sourceType = source.GetType();
        var destType = typeof(ProductViewModel);

        foreach (var sourceProp in sourceType.GetProperties())
        {
            if (!sourceProp.CanRead) continue;
            var value = sourceProp.GetValue(source);
            var destProp = destType.GetProperty(sourceProp.Name);
            if (destProp != null && destProp.CanWrite)
            {
                destProp.SetValue(dest, value);
            }
        }

        return dest;
    }
}
```

**Expected output:**

```
=== 1. Reflection-Based Object Mapper ===

Mapped ProductViewModel:
  Id: 42
  Name: Super Widget
  Price: $39.99
  Stock: 100
  DisplayPrice (computed): $39.99

=== 2. Plugin Discovery via Attributes ===

Discovered 3 IDataTransform implementations:

  Uppercase Transform: Converts text to uppercase (type: UppercaseTransform)
  Reverse Transform: Reverses the input string (type: ReverseTransform)
  Word Count: Counts words in the input (type: WordCountTransform)

=== 3. Using discovered plugins dynamically ===

Input: "hello world"
  UppercaseTransform.Transform → "HELLO WORLD"
  ReverseTransform.Transform → "dlrow olleh"
  WordCountTransform.Transform → "Word count: 2"

=== 4. Reflection Performance — cached vs uncached ===

Cached mapper: 10,000 mappings in Xms
Uncached mapping: 10,000 mappings in Yms

=== 5. Reflection tips and cautions ===

  - Cache reflection results (PropertyInfo, MethodInfo) for hot paths
  - Use nameof() for compile-time-checked property/method names
  - Reflection is slower than direct calls — avoid in tight loops
  - DynamicInvoke is much slower than compiled delegates
  - Consider expression trees or source-generated serializers for performance
  - Always handle MissingMethodException, AmbiguousMatchException
  - Reflection can access internal/private members — use with caution
```

**Notes:**

- The `ReflectionMapper` caches property mappings per `(SourceType, DestType)` pair. This is important because `GetProperties()` and `GetProperty()` are relatively expensive — repeating them in a loop or hot path adds up.
- Plugin discovery via attributes is a common pattern in extensible applications. The attribute provides metadata (name, description) that the host uses to build a plugin registry. At runtime, `Activator.CreateInstance` or dependency injection creates plugin instances, and interface casting gives you strongly-typed access.
- `Assembly.GetExecutingAssembly()` returns the currently executing assembly — useful for self-discovery of plugins that live in the same assembly. For plugins in other assemblies, use `Assembly.LoadFrom(path)` or `Assembly.Load(assemblyName)`.
- The performance comparison between cached and uncached mapping shows typical differences: cached reflection is dramatically faster because `GetProperties()` and `GetProperty()` are avoided on every call.
- In real-world applications, prefer purpose-built libraries (AutoMapper for mapping, dependency injection for plugin instantiation) over hand-rolled reflection — but understanding the mechanics makes you a better user of those libraries.
- `MethodInfo.Invoke` is slower than a direct call — use compiled delegates (`Delegate.CreateDelegate`) or expression trees for hot paths where reflection is unavoidable.

## Completion Checklist

- [ ] You can use `typeof(T)` and `obj.GetType()` to get `Type` objects
- [ ] You can enumerate properties, methods, constructors, and fields via `Type.GetProperties()`, `GetMethods()`, etc.
- [ ] You can use `BindingFlags` to filter which members are returned
- [ ] You can read custom attributes via `GetCustomAttribute<T>()` and `GetCustomAttributes()`
- [ ] You can define custom attribute classes with `AttributeUsage` and positional/named parameters
- [ ] You can create instances via `Activator.CreateInstance` and `ConstructorInfo.Invoke`
- [ ] You can read/write properties dynamically via `PropertyInfo.GetValue` and `SetValue`
- [ ] You can invoke methods dynamically via `MethodInfo.Invoke`
- [ ] You can walk the inheritance chain using `Type.BaseType`
- [ ] You can build a simple reflection-based object mapper with cached property mappings
- [ ] You can discover types by interface and filter by attribute metadata
- [ ] You understand the performance implications of reflection and when to cache results

## Hints

- Always prefer `nameof()` over string literals for property/method names — it gives you compile-time checking and refactor safety.
- `GetProperties()` returns properties from the type and all base types. Use `BindingFlags.DeclaredOnly` to restrict to the current type.
- `GetCustomAttribute<T>()` returns the first matching attribute; use `GetCustomAttributes()` or `GetCustomAttributesData()` for multiple attributes or for inspection without instantiation.
- Attribute positional parameters are constructor arguments; named parameters are public property/field setters. Choose positional for required values, named for optional ones.
- `Inherited = true` on `AttributeUsage` means derived types inherit the attribute. This is `false` by default.
- `Activator.CreateInstance` with no arguments calls the parameterless constructor. For parameterized constructors, pass the arguments or use `ConstructorInfo.Invoke`.
- Reflection is inherently slower than direct calls — cache `PropertyInfo`, `MethodInfo`, and `ConstructorInfo` objects when they'll be used repeatedly.
- For maximum performance with reflection-based mapping, consider `Expression` trees (compiled to delegates) or source generators — but start with caching and measure before optimizing further.
- Be careful with `MissingMethodException`, `AmbiguousMatchException`, and `TargetInvocationException` when invoking via reflection — these are common failure modes.
- Reflection can access non-public members — use `BindingFlags.NonPublic` intentionally, not accidentally.
