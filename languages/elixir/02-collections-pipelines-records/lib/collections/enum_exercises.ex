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
