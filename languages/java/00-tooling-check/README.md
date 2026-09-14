# Project 00: Tooling Check — Java

**Difficulty:** beginner  
**Prerequisites:** none

## Goals

- Verify you have the Java Development Kit (JDK) installed correctly
- Understand the basic project structure Java uses
- Learn how to compile and run a Java program
- Get familiar with Gradle/Maven as build tools

## Concepts

- **JDK (Java Development Kit)** — the toolchain that compiles `.java` files to JVM bytecode
- **JVM (Java Virtual Machine)** — Java's runtime that executes bytecode
- **javac** — the Java compiler
- **java** — the Java runtime launcher
- **Gradle / Maven** — standard build systems for Java projects

## Setup

### Option A: Install via SDKMAN (recommended)

```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java
sdk install maven
sdk install gradle
```

### Option B: Manual install

1. Download JDK 17+ from https://adoptium.net/ or https://jdk.java.net/
2. Install and add `bin/` to your PATH
3. Verify with `java -version` and `javac -version`

### Verify installation

```bash
java -version
javac -version
mvn --version      # if using Maven
gradle --version   # if using Gradle
```

## Exercises

Complete these exercises to confirm your setup:

### Exercise 1: Hello World

Create `src/HelloWorld.java`:

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```

Compile and run:

```bash
javac src/HelloWorld.java -d out
java -cp out HelloWorld
```

Expected output: `Hello, Java!`

### Exercise 2: Check Java version

In your terminal, run:

```bash
java -version
javac -version
```

Record the version numbers. You should see something like `java version "17.x.x"`.

### Exercise 3: Use the JShell REPL (JDK 9+)

Start JShell:

```bash
jshell
```

This opens an interactive prompt. Try:

```java
int add(int a, int b) { return a + b; }
add(3, 5)
```

Expected output: `$1 ==> 8`

Exit with `/exit`.

### Exercise 4: Use Maven or Gradle (optional advanced)

With Maven, create `pom.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.learning</groupId>
  <artifactId>tooling-check</artifactId>
  <version>1.0.0</version>
  <properties>
    <maven.compiler.source>17</maven.compiler.source>
    <maven.compiler.target>17</maven.compiler.target>
  </properties>
</project>
```

Run: `mvn compile` — this should complete without error.

With Gradle, create `build.gradle`:

```groovy
plugins {
    id 'java'
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}
```

Run: `gradle build` — this should complete without error.

## Completion Checklist

- [ ] `java -version` shows a JDK version (17+)
- [ ] `javac -version` shows a matching compiler version
- [ ] `mvn --version` or `gradle --version` shows a version number
- [ ] You can compile and run `HelloWorld.java` with `javac` + `java`
- [ ] You can use JShell REPL
- [ ] (Optional) `mvn compile` or `gradle build` works

## Hints

- If `javac` is not found but `java` works, you may have only the JRE installed — get the full JDK
- On Linux/macOS: check your PATH with `echo $PATH`
- JShell is great for quick experiments — type `/help` for commands
- The `-d` flag to `javac` specifies the output directory for `.class` files
- Use `-cp` (classpath) when running to tell `java` where to find compiled classes

---

*Use this project to make sure your environment is ready before starting the real work.*
