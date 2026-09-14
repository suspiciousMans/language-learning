# Project 02: Collections, Pipelines, and Records — Elixir

**Difficulty:** beginner→intermediate  
**Prerequisites:** Project 01 (Basics)

## Goals

- Master Elixir's collection types: lists, tuples, maps, and structs.
- Use the `Enum` and `Stream` modules for data transformation.
- Write list comprehensions for declarative data processing.
- Define and use structs as typed records with default values.
- Build clean data pipelines using the pipe operator.

## Concepts

- **Lists** — linked lists, `[head | tail]` pattern, `Enum` operations
- **Tuples** — fixed-size, fast indexed access, used for return values
- **Maps** — `%{key => value}`, the general-purpose key-value store
- **Structs** — `%StructName{}`, maps with a fixed set of keys, compile-time checking, default values
- **`Enum` vs `Stream`** — eager vs lazy; `Enum` computes immediately, `Stream` builds a computation pipeline
- **List comprehensions** — `for x <- list, cond -> ...`, declarative generation and filtering
- **`Enum` functions**: `map`, `filter`, `reduce`, `fold`, `group_by`, `uniq`, `sort`, `flat_map`, `chunk_by`
- **`Stream` functions**: `Stream.map`, `Stream.filter`, `Stream.flat_map`, `Stream.unfold`, `Stream.cycle`
- **Pipe operator `|>`** — threading data through transformations

## Exercises

### Exercise 1: Enum — Transforming Collections

Create `lib/collections/enum_exercises.ex`:

```elixir
defmodule Collections.EnumExercises do
  @moduledoc """
  Exercises using the Enum module.
  """

  @doc """
  Given a list of numbers, return only the even ones, doubled.
  """
  def even_doubled(numbers) when is_list(numbers) do
    numbers
    |> Enum.filter(&Integer.is_even/1)
    |> Enum.map(&(&1 * 2))
  end

  @doc """
  Group a list of maps by a key. Example:
    group_by(people, & &1[:department])
  Returns a map of department => [people].
  """
  def group_by(list, fun) when is_list(list) and is_function(fun, 1) do
    Enum.group_by(list, fun)
  end

  @doc """
  Return the most frequent element in a list.
  Ties are broken by the first occurrence.
  """
  def most_frequent(list) when is_list(list) and length(list) > 0 do
    list
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} -> {k, length(v)} end)
    |> Enum.max_by(fn {_k, count} -> count end)
    |> elem(0)
  end

  @doc """
  Flatten a nested list one level deep, then remove duplicates.
  Example: flatten_uniq([[1, 2], [2, 3], [3]]) == [1, 2, 3]
  """
  def flatten_uniq(nested) when is_list(nested) do
    nested
    |> List.flatten()
    |> Enum.uniq()
  end

  @doc """
  Chunk a list into groups of `n`, padding the last chunk with `nil` if needed.
  Example: chunk_pad([1,2,3,4,5], 2) == [[1,2], [3,4], [5, nil]]
  """
  def chunk_pad(list, n) when is_list(list) and n > 0 do
    list
    |> Enum.chunk_every(n, n, [nil])
  end
end
```

### Exercise 2: Streams — Lazy Pipelines

Create `lib/collections/stream_exercises.ex`:

```elixir
defmodule Collections.StreamExercises do
  @moduledoc """
  Exercises using the Stream module for lazy evaluation.
  """

  @doc """
  Create a stream that generates a fibonacci sequence up to `limit`.
  Use Stream.unfold/2.
  """
  def fibonacci_stream(limit) when limit >= 0 do
    Stream.unfold({0, 1}, fn
      {a, b} when a <= limit -> {a, {b, a + b}}
      _ -> nil
    end)
  end

  @doc """
  Lazily filter, map, and take from a stream of numbers.
  Return the first `n` even squares greater than `threshold`.
  """
  def even_squares_above(threshold, n) when n > 0 do
    Stream.resource(
      fn -> 1 end,
      fn state ->
        val = state * state
        if val > threshold and Integer.is_even(val) do
          {[val], state + 1}
        else
          {[], state + 1}
        end
      end,
      fn _ -> :ok end
    )
    |> Stream.take(n)
  end

  @doc """
  Lazily cycle through a list and take `n` elements.
  Use Stream.cycle/1 + Stream.take/2.
  """
  def cycle_take(list, n) when is_list(list) and n > 0 do
    list
    |> Stream.cycle()
    |> Stream.take(n)
    |> Enum.to_list()
  end

  @doc """
  Use Stream.flat_map/2 to generate a cross product of two lists.
  Example: cross_product([1,2], [:a, :b]) == [{1, :a}, {1, :b}, {2, :a}, {2, :b}]
  """
  def cross_product(list1, list2) when is_list(list1) and is_list(list2) do
    list1
    |> Stream.flat_map(fn x ->
      list2 |> Enum.map(fn y -> {x, y} end)
    end)
    |> Enum.to_list()
  end
end
```

### Exercise 3: List Comprehensions

Create `lib/collections/comprehensions.ex`:

```elixir
defmodule Collections.Comprehensions do
  @moduledoc """
  Exercises using Elixir's for-comprehension.
  """

  @doc """
  Generate all pairs (x, y) where x ∈ [1..n] and y ∈ [1..m].
  """
  def all_pairs(n, m) when n > 0 and m > 0 do
    for x <- 1..n, y <- 1..m do
      {x, y}
    end
  end

  @doc """
  Filter and transform in one comprehension:
  return squares of even numbers from 1..n.
  """
  def even_squares(n) when n > 0 do
    for x <- 1..n, Integer.is_even(x), do: x * x
  end

  @doc """
  Use comprehension with :into option to build a map.
  Given a list of key-value tuples, build a map.
  """
  def tuples_to_map(tuples) when is_list(tuples) do
    for {k, v} <- tuples, into: %{} do
      {k, v}
    end
  end

  @doc """
  Comprehension with multiple generators and a filter:
  Given a list of users and a list of roles, return all valid
  assignments where user[:level] >= role[:min_level].
  """
  def valid_assignments(users, roles) when is_list(users) and is_list(roles) do
    for user <- users,
        role <- roles,
        user[:level] >= role[:min_level] do
      {user[:name], role[:title]}
    end
  end

  @doc """
  Comprehension with :reduce option to build an accumulator.
  Count how many numbers in 1..n are divisible by any of the given divisors.
  """
  def count_divisible(n, divisors) when n > 0 and is_list(divisors) and length(divisors) > 0 do
    for x <- 1..n, divisor <- divisors, rem(x, divisor) == 0, reduce: %{} do
      acc ->
        Map.update(acc, x, 1, &(&1 + 1))
    end
    |> Map.keys()
    |> length()
  end
end
```

### Exercise 4: Structs as Typed Records

Create `lib/collections/structs.ex`:

```elixir
defmodule Collections.User do
  @moduledoc """
  A struct representing a user — exercise in defining and using structs.
  """
  defstruct [:id, :name, :email, :role, :level, :active]

  @doc """
  Create a new user with sensible defaults.
  """
  def new(id, name, email, role \\ :viewer, level \\ 1, active \\ true) do
    %Collections.User{
      id: id,
      name: name,
      email: email,
      role: role,
      level: level,
      active: active
    }
  end

  @doc """
  Promote a user by one level, returning a new struct.
  Structs are immutable — this returns a new one.
  """
  def promote(%Collections.User{} = user) do
    %{user | level: user.level + 1}
  end

  @doc """
  Check if a user has access to a resource requiring a minimum level.
  """
  def can_access?(%Collections.User{level: level, active: active}, required_level)
      when active and level >= required_level,
      do: true

  def can_access?(_, _), do: false

  @doc """
  List of users filtered by role, sorted by name.
  """
  def list_by_role(users, role) when is_list(users) do
    users
    |> Enum.filter(&(&1.role == role))
    |> Enum.sort_by(& &1.name)
  end
end

defmodule Collections.Structs do
  @moduledoc """
  Exercises using structs — typed records with defaults.
  """

  @doc """
  Build a team from a list of user specs (maps) and return
  only active members sorted by level descending.
  """
  def active_team_sorted(user_specs) when is_list(user_specs) do
    user_specs
    |> Enum.map(&Collections.User.new/1)
    |> Enum.filter(& &1.active)
    |> Enum.sort_by(& &1.level, :desc)
  end

  @doc """
  Promote all users in a list whose level is below a cap.
  Returns a new list of promoted structs.
  """
  def promote_below(users, cap) when is_list(users) do
    Enum.map(users, fn user ->
      if user.level < cap do
        Collections.User.promote(user)
      else
        user
      end
    end)
  end
end
```

## Completion Checklist

- [ ] `even_doubled/1` returns only even numbers, each doubled.
- [ ] `group_by/2` groups a list by the result of the given function.
- [ ] `most_frequent/1` returns the most common element.
- [ ] `flatten_uniq/1` flattens and deduplicates.
- [ ] `chunk_pad/2` chunks with nil padding on the last group.
- [ ] `fibonacci_stream/1` lazily generates fibonacci numbers up to a limit.
- [ ] `even_squares_above/2` returns the first `n` even squares above a threshold.
- [ ] `cycle_take/2` cycles a list and takes `n` elements.
- [ ] `cross_product/2` returns all pairs from two lists.
- [ ] `all_pairs/2` generates all (x, y) pairs in a range.
- [ ] `even_squares/1` returns squares of even numbers via comprehension.
- [ ] `tuples_to_map/1` builds a map from key-value tuples.
- [ ] `valid_assignments/2` returns matching user-role pairs.
- [ ] `count_divisible/2` counts numbers divisible by any divisor.
- [ ] The `Collections.User` struct has all expected fields and defaults.
- [ ] `Collections.User.promote/1` returns a user with level + 1.
- [ ] `Collections.User.can_access?/2` respects activity and level.
- [ ] `active_team_sorted/1` returns active users sorted by level descending.
- [ ] `promote_below/2` promotes only users below the cap.

## Hints

- `Enum` is eager — it traverses the whole collection immediately. `Stream` is lazy — it builds a computation that runs when you call `Enum.to_list/1` or similar.
- Use `Stream.unfold/2` when you need to generate an arbitrary sequence lazily (fibonacci, primes, etc.).
- The `for` comprehension is not a loop — it's a declarative generator that can have multiple generators, filters, and an `:into` or `:reduce` option.
- Structs are maps with a `__struct__` field. You can pattern-match on them with `%StructName{}` or `%StructName{key: value}`.
- Use `%{struct | key: new_value}` to update a struct — it returns a new struct, leaving the original unchanged.
- `Enum.group_by/2` is incredibly useful for organizing data by a key.

---

*This project gives you the data manipulation tools you'll use in every subsequent project. Enum + pipe + structs are the backbone of Elixir code.*
