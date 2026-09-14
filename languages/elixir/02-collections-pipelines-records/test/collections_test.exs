defmodule CollectionsTest do
  use ExUnit.Case

  describe "EnumExercises" do
    test "even_doubled/1 returns even numbers doubled" do
      assert Collections.EnumExercises.even_doubled([1, 2, 3, 4, 5, 6]) == [4, 8, 12]
    end

    test "even_doubled/1 returns empty list for no evens" do
      assert Collections.EnumExercises.even_doubled([1, 3, 5]) == []
    end

    test "group_by/2 groups by function result" do
      people = [
        %{name: "Alice", department: "Eng"},
        %{name: "Bob", department: "Eng"},
        %{name: "Carol", department: "HR"}
      ]
      result = Collections.EnumExercises.group_by(people, & &1[:department])
      assert result[:Eng] |> Enum.map(& &1[:name]) |> Enum.sort() == ["Alice", "Bob"]
      assert result[:HR] |> Enum.map(& &1[:name]) == ["Carol"]
    end

    test "most_frequent/1 returns the most common element" do
      assert Collections.EnumExercises.most_frequent([1, 2, 2, 3, 3, 3]) == 3
    end

    test "most_frequent/1 ties broken by first occurrence" do
      assert Collections.EnumExercises.most_frequent([1, 1, 2, 2]) == 1
    end

    test "flatten_uniq/1 flattens and deduplicates" do
      assert Collections.EnumExercises.flatten_uniq([[1, 2], [2, 3], [3]]) == [1, 2, 3]
    end

    test "chunk_pad/2 pads last chunk with nil" do
      assert Collections.EnumExercises.chunk_pad([1, 2, 3, 4, 5], 2) == [[1, 2], [3, 4], [5, nil]]
    end

    test "chunk_pad/2 no padding when exact multiple" do
      assert Collections.EnumExercises.chunk_pad([1, 2, 3, 4], 2) == [[1, 2], [3, 4]]
    end
  end

  describe "StreamExercises" do
    test "fibonacci_stream/1 generates fib numbers up to limit" do
      result = Collections.StreamExercises.fibonacci_stream(10) |> Enum.to_list()
      assert result == [0, 1, 1, 2, 3, 5, 8]
    end

    test "fibonacci_stream/1 limit 0 returns just [0]" do
      assert Collections.StreamExercises.fibonacci_stream(0) |> Enum.to_list() == [0]
    end

    test "even_squares_above/2 returns first n even squares above threshold" do
      result = Collections.StreamExercises.even_squares_above(10, 3) |> Enum.to_list()
      assert result == [16, 36, 64]
    end

    test "cycle_take/2 cycles and takes" do
      assert Collections.StreamExercises.cycle_take([:a, :b], 5) == [:a, :b, :a, :b, :a]
    end

    test "cross_product/2 returns all pairs" do
      result = Collections.StreamExercises.cross_product([1, 2], [:a, :b])
      assert result == [{1, :a}, {1, :b}, {2, :a}, {2, :b}]
    end
  end

  describe "Comprehensions" do
    test "all_pairs/2 generates all pairs" do
      result = Collections.Comprehensions.all_pairs(2, 3)
      assert result == [{1, 1}, {1, 2}, {1, 3}, {2, 1}, {2, 2}, {2, 3}]
    end

    test "even_squares/1 returns squares of evens" do
      assert Collections.Comprehensions.even_squares(6) == [4, 16, 36]
    end

    test "tuples_to_map/1 builds a map" do
      tuples = [{ :a, 1 }, { :b, 2 }, { :c, 3 }]
      assert Collections.Comprehensions.tuples_to_map(tuples) == %{a: 1, b: 2, c: 3}
    end

    test "valid_assignments/2 returns matching pairs" do
      users = [
        %{name: "Alice", level: 3},
        %{name: "Bob", level: 1}
      ]
      roles = [
        %{title: "viewer", min_level: 1},
        %{title: "editor", min_level: 2},
        %{title: "admin", min_level: 5}
      ]
      result = Collections.Comprehensions.valid_assignments(users, roles)
      assert result == [{"Alice", "viewer"}, {"Alice", "editor"}, {"Bob", "viewer"}]
    end

    test "count_divisible/2 counts divisible numbers" do
      assert Collections.Comprehensions.count_divisible(10, [2, 3]) == 7
    end
  end

  describe "Structs" do
    test "User.new/4 creates a struct with defaults" do
      user = Collections.User.new(1, "Alice", "alice@example.com")
      assert user.id == 1
      assert user.name == "Alice"
      assert user.email == "alice@example.com"
      assert user.role == :viewer
      assert user.level == 1
      assert user.active == true
    end

    test "User.promote/1 increments level" do
      user = Collections.User.new(1, "Bob", "bob@example.com", :viewer, 3)
      promoted = Collections.User.promote(user)
      assert promoted.level == 4
      assert user.level == 3  # original unchanged
    end

    test "User.can_access?/2 returns true for active user above level" do
      user = %Collections.User{level: 5, active: true}
      assert Collections.User.can_access?(user, 5) == true
      assert Collections.User.can_access?(user, 3) == true
    end

    test "User.can_access?/2 returns false for inactive user" do
      user = %Collections.User{level: 10, active: false}
      assert Collections.User.can_access?(user, 1) == false
    end

    test "User.can_access?/2 returns false below required level" do
      user = %Collections.User{level: 2, active: true}
      assert Collections.User.can_access?(user, 5) == false
    end

    test "Structs.active_team_sorted/1 returns active users sorted by level" do
      specs = [
        [id: 1, name: "Alice", level: 5, active: true],
        [id: 2, name: "Bob", level: 3, active: true],
        [id: 3, name: "Carol", level: 7, active: false],
        [id: 4, name: "Diana", level: 9, active: true]
      ]
      team = Collections.Structs.active_team_sorted(specs)
      assert team |> Enum.map(& &1.name) == ["Diana", "Alice", "Bob"]
      assert team |> Enum.map(& &1.level) == [9, 5, 3]
    end

    test "Structs.promote_below/2 promotes only below cap" do
      users = [
        Collections.User.new(1, "Alice", "a@b.com", :viewer, 2),
        Collections.User.new(2, "Bob", "b@c.com", :viewer, 5),
        Collections.User.new(3, "Carol", "c@d.com", :viewer, 1)
      ]
      result = Collections.Structs.promote_below(users, 4)
      levels = Enum.map(result, & &1.level)
      assert levels == [3, 5, 2]
    end
  end
end
