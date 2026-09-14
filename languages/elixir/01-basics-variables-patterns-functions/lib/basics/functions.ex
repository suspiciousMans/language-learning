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
