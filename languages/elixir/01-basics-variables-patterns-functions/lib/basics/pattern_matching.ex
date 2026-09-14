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
    case {:ok, x} do
      {:ok, ^x} -> "Matched: x is still #{x}"
      _ -> "No match"
    end
  end
end
