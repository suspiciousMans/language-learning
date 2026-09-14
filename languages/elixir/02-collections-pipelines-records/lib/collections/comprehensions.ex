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
