defmodule PatternMatchingTest do
  use ExUnit.Case

  describe "NestedMatch" do
    test "handle_api_response/1 matches {:ok, data}" do
      assert PatternMatching.NestedMatch.handle_api_response({:ok, %{"data" => "hello"}}) == {:success, "hello"}
    end

    test "handle_api_response/1 matches {:error, message}" do
      assert PatternMatching.NestedMatch.handle_api_response({:error, %{"message" => "bad request"}}) == {:error, "bad request"}
    end

    test "handle_api_response/1 returns generic error for {:error, _}" do
      assert PatternMatching.NestedMatch.handle_api_response({:error, :timeout}) == {:error, "generic error"}
    end

    test "handle_api_response/1 returns unexpected for other shapes" do
      assert PatternMatching.NestedMatch.handle_api_response({:unknown, :stuff}) == {:unexpected, {:unknown, :stuff}}
    end

    test "match_three/1 decomposes 3-element list" do
      assert PatternMatching.NestedMatch.match_three([1, 2, 3, 4, 5]) == {:first_and_second_and_rest, 1, 2, 3, [4, 5]}
    end

    test "match_three/1 returns :too_short for short list" do
      assert PatternMatching.NestedMatch.match_three([1, 2]) == {:too_short, 2}
    end

    test "get_city/1 extracts city from nested map" do
      input = %{user: %{address: %{city: "Springfield"}}}
      assert PatternMatching.NestedMatch.get_city(input) == {:ok, "Springfield"}
    end

    test "get_city/1 returns error for missing city" do
      assert PatternMatching.NestedMatch.get_city(%{}) == {:error, "no city found"}
    end

    test "match_expected/2 returns :match when equal" do
      assert PatternMatching.NestedMatch.match_expected(42, {:ok, 42}) == :match
    end

    test "match_expected/2 returns :mismatch when not equal" do
      assert PatternMatching.NestedMatch.match_expected(42, {:ok, 7}) == :mismatch
    end
  end

  describe "Guards" do
    test "categorize/1 negative" do
      assert PatternMatching.Guards.categorize(-5) == {:negative, -5}
      assert PatternMatching.Guards.categorize(-3.14) == {:negative, -3.14}
    end

    test "categorize/1 zero" do
      assert PatternMatching.Guards.categorize(0) == {:zero, 0}
    end

    test "categorize/1 positive integer" do
      assert PatternMatching.Guards.categorize(10) == {:positive_integer, 10}
    end

    test "categorize/1 positive float" do
      assert PatternMatching.Guards.categorize(3.14) == {:positive_float, 3.14}
    end

    test "leap_year?/1 correctly identifies leap years" do
      assert PatternMatching.Guards.leap_year?(2000) == true   # divisible by 400
      assert PatternMatching.Guards.leap_year?(1900) == false  # century not by 400
      assert PatternMatching.Guards.leap_year?(2024) == true   # divisible by 4
      assert PatternMatching.Guards.leap_year?(2023) == false  # not divisible by 4
      assert PatternMatching.Guards.leap_year?(2100) == false  # century not by 400
    end

    test "quadrant/1 returns correct quadrant" do
      assert PatternMatching.Guards.quadrant({1, 1}) == :quadrant_I
      assert PatternMatching.Guards.quadrant({-1, 1}) == :quadrant_II
      assert PatternMatching.Guards.quadrant({-1, -1}) == :quadrant_III
      assert PatternMatching.Guards.quadrant({1, -1}) == :quadrant_IV
    end

    test "quadrant/1 returns :on_axis for axis points" do
      assert PatternMatching.Guards.quadrant({0, 5}) == :on_axis
      assert PatternMatching.Guards.quadrant({5, 0}) == :on_axis
      assert PatternMatching.Guards.quadrant({0, 0}) == :on_axis
    end

    test "has_length/2 returns true for matching length" do
      assert PatternMatching.Guards.has_length([1, 2, 3], 3) == true
      assert PatternMatching.Guards.has_length([], 0) == true
    end

    test "has_length/2 returns false for non-matching" do
      assert PatternMatching.Guards.has_length([1, 2], 3) == false
    end

    test "is_weekend?/1 returns true for sat/sun" do
      assert PatternMatching.Guards.is_weekend?(:sat) == true
      assert PatternMatching.Guards.is_weekend?(:sun) == true
    end

    test "is_weekend?/1 returns false for weekdays" do
      assert PatternMatching.Guards.is_weekend?(:mon) == false
      assert PatternMatching.Guards.is_weekend?(:wed) == false
    end

    test "valid_age?/1 returns true for valid range" do
      assert PatternMatching.Guards.valid_age?(18) == true
      assert PatternMatching.Guards.valid_age?(50) == true
      assert PatternMatching.Guards.valid_age?(120) == true
    end

    test "valid_age?/1 returns false outside range" do
      assert PatternMatching.Guards.valid_age?(17) == false
      assert PatternMatching.Guards.valid_age?(121) == false
    end
  end

  describe "ControlFlow" do
    test "dispatch/1 {:ok, body}" do
      assert PatternMatching.ControlFlow.dispatch({:ok, "data"}) == {:success, "data"}
    end

    test "dispatch/1 {:redirect, url}" do
      assert PatternMatching.ControlFlow.dispatch({:redirect, "/new"}) == {:redirect, "/new"}
    end

    test "dispatch/1 {:error, status < 500, msg} → client_error" do
      assert PatternMatching.ControlFlow.dispatch({:error, 404, "not found"}) == {:client_error, "not found"}
      assert PatternMatching.ControlFlow.dispatch({:error, 400, "bad request"}) == {:client_error, "bad request"}
    end

    test "dispatch/1 {:error, status >= 500, msg} → server_error" do
      assert PatternMatching.ControlFlow.dispatch({:error, 500, "crash"}) == {:server_error, "crash"}
      assert PatternMatching.ControlFlow.dispatch({:error, 503, "unavailable"}) == {:server_error, "unavailable"}
    end

    test "dispatch/1 unknown shape" do
      assert PatternMatching.ControlFlow.dispatch({:weird, :shape}) == {:unknown, {:weird, :shape}}
    end

    test "grade_score/1 returns correct grades" do
      assert PatternMatching.ControlFlow.grade_score(95) == {:grade, "A"}
      assert PatternMatching.ControlFlow.grade_score(85) == {:grade, "B"}
      assert PatternMatching.ControlFlow.grade_score(75) == {:grade, "C"}
      assert PatternMatching.ControlFlow.grade_score(65) == {:grade, "D"}
      assert PatternMatching.ControlFlow.grade_score(55) == {:grade, "F"}
      assert PatternMatching.ControlFlow.grade_score(90) == {:grade, "A"}
      assert PatternMatching.ControlFlow.grade_score(60) == {:grade, "D"}
    end

    test "first_doubled_if/1 returns doubled first element" do
      assert PatternMatching.ControlFlow.first_doubled_if([5, 10, 15]) == 10
    end

    test "first_doubled_if/1 returns :empty for empty list" do
      assert PatternMatching.ControlFlow.first_doubled_if([]) == :empty
    end

    test "sum_unless_empty/1 returns sum" do
      assert PatternMatching.ControlFlow.sum_unless_empty([1, 2, 3]) == 6
    end

    test "sum_unless_empty/1 returns :empty for empty list" do
      assert PatternMatching.ControlFlow.sum_unless_empty([]) == :empty
    end

    test "parse_command/1 {:get, key}" do
      assert PatternMatching.ControlFlow.parse_command({:get, :name}) == {:value, :name}
    end

    test "parse_command/1 {:set, key, value}" do
      assert PatternMatching.ControlFlow.parse_command({:set, :count, 42}) == {:stored, :count, 42}
    end

    test "parse_command/1 {:delete, key}" do
      assert PatternMatching.ControlFlow.parse_command({:delete, :temp}) == {:deleted, :temp}
    end

    test "parse_command/1 {:unknown, cmd}" do
      assert PatternMatching.ControlFlow.parse_command({:unknown, :foobar}) == {:unknown, :foobar}
    end
  end

  describe "ExprEval" do
    test "eval/1 literal number" do
      assert PatternMatching.ExprEval.eval({:number, 42}) == 42
      assert PatternMatching.ExprEval.eval({:number, 3.14}) == 3.14
    end

    test "eval/1 binary operations" do
      assert PatternMatching.ExprEval.eval({:op, :add, {:number, 3}, {:number, 5}}) == 8
      assert PatternMatching.ExprEval.eval({:op, :sub, {:number, 10}, {:number, 4}}) == 6
      assert PatternMatching.ExprEval.eval({:op, :mul, {:number, 6}, {:number, 7}}) == 42
      assert PatternMatching.ExprEval.eval({:op, :div, {:number, 20}, {:number, 4}}) == 5.0
    end

    test "eval/1 nested operations" do
      expr = {:op, :add, {:op, :mul, {:number, 2}, {:number, 3}}, {:number, 4}}
      assert PatternMatching.ExprEval.eval(expr) == 10
    end

    test "eval/1 division by zero returns error" do
      expr = {:op, :div, {:number, 10}, {:number, 0}}
      assert PatternMatching.ExprEval.eval(expr) == {:error, "division by zero"}
    end

    test "eval/1 if-then-else conditional" do
      expr = {:if, {:number, 1}, {:number, 100}, {:number, 200}}
      assert PatternMatching.ExprEval.eval(expr) == 100

      expr_false = {:if, {:number, 0}, {:number, 100}, {:number, 200}}
      assert PatternMatching.ExprEval.eval(expr_false) == 200
    end

    test "eval/1 let binding and variable reference" do
      expr = {:let, :x, {:number, 5}, {:op, :mul, {:var, :x}, {:var, :x}}}
      assert PatternMatching.ExprEval.eval(expr) == 25
    end

    test "eval/1 let with arithmetic in body" do
      expr = {:let, :x, {:number, 10}, {:op, :add, {:var, :x}, {:number, 5}}}
      assert PatternMatching.ExprEval.eval(expr) == 15
    end

    test "safe_eval/1 wraps successful result" do
      assert PatternMatching.ExprEval.safe_eval({:number, 42}) == {:ok, 42}
    end

    test "safe_eval/1 catches division by zero" do
      expr = {:op, :div, {:number, 10}, {:number, 0}}
      assert PatternMatching.ExprEval.safe_eval(expr) == {:error, "division by zero"}
    end
  end
end
