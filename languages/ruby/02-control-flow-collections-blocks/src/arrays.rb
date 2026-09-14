# Array literal
fruits = ["apple", "banana", "cherry"]
puts "Fruits: #{fruits.inspect}"

# Array methods
puts "First: #{fruits.first}"
puts "Last: #{fruits.last}"
puts "Length: #{fruits.length}"
puts "Empty?: #{fruits.empty?}"
puts "Include 'banana'?: #{fruits.include?("banana")}"

# Push and pop
fruits.push("date")
puts "After push: #{fruits.inspect}"
last = fruits.pop
puts "Popped: #{last}, remaining: #{fruits.inspect}"

# Shift and unshift
first = fruits.shift
puts "Shifted: #{first}, remaining: #{fruits.inspect}"
fruits.unshift("avocado")
puts "After unshift: #{fruits.inspect}"

# Index and slice
numbers = [10, 20, 30, 40, 50]
puts "numbers[2]: #{numbers[2]}"
puts "numbers[1..3]: #{numbers[1..3].inspect}"
puts "numbers[1...3]: #{numbers[1...3].inspect}"
puts "numbers.values_at(0, 2, 4): #{numbers.values_at(0, 2, 4).inspect}"

# Concatenation and multiplication
a = [1, 2, 3]
b = [4, 5, 6]
puts "a + b: #{(a + b).inspect}"
puts "a * 2: #{(a * 2).inspect}"

# Flatten nested arrays
nested = [1, [2, 3], [4, [5, 6]]]
puts "Flattened: #{nested.flatten.inspect}"
puts "Flatten(1): #{nested.flatten(1).inspect}"

# Array creation
range_array = (1..5).to_a
puts "1..5 as array: #{range_array.inspect}"
puts "(1...5) as array: #{(1...5).to_a.inspect}"

# Join
words = ["hello", "world", "ruby"]
puts words.join(" ")
puts words.join("-")
puts words.join(", ")
