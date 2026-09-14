require_relative "calculator"

RSpec.describe Calculator do
  subject(:calc) { described_class.new }

  describe "#add" do
    it "returns the sum of two positive numbers" do
      result = calc.add(3, 5)
      expect(result).to eq(8)
    end

    it "handles negative numbers" do
      expect(calc.add(-3, 5)).to eq(2)
      expect(calc.add(3, -5)).to eq(-2)
      expect(calc.add(-3, -5)).to eq(-8)
    end

    it "handles zero" do
      expect(calc.add(0, 0)).to eq(0)
      expect(calc.add(5, 0)).to eq(5)
    end
  end

  describe "#subtract" do
    it "returns the difference" do
      expect(calc.subtract(10, 3)).to eq(7)
      expect(calc.subtract(3, 10)).to eq(-7)
    end
  end

  describe "#multiply" do
    it "returns the product" do
      expect(calc.multiply(3, 4)).to eq(12)
      expect(calc.multiply(-3, 4)).to eq(-12)
      expect(calc.multiply(0, 100)).to eq(0)
    end
  end

  describe "#divide" do
    it "returns the quotient" do
      expect(calc.divide(10, 2)).to eq(5)
      expect(calc.divide(7, 2)).to eq(3)
    end

    it "raises ArgumentError when dividing by zero" do
      expect { calc.divide(10, 0) }.to raise_error(ArgumentError, "Cannot divide by zero")
    end
  end

  describe "#power" do
    it "computes positive powers" do
      expect(calc.power(2, 3)).to eq(8)
      expect(calc.power(5, 0)).to eq(1)
    end

    it "raises ArgumentError for negative exponent" do
      expect { calc.power(2, -1) }.to raise_error(ArgumentError)
    end
  end

  describe "edge cases" do
    it "handles large numbers" do
      expect(calc.add(1_000_000, 2_000_000)).to eq(3_000_000)
    end

    it "handles integer overflow gracefully (Ruby has arbitrary precision)" do
      result = calc.power(2, 100)
      expect(result).to be_a(Integer)
      expect(result).to be > 0
    end
  end
end
