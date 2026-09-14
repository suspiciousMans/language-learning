# Project 01: Basics — Ruby

**Difficulty:** beginner  
**Prerequisites:** Project 00 (Tooling Check)

## Goals

- Understand Ruby's basic syntax: variables, data types, strings, symbols
- Write and run simple Ruby programs
- Learn Ruby's expressive, readable style

## Concepts

- **`Variable` assignment** — Ruby is dynamically typed; no type declarations needed
- **Strings** — double-quoted (interpolation) vs single-quoted (literal)
- **Symbols** — immutable, lightweight identifiers (`:name`) often used as hash keys
- **Numbers** — Integers and Floats; Ruby handles big integers automatically
- **Boolean values** — `true`, `false`, and Ruby's truthiness (only `nil` and `false` are falsy)
- **Here documents** — multi-line strings with `<<~DOC` syntax
- **String interpolation** — `"Value: #{expression}"`

## Exercises

### Exercise 1: Variables and Types

Create `src/variables.rb`:

```ruby
# Ruby is dynamically typed — no type declarations
name = "Ruby"           # String
year = 1995             # Integer (Fixnum/Bignum auto-handled)
version = 3.3           # Float
is_fun = true           # TrueClass
nothing = nil           # NilClass — Ruby's "no value"

# Constants start with uppercase (convention, not enforced)
Language = "Ruby"

puts "Language: #{Language}"
puts "Name: #{name}, Year: #{year}"
puts "Version: #{version}"
puts "Is fun: #{is_fun}"
puts "Nothing: #{nothing.inspect}"

# Reassignment is allowed for non-constant variables
name = "Ruby on Rails"
puts "After reassignment: #{name}"
```

Run: `ruby src/variables.rb`

**Expected output:**
```
Language: Ruby
Name: Ruby, Year: 1995
Version: 3.3
Is fun: true
Nothing: nil
After reassignment: Ruby on Rails
```

### Exercise 2: Strings

Create `src/strings.rb`:

```ruby
# Double-quoted strings support interpolation and escape sequences
first = "Alice"
last = "Smith"
full = "#{first} #{last}"
puts "Full name: #{full}"

# String methods
puts "Upcase: #{full.upcase}"
puts "Downcase: #{full.downcase}"
puts "Length: #{full.length}"
puts "Empty?: #{"".empty?}"
puts "Include 'Ali'?: #{full.include?("Ali")}"

# Single-quoted strings are literal — no interpolation
literal = 'Value: #{full}'
puts "Literal: #{literal}"

# Concatenation
greeting = "Hello, " + full + "!"
puts greeting

# Append with <<
sentence = "Ruby"
sentence << " is"
sentence << " awesome"
puts sentence

# Split and join
csv = "apple,banana,cherry"
fruits = csv.split(",")
puts "Fruits: #{fruits.inspect}"
puts "Back to CSV: #{fruits.join("-")}"

# Strip whitespace
messy = "  hello  "
puts "Stripped: '#{messy.strip}'"
puts "Uppercase strip: '#{messy.upcase.strip}'"
```

Run: `ruby src/strings.rb`

**Expected output (abridged):**
```
Full name: Alice Smith
Upcase: ALICE SMITH
...
Literal: Value: #{full}
Hello, Alice Smith!
Ruby is awesome
Fruits: ["apple", "banana", "cherry"]
Back to CSV: apple-banana-cherry
Stripped: 'hello'
```

### Exercise 3: Numbers and Math

Create `src/numbers.rb`:

```ruby
# Integer arithmetic
puts "10 + 5 = #{10 + 5}"
puts "10 - 5 = #{10 - 5}"
puts "10 * 5 = #{10 * 5}"
puts "10 / 5 = #{10 / 5}"
puts "10 % 3 = #{10 % 3}"
puts "2 ** 8 = #{2 ** 8}"       # exponentiation

# Integer division truncates — use floats for decimal results
puts "10 / 3 = #{10 / 3}"       # => 3 (integer division)
puts "10 / 3.0 = #{10 / 3.0}"   # => 3.333...
puts "10.fdiv(3) = #{10.fdiv(3)}"  # => 3.333... (float division method)

# Number methods
puts "54.to_s = #{54.to_s}"
puts "54.to_f = #{54.to_f}"
puts "3.14.to_i = #{3.14.to_i}"
puts "3.14.round = #{3.14.round}"
puts "3.14.ceil = #{3.14.ceil}"
puts "3.14.floor = #{3.14.floor}"

# Random numbers
puts "Random int 1..10: #{rand(1..10)}"
puts "Random float: #{rand}"

# Large integers handled automatically
big = 2 ** 100
puts "2^100 = #{big}"
```

Run: `ruby src/numbers.rb`

### Exercise 4: Symbols

Create `src/symbols.rb`:

```ruby
# Symbols are immutable, lightweight identifiers
:name
:ruby
:"complex symbol with spaces"

# Common use: hash keys
person = { name: "Alice", age: 30, city: "NYC" }
puts "Name: #{person[:name]}"
puts "Age: #{person[:age]}"

# Symbols vs strings
puts :name.class       # Symbol
puts "name".class      # String

# Symbols are unique — same symbol always has same object_id
puts :foo.object_id == :foo.object_id   # true
puts "foo".object_id == "foo".object_id # usually false (different objects)

# Convert between symbols and strings
puts :hello.to_s        # "hello"
puts "world".to_sym     # :world
```

Run: `ruby src/symbols.rb`

### Exercise 5: Here Documents and Formatting

Create `src/heredoc.rb`:

```ruby
# Heredoc for multi-line strings
letter = <<~LETTER
  Dear #{full},

  Welcome to Ruby! It's a language that feels like
  writing English — clean, expressive, and fun.

  Happy coding!
  LETTER

puts letter

# Heredoc with indentation (<<~ strips leading whitespace)
poem = <<~POEM
  Roses are red
  Violets are blue
  Ruby is great
  And so are you
  POEM

puts poem

# Format strings with %
name = "Bob"
puts "%s, welcome!" % name           # old-style
puts "%d + %d = %d" % [3, 4, 7]     # multiple values

# sprintf / format
puts format("Pi: %.4f", 3.14159265)  # "Pi: 3.1416"
puts format("%05d", 42)              # "00042"
```

Run: `ruby src/heredoc.rb`

## Completion Checklist

- [ ] You understand Ruby is dynamically typed — no type declarations
- [ ] You can use string interpolation with `#{expression}`
- [ ] You know the difference between single and double-quoted strings
- [ ] You can call string methods: `.upcase`, `.downcase`, `.length`, `.include?`, `.strip`, `.split`, `.join`
- [ ] You understand symbols (`:name`) and when to use them
- [ ] You know the difference between integer and float division
- [ ] You can use heredocs (`<<~DOC`) for multi-line strings
- [ ] You understand Ruby's truthiness (`nil` and `false` are falsy)

## Hints

- Ruby method names often end in `?` for boolean returns (e.g. `.empty?`, `.include?`) and `!` for mutating operations (e.g. `.upcase!`)
- String interpolation only works in double-quoted strings
- Symbols are ideal for hash keys and method names — they're faster and use less memory than strings
- Ruby's `rake` and `bundler` use symbols heavily — you'll see them everywhere
- When in doubt, check the Ruby docs: https://ruby-doc.org/core/

---

*These basics are the foundation for everything that follows. Make sure you're comfortable with strings, symbols, and numbers before moving on.*
