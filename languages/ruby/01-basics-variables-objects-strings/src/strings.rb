# frozen_string_literal: true

# Exercise 2: Strings
# Run: ruby src/strings.rb

first = "Alice"
last = "Smith"
full = "#{first} #{last}"

puts "Full name: #{full}"
puts "Upcase: #{full.upcase}"
puts "Downcase: #{full.downcase}"
puts "Length: #{full.length}"
puts "Empty?: #{"".empty?}"
puts "Include 'Ali'?: #{full.include?("Ali")}"

literal = 'Value: #{full}'
puts "Literal: #{literal}"

greeting = "Hello, " + full + "!"
puts greeting

sentence = "Ruby"
sentence << " is"
sentence << " awesome"
puts sentence

csv = "apple,banana,cherry"
fruits = csv.split(",")
puts "Fruits: #{fruits.inspect}"
puts "Back to CSV: #{fruits.join("-")}"

messy = "  hello  "
puts "Stripped: '#{messy.strip}'"
