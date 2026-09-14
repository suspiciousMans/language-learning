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
