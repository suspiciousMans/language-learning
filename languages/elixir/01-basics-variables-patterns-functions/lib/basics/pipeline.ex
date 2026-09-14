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
