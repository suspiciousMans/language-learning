require "optparse"
require_relative "store"
require_relative "task"

module Taskman
  class CLI
    def self.run(argv = ARGV)
      new(argv).run
    end

    def initialize(argv)
      @argv = argv.dup
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
          opts.arg_name "add <description>", "Add a new task"
          opts.arg_name "list", "List all tasks"
          opts.arg_name "done <id>", "Mark a task as done"
          opts.arg_name "delete <id>", "Delete a task"
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
        puts "-" * 70
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
          --data PATH      Use a custom data file (default: ~/.taskman_tasks.json)
          --status STATUS  Filter list by status (pending or done)
          -h, --help       Show this help message

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
      Integer(str)
    rescue ArgumentError
      $stderr.puts "Error: invalid ID '#{str}' for #{command}"
      exit 1
    end
  end
end
