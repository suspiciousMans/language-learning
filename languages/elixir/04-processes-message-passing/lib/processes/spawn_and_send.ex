defmodule Processes.SpawnAndSend do
  @moduledoc """
  Exercises: spawn processes, send messages, receive messages.
  """

  @doc """
  Spawn a process that sends a greeting back to the caller.
  Return the PID of the spawned process.
  The spawned process sends {:greeting, "hello from <pid>"} to the parent.
  """
  def spawn_greeting do
    parent = self()
    pid = spawn(fn ->
      send(parent, {:greeting, "hello from #{inspect(pid)}"})
    end)
    pid
  end

  @doc """
  Receive a greeting message and return it.
  Use receive/1 with pattern matching.
  """
  def receive_greeting do
    receive do
      {:greeting, msg} -> msg
    after
      5000 -> {:timeout, "no greeting received"}
    end
  end

  @doc """
  Spawn a process that sends multiple messages, then receive them all.
  Return the list of received messages.
  The spawned process sends {:msg, i} for i in 1..n, then {:done, pid}.
  """
  def spawn_and_collect(n) when n > 0 do
    parent = self()
    spawn(fn ->
      Enum.each(1..n, fn i ->
        send(parent, {:msg, i})
      end)
      send(parent, {:done, self()})
    end)

    collect_messages(n + 1)  # n messages + 1 done message
  end

  defp collect_messages(0), do: []
  defp collect_messages(remaining) do
    receive do
      {:msg, value} -> [value | collect_messages(remaining - 1)]
      {:done, _pid} -> collect_messages(remaining - 1)
    after
      5000 -> []
    end
  end

  @doc """
  Demonstrate a basic receive loop that echoes messages back.
  The spawned process echoes back any message until it receives :stop.
  Return a function that sends a message and awaits the echo.
  """
  def echo_server do
    spawn(fn ->
      echo_loop()
    end)
  end

  defp echo_loop do
    receive do
      {:echo, msg, from} ->
        send(from, {:echoed, msg})
        echo_loop()
      :stop ->
        :ok
    end
  end

  @doc """
  Send a message to the echo server and wait for the echo.
  """
  def echo(server_pid, msg) do
    send(server_pid, {:echo, msg, self()})
    receive do
      {:echoed, result} -> result
    after
      5000 -> {:timeout, "echo failed"}
    end
  end

  @doc """
  Stop the echo server.
  """
  def stop_echo(server_pid) do
    send(server_pid, :stop)
    :ok
  end
end
