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
