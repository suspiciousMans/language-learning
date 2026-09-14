# Blocks are anonymous chunks of code passed to methods
# Two syntaxes: do...end (multi-line) and {...} (single-line)

# each — iterate with a block
(1..5).each do |n|
  puts "Number: #{n}"
end

# curly brace style (prefer for single-line)
["apple", "banana", "cherry"].each { |fruit| puts "I like #{fruit}" }

# with index
fruits = ["apple", "banana", "cherry"]
fruits.each_with_index do |fruit, i|
  puts "  #{i}: #{fruit}"
end

# select — filter with a block
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
evens = numbers.select { |n| n.even? }
puts "Evens: #{evens.inspect}"

odds = numbers.reject { |n| n.even? }
puts "Odds: #{odds.inspect}"

# map/collect — transform
doubled = numbers.map { |n| n * 2 }
puts "Doubled: #{doubled.inspect}"

names = ["alice", "bob", "carol"]
capitalized = names.map(&:capitalize)  # &:method — shorthand for { |x| x.method }
puts "Capitalized: #{capitalized.inspect}"

# reduce/inject — accumulate
sum = numbers.reduce(0) { |acc, n| acc + n }
puts "Sum: #{sum}"

product = numbers.reduce(1) { |acc, n| acc * n }
puts "Product: #{product}"

# reduce without initial value (uses first element)
max = numbers.reduce { |acc, n| n > acc ? n : acc }
puts "Max: #{max}"

# chaining
result = numbers.select(&:odd?).map { |n| n ** 2 }.sort
puts "Odd squares sorted: #{result.inspect}"

# find/detect — first match
first_gt_5 = numbers.find { |n| n > 5 }
puts "First > 5: #{first_gt_5}"

# any?/all?
puts "Any even?: #{numbers.any?(&:even?)}"
puts "All positive?: #{numbers.all? { |n| n > 0 }}"
puts "None > 100?: #{numbers.none? { |n| n > 100 }}"

# block with multiple statements
total = 0
[10, 20, 30].each do |n|
  square = n * n
  puts "  #{n}² = #{square}"
  total += square
end
puts "Total of squares: #{total}"
