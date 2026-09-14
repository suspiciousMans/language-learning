# frozen_string_literal: true

# Exercise 3: Numbers and Math
# Run: ruby src/numbers.rb

puts "10 + 5 = #{10 + 5}"
puts "10 - 5 = #{10 - 5}"
puts "10 * 5 = #{10 * 5}"
puts "10 / 5 = #{10 / 5}"
puts "10 % 3 = #{10 % 3}"
puts "2 ** 8 = #{2 ** 8}"

puts "10 / 3 = #{10 / 3}"
puts "10 / 3.0 = #{10 / 3.0}"
puts "10.fdiv(3) = #{10.fdiv(3)}"

puts "54.to_s = #{54.to_s}"
puts "54.to_f = #{54.to_f}"
puts "3.14.to_i = #{3.14.to_i}"
puts "3.14.round = #{3.14.round}"
puts "3.14.ceil = #{3.14.ceil}"
puts "3.14.floor = #{3.14.floor}"

puts "Random int 1..10: #{rand(1..10)}"
puts "Random float: #{rand}"

big = 2 ** 100
puts "2^100 = #{big}"
