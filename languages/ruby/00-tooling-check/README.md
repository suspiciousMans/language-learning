# Project 00: Tooling Check — Ruby

**Difficulty:** beginner  
**Prerequisites:** none

## Goals

- Verify you have the Ruby toolchain installed correctly
- Understand the basic project structure Ruby uses
- Learn how to run a Ruby program from the command line
- Learn how to use Ruby's interactive console (IRB)

## Concepts

- **Ruby interpreter (`ruby`)** — the tool that runs `.rb` files
- **RubyGems** — Ruby's package manager; comes bundled with modern Ruby
- **Bundler** — dependency management for Ruby projects (used for real projects)
- **IRB (Interactive Ruby)** — Ruby's interactive REPL console

## Setup

### Option A: Install via version manager (recommended)

```bash
# Using rbenv (macOS/Linux)
brew install rbenv ruby-build   # macOS
# or
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -j && make install
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
rbenv install 3.3.6
rbenv global 3.3.6

# Using rvm (alternative)
\curl -sSL https://get.rvm.io | bash -s stable
rvm install 3.3.6
rvm use 3.3.6 --default
```

### Option B: System Ruby / package manager

```bash
# Ubuntu/Debian
sudo apt install ruby-full bundler

# Fedora
sudo dnf install ruby rubygems

# macOS (includes Ruby, but version may be old)
brew install ruby
```

### Verify installation

```bash
ruby -v
gem -v
bundle --version
```

## Exercises

Complete these exercises to confirm your setup:

### Exercise 1: Hello World

Create `hello.rb`:

```ruby
puts "Hello, Ruby!"
```

Run it:

```bash
ruby hello.rb
```

Expected output: `Hello, Ruby!`

### Exercise 2: Check Ruby version and environment

In your terminal, run:

```bash
ruby -v
ruby -e 'puts RUBY_PLATFORM'
ruby -e 'puts RUBY_VERSION'
```

Record the version number. You should see something like `ruby 3.3.x`.

### Exercise 3: Use IRB (Ruby's REPL)

Start IRB:

```bash
irb
```

This opens an interactive prompt. Try:

```ruby
def add(a, b)
  a + b
end
add(3, 5)
```

Expected output: `8`

Exit with `exit` or `quit`.

### Exercise 4: Use RubyGems

Check that RubyGems works:

```bash
gem list --local
gem install --user-install json  # install a sample gem
ruby -e 'require "json"; puts JSON.generate({hello: "world"})'
```

Expected output: `{"hello":"world"}`

### Exercise 5: Create a minimal project with Bundler

Create a file `Gemfile`:

```ruby
source "https://rubygems.org"

gem "json", "~> 2.0"
```

Run:

```bash
bundle install
ruby -e 'require "json"; puts JSON.generate({using: "bundler"})'
```

If Bundler is installed, this should complete without error.

## Completion Checklist

- [ ] `ruby -v` shows a version number (3.0 or newer recommended)
- [ ] `gem -v` shows a version number
- [ ] `bundle --version` shows a version number
- [ ] You can run `hello.rb` with `ruby hello.rb`
- [ ] You can use IRB interactively
- [ ] You can require and use a gem installed via RubyGems
- [ ] (Optional) `bundle install` works with a Gemfile

## Hints

- If `ruby` is not found, check your PATH: `echo $PATH`
- On macOS, the system Ruby is protected by SIP — use a version manager instead
- IRB is great for quick experiments; use `.rb` files for anything you want to save
- RubyGems comes bundled with Ruby 1.9+ — you usually don't need to install it separately
- The `-e` flag lets you run Ruby code inline: `ruby -e 'puts 1 + 2'`

---

*Use this project to make sure your environment is ready before starting the real work.*
