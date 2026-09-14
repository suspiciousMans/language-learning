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
