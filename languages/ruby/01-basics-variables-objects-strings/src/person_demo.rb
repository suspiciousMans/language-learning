# frozen_string_literal: true

# Exercise 7: Basic Object — a Person class
# Run: ruby src/person_demo.rb

class Person
  attr_reader :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def greet
    "Hello, I'm #{name} and I'm #{age} years old."
  end

  def birthday
    @age += 1
    "Happy birthday! Now #{age}."
  end

  def to_s
    "#{name} (#{age})"
  end
end

alice = Person.new("Alice", 30)
puts alice.greet
puts alice.birthday
puts "Now: #{alice}"
puts "Name: #{alice.name}, Age: #{alice.age}"
