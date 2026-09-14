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
