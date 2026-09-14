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
