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

# ---------- Module for namespacing ----------
module MyApp
  module Models
    class User
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end
  end

  module Utils
    def self.format_date
      Time.now.strftime("%Y-%m-%d")
    end
  end
end

user = MyApp::Models::User.new("Alice")
puts "User: #{user.name}"
puts "Date: #{MyApp::Utils.format_date}"

# ---------- Comparable module (mixin for ordering) ----------
class Score
  include Comparable

  attr_reader :points

  def initialize(points)
    @points = points
  end

  def <=>(other)
    @points <=> other.points
  end

  def to_s
    "#{@points} pts"
  end
end

s1 = Score.new(85)
s2 = Score.new(92)
s3 = Score.new(78)

puts "s1: #{s1}"
puts "s2: #{s2}"
puts "s3: #{s3}"
puts "s1 < s2: #{s1 < s2}"
puts "s2 > s3: #{s2 > s3}"
puts "Sorted: #{ [s1, s2, s3].sort.map(&:to_s).join(', ') }"

# ---------- Module as interface-like contract (documentation) ----------
module Payable
  # Classes that include this module must implement:
  #   - amount: returns the payable amount as a number
  #   - currency: returns the currency code as a string
  #   - payable?: returns true if this can be paid now
  #
  # This is a duck-typing contract — Ruby doesn't enforce it,
  # but the methods serve as a clear interface contract.
end

class Invoice
  include Payable

  attr_reader :amount, :currency

  def initialize(amount, currency = "USD")
    @amount = amount
    @currency = currency
    @paid = false
  end

  def payable?
    !@paid && @amount > 0
  end

  def pay
    @paid = true if payable?
  end
end

inv = Invoice.new(150.00)
puts "Invoice #{inv.amount} #{inv.currency} payable?: #{inv.payable?}"
inv.pay
puts "After pay: payable?: #{inv.payable?}"
