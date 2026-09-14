defmodule ToolingCheckTest do
  use ExUnit.Case

  test "check/0 returns a toolchain confirmation string" do
    result = ToolingCheck.check()
    assert is_binary(result)
    assert String.contains?(result, "toolchain ok")
    assert String.contains?(result, "Elixir")
  end

  test "hello/0 prints to stdout" do
    assert capture_io(fn -> ToolingCheck.Hello.greet() end) == "Hello, Elixir!\n"
  end
end
