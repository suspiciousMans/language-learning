# Project 01: Basics — Variables, Patterns, and Functions — Elixir

**Difficulty:** beginner  
**Prerequisites:** Project 00 (Tooling Check)

## Goals

- Understand Elixir's basic syntax: variables, data types, pattern matching, functions.
- Write and run simple Elixir modules.
- Learn the functional mindset: immutability, pattern matching, and function composition.

## Concepts

- **Variables and binding** — `=` is pattern matching, not assignment; variables can be rebound
- **Immutable data** — data never changes in place; every operation returns new data
- **Basic types** — integers, floats, atoms, strings, booleans, nil
- **Tuples** — `{a, b, c}`, used for structured return values (e.g. `{:ok, result}`)
- **Lists** — `[1, 2, 3]`, linked lists, head/tail decomposition `[head | tail]`
- **Maps** — `%{key: value}`, the go-to key-value structure
- **Pattern matching** — matching shapes against data in `case`, function heads, and `=` bindings
- **Functions** — named functions, anonymous functions (`fn`), captures (`&`), multiple clauses, guards
- **Pipe operator `|>`** — thread the result of one function into the next

## Exercises

### Exercise 1: Variables and Basic Types

Create `lib/basics/variables_types.ex`:

```elixir
defmodule Basics.VariablesTypes do
  @moduledoc """
  Exercises: variable binding, basic types, immutability.
  """

  @doc """
  Demonstrate variable binding and rebinding.
  """
  def binding_demo do
    x = 1
    x = x + 1  # rebinding — x is now 2
    x
  end

  @doc """
  Demonstrate that data is immutable: modifying a list returns a new list.
  """
  def immutability_demo(list) when is_list(list) do
    original = list
    # "Adding" to the list creates a new one; original is unchanged
    new_list = [0 | list]
    {original, new_list}
  end

  @doc """
  Return a tuple with a greeting and the current Elixir version.
  """
  def greet_with_version(name) when is_binary(name) do
    {:ok, "Hello, #{name}! Running Elixir #{System.version()}"}
  end

  @doc """
  Exercise: create an atom, a float, and a boolean, and return them in a map.
  """
  def basic_types_map do
    %{
      status: :ready,
      pi: 3.14,
      is_fun: true
    }
  end
end
```

### Exercise 2: Pattern Matching — Tuples, Lists, Maps

Create `lib/basics/pattern_matching.ex`:

```elixir
defmodule Basics.PatternMatching do
  @moduledoc """
  Exercises: pattern matching in various shapes.
  """

  @doc """
  Pattern match on a `{:ok, value}` or `{:error, reason}` tuple.
  """
  def handle_result({:ok, value}) do
    {:success, value}
  end

  def handle_result({:error, reason}) do
    {:failed, reason}
  end

  @doc """
  Decompose a list into head and tail using pattern matching.
  """
  def decompose_list([head | tail]) do
    {head, tail}
  end

  def decompose_list([]), do: {:empty, []}

  @doc """
  Match specific elements of a 3-tuple.
  """
  def match_point({x, y, z}) when is_number(x) and is_number(y) and is_number(z) do
    "Point at (#{x}, #{y}, #{z})"
  end

  @doc """
  Extract values from a map using pattern matching.
  """
  def user_name(%{name: name}) do
    name
  end

  @doc """
  Use the pin operator (^) to match against an existing variable.
  """
  def pin_demo(expected \\ 42) do
    x = 42
    # ^x means "match against the current value of x, don't rebind"
    case {:ok, x} do
      {:ok, ^x} -> "Matched: x is still #{x}"
      _ -> "No match"
    end
  end
end
```

### Exercise 3: Functions — Clauses, Guards, Anonymous, Pipe

Create `lib/basics/functions.ex`:

```elixir
defmodule Basics.Functions do
  @moduledoc """
  Exercises: function clauses, guards, private functions, pipe.
  """

  @doc """
  Multiple function clauses with guards: categorize a number.
  """
  def categorize(n) when n < 0, do: {:negative, n}
  def categorize(n) when n == 0, do: {:zero, n}
  def categorize(n) when n > 0, do: {:positive, n}

  @doc """
  Factorial using multiple recursive clauses.
  """
  def factorial(0), do: 1
  def factorial(n) when n > 0 do
    n * factorial(n - 1)
  end

  @doc """
  Returns the sum of a list of numbers using the pipe operator.
  """
  def sum_list(list) when is_list(list) do
    list
    |> Enum.filter(&is_number/1)
    |> Enum.reduce(0, &+/2)
  end

  @doc """
  Anonymous function exercise: return an anonymous function that doubles its input.
  """
  def make_doubler do
    fn x -> x * 2 end
  end

  @doc """
  Use the capture operator (&) to create a function reference.
  """
  def doubler_ref do
    &(&1 * 2)
  end

  @doc """
  Private helper — only callable within this module.
  """
  defp secret_value do
    42
  end
end
```

### Exercise 4: Putting It Together — A Tiny Data Pipeline

Create `lib/basics/pipeline.ex`:

```elixir
defmodule Basics.Pipeline do
  @moduledoc """
  Exercise: chain operations with the pipe operator to process a list of users.
  """

  @doc """
  Given a list of maps with `:name` and `:age` keys, return the names
  of adults (age >= 18), sorted alphabetically.
  """
  def adult_names(people) when is_list(people) do
    people
    |> Enum.filter(&(&1[:age] >= 18))
    |> Enum.sort_by(& &1[:name])
    |> Enum.map(& &1[:name])
  end

  @doc """
  Given a list of numbers, return {:sum, total}, {:mean, average}.
  Use pattern matching to build the result tuple.
  """
  def stats(numbers) when is_list(numbers) and length(numbers) > 0 do
    total = Enum.reduce(numbers, 0, &+/2)
    count = length(numbers)
    average = total / count
    {:ok, total, average}
  end

  def stats([]), do: {:error, "empty list"}
end
```

## Completion Checklist

- [ ] `binding_demo/0` returns 2, confirming rebinding works.
- [ ] `immutability_demo/1` returns a 2-tuple with original and new list unchanged.
- [ ] `greet_with_version/1` returns `{:ok, string}`.
- [ ] `handle_result/1` distinguishes `:ok` from `:error` tuples.
- [ ] `decompose_list/1` returns `{head, tail}` for non-empty and `{:empty, []}` for empty.
- [ ] `match_point/1` formats a 3D point string.
- [ ] `user_name/1` extracts the `:name` key from a map.
- [ ] `pin_demo/1` returns a match confirmation string.
- [ ] `categorize/1` returns the correct tuple for negative, zero, and positive numbers.
- [ ] `factorial/1` computes factorial correctly (e.g. `factorial(5) == 120`).
- [ ] `sum_list/1` sums only the numeric elements.
- [ ] `make_doubler/0` returns an anonymous function that doubles its input.
- [ ] `doubler_ref/0` returns a capture-based doubler.
- [ ] `adult_names/1` returns sorted adult names.
- [ ] `stats/1` returns `{:ok, total, average}` for non-empty lists.

## Hints

- `=` in Elixir is pattern matching, not assignment. `x = 1` means "match x against 1" (which binds x).
- To rebind, just use `=` again: `x = x + 1` — but you cannot pattern-match a bound variable without pinning it with `^x`.
- Guards (`when`) let you add conditions to function clauses and `case` branches. Simple functions only: comparison, `is_*` type checks, arithmetic.
- The pipe operator `|>` is syntactic sugar: `x |> f(y)` becomes `f(x, y)`.
- Anonymous functions close over their environment: `fn x -> x + y end` captures `y` from the surrounding scope.
- Private functions (`defp`) are only accessible within their module — use them for internal helpers.

---

*This project builds the foundation for everything that follows — pattern matching and the pipe operator show up everywhere in Elixir.*
