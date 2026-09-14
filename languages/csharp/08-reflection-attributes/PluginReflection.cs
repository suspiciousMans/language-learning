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
                    p.Source.PropertyType.IsAssignableFrom(p.Dest.PropertyType) ||
                    p.Dest.PropertyType.IsAssignableFrom(p.Source.PropertyType))
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
