# Project 04: Processes and Message Passing — Elixir

**Difficulty:** intermediate  
**Prerequisites:** Project 03 (Pattern Matching, Guard Clauses)

## Goals

- Understand Elixir's process model: lightweight actors on the BEAM VM.
- Send and receive messages between processes using `send/2` and `receive/1`.
- Use `Task` for simple concurrent work.
- Use `Agent` for shared state.
- Build a simple concurrent system with interacting processes.

## Concepts

- **BEAM processes** — lightweight (few KB), isolated, scheduled by the VM; not OS threads
- **`spawn/1`, `spawn_link/1`, `spawn_monitor/1`** — create new processes
- **`send/2`** — send a message to a PID or name
- **`receive/1`** — pattern-match incoming messages in a blocking loop
- **`Process.exit/2`, `Process.monitor/1`, `Process.link/1`** — lifecycle and failure propagation
- **`Task`** — one-off concurrent work; `Task.async/1`, `Task.await/2`, `Task Supervisor`
- **`Agent`** — a process that holds state and exposes get/update operations
- **`GenServer` (intro)** — the standard stateful process behaviour; used deeply in Project 05
- **Message loop** — `receive` + recursion to handle multiple messages
- **`after` timeout** — receive with a timeout to avoid blocking forever

## Exercises

### Exercise 1: Spawn and Message Passing Basics

Create `lib/processes/spawn_and_send.ex`:

```elixir
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
  end
end
```

### Exercise 2: Process Linking and Monitoring

Create `lib/processes/links_and_monitors.ex`:

```elixir
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
```

### Exercise 3: Agents — Shared State Processes

Create `lib/processes/agent_state.ex`:

```elixir
defmodule Processes.AgentState do
  @moduledoc """
  Exercises: use Agent for shared state.
  """

  @doc """
  Start an Agent that holds a counter (initial value 0).
  Return {:ok, pid}.
  """
  def start_counter do
    Agent.start(fn -> 0 end, name: __MODULE__.Counter)
  end

  @doc """
  Increment the counter by 1.
  """
  def increment do
    Agent.update(__MODULE__.Counter, fn count -> count + 1 end)
  end

  @doc """
  Get the current counter value.
  """
  def get_count do
    Agent.get(__MODULE__.Counter, fn count -> count end)
  end

  @doc """
  Stop the counter agent.
  """
  def stop_counter do
    Agent.stop(__MODULE__.Counter, :normal)
  end

  @doc """
  Create a key-value store Agent.
  Support: put(key, value), get(key), get_all(), delete(key).
  """
  def start_kv do
    Agent.start(fn -> %{} end, name: __MODULE__.KV)
  end

  def put(key, value) when is_binary(key) do
    Agent.update(__MODULE__.KV, fn store ->
      Map.put(store, key, value)
    end)
  end

  def get(key) when is_binary(key) do
    Agent.get(__MODULE__.KV, fn store ->
      Map.get(store, key)
    end)
  end

  def get_all do
    Agent.get(__MODULE__.KV, fn store -> store end)
  end

  def delete(key) when is_binary(key) do
    Agent.update(__MODULE__.KV, fn store ->
      Map.delete(store, key)
    end)
  end

  def stop_kv do
    Agent.stop(__MODULE__.KV, :normal)
  end

  @doc """
  Create a simple named counter Agent (no module name used).
  Return the PID so the caller can pass it explicitly.
  """
  def start_anonymous_counter do
    Agent.start(fn -> 0 end)
  end

  def inc_anonymous(pid) do
    Agent.update(pid, fn count -> count + 1 end)
  end

  def get_anonymous(pid) do
    Agent.get(pid, fn count -> count end)
  end
end
```

### Exercise 4: Tasks — Concurrent Work

Create `lib/processes/tasks.ex`:

```elixir
defmodule Processes.Tasks do
  @moduledoc """
  Exercises: use Task for concurrent work.
  """

  @doc """
  Run a function concurrently using Task.async/1.
  Return the result.
  """
  def run_concurrently(fun) when is_function(fun, 0) do
    task = Task.async(fun)
    Task.await(task, 10_000)
  end

  @doc """
  Run two functions concurrently and return both results as a tuple.
  """
  def run_two_concurrently(fun1, fun2)
      when is_function(fun1, 0) and is_function(fun2, 0) do
    task1 = Task.async(fun1)
    task2 = Task.async(fun2)
    result1 = Task.await(task1, 10_000)
    result2 = Task.await(task2, 10_000)
    {result1, result2}
  end

  @doc """
  Run n tasks that each sleep for a random duration and return their pid.
  Collect all results.
  """
  def run_n_tasks(n) when n > 0 do
    tasks =
      Enum.map(1..n, fn i ->
        Task.async(fn ->
          Process.sleep(:rand.uniform(100))
          {:task, i, self()}
        end)
      end)

    Enum.map(tasks, fn task ->
      Task.await(task, 30_000)
    end)
  end

  @doc """
  Demonstrate that Task.async/1 catches exceptions in the child
  and re-raises them in the parent on await.
  """
  def task_error_demo do
    task = Task.async(fn ->
      raise "intentional task error"
    end)

    try do
      Task.await(task, 5000)
    rescue
      RuntimeError -> {:caught, "task error propagated"}
    end
  end

  @doc """
  Use Task.async_stream/3 to process a list concurrently with limited concurrency.
  Return the results in order.
  """
  def async_stream_map(list, concurrency \\ 4) when is_list(list) do
    Task.async_stream(list, fn item ->
      Process.sleep(:rand.uniform(50))
      item * 2
    end, max_concurrency: concurrency)
    |> Enum.to_list()
    |> Enum.map(fn {:ok, val} -> val end)
  end
end
```

### Exercise 5: A Concurrent Counter Service

Create `lib/processes/concurrent_counter.ex`:

```elixir
defmodule Processes.ConcurrentCounter do
  @moduledoc """
  A more complete exercise: a counter service running as a dedicated process.
  Clients send messages to increment, decrement, get, and reset.
  The server runs a receive loop.
  """

  @doc """
  Start the counter server.
  Return {:ok, pid}.
  """
  def start do
    spawn(fn -> counter_loop(0) end)
  end

  @doc """
  Start with a named process (using a registered name).
  """
  def start_named(name) do
    spawn(fn -> counter_loop(0) end)
    |> Process.register(name)
  end

  defp counter_loop(count) do
    receive do
      {:increment, from} ->
        new_count = count + 1
        send(from, {:ok, new_count})
        counter_loop(new_count)

      {:decrement, from} ->
        new_count = count - 1
        send(from, {:ok, new_count})
        counter_loop(new_count)

      {:get, from} ->
        send(from, {:ok, count})
        counter_loop(count)

      {:reset, from} ->
        send(from, {:ok, 0})
        counter_loop(0)

      :stop ->
        :ok
    end
  end

  @doc """
  Increment the named counter and wait for the response.
  Return {:ok, new_value}.
  """
  def increment(server_name) do
    send(server_name, {:increment, self()})
    receive do
      {:ok, value} -> {:ok, value}
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Decrement the named counter.
  """
  def decrement(server_name) do
    send(server_name, {:decrement, self()})
    receive do
      {:ok, value} -> {:ok, value}
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Get the current value of the named counter.
  """
  def get(server_name) do
    send(server_name, {:get, self()})
    receive do
      {:ok, value} -> {:ok, value}
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Reset the named counter to 0.
  """
  def reset(server_name) do
    send(server_name, {:reset, self()})
    receive do
      {:ok, 0} -> :ok
    after
      5000 -> {:error, :timeout}
    end
  end

  @doc """
  Stop the named counter server.
  """
  def stop(server_name) do
    send(server_name, :stop)
    :ok
  end
end
```

## Completion Checklist

- [ ] `spawn_greeting/0` returns a PID, and `receive_greeting/0` returns the greeting string.
- [ ] `spawn_and_collect/1` returns a list with `n` integers 1..n.
- [ ] `echo_server/0` returns a PID; `echo/2` sends a message and gets it echoed back.
- [ ] `stop_echo/1` stops the echo server.
- [ ] `spawn_linked_crash/0` demonstrates linked crash propagation (or catches it).
- [ ] `spawn_monitored/0` returns a monitor reference; `wait_down/2` returns `{:ok, reason}`.
- [ ] `linked_worker_demo/0` shows supervisor crash propagation.
- [ ] `trap_exit_demo/0` returns `{:trapped, reason}` when a linked process exits.
- [ ] `start_counter/0` starts an Agent; `increment/0` and `get_count/0` work correctly.
- [ ] `start_kv/0` starts a key-value Agent; `put/2`, `get/1`, `get_all/0`, `delete/1` all work.
- [ ] `start_anonymous_counter/0` returns a PID; `inc_anonymous/1` and `get_anonymous/1` work.
- [ ] `run_concurrently/1` runs a function concurrently and returns its result.
- [ ] `run_two_concurrently/2` returns both results as a tuple.
- [ ] `run_n_tasks/1` runs n concurrent tasks and returns their results.
- [ ] `task_error_demo/0` catches a task error and returns `{:caught, ...}`.
- [ ] `async_stream_map/2` processes a list with limited concurrency.
- [ ] `ConcurrentCounter.start/0` returns a PID; increment/decrement/get/reset all work.
- [ ] `ConcurrentCounter.start_named/1` registers the counter by name; operations work via name.
- [ ] `ConcurrentCounter.stop/1` stops the server.

## Hints

- `self()` returns the PID of the current process — use it to send messages back to yourself.
- Messages are stored in the process mailbox. `receive/1` pattern-matches the next message; unmatched messages stay in the mailbox.
- `receive ... after milliseconds -> ... end` adds a timeout to avoid blocking forever.
- Processes are isolated: a crash in one process does NOT crash another process unless they are linked.
- `spawn_link/1` creates a link — if one process crashes, the other receives an exit signal (and crashes by default unless it traps exits).
- `spawn_monitor/1` creates a monitor — the monitor receives `{:DOWN, ...}` messages when the monitored process exits, without crashing itself.
- `Process.flag(:trap_exit, true)` makes a process receive exit signals as messages instead of crashing.
- `Agent` is great for simple shared state. For more complex state machines or request/response protocols, use `GenServer` (Project 05).
- `Task.async/1` + `Task.await/2` is the simplest way to run concurrent work. `Task.async_stream/3` adds bounded concurrency.

---

*Processes and message passing are Elixir's concurrency primitives. Master them here and GenServer in the next project will feel natural — it's just a structured receive loop with OTP support.*
