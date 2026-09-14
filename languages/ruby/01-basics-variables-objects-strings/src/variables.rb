# frozen_string_literal: true

# Exercise 1: Variables and Types
# Run: ruby src/variables.rb

name = "Ruby"
year = 1995
version = 3.3
is_fun = true
nothing = nil

Language = "Ruby"

puts "Language: #{Language}"
puts "Name: #{name}, Year: #{year}"
puts "Version: #{version}"
puts "Is fun: #{is_fun}"
puts "Nothing: #{nothing.inspect}"

name = "Ruby on Rails"
puts "After reassignment: #{name}"
