defmodule Processes.LinksAndMonitors do
  @moduledoc """
  Exercises: process linking, monitoring, and exit handling.
  """

  @doc """
  Spawn a linked process that exits immediately.
  The caller should receive an exit signal (crash if not caught).
  Wrap in try/rescue to demonstrate.
  """
  def spawn_linked_crash do
    pid = spawn_link(fn ->
      send(self(), :crash)
      receive do
        :crash -> raise "intentional crash"
      end
    end)
    # Give the process time to crash
    Process.sleep(100)
    :ok  # may crash the caller — that's the point
  end

  @doc """
  Spawn a process under a monitor. When the spawned process exits,
  the monitor receives a {:DOWN, ref, :process, pid, reason} message.
  Return the monitor reference.
  """
  def spawn_monitored do
    parent = self()
    {pid, ref} = spawn_monitor(fn ->
      send(parent, {:started, self()})
      Process.sleep(100)
      exit(:normal_exit)
    end)

    # Wait for the started message
    receive do
      {:started, child_pid} -> child_pid
    end

    # Return the monitor ref for later checking
    ref
  end

  @doc """
  Check if a monitored process has exited by receiving the DOWN message.
  Return {:ok, reason} or {:timeout}.
  """
  def wait_down(ref, timeout \\ 5000) do
    receive do
      {:DOWN, ^ref, :process, _pid, reason} -> {:ok, reason}
    after
      timeout -> {:timeout}
    end
  end

  @doc """
  Demonstrate that linked processes propagate exits.
  Start a "worker" process linked to a "supervisor".
  When the worker crashes, the supervisor also exits.
  Use spawn_link and try/rescue.
  """
  def linked_worker_demo do
    supervisor_pid = self()

    # Spawn a worker that will crash
    spawn_link(fn ->
      Process.sleep(50)
      raise "worker crash"
    end)

    # Wait for the worker to crash and propagate
    Process.sleep(200)

    # If we get here, the supervisor didn't crash
    :supervisor_survived
  rescue
    Kind: _kind, Reason: _reason ->
      :supervisor_crashed
  end

  @doc """
  Use Process.flag/2 to trap exits on the current process.
  Then spawn a linked process that exits; the current process
  should receive an exit signal as a message instead of crashing.
  """
  def trap_exit_demo do
    Process.flag(:trap_exit, true)

    spawn_link(fn ->
      Process.sleep(50)
      exit(:worker_exit)
    end)

    receive do
      {:EXIT, _pid, reason} -> {:trapped, reason}
    after
      5000 -> {:timeout}
    end
  end
end
