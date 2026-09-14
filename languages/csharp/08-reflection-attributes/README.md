# Project 08: Reflection and Attributes — C#

**Difficulty:** advanced  
**Prerequisites:** C# 00–07 (through I/O and serialization)

## Goals

- Understand what reflection is and when to use it (vs compile-time approaches)
- Use `Type`, `MemberInfo`, and `System.Reflection` to inspect assemblies, types, members, and metadata at runtime
- Read and interpret custom attributes on types, methods, properties, and parameters
- Create your own custom attributes with target and lifetime constraints
- Use reflection to dynamically invoke methods, set properties, and create instances
- Build a simple dependency injection container / type registry using reflection
- Understand the performance implications of reflection and mitigation strategies (cached delegates, `Expression` trees, source generators)
- Know how attributes power frameworks: serialization, validation, routing, testing, and DI

## Concepts

### What Is Reflection?

Reflection is the ability of a program to inspect its own structure at runtime — types, members, attributes, and metadata — and to act on that information dynamically. It's the backbone of many .NET features:

- **Serialization** (JSON, XML, binary) uses reflection to discover properties and serialize them
- **Dependency injection** containers use reflection to create object graphs and inject constructor parameters
- **ORM mappers** (like EF Core) map class properties to database columns via attributes or convention
- **Testing frameworks** (xUnit, NUnit) discover test methods via attributes and invoke them
- **Web frameworks** (ASP.NET Core) map routes, bind parameters, and validate models using attributes and reflection
- **UI frameworks** bind to properties and generate UI from type metadata

### The Reflection API

- **`Type`** — represents a type at runtime; obtained from `obj.GetType()`, `typeof(T)`, or `Type.GetType("assembly-qualified-name")`
- **`Assembly`** — represents a loaded .NET assembly; you can enumerate types with `GetTypes()`, `GetExportedTypes()`, or `DefinedTypes`
- **`MemberInfo`** and its subclasses (`MethodInfo`, `PropertyInfo`, `FieldInfo`, `ConstructorInfo`, `EventInfo`) — describe members
- **`PropertyInfo`** — get/set values via `GetValue`/`SetValue`; discover get/set accessors, attributes, property type
- **`MethodInfo`** — invoke methods dynamically with `Invoke`; inspect parameters, return type, custom attributes
- **`ConstructorInfo`** — create instances dynamically via `Invoke`; inspect parameter types
- **`BindingFlags`** — control what members are discovered (Public, NonPublic, Instance, Static, DeclaredOnly, etc.)

### Custom Attributes

- Attributes are classes inheriting from `System.Attribute`; conventionally suffixed with `Attribute` (e.g., `MyAttribute`)
- Applied with `[My]` or `[My(...)]` syntax on types, members, parameters, return values, assemblies
- **AttributeUsage** — control where an attribute can appear (`AttributeTargets`), whether it's single-use or multi-use, and whether inherited by derived types
- **Named and positional parameters** — constructor parameters are positional; properties set via named arguments in the attribute usage
- **Retrieve attributes** via `GetCustomAttributes()` / `GetCustomAttribute<T>()` on `Type`, `MemberInfo`, `ParameterInfo`, `Assembly`
- **Attributes are not executable code** — they carry metadata; the framework that reads them decides what to do

### Dynamic Invocation

- Create an instance of a type by name: load assembly, `GetType`, `Activator.CreateInstance` or `ConstructorInfo.Invoke`
- Set properties: `PropertyInfo.SetValue(obj, value)`
- Invoke methods: `MethodInfo.Invoke(obj, args)`
- Use delegates for better performance: `Delegate.CreateDelegate` to turn `MethodInfo` into a strongly-typed delegate; cache the delegate for repeated calls
- Expression trees (`System.Linq.Expressions`) can compile fast property getters/setters and method calls at runtime

### Practical Patterns

- **Type registry / plugin pattern** — discover types implementing an interface in an assembly and register them
- **Command dispatch** — map string commands to methods via attributes or naming conventions
- **DI container (simple)** — inspect constructors, resolve dependencies recursively, build object graphs
- **Validation engine** — define `[Required]`, `[Range]` attributes and a validator that reads them at runtime
- **Serialization helpers** — use reflection to discover serializable properties (similar to what `System.Text.Json` does internally)

### Performance Caveats

- Reflection is slower than direct calls; use it at startup/bootstrapping, not in tight loops
- Cache `Type`, `PropertyInfo`, `MethodInfo` objects — repeated `GetType()`/`GetProperty()` calls are expensive
- For hot paths, compile delegates with `Delegate.CreateDelegate` or Expression Trees, or use `System.Text.Json`/`Serializer`-generated delegates
- Source generators (C# 9+) can move some reflection-based work to compile time — see `System.Text.Json.SourceGeneration` as an example

### Reflection Security and Constraints

- Reflection can access non-public members (with `BindingFlags.NonPublic`), but some scenarios (e.g., AOT compilation with `Trimming`) may break reflection
- Reflection is less reliable in trimmed/AOT deployments unless types/members are annotated for preservation (`[DynamicallyAccessedMembers]`)
- `Assembly.Load` may fail if the assembly is not available or is trimmed; `Type.GetType` needs the assembly-qualified name for types outside `mscorlib`/`System.Private.CoreLib`

## Setup

### Install .NET SDK

Install .NET 8.0 or later. Verify:

```bash
dotnet --version
```

### Creating the project

The project file (`08-reflection.csproj`) targets .NET 8.0 with nullable reference types enabled. To build and run:

```bash
dotnet build
dotnet run
```

## Exercises

### Exercise 1: Type Inspection and Discovery

File: `ReflectiveDispatch.cs`

Covers:
- Getting `Type` objects via `typeof(T)` and `obj.GetType()`
- Inspecting type name, namespace, assembly, base type, implemented interfaces
- Enumerating public properties (`GetProperties`) and filtering by `BindingFlags`
- Enumerating methods, constructors, fields
- Reading custom attributes on type and members (`GetCustomAttribute<T>`)
- Using `PropertyInfo.GetValue` / `SetValue` to read and write properties dynamically
- Using `MethodInfo.Invoke` to call methods dynamically
- Handling `NullReferenceException` and proper nullability when reflecting over nullable types
- Displaying a type summary — useful for debugging and tooling

What you will do:
- Define a few sample types with properties, methods, and attributes (e.g., `[DisplayName]`, `[Description]`)
- Write a program that takes a type and prints its full metadata: name, attributes, properties with their types and attributes, methods with parameters and return types
- Use `PropertyInfo.GetValue` to read property values from an instance and `SetValue` to change them
- Invoke a method by name on an object dynamically (e.g., call `ToString` or a custom method)
- Demonstrate `BindingFlags` to find non-public members, static members, etc.
- Show how to discover interfaces implemented by a type and reflect over an interface property

### Exercise 2: Threading, Plugins, and Assembly Loading

File: `PluginReflection.cs`

Covers:
- Loading an assembly by path with `Assembly.LoadFrom` or `AssemblyLoadContext` (for isolation)
- Discovering all types in an assembly that implement a given interface or are decorated with a specific attribute
- Defining a plugin contract (interface) and plugin lifecycle attributes (e.g., `[PluginInfo]`, `[PluginDependency]`)
- Creating plugin instances via `Activator.CreateInstance` or reflection over constructors
- Reflection-based plugin registration: scan an assembly, find plugin types, instantiate, and register them by name
- Threading concepts: use `Thread`, `ThreadPool`, `Task` to run plugin operations concurrently; ensure thread-safety considerations when multiple threads interact with shared state
- Reflection and threading intersection: read type metadata once at startup; use delegates for fast concurrent invocation
- Plugin dependency ordering via attributes

What you will do:
- Define a `IPlugin` interface with `Initialize()`, `Execute()`, `Shutdown()`, and a name property
- Define a `[PluginInfo(Name = "...")]` attribute and a `[PluginDependency("OtherPlugin")]` attribute
- Write a plugin scanner that loads an assembly, finds all `IPlugin` implementations, reads their attributes, and builds a plugin registry
- Instantiate plugins, run `Initialize` on all, then `Execute` in parallel using `Task.WhenAll` (or `Parallel.ForEach`)
- Implement a simple dependency resolver: sort plugins so dependencies are initialized first
- Demonstrate running plugin work on background threads and coordinating with `Task` and `CancellationToken`

### Exercise 3: Attributes, Dependency Injection, and Validation

File: `AttributeReflection.cs`

Defines:
- Custom attributes: `[Inject]` (mark constructor parameters or properties for injection), `[Singleton]`, `[Transient]`, `[ValidateRequired]`, `[ValidateRange]`, `[ValidateRegex]`
- A simple DI container that:
  - Discovers service registrations via attributes or explicit registration
  - Uses reflection to inspect constructors and resolve dependencies recursively
  - Builds object graphs and caches singleton instances
- A validation engine that:
  - Reads validation attributes from properties and applies rules at runtime
  - Returns a list of validation errors with property names and messages
- Reflection-based property binding and validation invocation

What you will do:
- Define `[Inject]`, `[Singleton]`, `[Transient]` attributes
- Define validation attributes: `[ValidateRequired]`, `[ValidateRange(int min, int max)]`, `[ValidateRegex(string pattern)]`
- Build a minimal DI container:
  - Register types by scanning for `[Singleton]` / `[Transient]` or explicit calls
  - For each type, use reflection to find the constructor, resolve each parameter (by type or by attribute), and create the instance
  - Cache singletons; create new instances for transients
- Build a validator:
  - Given an object, enumerate its properties with `GetProperties`
  - For each property, check for validation attributes and apply rules
  - Return a `ValidationResult` with `IsValid` and a list of `ValidationError` objects
- Write a demo: define a `UserService` that depends on `IUserRepository` (injected), and a `User` class with validation attributes; validate a `User` instance and resolve `UserService` from the container

## Expected Output

### ReflectiveDispatch (console output sample)

```
=== Type Inspection Demo ===

Type: SampleService
  Namespace: ReflectionDemo
  Assembly: ReflectionDemo, Version=1.0.0.0
  Base type: object
  Interfaces: ISampleService
  Attributes:
    [DisplayName("Sample Service")]
    [Description("A sample service for reflection demos")]

  Properties (public instance):
    Name (String) [DisplayName("Full Name")]
      Value: "Sample"
    Count (Int32)
      Value: 42
    IsActive (Boolean)
      Value: True

  Methods (public instance):
    DoWork( String, Int32 ) : Void
    GetResult() : String

  Invoking DoWork("hello", 10)...
  DoWork called with: hello, 10
  Setting Count to 100...
  Count is now: 100
  Invoking GetResult()...
  Result: "The answer is 100"
```

### PluginReflection (console output sample)

```
=== Plugin System Demo ===

Scanning assembly: PluginReflection
Found 3 plugin types:

  Plugin: DataCollectorPlugin
    Description: Collects and aggregates data
    Dependencies: [LoggerPlugin]
    Category: Data

  Plugin: LoggerPlugin
    Description: Logging and diagnostics
    Dependencies: []
    Category: Infrastructure

  Plugin: ReportGeneratorPlugin
    Description: Generates reports from collected data
    Dependencies: [DataCollectorPlugin, LoggerPlugin]
    Category: Reporting

Resolving dependencies...
Initialization order:
  1. LoggerPlugin (no dependencies)
  2. DataCollectorPlugin (depends on LoggerPlugin)
  3. ReportGeneratorPlugin (depends on DataCollectorPlugin, LoggerPlugin)

Initializing plugins...
  LoggerPlugin initialized
  DataCollectorPlugin initialized
  ReportGeneratorPlugin initialized

Executing plugins in parallel...
  LoggerPlugin: Logging started
  DataCollectorPlugin: Collecting data from source A
  DataCollectorPlugin: Collecting data from source B
  ReportGeneratorPlugin: Generating report
  LoggerPlugin: Logging finished
  DataCollectorPlugin: Collected 150 records
  ReportGeneratorPlugin: Report generated (2 pages)

Shutting down plugins...
  LoggerPlugin shutdown
  DataCollectorPlugin shutdown
  ReportGeneratorPlugin shutdown
```

### AttributeReflection (console output sample)

```
=== Dependency Injection Demo ===

Registering services:
  IUserRepository -> SqlUserRepository (Singleton)
  IEmailService -> EmailService (Transient)
  UserService -> UserService (Singleton)

Resolving UserService...
  Created SqlUserRepository (singleton)
  Created EmailService (transient)
  Created UserService

UserService resolved successfully.
  Repository type: SqlUserRepository
  EmailService type: EmailService

Resolving UserService again (singleton)... same instance? True
Resolving UserService again (singleton)... same instance? True

=== Validation Demo ===

Validating User:
  Name: "John"
  Age: 25
  Email: "john@example.com"
  IsValid: True

Validating invalid User:
  Name: ""        (error: Name is required)
  Age: 150        (error: Age must be between 0 and 150)
  Email: "bad"    (error: Email is invalid)
  IsValid: False
  Errors:
    Name: Name is required
    Age: Age must be between 0 and 150
    Email: Email is invalid

Validating User with null name:
  Name: null       (error: Name is required)
  IsValid: False
```

## Completion Checklist

- [ ] You can obtain a `Type` object from an instance and from a compile-time type
- [ ] You can enumerate public properties, methods, constructors, and fields of a type
- [ ] You can read custom attributes from a type and its members
- [ ] You can dynamically read and write property values with `PropertyInfo`
- [ ] You can dynamically invoke methods with `MethodInfo.Invoke`
- [ ] You can discover types in an assembly that implement an interface or carry an attribute
- [ ] You can load an assembly at runtime and instantiate types by name
- [ ] You can define and apply custom attributes with `AttributeUsage` constraints
- [ ] You can build a simple DI container using reflection to resolve constructor dependencies
- [ ] You can build a validation engine that reads validation attributes at runtime
- [ ] You can run plugin operations in parallel using `Task`/`Thread` and understand thread-safety concerns
- [ ] You understand the performance cost of reflection and how to cache delegates for hot paths

## Hints

- `typeof(T)` is the fastest way to get a `Type` — prefer it over `Type.GetType(string)` when you know the type at compile time
- Use `GetProperties(BindingFlags.Public | BindingFlags.Instance)` to filter to public instance properties; add `BindingFlags.Static` or `BindingFlags.NonPublic` as needed
- `PropertyInfo.GetValue` and `SetValue` work on instances; for static properties pass `null` as the target
- `MethodInfo.Invoke` returns `object?`; cast to the expected type and handle exceptions for missing arguments or type mismatches
- `Activator.CreateInstance(type)` is a convenient shortcut for `ConstructorInfo.Invoke`, but using `ConstructorInfo` directly gives more control (parameter binding, specific constructor selection)
- `GetCustomAttribute<T>()` returns `null` if the attribute is not present (single-use attributes) — check for null before accessing
- For attributes with multiple instances (multi-use), use `GetCustomAttributes<T>().ToList()`
- `AssemblyLoadContext.Default.LoadFromAssemblyPath(path)` is the modern way to load assemblies; it supports unloading (dotnet 5+)
- When building a DI container, resolve dependencies recursively and detect cycles to avoid infinite loops
- For validation, read attributes once and cache the validation rules per type for performance
- Reflection performance can be improved by compiling delegates: `Delegate.CreateDelegate(typeof(Func<>), methodInfo)` or building Expression Trees and calling `.Compile()`
- Be careful with trimming/AOT: mark types and members used via reflection with `[DynamicallyAccessedMembers]` or ensure they are preserved

## Reference

- [System.Reflection namespace](https://learn.microsoft.com/dotnet/api/system.reflection)
- [Type class](https://learn.microsoft.com/dotnet/api/system.type)
- [PropertyInfo](https://learn.microsoft.com/dotnet/api/system.reflection.propertyinfo)
- [MethodInfo](https://learn.microsoft.com/dotnet/api/system.reflection.methodinfo)
- [Activator.CreateInstance](https://learn.microsoft.com/dotnet/api/system.activator.createinstance)
- [AttributeUsage](https://learn.microsoft.com/dotnet/api/system.attributetargets)
- [AssemblyLoadContext](https://learn.microsoft.com/dotnet/api/system.runtime.loader.assemblyloadcontext)
- [Delegate.CreateDelegate](https://learn.microsoft.com/dotnet/api/system.delegate.createdelegate)
- [Expression Trees](https://learn.microsoft.com/dotnet/csharp/expressions/expression-trees)

## Style Reference

This README follows the same structure as projects 05 (Exceptions & Nullable Reference Types), 06 (Collections & LINQ Deep Dive), and 07 (I/O & Serialization): Goals, Concepts, Setup, Exercises with file references, Expected Output sample, Completion Checklist, and Hints.

---

*This project completes the intermediate-to-advanced C# learning path (00–08).*
