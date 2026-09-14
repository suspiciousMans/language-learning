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
