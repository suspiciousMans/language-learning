# language-learning

A collection of language learning paths — one for each language — designed to take you from basics to real-world proficiency. Each language has a progressive series of projects with exercises, solutions, and tests.

## Languages

| Language | Path | Projects | Capstone |
|----------|------|----------|----------|
| Python | `languages/python/` | 9 projects | PyTorch neural network |
| TypeScript | `languages/typescript/` | 9 projects | Vite + React web app |
| Rust | `languages/rust/` | 10 projects | 2D game engine |
| Kotlin | `languages/kotlin/` | 9 projects | Ktor REST backend |
| Go | `languages/go/` | 10 projects | CLI tool + HTTP dashboard |
| C | `languages/c/` | 10 projects | CHIP-8 emulator |
| OCaml | `languages/ocaml/` | 10 projects | Tiny compiler |
| JavaScript | `languages/javascript/` | 10 projects | Node backend + vanilla frontend |

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
│   ├── python/
│   │   ├── 00-tooling-check/
│   │   ├── 01-basics/
│   │   ├── 02-data-structures/
│   │   ├── ...
│   │   └── 08-capstone-pytorch-mnist/
│   ├── typescript/
│   ├── rust/
│   ├── kotlin/
│   ├── go/
│   ├── c/
│   ├── ocaml/
│   └── javascript/
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

- **Python**: Build a neural network with PyTorch to classify MNIST digits
- **TypeScript**: Build a Vite + React web application
- **Rust**: Build a 2D game engine with macroquad or bevy
- **Kotlin**: Build a REST API backend with Ktor, database, and Docker
- **Go**: Build a CLI tool + concurrent HTTP dashboard
- **C**: Build a CHIP-8 emulator (retro game console)
- **OCaml**: Build a tiny compiler with lexer, parser, and evaluator
- **JavaScript**: Build a Node.js backend + vanilla JS frontend

## Contributing

See each language's `CONTRIBUTING.md` for language-specific guidelines.

## License

MIT License — see each language's LICENSE file (or project root for single-license repos).
