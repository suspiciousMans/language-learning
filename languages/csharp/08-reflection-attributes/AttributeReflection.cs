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
