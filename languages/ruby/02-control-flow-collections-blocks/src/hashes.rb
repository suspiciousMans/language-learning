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
