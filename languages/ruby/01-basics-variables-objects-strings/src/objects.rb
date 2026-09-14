# frozen_string_literal: true

# Exercise 6: Objects and Message Passing
# Ruby is purely object-oriented — everything is an object.
# Run: ruby src/objects.rb

# Even numbers are objects
puts 42.class
puts 42.methods.sort.take(10).join(", ")

# Everything responds to methods
str = "hello"
puts str.class
puts str.upcase
puts str.methods.select { |m| m.to_s.include?("case") }.join(", ")

# Objects have identity
a = "test"
b = "test"
puts "Same object? #{a.equal?(b)}"     # false (different objects)
puts "Same value? #{a == b}"            # true (same content)
puts "Same object_id? #{a.object_id == b.object_id}" # false

# Freeze an object to make it immutable
immutable = "cannot change".freeze
puts "Frozen?: #{immutable.frozen?}"
# immutable << "!" would raise FrozenError

# nil is also an object
puts nil.class
puts nil.nil?
puts nil.to_s          # "" (empty string)
puts nil.inspect       # "nil"
