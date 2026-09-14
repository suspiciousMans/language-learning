require_relative "spec_helper"
require "taskman/cli"
require "taskman/task"
require "taskman/store"
require "tmpdir"
require "fileutils"

RSpec.describe Taskman::CLI do
  let(:tmpdir) { Dir.mktmpdir }
  let(:data_path) { File.join(tmpdir, "tasks.json") }
  let(:argv) { [] }
  let(:cli) { described_class.new(argv) }

  after(:each) do
    FileUtils.rm_rf(tmpdir)
  end

  before(:each) do
    allow(cli).to receive(:store).and_return(Taskman::Store.new(data_path))
  end

  describe "#run" do
    it "shows help when no command is given" do
      expect($stdout).to receive(:puts).with(/taskman.*command-line task manager/)
      cli.run
    end

    it "shows help for unknown commands" do
      expect($stderr).to receive(:puts).with(/Unknown command: foo/)
      expect($stdout).to receive(:puts).with(/taskman.*command-line task manager/)
      cli.run
    end
  end

  describe "add command" do
    it "adds a task with a valid description" do
      expect($stdout).to receive(:puts).with("Added task #1: Buy milk")
      described_class.new(["add", "Buy milk"]).run
    end

    it "prints an error for missing description" do
      expect($stderr).to receive(:puts).with(/task description is required/)
      expect { described_class.new(["add"]).run }.to raise_error(SystemExit)
    end

    it "prints an error for empty description" do
      expect($stderr).to receive(:puts).with(/task description is required/)
      expect { described_class.new(["add", "   "]).run }.to raise_error(SystemExit)
    end
  end

  describe "list command" do
    it "prints 'No tasks.' when there are no tasks" do
      expect($stdout).to receive(:puts).with("No tasks.")
      described_class.new(["list"]).run
    end

    it "prints task rows for existing tasks" do
      File.write(data_path, JSON.pretty_generate([Taskman::Task.new(id: 1, description: "Buy milk").to_h]))

      output = capture_stdout { described_class.new(["list"]).run }
      expect(output).to include("Buy milk")
      expect(output).to include("1")
    end

    it "filters by --status pending" do
      File.write(data_path, JSON.pretty_generate([
        Taskman::Task.new(id: 1, description: "Pending task"),
        Taskman::Task.new(id: 2, description: "Done task", status: "done")
      ].map(&:to_h)))

      output = capture_stdout { described_class.new(["list", "--status", "pending"]).run }
      expect(output).to include("Pending task")
      expect(output).not_to include("Done task")
    end

    it "says 'No done tasks.' when filter matches nothing" do
      File.write(data_path, JSON.pretty_generate([Taskman::Task.new(id: 1, description: "Pending").to_h]))

      output = capture_stdout { described_class.new(["list", "--status", "done"]).run }
      expect(output).to include("No done tasks.")
    end
  end

  describe "done command" do
    it "marks a task as done" do
      File.write(data_path, JSON.pretty_generate([Taskman::Task.new(id: 1, description: "Buy milk").to_h]))

      output = capture_stdout { described_class.new(["done", "1"]).run }
      expect(output).to include("Marked task #1 as done")
    end

    it "says already done when task is already done" do
      File.write(data_path, JSON.pretty_generate([Taskman::Task.new(id: 1, description: "Buy milk", status: "done").to_h]))

      output = capture_stdout { described_class.new(["done", "1"]).run }
      expect(output).to include("already done")
    end

    it "prints an error for non-existent task" do
      expect($stderr).to receive(:puts).with(/task #99 not found/)
      expect { described_class.new(["done", "99"]).run }.to raise_error(SystemExit)
    end

    it "prints an error for invalid ID" do
      expect($stderr).to receive(:puts).with(/invalid ID/)
      expect { described_class.new(["done", "abc"]).run }.to raise_error(SystemExit)
    end
  end

  describe "delete command" do
    it "deletes a task" do
      File.write(data_path, JSON.pretty_generate([Taskman::Task.new(id: 1, description: "Buy milk").to_h]))

      output = capture_stdout { described_class.new(["delete", "1"]).run }
      expect(output).to include("Deleted task #1")
    end

    it "prints an error for non-existent task" do
      expect($stderr).to receive(:puts).with(/task #99 not found/)
      expect { described_class.new(["delete", "99"]).run }.to raise_error(SystemExit)
    end
  end

  def capture_stdout
    original = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original
  end
end
