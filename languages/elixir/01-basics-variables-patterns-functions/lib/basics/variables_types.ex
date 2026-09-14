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
