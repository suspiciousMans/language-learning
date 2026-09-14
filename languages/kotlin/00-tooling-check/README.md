# Project 00: Tooling Check — Kotlin

**Difficulty:** beginner  
**Prerequisites:** none

## Goals

- Verify you have the Kotlin toolchain installed correctly
- Understand the basic project structure Kotlin uses
- Learn how to compile and run a Kotlin program

## Concepts

- **Kotlin compiler (`kotlinc`)** — the tool that compiles `.kt` files to JVM bytecode
- **JVM (Java Virtual Machine)** — Kotlin runs on the JVM, the same runtime Java uses
- **Gradle** — Kotlin's standard build system (used for real projects)
- **Read-Eval-Print Loop (REPL)** — Kotlin's interactive mode

## Setup

### Option A: Install via SDKMAN (recommended)

```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install kotlin
sdk install gradle
```

### Option B: Manual install (download from kotlinlang.org)

1. Download Kotlin from https://kotlinlang.org/docs/command-line.html
2. Extract to a directory
3. Add `bin/` to your PATH

### Verify installation

```bash
kotlin -version
gradle --version
java -version   # Kotlin needs a JDK
```

## Exercises

Complete these exercises to confirm your setup:

### Exercise 1: Hello World

Create `hello.kt`:

```kotlin
fun main() {
    println("Hello, Kotlin!")
}
```

Compile and run:

```bash
kotlinc hello.kt -include-runtime -d hello.jar
java -jar hello.jar
```

Expected output: `Hello, Kotlin!`

### Exercise 2: Check Kotlin version

In your terminal, run:

```bash
kotlinc -version
```

Record the version number. You should see something like `Kotlin version 1.9.x`.

### Exercise 3: Use the Kotlin REPL

Start the Kotlin REPL:

```bash
kotlinc
```

This opens an interactive prompt. Try:

```
fun add(a: Int, b: Int): Int = a + b
add(3, 5)
```

Expected output: `8`

Exit with `:q` or `System.exit(0)`.

### Exercise 4: Use Gradle (optional advanced)

Create a file `build.gradle.kts`:

```kotlin
plugins {
    kotlin("jvm") version "1.9.22"
}

repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
}
```

Run:

```bash
gradle build
```

If Gradle is installed, this should complete without error.

## Completion Checklist

- [ ] `kotlin -version` shows a version number
- [ ] `gradle --version` shows a version number
- [ ] `java -version` shows a JDK version
- [ ] You can compile and run `hello.kt` with `kotlinc` + `java`
- [ ] You can use the Kotlin REPL
- [ ] (Optional) `gradle build` works

## Hints

- If `kotlinc` is not found, check your PATH. On Linux/macOS: `echo $PATH`
- If you get a Gradle version mismatch, try `gradle wrapper` inside your project directory
- The `-include-runtime` flag bundles the Kotlin runtime into the JAR, making it self-contained

---

*Use this project to make sure your environment is ready before starting the real work.*
