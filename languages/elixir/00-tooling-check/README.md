# Project 00: Tooling Check — Elixir

**Difficulty:** beginner  
**Prerequisites:** none

## Goals

- Verify you have the Elixir toolchain installed correctly.
- Understand the basic project structure Elixir uses (`mix`).
- Learn how to compile, run, and test an Elixir project.
- Get a quick win before the harder projects.

## Concepts

- **`mix`** — Elixir's build tool (create, compile, test, run)
- **`iex`** — Elixir's interactive REPL
- **`.ex` vs `.exs`** — compiled modules vs scripts
- **OTP** — Erlang/OTP runtime that Elixir runs on top of

## Setup

### Option A: Install via package manager

```bash
# macOS
brew install elixir

# Ubuntu/Debian
sudo apt install elixir erlang

# Arch
sudo pacman -S elixir erlang
```

### Option B: Install via asdf (recommended for version management)

```bash
asdf plugin add elixir
asdf install elixir 1.17.3
asdf global elixir 1.17.3
```

### Verify installation

```bash
elixir --version
erl -version   # Erlang/OTP version (Elixir depends on this)
mix --version
```

## Exercises

### Exercise 1: Hello World with `mix`

Create a new mix project:

```bash
mix new hello_elixir
cd hello_elixir
```

Edit `lib/hello_elixir.ex`:

```elixir
defmodule HelloElixir do
  @moduledoc """
  A simple module that greets the world.
  """

  @doc """
  Prints a greeting message.
  """
  def greet do
    IO.puts("Hello, Elixir!")
  end
end
```

Run it:

```bash
mix run -e "HelloElixir.greet()"
```

Expected output: `Hello, Elixir!`

### Exercise 2: Use the Elixir REPL (`iex`)

Start `iex` inside the project (loads the project's code):

```bash
iex -S mix
```

Try in the REPL:

```elixir
HelloElixir.greet()
# => Hello, Elixir!

# Basic Elixir expressions
IO.puts("3 + 5 = #{3 + 5}")
# => 3 + 5 = 8

# Lists and pipelines
[1, 2, 3] |> Enum.map(&(&1 * 2)) |> IO.inspect()
# => [2, 4, 6]
```

Exit with `Ctrl+C` twice or `System.stop(0)`.

### Exercise 3: Run tests with `mix test`

The generated project includes a test file at `test/hello_elixir_test.exs`.
Run:

```bash
mix test
```

You should see: `1 test passed`.

### Exercise 4: Create a script (`.exs`)

Create `script.exs`:

```elixir
# script.exs — no module, just top-level code
IO.puts("This is an Elixir script (.exs)")
IO.puts("Elixir version: #{System.version()}")
IO.puts("OTP version: #{ :erlang.system_info(:otp_release) }")
```

Run it directly:

```bash
elixir script.exs
```

Expected output: version info printed.

## Completion Checklist

- [ ] `elixir --version` shows an Elixir version (1.15+)
- [ ] `erl -version` shows an Erlang/OTP version
- [ ] `mix --version` shows a mix version
- [ ] `mix new` creates a project and `mix run -e` executes code
- [ ] You can use `iex -S mix` and evaluate expressions
- [ ] `mix test` runs and passes
- [ ] You can run a standalone `.exs` script with `elixir script.exs`

## Hints

- Elixir runs on the Erlang VM (BEAM). If `elixir` works but `erl` doesn't, your Erlang install is broken.
- `iex -S mix` is the most useful incantation — it starts a REPL with your project loaded.
- `.ex` files are compiled modules; `.exs` files are scripts (no compilation step).
- If `mix test` fails with a version mismatch, run `mix local.rebar` and `mix local.hex`.

---

*Use this project to make sure your environment is ready before starting the real work.*
