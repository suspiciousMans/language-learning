# Project 00: Tooling Check — Haskell

**Difficulty:** beginner  
**Prerequisites:** none

## Goals

- Verify you have the Haskell toolchain installed correctly
- Understand the basic project structure Haskell uses
- Learn how to compile and run a Haskell program with GHC and cabal/stack

## Concepts

- **GHC (Glasgow Haskell Compiler)** — the standard Haskell compiler
- **GHCi** — Haskell's interactive REPL
- **cabal** — Haskell's standard build tool and package manager
- **stack** — alternative build tool using Stackage snapshots
- **REPL (Read-Eval-Print Loop)** — GHCi's interactive mode

## Setup

### Option A: Install via GHCup (recommended)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# Then install GHC and cabal:
ghcup install ghc
ghcup install cabal
```

### Option B: System package manager

```bash
# Ubuntu/Debian
sudo apt-get install ghc cabal-install

# macOS (Homebrew)
brew install ghc cabal-install

# Arch Linux
sudo pacman -S ghc cabal-install
```

### Verify installation

```bash
ghc --version
cabal --version
# Or if using stack:
stack --version
```

## Exercises

Complete these exercises to confirm your setup:

### Exercise 1: Hello World

Create `src/hello.hs`:

```haskell
main :: IO ()
main = putStrLn "Hello, Haskell!"
```

Compile and run:

```bash
ghc src/hello.hs -o hello
./hello
```

Expected output: `Hello, Haskell!`

### Exercise 2: Check GHC version

```bash
ghc --version
```

Record the version. You should see something like `The Glorious Glasgow Haskell Compilation System, version 9.x.x`.

### Exercise 3: Use GHCi (REPL)

Start GHCi:

```bash
ghci
```

Try:

```haskell
Prelude> add a b = a + b
Prelude> add 3 5
```

Expected output: `8`

Exit with `:q` or `Ctrl+D`.

### Exercise 4: Use cabal (optional advanced)

From the project root:

```bash
cabal build
cabal run haskell-toolbox
```

If cabal is installed, this should resolve dependencies and build without error.

## Completion Checklist

- [ ] `ghc --version` shows a version number
- [ ] `cabal --version` shows a version number
- [ ] You can compile and run `hello.hs` with `ghc`
- [ ] You can use GHCi (REPL)
- [ ] (Optional) `cabal build` works

## Hints

- If `ghc` is not found, check your PATH. On Linux/macOS: `echo $PATH`
- If you get a cabal version mismatch, try `cabal update` to update package lists
- GHCi is your friend — use it to experiment with expressions before writing files
- The `:t` command in GHCi shows the type of any expression: `:t 3 + 5`

---

*Use this project to make sure your environment is ready before starting the real work.*
