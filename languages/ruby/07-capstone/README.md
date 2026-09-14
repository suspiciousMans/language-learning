# Project 07: Capstone — Build a CLI Application — Ruby

**Difficulty:** intermediate-advanced (capstone)  
**Prerequisites:** Projects 03–06 (Methods and Classes, Error Handling, Testing, Concurrency)

## Goals

- Design and build a complete command-line application from scratch
- Apply everything learned so far: classes, modules, error handling, testing, and concurrency
- Structure a non-trivial Ruby program with multiple files and clear responsibilities
- Use Ruby's standard library for file I/O, argument parsing, and terminal output
- Write tests for the core logic and document the application for users

## Concepts

- **CLI application structure** — entry point (`bin/` or `main.rb`), library code (`lib/`), tests (`spec/` or `test/`), and configuration
- **Option parsing** — `OptionParser` from Ruby's standard library for parsing command-line flags and arguments
- **File I/O for data persistence** — reading and writing structured data files (JSON, YAML, or CSV)
- **Separation of concerns** — model objects for data, service objects for business logic, and a thin CLI layer for user interaction
- **Error handling in a CLI** — graceful error messages, exit codes, and avoiding stack traces for expected failures
- **Formatting terminal output** — using string formatting, alignment, and optional color for readable output
- **Testing a CLI application** — unit-testing the business logic separately from the CLI layer; integration-testing the command-line interface with `Open3` or `Kernel#system`
- **Documentation** — a `README.md` with installation, usage examples, and a command reference

## The Project: `taskman` — A Simple Task Manager CLI

Build a command-line task manager called `taskman` that lets users create, list, complete, and delete tasks, with persistent storage in a JSON file. The application should be structured as a small but real Ruby project.

### Required Features

1. **Add a task** — `taskman add "Buy groceries"` creates a new task with a description, a unique ID, a creation timestamp, and a `pending` status
2. **List tasks** — `taskman list` shows all tasks with their ID, description, status, and creation date; support a `--status` flag to filter by `pending` or `done`
3. **Complete a task** — `taskman done <id>` marks a task as completed with a completion timestamp
4. **Delete a task** — `taskman delete <id>` removes a task permanently
5. **Persistence** — tasks are saved to a JSON file (default: `~/.taskman_tasks.json`); the file is created if it doesn't exist
6. **Error handling** — clear error messages for: missing description on `add`, invalid or non-existent ID on `done`/`delete`, file corruption or permission errors on load/save
7. **Help** — `taskman --help` prints usage information and exits

### Suggested Structure

```
taskman/
├── bin/
│   └── taskman          # executable entry point
├── lib/
│   ├── taskman.rb       # main entry point for the library
│   ├── taskman/
│   │   ├── version.rb   # VERSION constant
│   │   ├── task.rb      # Task model
│   │   ├── store.rb     # JSON file persistence
│   │   ├── cli.rb       # command parsing and dispatch
│   │   └── commands/
│   │       ├── base.rb  # base command class (optional)
│   │       ├── add.rb
│   │       ├── list.rb
│   │       ├── done.rb
│   │       └── delete.rb
│   end
├── spec/
│   ├── spec_helper.rb
│   ├── task_spec.rb
│   ├── store_spec.rb
│   └── cli_spec.rb
├── Gemfile
└── README.md
```

You don't need to create all of these files — a simpler layout with fewer, larger files is fine too. The goals are: clear separation between the data model, the persistence layer, and the CLI, plus tests for the non-trivial logic.

### Exercise 1: Design the Task Model

Create `lib/taskman/task.rb` (or put it directly in `lib/taskman.rb` if you prefer a simpler layout):

```ruby
require "json"
require "time"

module Taskman
  class Task
    attr_reader :id, :description, :status, :created_at, :completed_at

    def initialize(id:, description:, status: "pending", created_at: nil, completed_at: nil)
      @id = id
      @description = description
      @status = status
      @created_at = created_at || Time.now.utc.iso8601
      @completed_at = completed_at
    end

    def done!
      @status = "done"
      @completed_at = Time.now.utc.iso8601
    end

    def pending?
      @status == "pending"
    end

    def done?
      @status == "done"
    end

    def to_h
      {
        "id" => @id,
        "description" => @description,
        "status" => @status,
        "created_at" => @created_at,
        "completed_at" => @completed_at
      }
    end

    def to_json(*args)
      to_h.to_json(*args)
    end

    def self.from_h(hash)
      new(
        id: hash["id"],
        description: hash["description"],
        status: hash["status"] || "pending",
        created_at: hash["created_at"],
        completed_at: hash["completed_at"]
      )
    end

    def self.from_json(json_string)
      from_h(JSON.parse(json_string))
    end
  end
end
```

**Run:** `ruby -I lib -r taskman/task -e 't = Taskman::Task.new(id: 1, description: "Test"); puts t.to_json'`

**Expected:** a JSON string with the task data.

### Exercise 2: Build the Persistence Layer (Store)

Create `lib/taskman/store.rb`:

```ruby
require "json"
require "fileutils"
require_relative "task"

module Taskman
  class Store
    DEFAULT_PATH = File.expand_path("~/.taskman_tasks.json")

    def initialize(path = nil)
      @path = path || DEFAULT_PATH
      @mutex = Mutex.new
    end

    def load
      return [] unless File.exist?(@path)
      begin
        JSON.parse(File.read(@path)).map { |h| Task.from_h(h) }
      rescue JSON::ParserError => e
        $stderr.puts "Warning: could not parse task file, starting fresh: #{e.message}"
        []
      end
    end

    def save(tasks)
      FileUtils.mkdir_p(File.dirname(@path))
      tmp_path = @path + ".tmp"
      File.write(tmp_path, JSON.pretty_generate(tasks.map(&:to_h)))
      File.rename(tmp_path, @path)
    rescue SystemCallError => e
      raise "Failed to save tasks: #{e.message}"
    end

    # Marshaled access — load, modify, save atomically
    def with_tasks
      tasks = load
      result = yield tasks
      save(tasks)
      result
    rescue => e
      $stderr.puts "Error: #{e.message}"
      exit 1
    end

    private

    def synchronize
      @mutex.synchronize { yield }
    end
  end
end
```

**Notes:**
- Uses a temp file + `File.rename` for atomic writes (avoids corrupting the data file if the write is interrupted)
- Handles corrupted JSON gracefully by starting fresh with a warning
- Creates parent directories if they don't exist

**Run:** `ruby -I lib -e 's = Taskman::Store.new("/tmp/test_store.json"); s.with_tasks { |tasks| tasks << Taskman::Task.new(id: 1, description: "Hello"); puts "Saved #{tasks.size} tasks" }; puts "Loaded: #{s.load.size} tasks"'`

**Expected:**
```
Saved 1 tasks
Loaded: 1 tasks
```

### Exercise 3: Build the CLI Layer

Create `lib/taskman/cli.rb` (or put it in `lib/taskman.rb`):

```ruby
require "optparse"
require_relative "store"
require_relative "task"

module Taskman
  class CLI
    def self.run(argv = ARGV)
      new(argv).run
    end

    def initialize(argv)
      @argv = argv
      @store = Store.new
    end

    def run
      parse_options
      command = @argv.shift
      case command
      when "add"   then cmd_add
      when "list"  then cmd_list
      when "done"  then cmd_done
      when "delete" then cmd_delete
      when nil     then cmd_help
      else
        $stderr.puts "Unknown command: #{command}"
        cmd_help
      end
    end

    private

    def parse_options
      @options = {}
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: taskman <command> [options]"
        opts.separator ""
        opts.separator "Commands:"
        opts.on_head do
          opts.arg_name "add LIST", "Add a new task"
          opts.arg_name "list", "List all tasks"
          opts.arg_name "done ID", "Mark a task as done"
          opts.arg_name "delete ID", "Delete a task"
        end
        opts.separator ""
        opts.separator "Options:"
        opts.on("-h", "--help", "Show this help message") do
          puts opts
          exit
        end
        opts.on("--data PATH", "Path to task data file") do |path|
          @store = Store.new(path)
        end
        opts.on("--status STATUS", "Filter by status (pending/done)") do |status|
          @options[:status_filter] = status
        end
      end
      parser.parse!(@argv)
    rescue OptionParser::InvalidOption, OptionParser::MissingArgument => e
      $stderr.puts "Error: #{e.message}"
      puts ""
      puts parser
      exit 1
    end

    def cmd_add
      desc = @argv.shift
      if desc.nil? || desc.strip.empty?
        $stderr.puts "Error: task description is required"
        $stderr.puts "Usage: taskman add <description>"
        exit 1
      end

      @store.with_tasks do |tasks|
        id = (tasks.map(&:id).max || 0) + 1
        task = Task.new(id: id, description: desc.strip)
        tasks << task
        puts "Added task ##{id}: #{task.description}"
      end
    end

    def cmd_list
      status_filter = @options[:status_filter]
      @store.with_tasks do |tasks|
        if tasks.empty?
          puts "No tasks."
          return
        end
        filtered = status_filter ? tasks.select { |t| t.status == status_filter } : tasks
        if filtered.empty?
          puts "No #{status_filter} tasks."
          return
        end
        puts ""
        puts "%-5s  %-12s  %-10s  %s" % ["ID", "STATUS", "CREATED", "DESCRIPTION"]
        puts "-" * 60
        filtered.each do |t|
          created = t.created_at ? t.created_at[0..9] : "-"
          puts "%-5s  %-12s  %-10s  %s" % [t.id, t.status, created, t.description]
        end
        puts ""
        puts "Total: #{filtered.size} task(s)"
      end
    end

    def cmd_done
      id_str = @argv.shift
      id = parse_id(id_str, "done")
      @store.with_tasks do |tasks|
        task = tasks.find { |t| t.id == id }
        unless task
          $stderr.puts "Error: task ##{id} not found"
          exit 1
        end
        if task.done?
          puts "Task ##{id} is already done"
          return
        end
        task.done!
        puts "Marked task ##{id} as done: #{task.description}"
      end
    end

    def cmd_delete
      id_str = @argv.shift
      id = parse_id(id_str, "delete")
      @store.with_tasks do |tasks|
        task = tasks.find { |t| t.id == id }
        unless task
          $stderr.puts "Error: task ##{id} not found"
          exit 1
        end
        tasks.delete(task)
        puts "Deleted task ##{id}: #{task.description}"
      end
    end

    def cmd_help
      puts <<~HELP
        taskman — a simple command-line task manager

        Usage:
          taskman add <description>     Add a new task
          taskman list                  List all tasks
          taskman done <id>            Mark a task as done
          taskman delete <id>          Delete a task

        Options:
          --data PATH    Use a custom data file (default: ~/.taskman_tasks.json)
          --status STATUS  Filter list by status (pending or done)
          -h, --help     Show this help message

        Examples:
          taskman add "Buy groceries"
          taskman list
          taskman list --status pending
          taskman done 1
          taskman delete 1
      HELP
    end

    def parse_id(str, command)
      raise ArgumentError, "ID is required for #{command}" unless str
      Integer(str) rescue nil
    end
  end
end
```

**Run:** `ruby -I lib -r taskman/cli -e 'Taskman::CLI.run(ARGV)' add "Buy milk"`

**Expected:**
```
Added task #1: Buy milk
```

Or run the full CLI:
```bash
ruby -I lib lib/taskman/cli.rb add "Buy milk"
ruby -I lib lib/taskman/cli.rb list
ruby -I lib lib/taskman/cli.rb done 1
ruby -I lib lib/taskman/cli.rb list
ruby -I lib lib/taskman/cli.rb delete 1
```

### Exercise 4: Write the Entry Point and Package It

Create `bin/taskman`:

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "taskman/cli"

exit(Taskman::CLI.run(ARGV))
```

Make it executable: `chmod +x bin/taskman`

Then run it:
```bash
./bin/taskman add "Learn Ruby concurrency"
./bin/taskman add "Write tests for taskman"
./bin/taskman list
./bin/taskman done 1
./bin/taskman list --status pending
./bin/taskman delete 2
./bin/taskman list
```

### Exercise 5: Write Tests

Create `spec/spec_helper.rb`:

```ruby
require "rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
```

Create `spec/task_spec.rb`:

```ruby
require_relative "spec_helper"
require "taskman/task"

RSpec.describe Taskman::Task do
  subject(:task) { described_class.new(id: 1, description: "Buy groceries") }

  describe "#initialize" do
    it "sets the id and description" do
      expect(task.id).to eq(1)
      expect(task.description).to eq("Buy groceries")
    end

    it "defaults status to pending" do
      expect(task.status).to eq("pending")
    end

    it "sets created_at to now by default" do
      created = task.created_at
      expect(created).to be_a(String)
      expect(created).to match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/)
    end

    it "allows custom created_at" do
      t = described_class.new(id: 2, description: "X", created_at: "2024-01-01T00:00:00Z")
      expect(t.created_at).to eq("2024-01-01T00:00:00Z")
    end

    it "starts with no completed_at" do
      expect(task.completed_at).to be_nil
    end
  end

  describe "#done!" do
    it "sets status to done" do
      task.done!
      expect(task.status).to eq("done")
    end

    it "sets completed_at to now" do
      Timecop.freeze do
        task.done!
        expect(task.completed_at).to eq(Time.now.utc.iso8601)
      end
    end

    it "is idempotent — calling done! again doesn't change anything" do
      task.done!
      completed_at = task.completed_at
      task.done!
      expect(task.completed_at).to eq(completed_at)
    end
  end

  describe "#pending?" do
    it "returns true when pending" do
      expect(task.pending?).to be true
    end

    it "returns false when done" do
      task.done!
      expect(task.pending?).to be false
    end
  end

  describe "#done?" do
    it "returns false when pending" do
      expect(task.done?).to be false
    end

    it "returns true when done" do
      task.done!
      expect(task.done?).to be true
    end
  end

  describe "#to_h" do
    it "serializes all fields" do
      task.done!
      hash = task.to_h
      expect(hash).to include("id" => 1, "description" => "Buy groceries", "status" => "done")
      expect(hash["created_at"]).to be_a(String)
      expect(hash["completed_at"]).to be_a(String)
    end
  end

  describe ".from_h" do
    it "reconstructs a Task from a hash" do
      hash = {
        "id" => 42,
        "description" => "Test",
        "status" => "done",
        "created_at" => "2024-06-01T12:00:00Z",
        "completed_at" => "2024-06-02T12:00:00Z"
      }
      t = described_class.from_h(hash)
      expect(t.id).to eq(42)
      expect(t.description).to eq("Test")
      expect(t.status).to eq("done")
      expect(t.created_at).to eq("2024-06-01T12:00:00Z")
      expect(t.completed_at).to eq("2024-06-02T12:00:00Z")
    end

    it "handles missing optional fields" do
      t = described_class.from_h("id" => 1, "description" => "X")
      expect(t.status).to eq("pending")
      expect(t.created_at).to be_nil
      expect(t.completed_at).to be_nil
    end
  end

  describe ".from_json" do
    it "parses JSON and creates a Task" do
      json = JSON.generate({
        "id" => 1,
        "description" => "From JSON",
        "status" => "pending",
        "created_at" => "2024-01-01T00:00:00Z",
        "completed_at" => nil
      })
      t = described_class.from_json(json)
      expect(t.id).to eq(1)
      expect(t.description).to eq("From JSON")
    end
  end

  describe "#to_json" do
    it "produces valid JSON" do
      json = task.to_json
      parsed = JSON.parse(json)
      expect(parsed["id"]).to eq(1)
      expect(parsed["description"]).to eq("Buy groceries")
    end
  end
end
```

For the store tests (`spec/store_spec.rb`), test:
- `load` returns an empty array for a non-existent file
- `load` returns parsed tasks for a valid JSON file
- `load` returns an empty array with a warning for corrupted JSON
- `save` writes valid JSON to the file
- `save` uses atomic write (temp file + rename)
- `with_tasks` yields tasks and saves afterward

For the CLI tests (`spec/cli_spec.rb`), test:
- `add` with a valid description creates a task and prints a confirmation
- `add` with no description prints an error and exits
- `list` with no tasks prints "No tasks."
- `list` prints formatted task rows
- `list --status pending` filters correctly
- `done` with a valid ID marks the task done
- `done` with a non-existent ID prints an error
- `delete` with a valid ID removes the task
- `delete` with a non-existent ID prints an error
- unknown commands print an error and show help

### Exercise 6: Write the README

Create a `README.md` for the project with:
- A short description of what `taskman` does
- Installation instructions (clone, `bundle install`, optionally `gem install`)
- Usage examples for each command
- A command reference table
- Configuration (the `--data` flag and the default path)
- A note on the project structure

## Completion Checklist

- [ ] You have a working `taskman` CLI that supports `add`, `list`, `done`, `delete`, and `--help`
- [ ] Tasks persist in a JSON file between runs
- [ ] The CLI handles errors gracefully (no stack traces for expected failures)
- [ ] `list` supports `--status` filtering
- [ ] `list` output is formatted in aligned columns
- [ ] The `Store` class uses atomic writes (temp file + rename)
- [ ] The `Store` class handles corrupted JSON gracefully
- [ ] You have tests for the `Task` model (at least the happy path and edge cases)
- [ ] You have tests for the `Store` class (load/save/atomic write)
- [ ] You have tests for the `CLI` class (each command)
- [ ] You have a `README.md` with usage examples and a command reference
- [ ] You have a `Gemfile` with `rspec` as a development dependency
- [ ] The entry point (`bin/taskman`) is executable and works

## Hints

- Use `OptionParser` from Ruby's standard library for CLI argument parsing — it handles `--help`, `-h`, and option parsing out of the box
- For atomic file writes, write to a temp file first, then `File.rename` — rename is atomic on POSIX systems, so the data file is never in a partially-written state
- When testing the CLI, consider testing the business logic (Task, Store) separately from the CLI layer. The CLI layer is harder to test because it reads from ARGV and writes to STDOUT/STDERR — you can use `Open3.capture3` or temporarily redirect `$stdout`/`$stderr` for integration tests
- For the task ID, a simple approach is `tasks.map(&:id).max + 1` — not safe under concurrent access, but fine for a single-user CLI. If you want to be more robust, use a UUID or a timestamp-based ID
- Keep the CLI layer thin — parse arguments, call the store, print results. Put all business logic in the model and store classes so it's easy to test
- Use `exit(status)` to return meaningful exit codes: 0 for success, 1 for user errors (bad arguments, not found), and let exceptions propagate for unexpected errors (which Ruby turns into a non-zero exit with a stack trace — that's fine for truly unexpected errors)
- For formatted output, `printf`-style formatting with `"%-5s  %-12s  ..."` gives clean aligned columns; alternatively, use `String#%` with an array
- The `frozen_string_literal: true` magic comment at the top of each file tells Ruby to freeze all string literals — this is a good habit for performance and immutability, and many Ruby projects use it
- Use `$stderr.puts` for error messages so they don't mix with the normal output (important if someone pipes the output to another command)
