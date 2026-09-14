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
