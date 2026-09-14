# Project 02: Control Flow, Collections, and Blocks — Ruby

**Difficulty:** beginner  
**Prerequisites:** Project 01 (Basics — Variables, Objects, Strings)

## Goals

- Master Ruby's control flow constructs: conditionals, loops, case statements
- Work with Ruby's core collections: Arrays, Hashes, Ranges
- Understand Ruby's block/proc/lambda system — the foundation of Ruby's expressiveness
- Practice iterating, filtering, and transforming collections

## Concepts

- **`if`/`unless`/`elsif`** — conditionals; `unless` is the inverse of `if`
- **`case`/`when`** — pattern matching on values; uses `===` under the hood
- **`while`/`until`/`for`** — loops; `until` is `while`'s inverse
- **`each`** — the essential iterator; takes a block
- **Blocks** — anonymous chunks of code passed to methods; `{...}` or `do...end`
- **Arrays** — ordered, integer-indexed collections; `[]` literal, `.new`, `.push`, `.pop`
- **Hashes** — key-value dictionaries; `{key: value}` syntax, symbol keys common
- **Ranges** — `1..10` (inclusive) or `1...10` (exclusive); can be used in `case` statements
- **Enumerable** — the module that gives collections `.map`, `.filter`, `.reduce`, etc.
- **Block parameters** — `|x|` in `array.each { |x| ... }`
- **Splat (`*`)** — collects or expands arguments: `*args`, `def method(*args)`
- **`collect` / `map`** — transform each element, return new array
- **`select` / `filter`** — keep elements matching a condition
- **`reject`** — remove elements matching a condition
- **`reduce` / `inject`** — accumulate a result across elements
- **`find` / `detect`** — return first element matching a condition
- **`any?`/`all?`** — predicate checks across collection

## Exercises

### Exercise 1: Conditionals

Create `src/conditionals.rb`:

```ruby
# if/elsif/else
score = 85

if score >= 90
  grade = "A"
elsif score >= 80
  grade = "B"
elsif score >= 70
  grade = "C"
else
  grade = "F"
end

puts "Score: #{score} → Grade: #{grade}"

# unless — runs when condition is false
logged_in = false
unless logged_in
  puts "Please log in"
end

# inline if/unless
puts "Access granted" if logged_in
puts "Access denied" unless logged_in

# case/when — uses === for matching
day = 3
day_name = case day
  when 1 then "Monday"
  when 2 then "Tuesday"
  when 3 then "Wednesday"
  when 4 then "Thursday"
  when 5 then "Friday"
  when 6, 7 then "Weekend"
  else "Unknown"
end

puts "Day #{day} is #{day_name}"

# case with range
age = 25
status = case age
  when 0..12 then "child"
  when 13..17 then "teen"
  when 18..64 then "adult"
  else "senior"
end

puts "Age #{age}: #{status}"

# case with regex
command = "git commit -m 'fix'"
action = case command
  when /^git commit/ then "commit"
  when /^git push/ then "push"
  when /^git pull/ then "pull"
  else "unknown git command"
end

puts "Command '#{command}' → #{action}"
```

Run: `ruby src/conditionals.rb`

**Expected output:**
```
Score: 85 → Grade: B
Please log in
Day 3 is Wednesday
Age 25: adult
Command 'git commit -m 'fix'' → commit
```

### Exercise 2: Arrays

Create `src/arrays.rb`:

```ruby
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
```

Run: `ruby src/arrays.rb`

**Expected output (abridged):**
```
Fruits: ["apple", "banana", "cherry"]
First: apple
Last: cherry
Length: 3
Empty?: false
Include 'banana'?: true
After push: ["apple", "banana", "cherry", "date"]
Popped: date, remaining: ["apple", "banana", "cherry"]
Shifted: apple, remaining: ["banana", "cherry"]
After unshift: ["avocado", "banana", "cherry"]
numbers[2]: 30
numbers[1..3]: [20, 30, 40]
numbers[1...3]: [20, 30]
numbers.values_at(0, 2, 4): [10, 30, 50]
a + b: [1, 2, 3, 4, 5, 6]
a * 2: [1, 2, 3, 1, 2, 3]
Flattened: [1, 2, 3, 4, 5, 6]
1..5 as array: [1, 2, 3, 4, 5]
(1...5) as array: [1, 2, 3, 4]
hello world ruby
hello-world-ruby
hello, world, ruby
```

### Exercise 3: Hashes

Create `src/hashes.rb`:

```ruby
# Hash literal — symbol keys (common style)
person = { name: "Alice", age: 30, city: "NYC", active: true }
puts "Person: #{person.inspect}"
puts "Name: #{person[:name]}"
puts "Age: #{person[:age]}"

# Accessing missing key
puts "Country: #{person[:country].inspect}"  # nil
puts "Country (default): #{person.fetch(:country, "Unknown")}"

# Adding/updating
person[:email] = "alice@example.com"
person[:age] = 31
puts "Updated: #{person.inspect}"

# Hash methods
puts "Keys: #{person.keys.inspect}"
puts "Values: #{person.values.inspect}"
puts "Length: #{person.length}"
puts "Has key :name?: #{person.key?(:name)}"
puts "Has value 'NYC'?: #{person.value?("NYC")}"

# Delete
person.delete(:active)
puts "After delete active: #{person.inspect}"

# Default value
defaults = Hash.new("N/A")
defaults[:name] = "Bob"
puts "defaults[:name]: #{defaults[:name]}"
puts "defaults[:missing]: #{defaults[:missing]}"

# Symbol vs string keys
mixed = { "name" => "Carol", :age => 28 }
puts "String key: #{mixed["name"]}"
puts "Symbol key: #{mixed[:age]}"
# Note: mixed[:name] would be nil — key types must match!

# Iterating a hash
person.each do |key, value|
  puts "  #{key}: #{value}"
end

# transform_keys / transform_values (Ruby 2.5+)
puts person.transform_keys { |k| k.to_s.upcase }.inspect
puts person.transform_values { |v| v.is_a?(Integer) ? v * 2 : v }.inspect
```

Run: `ruby src/hashes.rb`

**Expected output (abridged):**
```
Person: {:name=>"Alice", :age=>30, :city=>"NYC", :active=>true}
Name: Alice
Age: 30
Country:
Country (default): Unknown
Updated: {:name=>"Alice", :age=>31, :city=>"NYC", :active=>true, :email=>"alice@example.com"}
Keys: [:name, :age, :city, :active, :email]
Values: ["Alice", 31, "NYC", true, "alice@example.com"]
Length: 5
Has key :name?: true
Has value 'NYC'?: true
After delete active: {:name=>"Alice", :age=>31, :city=>"NYC", :email=>"alice@example.com"}
defaults[:name]: Bob
defaults[:missing]: N/A
String key: Carol
Symbol key: 28
  name: Alice
  age: 31
  city: NYC
  email: alice@example.com
{"NAME"=>"Alice", "AGE"=>31, "CITY"=>"NYC", "EMAIL"=>"alice@example.com"}
{"name"=>"Alice", "age"=>62, "city"=>"NYC", "email"=>"alice@example.com"}
```

### Exercise 4: Blocks and Iterators

Create `src/blocks.rb`:

```ruby
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
```

Run: `ruby src/blocks.rb`

**Expected output (abridged):**
```
Number: 1
Number: 2
Number: 3
Number: 4
Number: 5
I like apple
I like banana
I like cherry
  0: apple
  1: banana
  2: cherry
Evens: [2, 4, 6, 8, 10]
Odds: [1, 3, 5, 7, 9]
Doubled: [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
Capitalized: ["Alice", "Bob", "Carol"]
Sum: 55
Product: 3628800
Max: 10
Odd squares sorted: [1, 9, 25, 49, 81]
First > 5: 6
Any even?: true
All positive?: true
None > 100?: true
  10² = 100
  20² = 400
  30² = 900
Total of squares: 1400
```

### Exercise 5: Ranges

Create `src/ranges.rb`:

```ruby
# Ranges — inclusive (..) and exclusive (...)
puts "1..5: #{(1..5).to_a.inspect}"
puts "1...5: #{(1...5).to_a.inspect}"
puts "'a'..'e': #{(("a".."e").to_a).inspect}"

# Range methods
r = 1..10
puts "1..10 include 5?: #{r.include?(5)}"
puts "1..10 include 10?: #{r.include?(10)}"
puts "1...10 include 10?: #{(1...10).include?(10)}"
puts "1..10 first: #{r.first}"
puts "1..10 last: #{r.last}"
puts "1..10 size: #{r.size}"

# Case statement with ranges
def age_group(age)
  case age
  when 0..12 then "child"
  when 13..17 then "teen"
  when 18..64 then "adult"
  when 65..Float::INFINITY then "senior"
  else "invalid"
  end
end

[5, 15, 30, 70, 120].each do |a|
  puts "Age #{a}: #{age_group(a)}"
end

# Step through a range
puts "Odd numbers 1..20: #{(1..20).select(&:odd?).inspect}"
puts "Every 3rd 0..15: #{(0..15).step(3).to_a.inspect}"

# Strings in ranges
letters = "a".."z"
puts "Letters include 'm'?: #{letters.include?("m")}"
puts "First 5 letters: #{(("a".."e").to_a).join}"
```

Run: `ruby src/ranges.rb`

**Expected output (abridged):**
```
1..5: [1, 2, 3, 4, 5]
1...5: [1, 2, 3, 4]
'a'..'e': ["a", "b", "c", "d", "e"]
1..10 include 5?: true
1..10 include 10?: true
1...10 include 10?: false
1..10 first: 1
1..10 last: 10
1..10 size: 10
Age 5: child
Age 15: teen
Age 30: adult
Age 70: senior
Age 120: senior
Odd numbers 1..20: [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]
Every 3rd 0..15: [0, 3, 6, 9, 12, 15]
Letters include 'm'?: true
First 5 letters: a b c d e
```

## Completion Checklist

- [ ] You can write `if`/`elsif`/`else` and `unless` conditionals
- [ ] You can use `case`/`when` with values, ranges, and regex
- [ ] You can iterate with `each`, `each_with_index`
- [ ] You understand blocks — both `{...}` and `do...end` syntax
- [ ] You can use `select`, `reject`, `map`, `reduce`, `find`, `any?`, `all?`
- [ ] You understand the `&:method` shorthand for blocks
- [ ] You can work with Arrays: push/pop/shift/unshift, slicing, flattening
- [ ] You can work with Hashes: symbol keys, access, iterate, defaults
- [ ] You can use Ranges for sequences, case matching, and stepping
- [ ] You can chain Enumerable methods: `select.map.sort`

## Hints

- Ruby's `&:method` shorthand (`array.map(&:upcase)`) calls the method on each element — equivalent to `{ |x| x.upcase }`
- `select` + `map` is a common pattern: filter then transform
- `reduce` without an initial value uses the first element as the seed — be careful with empty collections
- Hashes with symbol keys (`{name: "Alice"}`) are more common than string keys in modern Ruby
- Ranges are "lazy" — they don't create all elements until you call `.to_a` or iterate
- Ruby's truthiness: only `false` and `nil` are falsy; everything else (including `0`, `""`, `[]`) is truthy
