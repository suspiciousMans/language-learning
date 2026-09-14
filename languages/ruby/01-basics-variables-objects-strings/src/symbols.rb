# frozen_string_literal: true

# Exercise 4: Symbols
# Run: ruby src/symbols.rb

# Symbols are immutable, lightweight identifiers
name_sym = :name
ruby_sym = :ruby

# Common use: hash keys
person = { name: "Alice", age: 30, city: "NYC" }
puts "Name: #{person[:name]}"
puts "Age: #{person[:age]}"

puts :name.class     # Symbol
puts "name".class    # String

# Symbols are unique
puts "Same object_id: #{:foo.object_id == :foo.object_id}"
puts "Different object_id: #{("foo".object_id == "foo".object_id)}"

# Convert between symbols and strings
puts :hello.to_s      # "hello"
puts "world".to_sym   # :world
