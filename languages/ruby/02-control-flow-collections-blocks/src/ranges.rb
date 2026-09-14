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
