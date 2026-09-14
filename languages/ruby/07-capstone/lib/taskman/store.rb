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

    def with_tasks
      tasks = load
      result = yield tasks
      save(tasks)
      result
    rescue => e
      $stderr.puts "Error: #{e.message}"
      exit 1
    end
  end
end
