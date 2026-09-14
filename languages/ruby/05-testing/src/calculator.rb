# A simple calculator class to test
class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  def multiply(a, b)
    a * b
  end

  def divide(a, b)
    raise ArgumentError, "Cannot divide by zero" if b.zero?
    a / b
  end

  def power(base, exp)
    raise ArgumentError, "Negative exponent not supported" if exp < 0
    result = 1
    exp.times { result *= base }
    result
  end
end
