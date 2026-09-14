# Project 00: Tooling Check — C#

**Difficulty:** beginner  
**Prerequisites:** none

## Goals

- Verify you have the .NET SDK installed correctly
- Understand the basic project structure C# uses
- Learn how to compile and run a C# program with `dotnet`

## Concepts

- **.NET SDK** — the toolchain that compiles C# to managed bytecode and runs it via the CLR
- **dotnet CLI** — `dotnet new`, `dotnet build`, `dotnet run`, `dotnet test`
- **C# project file (`.csproj`)** — MSBuild-based project descriptor (SDK-style)
- **Read-Eval-Print Loop (REPL)** — `csharpier` / `dotnet script` interactive mode (optional)

## Setup

### Install .NET SDK

Download from https://dotnet.microsoft.com/download. Install the latest LTS (8.0 or 9.0).

### Verify installation

```bash
dotnet --version
dotnet --list-sdks
```

You should see a version number like `8.0.x` or `9.0.x`.

## Exercises

Complete these exercises to confirm your setup:

### Exercise 1: Hello World

Create `Hello.cs`:

```csharp
Console.WriteLine("Hello, C#!");
```

Run with the dotnet CLI:

```bash
dotnet new console -n HelloProject -o .
dotnet run
```

Or use the older `csc` compiler:

```bash
csc Hello.cs
mono Hello.exe    # on Linux/macOS with Mono
```

Expected output: `Hello, C#!`

### Exercise 2: Check .NET version

In your terminal, run:

```bash
dotnet --version
dotnet --info
```

Record the version number. You should see something like `8.0.0` or `9.0.100`.

### Exercise 3: Use the C# REPL (optional)

If you have `dotnet-script` installed:

```bash
dotnet tool install -g dotnet-script
dotnet script
```

Try:

```csharp
var add = (int a, int b) => a + b;
add(3, 5);
```

Expected output: `8`

Exit with `Ctrl+D` or `#exit`.

### Exercise 4: Create a console project (optional advanced)

```bash
dotnet new console -n MyFirstApp
cd MyFirstApp
dotnet run
```

This creates a full project with `.csproj`, `Program.cs`, and runs it.

## Completion Checklist

- [ ] `dotnet --version` shows a version number
- [ ] `dotnet --list-sdks` lists at least one SDK
- [ ] You can compile and run a simple C# file
- [ ] (Optional) You can use `dotnet-script` REPL
- [ ] (Optional) `dotnet new console` + `dotnet run` works

## Hints

- If `dotnet` is not found, check your PATH. On Linux: `echo $PATH`
- .NET installs per-user by default on Windows; on Linux/macOS check `/usr/share/dotnet` or `~/.dotnet`
- The .NET SDK includes the compiler (`csc`), CLR runtime, and CLI tools all in one
- SDK-style `.csproj` files are minimal — you rarely need to edit them manually

---

*Use this project to make sure your environment is ready before starting the real work.*
