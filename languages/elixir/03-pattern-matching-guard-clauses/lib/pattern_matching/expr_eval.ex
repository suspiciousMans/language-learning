defmodule PatternMatching.ExprEval do
  @moduledoc """
  A simple arithmetic expression evaluator using pattern matching
  and guards. Expressions are represented as tuples.
  """

  @doc """
  Evaluate a literal number.
  """
  def eval({:number, n}) when is_number(n), do: n

  @doc """
  Evaluate a binary operation: {:op, operator, left, right}.
  Operators: :add, :sub, :mul, :div.
  """
  def eval({:op, :add, left, right}) do
    eval(left) + eval(right)
  end

  def eval({:op, :sub, left, right}) do
    eval(left) - eval(right)
  end

  def eval({:op, :mul, left, right}) do
    eval(left) * eval(right)
  end

  def eval({:op, :div, left, right}) do
    denominator = eval(right)
    if denominator != 0 do
      eval(left) / denominator
    else
      {:error, "division by zero"}
    end
  end

  @doc """
  Evaluate a conditional expression:
  {:if, condition, then_branch, else_branch}
  condition is evaluated; if truthy, eval then_branch, else else_branch.
  """
  def eval({:if, condition, then_branch, else_branch}) do
    cond_val = eval(condition)
    if cond_val != 0 and cond_val != false and cond_val != nil do
      eval(then_branch)
    else
      eval(else_branch)
    end
  end

  @doc """
  Evaluate a let expression:
  {:let, var_name, value_expr, body_expr}
  Bind var_name to the evaluated value and evaluate body.
  For simplicity, var_name is just a symbol atom; the body is a tuple
  that references the variable with {:var, var_name}.
  """
  def eval({:let, var, value_expr, body_expr}) do
    value = eval(value_expr)
    eval_body(body_expr, var, value)
  end

  defp eval_body({:var, ^var}, var, value), do: value
  defp eval_body({:op, op, left, right}, var, value) do
    eval({:op, op, eval_body(left, var, value), eval_body(right, var, value)})
  end
  defp eval_body(term, _var, _value), do: eval(term)

  @doc """
  Safe evaluation that catches division-by-zero errors.
  Returns {:ok, result} or {:error, reason}.
  """
  def safe_eval(expr) do
    case eval(expr) do
      {:error, _} = err -> err
      result -> {:ok, result}
    end
  end
end
