defmodule BasicsTest do
  use ExUnit.Case

  describe "VariablesTypes" do
    test "binding_demo/0 returns 2 after rebinding" do
      assert Basics.VariablesTypes.binding_demo() == 2
    end

    test "immutability_demo/1 returns original and new list unchanged" do
      original = [1, 2, 3]
      {orig, new} = Basics.VariablesTypes.immutability_demo(original)
      assert orig == [1, 2, 3]
      assert new == [0, 1, 2, 3]
      assert orig != new
    end

    test "greet_with_version/1 returns {:ok, string with name and version}" do
      {:ok, msg} = Basics.VariablesTypes.greet_with_version("Alice")
      assert String.contains?(msg, "Hello, Alice!")
      assert String.contains?(msg, "Elixir")
    end

    test "basic_types_map/0 returns a map with expected keys" do
      result = Basics.VariablesTypes.basic_types_map()
      assert result.status == :ready
      assert result.pi == 3.14
      assert result.is_fun == true
    end
  end

  describe "PatternMatching" do
    test "handle_result/1 matches {:ok, value}" do
      assert Basics.PatternMatching.handle_result({:ok, 42}) == {:success, 42}
    end

    test "handle_result/1 matches {:error, reason}" do
      assert Basics.PatternMatching.handle_result({:error, "oops"}) == {:failed, "oops"}
    end

    test "decompose_list/1 returns {head, tail}" do
      assert Basics.PatternMatching.decompose_list([1, 2, 3]) == {1, [2, 3]}
    end

    test "decompose_list/1 returns {:empty, []} for empty list" do
      assert Basics.PatternMatching.decompose_list([]) == {:empty, []}
    end

    test "match_point/1 formats a point string" do
      assert Basics.PatternMatching.match_point({1, 2, 3}) == "Point at (1, 2, 3)"
    end

    test "user_name/1 extracts name from map" do
      assert Basics.PatternMatching.user_name(%{name: "Bob", age: 30}) == "Bob"
    end

    test "pin_demo/1 returns match confirmation" do
      assert Basics.PatternMatching.pin_demo() == "Matched: x is still 42"
    end
  end

  describe "Functions" do
    test "categorize/1 for negative" do
      assert Basics.Functions.categorize(-5) == {:negative, -5}
    end

    test "categorize/1 for zero" do
      assert Basics.Functions.categorize(0) == {:zero, 0}
    end

    test "categorize/1 for positive" do
      assert Basics.Functions.categorize(10) == {:positive, 10}
    end

    test "factorial/1 computes correctly" do
      assert Basics.Functions.factorial(0) == 1
      assert Basics.Functions.factorial(1) == 1
      assert Basics.Functions.factorial(5) == 120
      assert Basics.Functions.factorial(7) == 5040
    end

    test "sum_list/1 sums numeric elements" do
      assert Basics.Functions.sum_list([1, 2, 3, 4]) == 10
      assert Basics.Functions.sum_list([]) == 0
    end

    test "make_doubler/0 returns a function that doubles" do
      doubler = Basics.Functions.make_doubler()
      assert doubler.(5) == 10
      assert doubler.(0) == 0
    end

    test "doubler_ref/0 returns a capture-based doubler" do
      doubler = Basics.Functions.doubler_ref()
      assert doubler.(7) == 14
    end
  end

  describe "Pipeline" do
    test "adult_names/1 returns sorted adult names" do
      people = [
        %{name: "Charlie", age: 17},
        %{name: "Alice", age: 25},
        %{name: "Bob", age: 18},
        %{name: "Diana", age: 16}
      ]
      assert Basics.Pipeline.adult_names(people) == ["Alice", "Bob"]
    end

    test "stats/1 returns {:ok, total, average}" do
      {:ok, total, avg} = Basics.Pipeline.stats([10, 20, 30])
      assert total == 60
      assert avg == 20.0
    end

    test "stats/1 returns error for empty list" do
      assert Basics.Pipeline.stats([]) == {:error, "empty list"}
    end
  end
end
