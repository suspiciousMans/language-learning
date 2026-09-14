# frozen_string_literal: true

# Exercise 5: Here Documents and Formatting
# Run: ruby src/heredoc.rb

full = "Alice Smith"

letter = <<~LETTER
  Dear #{full},

  Welcome to Ruby! It's a language that feels like
  writing English — clean, expressive, and fun.

  Happy coding!
  LETTER

puts letter

poem = <<~POEM
  Roses are red
  Violets are blue
  Ruby is great
  And so are you
  POEM

puts poem

name = "Bob"
puts "%s, welcome!" % name
puts "%d + %d = %d" % [3, 4, 7]

puts format("Pi: %.4f", 3.14159265)
puts format("%05d", 42)
