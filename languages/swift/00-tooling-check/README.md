# Project 00: Tooling Check — Swift

**Difficulty:** beginner  
**Prerequisites:** none

## Goals

- Verify you have the Swift toolchain installed correctly
- Understand the basic project structure Swift uses
- Learn how to compile and run a Swift program
- Set up a Swift Package Manager (SPM) project

## Concepts

- **Swift compiler (`swiftc`)** — the tool that compiles `.swift` files to machine code
- **Swift Package Manager (SPM)** — Swift's standard build system and dependency manager
- **REPL / Playgrounds** — Swift's interactive mode
- **macOS vs Linux** — Swift runs on both; some features differ

## Setup

### Option A: Install via Homebrew (macOS, recommended)

```bash
brew install swift
```

### Option B: Install Swift toolchain (Linux)

```bash
# Ubuntu/Debian
sudo apt-get install swiftlang
```

Or download the official toolchain from https://www.swift.org/download/

### Verify installation

```bash
swift --version
swift build --version   # SPM version
```

## Exercises

Complete these exercises to confirm your setup:

### Exercise 1: Hello World

Create `hello.swift`:

```swift
print("Hello, Swift!")
```

Compile and run:

```bash
swift hello.swift
```

Expected output: `Hello, Swift!`

Alternatively, use the REPL:

```bash
swift
>>> print("Hello from REPL!")
>>> import Foundation
>>> 3 + 5
8
>>> import AsyncAlgorithms   // may fail if not installed — just try basic stuff
```

Exit with `:q` or `Control-D`.

### Exercise 2: Check Swift version

In your terminal, run:

```bash
swift --version
```

Record the version number. You should see something like `Swift version 5.x.x`.

### Exercise 3: Create a Swift Package

Create a minimal SPM project:

```bash
mkdir MyProject && cd MyProject
swift package init --type executable
swift build
swift run
```

This creates:
- `Package.swift` — the package manifest
- `Sources/MyProject/main.swift` — the entry point
- `Tests/MyProjectTests/` — test directory (if you use `--type executable` with tests)

### Exercise 4: Build and run an SPM project

After `swift package init --type executable`:

```bash
swift build      # compile
swift run        # run the executable
swift test       # run tests (if any)
```

## Completion Checklist

- [ ] `swift --version` shows a version number (Swift 5.x)
- [ ] `swift build --version` shows SPM version
- [ ] You can compile and run `hello.swift` with `swift`
- [ ] You can enter and use the Swift REPL
- [ ] You can create, build, and run a Swift Package project
- [ ] (Optional) `swift test` works in your project

## Hints

- If `swift` is not found, check your PATH: `echo $PATH`
- On Linux, you may need to install additional packages for Foundation support
- Swift packages use `Package.swift` as the manifest — it's Swift code, not a DSL
- `swift run` automatically builds if needed

---

*Use this project to make sure your environment is ready before starting the real work.*
