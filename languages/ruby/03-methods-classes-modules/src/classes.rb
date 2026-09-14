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
