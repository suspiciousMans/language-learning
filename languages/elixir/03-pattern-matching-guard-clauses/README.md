# Project 03: Pattern Matching and Guard Clauses — Elixir

**Difficulty:** intermediate  
**Prerequisites:** Project 02 (Collections, Pipelines, Records)

## Goals

- Deepen your understanding of Elixir's pattern matching — the core of its expressiveness.
- Learn and apply guard clauses to constrain function heads and `case` branches.
- Master `case`, `cond`, and `if` as flow-control tools.
- Understand when to use matching vs guards vs conditionals.
- Write code that leans on the compiler to enforce correctness.

## Concepts

- **Pattern matching** — matching shapes (tuples, lists, maps, structs) against data; `=` is a match, not assignment
- **Guard clauses** — `when` conditions on function heads and `case` branches; limited but powerful
- **Allowed guard expressions** — comparison operators (`==`, `!=`, `===`, `!==`, `>`, `<`, `>=`, `<=`), boolean operators (`and`, `or`, `not`), arithmetic operators (`+`, `-`, `*`, `/`, `div`, `rem`), `in` operator, `is_*` type checks, `abs/1`, `byte_size/1`, `ceil/1`, `floor/1`, `length/1`, `map_size/1`, `tuple_size/1`
- **`case` expression** — pattern-match against a value with multiple clauses
- **`cond` expression** — boolean conditions, no pattern matching
- **`if`/`unless`** — single condition, binary branch
- **Function heads with patterns** — multiple clauses matched in order; first match wins
- **The pin operator `^`** — match against an existing variable, don't rebind
- **Default arguments** — `def f(x, y \\ 42)` — the `\` syntax
- **`_` wildcard** — "I don't care about this value"
- **Matching on results** — `{:ok, value} = result` — will raise if result is `{:error, _}`

## Exercises

### Exercise 1: Advanced Pattern Matching — Nested Shapes

Create `lib/pattern_matching/nested_match.ex`:

```elixir
defmodule PatternMatching.NestedMatch do
  @moduledoc """
  Exercises: matching on deeply nested structures.
  """

  @doc """
  Match a response tuple that is either:
    {:ok, %{"data" => data}} — extract data
    {:error, %{"message" => msg}} — return error string
    {:error, _} — return generic error
  """
  def handle_api_response({:ok, %{"data" => data}}) do
    {:success, data}
  end

  def handle_api_response({:error, %{"message" => msg}}) do
    {:error, msg}
  end

  def handle_api_response({:error, _}) do
    {:error, "generic error"}
  end

  def handle_api_response(other), do: {:unexpected, other}

  @doc """
  Match a list that has at least 3 elements.
  Return {:first, :second, :rest} or {:too_short, actual_length}.
  """
  def match_three([a, b, c | rest]) do
    {:first_and_second_and_rest, a, b, c, rest}
  end

  def match_three(list) when is_list(list) do
    {:too_short, length(list)}
  end

  @doc """
  Match a deeply nested map: extract user's address city.
  Return {:ok, city} or {:error, reason}.
  """
  def get_city(%{user: %{address: %{city: city}}}, do: {:ok, city})
  def get_city(_), do: {:error, "no city found"}

  @doc """
  Match on a result tuple with a pinned expected value.
  Return :match or :mismatch.
  """
  def match_expected(expected, {:ok, actual}) do
    if expected == actual, do: :match, else: :mismatch
  end
end
```

### Exercise 2: Guard Clauses in Depth

Create `lib/pattern_matching/guards.ex`:

```elixir
defmodule PatternMatching.Guards do
  @moduledoc """
  Exercises using guard clauses on function heads.
  """

  @doc """
  Categorize a number as negative, zero, positive integer, or positive float.
  Use guards to distinguish integer from float.
  """
  def categorize(n) when n < 0, do: {:negative, n}
  def categorize(n) when n == 0, do: {:zero, n}
  def categorize(n) when is_integer(n) and n > 0, do: {:positive_integer, n}
  def categorize(n) when is_float(n) and n > 0, do: {:positive_float, n}

  @doc """
  Determine if a given year is a leap year.
  Rules: divisible by 4, except centuries not divisible by 400.
  Use guard expressions with `rem`.
  """
  def leap_year?(year) when rem(year, 400) == 0, do: true
  def leap_year?(year) when rem(year, 100) == 0, do: false
  def leap_year?(year) when rem(year, 4) == 0, do: true
  def leap_year?(_), do: false

  @doc """
  Match a point tuple and compute the quadrant.
  Quadrants: I (x>0, y>0), II (x<0, y>0), III (x<0, y<0), IV (x>0, y<0).
  On axes, return :on_axis.
  """
  def quadrant({x, y}) when x > 0 and y > 0, do: :quadrant_I
  def quadrant({x, y}) when x < 0 and y > 0, do: :quadrant_II
  def quadrant({x, y}) when x < 0 and y < 0, do: :quadrant_III
  def quadrant({x, y}) when x > 0 and y < 0, do: :quadrant_IV
  def quadrant({x, y}) when x == 0 or y == 0, do: :on_axis

  @doc """
  Check if a list has exactly `n` elements using `length/1` guard.
  """
  def has_length(list, n) when length(list) == n, do: true
  def has_length(_, _), do: false

  @doc """
  Use `in` operator in a guard to check if value is in a list.
  """
  def is_weekend?(day) when day in [:sat, :sun], do: true
  def is_weekend?(_), do: false

  @doc """
  Combine guards with boolean operators.
  Return :valid if age >= 18 and age <= 120.
  """
  def valid_age?(age) when age >= 18 and age <= 120, do: true
  def valid_age?(_), do: false
end
```

### Exercise 3: case, cond, and if — Flow Control

Create `lib/pattern_matching/control_flow.ex`:

```elixir
defmodule PatternMatching.ControlFlow do
  @moduledoc """
  Exercises: case, cond, if/unless.
  """

  @doc """
  Use `case` to dispatch on an HTTP-status-like tuple.
  {:ok, body} → {:success, body}
  {:redirect, url} → {:redirect, url}
  {:error, status, msg} → {:client_error, msg} if status < 500
                          {:server_error, msg} if status >= 500
  Anything else → {:unknown, term}
  """
  def dispatch({:ok, body}), do: {:success, body}
  def dispatch({:redirect, url}), do: {:redirect, url}

  def dispatch({:error, status, msg}) when status >= 500 do
    {:server_error, msg}
  end

  def dispatch({:error, status, msg}) when status < 500 do
    {:client_error, msg}
  end

  def dispatch(other), do: {:unknown, other}

  @doc """
  Use `cond` to select the first matching boolean condition.
  Categorize a score: A (>= 90), B (>= 80), C (>= 70), D (>= 60), F (< 60).
  Return {:grade, letter}.
  """
  def grade_score(score) when is_number(score) do
    cond do
      score >= 90 -> {:grade, "A"}
      score >= 80 -> {:grade, "B"}
      score >= 70 -> {:grade, "C"}
      score >= 60 -> {:grade, "D"}
      true -> {:grade, "F"}
    end
  end

  @doc """
  Use `if` to conditionally transform data.
  If the list is non-empty, return the first element doubled.
  Otherwise return :empty.
  """
  def first_doubled_if(list) when is_list(list) do
    if length(list) > 0 do
      hd(list) * 2
    else
      :empty
    end
  end

  @doc """
  Use `unless` to skip processing empty data.
  Return the sum of a list, or :empty if the list is empty.
  """
  def sum_unless_empty(list) when is_list(list) do
    unless length(list) == 0 do
      Enum.reduce(list, 0, &+/2)
    else
      :empty
    end
  end

  @doc """
  Combine pattern matching and `case` in one function.
  Parse a command tuple:
    {:get, key} — return {:value, lookup(key)}
    {:set, key, value} — return {:stored, key, value}
    {:delete, key} — return {:deleted, key}
    {:unknown, cmd} — return {:unknown, cmd}
  """
  def parse_command({:get, key}), do: {:value, key}
  def parse_command({:set, key, value}), do: {:stored, key, value}
  def parse_command({:delete, key}), do: {:deleted, key}
  def parse_command({:unknown, cmd}), do: {:unknown, cmd}
end
```

### Exercise 4: Put It All Together — A Simple Expression Evaluator

Create `lib/pattern_matching/expr_eval.ex`:

```elixir
defmodule PatternMatching.ExprEval do
  @moduledoc """
  A simple arithmetic expression evaluator using pattern matching
  and guards. Expressions are represented as tuples.
  """

  @doc """
  Evaluate a literal number.
  """
  def eval({:number, n}) when is_number(n), do: n

  @doc """
  Evaluate a binary operation: {:op, operator, left, right}.
  Operators: :add, :sub, :mul, :div.
  """
  def eval({:op, :add, left, right}) do
    eval(left) + eval(right)
  end

  def eval({:op, :sub, left, right}) do
    eval(left) - eval(right)
  end

  def eval({:op, :mul, left, right}) do
    eval(left) * eval(right)
  end

  def eval({:op, :div, left, right}) do
    denominator = eval(right)
    if denominator != 0 do
      eval(left) / denominator
    else
      {:error, "division by zero"}
    end
  end

  @doc """
  Evaluate a conditional expression:
  {:if, condition, then_branch, else_branch}
  condition is evaluated; if truthy, eval then_branch, else else_branch.
  """
  def eval({:if, condition, then_branch, else_branch}) do
    if eval(condition) != 0 and eval(condition) != false and eval(condition) != nil do
      eval(then_branch)
    else
      eval(else_branch)
    end
  end

  @doc """
  Evaluate a let expression:
  {:let, var_name, value_expr, body_expr}
  Bind var_name to the evaluated value and evaluate body.
  For simplicity, var_name is just a symbol atom; the body is a tuple
  that references the variable with {:var, var_name}.
  """
  def eval({:let, var, value_expr, body_expr}) do
    value = eval(value_expr)
    eval_body(body_expr, var, value)
  end

  defp eval_body({:var, ^var}, var, value), do: value
  defp eval_body({:op, op, left, right}, var, value) do
    eval({:op, op, eval_body(left, var, value), eval_body(right, var, value)})
  end
  defp eval_body(term, _var, _value), do: eval(term)

  @doc """
  Safe evaluation that catches division-by-zero errors.
  Returns {:ok, result} or {:error, reason}.
  """
  def safe_eval(expr) do
    case eval(expr) do
      {:error, _} = err -> err
      result -> {:ok, result}
    end
  end
end
```

## Completion Checklist

- [ ] `handle_api_response/1` handles all response shapes correctly.
- [ ] `match_three/1` returns the 3-element decomposition for long enough lists.
- [ ] `get_city/1` extracts city from nested map or returns error.
- [ ] `match_expected/2` returns `:match` or `:mismatch`.
- [ ] `categorize/1` distinguishes negative, zero, positive integer, positive float.
- [ ] `leap_year?/1` correctly identifies leap years (e.g. 2000 = true, 1900 = false, 2024 = true).
- [ ] `quadrant/1` returns the correct quadrant for all 4 quadrants and axis cases.
- [ ] `has_length/2` returns true only when list length matches.
- [ ] `is_weekend?/1` returns true for `:sat` and `:sun`.
- [ ] `valid_age?/1` returns true only for ages 18..120 inclusive.
- [ ] `dispatch/1` routes all HTTP-like tuples correctly.
- [ ] `grade_score/1` returns correct letter grades.
- [ ] `first_doubled_if/1` returns first element doubled, or `:empty`.
- [ ] `sum_unless_empty/1` returns sum or `:empty`.
- [ ] `parse_command/1` handles get/set/delete/unknown.
- [ ] `eval/1` evaluates number literals.
- [ ] `eval/1` evaluates binary operations (add, sub, mul, div).
- [ ] `eval/1` handles division by zero with error tuple.
- [ ] `eval/1` evaluates `{:if, ...}` conditionals.
- [ ] `eval/1` evaluates `{:let, ...}` with variable binding and reference.
- [ ] `safe_eval/1` wraps eval results in `{:ok, ...}` or `{:error, ...}`.

## Hints

- Pattern matching goes in the function head — the arguments are matched against patterns, and the first matching clause wins.
- Guards are an extension, not a replacement, for pattern matching. They let you add boolean conditions to clauses, but they are limited (no function calls except the allowed built-ins).
- `case` is great when you have a single value to match against multiple shapes. `cond` is great when you have independent boolean conditions. `if` is for binary branching.
- `{:ok, result} = expr` is a common idiom — it matches and binds `result`. But it will raise if `expr` is not `{:ok, _}`. Use `case` for safe handling.
- The pin operator `^` is essential when you need to compare a variable to a value in a pattern, not rebind it.
- The expression evaluator exercises show how pattern matching can replace explicit dispatch logic — each expression type is a different pattern.

---

*Pattern matching and guards are the heart of Elixir's expressiveness. Mastery here makes every subsequent project easier — OTP behaviours, Phoenix plugs, and Ecto queries all lean heavily on matching.*
