# language-learning

A collection of language learning paths — one for each language — designed to take you from basics to real-world proficiency. Each language has a progressive series of projects with exercises, solutions, and tests.

## Languages

### Compiled / Systems
| Language | Path | Projects | Capstone | Typeclass |
|----------|------|----------|----------|-----------|
| **Rust** | `languages/rust/` | 10 | 2D game engine | N/A |
| **C** | `languages/c/` | 10 | CHIP-8 emulator | N/A |
| **OCaml** | `languages/ocaml/` | 10 | Tiny compiler | N/A |
| **Zig** | `languages/zig/` | 8+ | Systems program / game | N/A |

### JVM Languages
| Language | Path | Projects | Capstone | Typeclass |
|----------|------|----------|----------|-----------|
| **Kotlin** | `languages/kotlin/` | 10 | Ktor REST backend | N/A |
| **Java** | `languages/java/` | 8+ | Spring Boot REST API | N/A |

### Web / Scripting / Dynamic
| Language | Path | Projects | Capstone | Typeclass |
|----------|------|----------|----------|-----------|
| **Python** | `languages/python/` | 9 | PyTorch neural network | N/A |
| **TypeScript** | `languages/typescript/` | 9 | Vite + React web app | N/A |
| **JavaScript** | `languages/javascript/` | 10 | Node backend + vanilla frontend | N/A |
| **Go** | `languages/go/` | 10 | CLI tool + HTTP dashboard | N/A |
| **Ruby** | `languages/ruby/` | 8+ | Rails web application | N/A |
| **Elixir** | `languages/elixir/` | 8+ | Phoenix web application | N/A |

### Functional / Advanced
| Language | Path | Projects | Capstone | Typeclass |
|----------|------|----------|----------|-----------|
| **Haskell** | `languages/haskell/` | 8+ | Web app with Servant or DSL | Typeclasses |
| **Swift** | `languages/swift/` | 8+ | SwiftUI iOS app / Vapor server | N/A |

### Enterprise / Managed
| Language | Path | Projects | Capstone | Typeclass |
|----------|------|----------|----------|-----------|
| **C#** | `languages/csharp/` | 8+ | ASP.NET Core API / Unity game | N/A |

## How to Use

1. **Pick a language** — navigate to `languages/<language-name>/`
2. **Start with Project 00** — tooling check to verify your environment
3. **Work through projects in order** — each builds on the previous
4. **Read the README** — each project has goals, concepts, exercises, and a completion checklist
5. **Try the exercises** — fill in the TODO stubs in the starter code
6. **Check solutions** — compare with provided solutions (where available)
7. **Run tests** — verify your implementations pass (TDD-first)

## Project Structure

```
language-learning/
├── languages/
│   ├── rust/
│   ├── c/
│   ├── ocaml/
│   ├── zig/
│   ├── kotlin/
│   ├── java/
│   ├── python/
│   ├── typescript/
│   ├── javascript/
│   ├── go/
│   ├── ruby/
│   ├── elixir/
│   ├── haskell/
│   ├── swift/
│   └── csharp/
├── README.md           # This file
└── .gitignore
```

Each project folder follows the same pattern:

```
languages/<language>/<NN-project-name>/
├── README.md           # Goals, concepts, exercises, completion checklist
├── starter/            # (Optional) Starter code to begin from
├── exercises/          # (Optional) Individual exercise files
├── solutions/          # (Optional) Complete working solutions
└── tests/              # (Optional) Test suite (TDD-first)
```

## Project 00: Tooling Check

Every language starts with Project 00 — a quick checklist to verify your environment:
- Compiler/interpreter is installed
- Build tool (if applicable) is available
- You can compile/run a "Hello World" program

## Capstone Projects

Each language ends with a capstone project that ties together everything you've learned:

### Systems / Native
- **Rust**: Build a 2D game engine with macroquad or bevy
- **C**: Build a CHIP-8 emulator (retro game console)
- **OCaml**: Build a tiny compiler with lexer, parser, and evaluator
- **Zig**: Build a systems program — small game with SDL2 or CLI tool

### JVM
- **Kotlin**: Build a REST API backend with Ktor, database, and Docker
- **Java**: Build a Spring Boot REST API with database, tests, and Docker

### Web / Dynamic
- **Python**: Build a neural network with PyTorch to classify MNIST digits
- **TypeScript**: Build a Vite + React web application
- **JavaScript**: Build a Node.js backend + vanilla JS frontend
- **Go**: Build a CLI tool + concurrent HTTP dashboard
- **Ruby**: Build a Rails web application
- **Elixir**: Build a Phoenix web application with real-time features

### Functional
- **Haskell**: Build a web application with Servant, or a DSL with a parser/evaluator

### Modern / Managed
- **Swift**: Build a SwiftUI iOS app, or a server-side Swift app with Vapor
- **C#**: Build an ASP.NET Core REST API, or a Unity game component, or a WPF desktop app

## Contributing

See each language's `CONTRIBUTING.md` for language-specific guidelines.

## License

MIT License — see each language's LICENSE file (or project root for single-license repos).
