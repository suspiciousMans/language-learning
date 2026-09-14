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
