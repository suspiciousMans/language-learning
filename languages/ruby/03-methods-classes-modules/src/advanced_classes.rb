# Exercise 5: Advanced Classes

# ---------- Singletons ----------
require 'singleton'

class Configuration
  include Singleton

  attr_accessor :app_name, :version, :debug

  def initialize
    @app_name = "MyApp"
    @version = "1.0.0"
    @debug = false
  end

  def self.config
    instance
  end
end

# Access the singleton
config = Configuration.config
puts "App: #{config.app_name} v#{config.version}"
config.debug = true
puts "Debug: #{Configuration.instance.debug}"

# Another singleton via class methods (alternative pattern)
class Logger
  @@instance = new

  private_class_method :new

  def self.instance
    @@instance
  end

  def log(msg)
    puts "[LOG] #{Time.now.iso8601}: #{msg}"
  end
end

Logger.instance.log("Application started")
Logger.instance.log("Processing request")

# ---------- Class methods vs instance methods ----------
class MyClass
  # Class method — called on the class itself
  def self.class_method
    "I am a class method"
  end

  # Another way to define class methods
  class << self
    def another_class_method
      "I am also a class method"
    end
  end

  # Instance method — called on instances
  def instance_method
    "I am an instance method"
  end
end

puts MyClass.class_method
puts MyClass.another_class_method
puts MyClass.new.instance_method

# ---------- Method missing and ghost methods ----------
class Flexible
  def method_missing(name, *args, &block)
    if name.to_s.start_with?("get_")
      attr_name = name.to_s[4..].to_sym
      @data[attr_name]
    else
      super
    end
  end

  def respond_to_missing?(name, include_private = false)
    name.to_s.start_with?("get_") || super
  end

  def initialize
    @data = { name: "Flexible", version: 1 }
  end
end

f = Flexible.new
puts f.get_name
puts f.get_version
# puts f.get_missing  # nil — no such key

# ---------- Struct vs OpenStruct vs Data ----------
# Struct — fixed set of attributes, lightweight
Color = Struct.new(:red, :green, :blue)
c = Color.new(255, 128, 0)
puts "Color: r=#{c.red} g=#{c.green} b=#{c.blue}"

# Struct with keyword_init: true (Ruby 2.5+)
Point = Struct.new(:x, :y, keyword_init: true)
p = Point.new(x: 10, y: 20)
puts "Point: #{p.x}, #{p.y}"

# ---------- Vaccine pattern: freeze after initialization ----------
class ImmutablePerson
  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age = age
    freeze
  end
end

person = ImmutablePerson.new("Eve", 28)
puts "#{person.name}, #{person.age}"
# person.name = "Eve2"  # FrozenError

# ---------- true, false, nil are objects too ----------
puts true.class     # TrueClass
puts false.class    # FalseClass
puts nil.class      # NilClass
puts nil.nil?       # true
puts 0.nil?         # false — only nil and false are falsy
