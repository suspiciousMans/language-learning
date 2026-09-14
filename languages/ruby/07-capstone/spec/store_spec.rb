require_relative "spec_helper"
require "taskman/store"
require "taskman/task"
require "tmpdir"
require "fileutils"

RSpec.describe Taskman::Store do
  let(:tmpdir) { Dir.mktmpdir }
  let(:path) { File.join(tmpdir, "tasks.json") }
  let(:store) { described_class.new(path) }

  after(:each) do
    FileUtils.rm_rf(tmpdir)
  end

  describe "#load" do
    it "returns an empty array for a non-existent file" do
      expect(store.load).to eq([])
    end

    it "returns parsed tasks for a valid JSON file" do
      tasks = [
        Taskman::Task.new(id: 1, description: "Task 1"),
        Taskman::Task.new(id: 2, description: "Task 2", status: "done")
      ]
      File.write(path, JSON.pretty_generate(tasks.map(&:to_h)))

      loaded = store.load
      expect(loaded.size).to eq(2)
      expect(loaded[0].id).to eq(1)
      expect(loaded[0].description).to eq("Task 1")
      expect(loaded[1].status).to eq("done")
    end

    it "returns an empty array with a warning for corrupted JSON" do
      File.write(path, "{this is not json")

      expect($stderr).to receive(:puts).with(/could not parse task file/)
      expect(store.load).to eq([])
    end
  end

  describe "#save" do
    it "writes valid JSON to the file" do
      tasks = [Taskman::Task.new(id: 1, description: "Test")]
      store.save(tasks)

      expect(File.exist?(path)).to be true
      parsed = JSON.parse(File.read(path))
      expect(parsed.size).to eq(1)
      expect(parsed[0]["description"]).to eq("Test")
    end

    it "creates parent directories if they don't exist" do
      deep_path = File.join(tmpdir, "a", "b", "c", "tasks.json")
      store = described_class.new(deep_path)
      tasks = [Taskman::Task.new(id: 1, description: "Deep")]
      store.save(tasks)

      expect(File.exist?(deep_path)).to be true
    end

    it "uses JSON.pretty_generate for human-readable output" do
      tasks = [Taskman::Task.new(id: 1, description: "Test")]
      store.save(tasks)

      content = File.read(path)
      expect(content).to include("description")
      expect(content).to include("\n")
    end
  end

  describe "#with_tasks" do
    it "yields the loaded tasks" do
      File.write(path, JSON.pretty_generate([Taskman::Task.new(id: 1, description: "Existing").to_h]))

      store.with_tasks do |tasks|
        expect(tasks.size).to eq(1)
        expect(tasks[0].description).to eq("Existing")
      end
    end

    it "saves tasks after the block" do
      store.with_tasks do |tasks|
        tasks << Taskman::Task.new(id: 1, description: "New")
      end

      loaded = store.load
      expect(loaded.size).to eq(1)
      expect(loaded[0].description).to eq("New")
    end

    it "handles exceptions from the block gracefully" do
      expect($stderr).to receive(:puts).with(/Error/)
      expect { store.with_tasks { raise "something went wrong" } }.to raise_error(SystemExit)
    end
  end
end
