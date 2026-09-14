# Project 03: Methods, Classes, and Modules — Ruby

**Difficulty:** intermediate  
**Prerequisites:** Project 02 (Control Flow, Collections, and Blocks)

## Goals

- Write methods with arguments, defaults, splats, and keyword arguments
- Create classes with constructors, methods, attributes, and inheritance
- Use modules for mixins, namespacing, and interface-like contracts
- Understand Ruby's message-sending object model
- Practice encapsulation, visibility (public/private/protected), and class versus instance methods

## Concepts

- **`def`/`end`** — method definition
- **Method arguments**: positional, default (`def f(a, b=10)`), splat (`*args`), keyword (`def f(name:, age:)`), double splat (`**kwargs`)
- **`return`** — explicit return (often unnecessary; last expression is the return value)
- **`self`** — the current object; receiver of the message
- **Classes** — `class Name ... end`; constructor is `initialize`
- **Instance variables** — `@name`, `@age`; per-object state
- **Attribute accessors** — `attr_reader`, `attr_writer`, `attr_accessor`
- **Class variables** — `@@count` (shared across class hierarchy; use cautiously)
- **Class instance variables** — `@count` inside class methods (preferred over `@@`)
- **Class methods** — `def self.method` or `class << self ... end`
- **Inheritance** — `class Child < Parent`; single inheritance only
- **`super`** — call parent method; can pass args or use empty `super` to forward all
- **Modules** — `module Name ... end`; mixins via `include`, `prepend`, `extend`
- **Duck typing** — "if it walks like a duck"; Ruby cares about messages, not types
- **Visibility**: `public` (default), `private` (no explicit receiver), `protected` (receiver can be other instance of same class)
- **`<=>` spaceship operator** — for ordering/comparison (used by `<`, `>`, `between?`, etc.)
- **`attr_*` macros** — generate getter/setter methods at class definition time

## Exercises

### Exercise 1: Methods

Create `src/methods.rb`:

```ruby
# ---------- Basic method ----------
def greet(name)
  "Hello, #{name}!"
end

puts greet("Alice")
puts greet("Bob")

# ---------- Default arguments ----------
def greet_with_default(name = "World")
  "Hello, #{name}!"
end

puts greet_with_default()
puts greet_with_default("Ruby")

# ---------- Multiple defaults ----------
def make_tag(tag, content, css_class = "", id = "")
  attrs = ""
  attrs += " class='#{css_class}'" unless css_class.empty?
  attrs += " id='#{id}'" unless id.empty?
  "<#{tag}#{attrs}>#{content}</#{tag}>"
end

puts make_tag("p", "Hello")                         # <p>Hello</p>
puts make_tag("p", "Hello", "highlight")            # <p class='highlight'>Hello</p>
puts make_tag("div", "Content", "box", "main")      # <div class='box' id='main'>Content</div>

# ---------- Splat arguments ----------
def sum_all(*numbers)
  numbers.reduce(0, :+)
end

puts "sum_all(1,2,3): #{sum_all(1, 2, 3)}"
puts "sum_all(10,20,30,40): #{sum_all(10, 20, 30, 40)}"
puts "sum_all(): #{sum_all()}"

def method_with_splat_and_regular(a, b, *rest)
  "a=#{a}, b=#{b}, rest=#{rest.inspect}"
end

puts method_with_splat_and_regular(1, 2)
puts method_with_splat_and_regular(1, 2, 3, 4, 5)

# ---------- Keyword arguments ----------
def create_user(name:, email:, role: "user")
  { name: name, email: email, role: role }
end

puts create_user(name: "Alice", email: "a@b.com").inspect
puts create_user(name: "Bob", email: "b@c.com", role: "admin").inspect

# ---------- Double splat (**kwargs) ----------
def log_event(event, **metadata)
  base = { event: event, timestamp: Time.now.to_i }
  puts base.merge(metadata).inspect
end

log_event("login", user: "alice", ip: "192.168.1.1")
log_event("click", element: "submit", page: "/checkout")

# ---------- Combination ----------
def flexible(*args, **kwargs)
  "args=#{args.inspect}, kwargs=#{kwargs.inspect}"
end

puts flexible(1, 2, 3, x: 10, y: 20)
puts flexible(a: 1, b: 2)

# ---------- Return values ----------
def last_expression
  # No explicit return — last expression is returned
  x = 42
  x * 2
end

puts "last_expression: #{last_expression}"

def explicit_return
  return "early exit"
  "never reached"
end

puts "explicit_return: #{explicit_return}"

def conditional_return(age)
  return "child" if age < 13
  return "teen" if age < 20
  "adult"
end

puts conditional_return(8)
puts conditional_return(15)
puts conditional_return(30)
```

Run: `ruby src/methods.rb`

**Expected output (abridged):**
```
Hello, Alice!
Hello, Bob!
Hello, World!
Hello, Ruby!
<p>Hello</p>
<p class='highlight'>Hello</p>
<div class='box' id='main'>Content</div>
sum_all(1,2,3): 6
sum_all(10,20,30,40): 100
sum_all(): 0
a=1, b=2, rest=[]
a=1, b=2, rest=[3, 4, 5]
{:name=>"Alice", :email=>"a@b.com", :role=>"user"}
{:name=>"Bob", :email=>"b@c.com", :role=>"admin"}
{:event=>"login", :timestamp=>..., :user=>"alice", :ip=>"192.168.1.1"}
{:event=>"click", :timestamp=>..., :element=>"submit", :page=>"/checkout"}
args=[1, 2, 3], kwargs={:x=>10, :y=>20}
args=[], kwargs={:a=>1, :b=>2}
last_expression: 84
explicit_return: early exit
child
teen
adult
```

### Exercise 2: Classes and Instances

Create `src/classes.rb`:

```ruby
# ---------- Simple class with constructor ----------
class Person
  def initialize(name, age)
    @name = name
    @age = age
  end

  # Getter
  def name
    @name
  end

  # Setter
  def name=(new_name)
    @name = new_name
  end

  def age
    @age
  end

  def introduce
    "Hi, I'm #{@name}, #{ @age } years old"
  end

  # Custom to_s for nice printing
  def to_s
    "#{@name} (#{@age})"
  end
end

alice = Person.new("Alice", 30)
puts alice.introduce
puts alice.name
alice.name = "Alicia"
puts alice.name
puts alice.to_s

bob = Person.new("Bob", 25)
puts bob.introduce

# ---------- attr_accessor (generates getter + setter) ----------
class Person2
  attr_accessor :name, :age

  def initialize(name, age)
    @name = name
    @age = age
  end

  def introduce
    "Hi, I'm #{name}, #{age} years old"
  end
end

carol = Person2.new("Carol", 28)
carol.age += 1
puts carol.introduce

# ---------- attr_reader / attr_writer ----------
class BankAccount
  attr_reader :owner, :balance
  attr_writer :owner

  def initialize(owner, balance)
    @owner = owner
    @balance = balance
  end

  def deposit(amount)
    @balance += amount
    "Deposited #{amount}, new balance: #{@balance}"
  end

  def withdraw(amount)
    if amount > @balance
      "Insufficient funds"
    else
      @balance -= amount
      "Withdrawn #{amount}, new balance: #{@balance}"
    end
  end

  def to_s
    "#{@owner}: $#{@balance}"
  end
end

account = BankAccount.new("Dave", 100.0)
puts account.deposit(50)
puts account.withdraw(30)
puts account.withdraw(200)
puts account.to_s
# account.balance = 999  # NoMethodError — no writer for balance

# ---------- Class variable (shared across instances — use sparingly) ----------
class PersonCounter
  @@count = 0

  def initialize(name)
    @name = name
    @@count += 1
  end

  def self.count
    @@count
  end

  def introduce
    "I'm #{@name} (person ##{@@count})"
  end
end

p1 = PersonCounter.new("Eve")
p2 = PersonCounter.new("Frank")
p3 = PersonCounter.new("Grace")
puts p1.introduce
puts p2.introduce
puts "Total people: #{PersonCounter.count}"

# ---------- Class instance variable (preferred pattern) ----------
class BetterCounter
  @count = 0  # class instance variable

  def initialize(name)
    @name = name
    self.class.increment
  end

  def self.increment
    @count += 1
  end

  def self.count
    @count
  end

  def introduce
    "I'm #{@name}"
  end
end

BetterCounter.new("Heidi")
BetterCounter.new("Ivan")
BetterCounter.new("Judy")
puts "Total (better): #{BetterCounter.count}"
```

Run: `ruby src/classes.rb`

**Expected output (abridged):**
```
Hi, I'm Alice, 30 years old
Alice
Alicia
Alice (30)
Hi, I'm Bob, 25 years old
Hi, I'm Carol, 29 years old
Deposited 50, new balance: 150.0
Withdrawn 30, new balance: 120.0
Insufficient funds
Dave: $120.0
I'm Eve (person #1)
I'm Frank (person #2)
I'm Grace (person #3)
Total people: 3
I'm Heidi
I'm Ivan
I'm Judy
Total (better): 3
```

### Exercise 3: Inheritance

Create `src/inheritance.rb`:

```ruby
# ---------- Single inheritance ----------
class Animal
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} makes a sound"
  end

  def info
    "#{@name} is an animal"
  end
end

class Dog < Animal
  def speak
    "#{@name} says: Woof!"
  end
end

class Cat < Animal
  def speak
    "#{@name} says: Meow!"
  end
end

animals = [Animal.new("Generic"), Dog.new("Rex"), Cat.new("Whiskers")]
animals.each { |a| puts a.speak; puts a.info; puts }

# ---------- super ----------
class Animal2
  def initialize(name, legs = 4)
    @name = name
    @legs = legs
  end

  def info
    "I'm #{@name}, a #{@legs}-legged animal"
  end
end

class Bird < Animal2
  def initialize(name)
    super(name, 2)  # pass specific args to parent
  end

  def info
    super + " that can fly"  # augment parent behavior
  end
end

bird = Bird.new("Tweety")
puts bird.info

# ---------- Method overriding and super forwarding ----------
class Greeter
  def greet
    "Hello"
  end
end

class FormalGreeter < Greeter
  def greet(name)
    "#{super}, #{name}. Welcome."  # super with no args = same as super()
  end
end

puts FormalGreeter.new.greet("Alice")

# ---------- Inheritance with custom constructor ----------
class Product
  attr_reader :sku, :price

  def initialize(sku, price)
    @sku = sku
    @price = price
  end

  def discount(percent)
    @price *= (1 - percent / 100.0)
    @price
  end
end

class DiscountedProduct < Product
  def initialize(sku, price, discount_percent)
    super(sku, price)
    @discount_percent = discount_percent
  end

  def price
    super * (1 - @discount_percent / 100.0)
  end
end

item = DiscountedProduct.new("SKU-123", 100, 20)
puts "Price after 20% discount: $#{item.price}"
```

Run: `ruby src/inheritance.rb`

**Expected output (abridged):**
```
Generic makes a sound
Generic is an animal

Rex says: Woof!
Rex is an animal

Whiskers says: Meow!
Whiskers is an animal

I'm Tweety, a 2-legged animal that can fly
Hello, Alice. Welcome.
Price after 20% discount: $80.0
```

### Exercise 4: Modules as Mixins

Create `src/modules.rb`:

```ruby
# ---------- Module as a mixin (include) ----------
module Describable
  def describe
    "#{self.class.name}: #{@to_s_value}"
  end

  # Classes including this module must provide to_s
  # Convention: if it quacks like a duck...
end

class Item
  include Describable

  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end

  def to_s
    "#{@name} — $#{@price}"
  end
end

item = Item.new("Widget", 9.99)
puts item.describe
puts item.to_s

# ---------- Module with class methods (extend) ----------
module MathHelpers
  def square(x)
    x * x
  end

  def cube(x)
    x * x * x
  end
end

class Calculator
  extend MathHelpers  # makes methods class methods
end

puts Calculator.square(5)
puts Calculator.cube(3)

# Also extend a specific object
obj = Object.new
obj.extend(MathHelpers)
puts obj.square(4)

# ---------- Comparable mixin (uses <=>) ----------
class Score
  include Comparable

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def <=>(other)
    @value <=> other.value
  end

  def to_s
    "Score(#{@value})"
  end
end

s1 = Score.new(85)
s2 = Score.new(92)
s3 = Score.new(85)

puts "s1 > s2: #{s1 > s2}"
puts "s1 < s2: #{s1 < s2}"
puts "s1 == s3: #{s1 == s3}"
puts "s1 >= s2: #{s1 >= s2}"
puts "s1.between?(s2, s3): #{s1.between?(s2, s3)}"

# ---------- Enumerable mixin (use each to get all Enumerable methods) ----------
class MyCollection
  include Enumerable

  def initialize(*elements)
    @elements = elements
  end

  def each
    return enum_for(:each) unless block_given?  # returns Enumerator if no block
    @elements.each { |e| yield e }
  end
end

coll = MyCollection.new(1, 2, 3, 4, 5)
puts "Sum: #{coll.sum}"
puts "Select even: #{coll.select(&:even?).inspect}"
puts "Map squared: #{coll.map { |n| n**2 }.inspect}"
puts "Any > 3?: #{coll.any? { |n| n > 3 }}"
puts "All < 10?: #{coll.all? { |n| n < 10 }}"

# ---------- Namespace module (organize code) ----------
module MyApp
  module Models
    class User
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end
  end

  module Services
    def self.process(user)
      "Processed #{user.name}"
    end
  end
end

user = MyApp::Models::User.new("Kim")
puts MyApp::Services.process(user)

# ---------- Prepend (runs before class method) ----------
module Audit
  def save
    puts "[AUDIT] saving..."
    super  # call the original class method
    puts "[AUDIT] saved."
  end
end

class Document
  prepend Audit

  def save
    puts "Document saved to disk"
  end
end

doc = Document.new
doc.save
```

Run: `ruby src/modules.rb`

**Expected output (abridged):**
```
Item: Widget — $9.99
Widget — $9.99
25
27
16
85 > 92: false
85 < 92: true
85 == 85: true
85 >= 92: false
Score(85).between?(Score(92), Score(85)): true
Sum: 15
Select even: [2, 4]
Map squared: [1, 4, 9, 16, 25]
Any > 3?: true
All < 10?: true
Processed Kim
[AUDIT] saving...
Document saved to disk
[AUDIT] saved.
```

### Exercise 5: Advanced Class Features

Create `src/advanced_classes.rb`:

```ruby
# ---------- Singleton class (per-object methods) ----------
obj = Object.new

def obj.hello
  "Hello from this specific object"
end

puts obj.hello

# singleton class access
puts obj.singleton_class
puts obj.singleton_methods  # [:hello]

# ---------- Eigenclass / class << self ----------
class Logger
  class << self
    def debug(msg)
      "[DEBUG] #{msg}"
    end

    def info(msg)
      "[INFO] #{msg}"
    end
  end
end

puts Logger.debug("starting up")
puts Logger.info("ready")

# ---------- Method missing (dynamic dispatch) ----------
class FlexibleObject
  def method_missing(method_name, *args, &block)
    if method_name.to_s.start_with?("get_")
      key = method_name.to_s[4..-1].to_sym
      "Got #{key.inspect} with args: #{args.inspect}"
    else
      super  # re-raise as NoMethodError if not our prefix
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?("get_") || super
  end
end

flex = FlexibleObject.new
puts flex.get_name("Alice")
puts flex.get_count(42, "items")
# puts flex.regular_method  # NoMethodError

# ---------- Struct (lightweight data class) ----------
Point = Struct.new(:x, :y)

p1 = Point.new(10, 20)
p2 = Point.new(30, 40)

puts "p1: #{p1.inspect}"
puts "p1.x: #{p1.x}, p1.y: #{p1.y}"
puts "p1 == p2: #{p1 == p2}"
puts "p1.to_a: #{p1.to_a.inspect}"
puts "p1.to_h: #{p1.to_h.inspect}"

# Add methods to a Struct subclass
PersonStruct = Struct.new(:name, :age) do
  def adult?
    age >= 18
  end

  def to_s
    "#{name} (#{age}, #{adult? ? "adult" : "minor"})"
  end
end

ps = PersonStruct.new("Leo", 17)
puts ps
puts "Adult?: #{ps.adult?}"

# ---------- Data class with to_h, to_a, [](), []=, dig ----------
config = { host: "localhost", port: 8080, database: { name: "mydb", user: "admin" } }

# OpenStruct for dynamic fields (use cautiously — no typo protection)
require "ostruct"
settings = OpenStruct.new(host: "localhost", port: 8080)
puts settings.host
puts settings.port
settings.port = 9090
puts settings.port
```

Run: `ruby src/advanced_classes.rb`

**Expected output (abridged):**
```
Hello from this specific object
#<Class:#<Object:0x...>>
[:hello]
[DEBUG] starting up
[INFO] ready
Got :name with args: ["Alice"]
Got :count with args: [42, "items"]
p1: #<struct Point x=10, y=20>
p1.x: 10, p1.y: 20
p1 == p2: false
p1.to_a: [10, 20]
p1.to_h: {:x=>10, :y=>20}
Leo (17, minor)
Adult?: false
localhost
8080
9090
```

## Completion Checklist

- [ ] You can define methods with positional, default, splat, and keyword arguments
- [ ] You understand `return` and that the last expression is the implicit return value
- [ ] You can create classes with `initialize`, instance variables, and custom `to_s`
- [ ] You can use `attr_reader`, `attr_writer`, `attr_accessor` to generate accessors
- [ ] You can create class methods with `def self.method` or `class << self`
- [ ] You can use class instance variables (`@count` inside class methods) instead of `@@`
- [ ] You can use single inheritance with `<` and call `super` with or without arguments
- [ ] You can use modules as mixins (`include`) for instance methods and `extend` for class methods
- [ ] You can use `Comparable` (`<=>`) to get all comparison operators for free
- [ ] You can use `Enumerable` (by defining `each`) to get all collection methods for free
- [ ] You can namespace code with nested modules (`MyApp::Models::User`)
- [ ] You can use `prepend` to run module code before the class method
- [ ] You understand `method_missing` for dynamic dispatch and why `respond_to_missing?` matters
- [ ] You can use `Struct` for lightweight data classes and add behavior via block
- [ ] You understand singleton methods (`def obj.hello`) and the eigenclass

## Hints

- Prefer `attr_accessor`/`attr_reader`/`attr_writer` over hand-written getters/setters — they're idiomatic and concise
- Use class instance variables (`@count` in class methods) over `@@` class variables — `@@` shares across the entire class hierarchy and can cause surprising bugs
- `include` adds instance methods, `extend` adds class methods, `prepend` runs before the class method (good for wrapping/auditing)
- `<=>` (spaceship operator) should return -1, 0, or 1; including `Comparable` gives you `<`, `<=`, `==`, `>=`, `>`, `between?`, `clamp` for free
- Defining `each` and including `Enumerable` is the standard way to make a custom collection support all Enumerable methods
- `method_missing` is powerful but should be used sparingly — it can make code harder to understand and debug
- `Struct` is great for simple data containers; `OpenStruct` is more flexible but has no typo protection (typos create new fields silently)
- Ruby's `enum_for(:method)` returns an `Enumerator` when no block is given — this is how `map` works without a block in IRB
