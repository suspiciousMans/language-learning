defmodule ToolingCheck do
  @moduledoc """
  A minimal module to confirm the toolchain is working.
  """

  @doc """
  Returns a greeting string confirming the toolchain is OK.
  """
  def check do
    "toolchain ok — Elixir #{System.version()}, OTP #{:erlang.system_info(:otp_release)}"
  end
end
