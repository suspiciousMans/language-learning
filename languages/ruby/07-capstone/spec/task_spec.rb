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

    it "sets completed_at" do
      task.done!
      expect(task.completed_at).to be_a(String)
      expect(task.completed_at).to match(/\A\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/)
    end

    it "is idempotent" do
      task.done!
      first = task.completed_at
      task.done!
      expect(task.completed_at).to eq(first)
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
