module Validation
  def self.validate_email(email)
    raise ArgumentError, "Email is nil" if email.nil?
    raise ArgumentError, "Email is empty" if email.strip.empty?
    raise ArgumentError, "Email must contain @" unless email.include?("@")
    raise ArgumentError, "Email must contain a domain" unless email.split("@").last.include?(".")
    email.strip.downcase
  end

  def self.validate_age(age)
    raise ArgumentError, "Age is nil" if age.nil?
    raise ArgumentError, "Age must be an integer" unless age.is_a?(Integer)
    raise ArgumentError, "Age must be positive" if age < 0
    raise ArgumentError, "Age seems unrealistic" if age > 150
    age
  end

  def self.validate_username(username)
    raise ArgumentError, "Username is required" if username.nil? || username.strip.empty?
    raise ArgumentError, "Username too short (min 3 chars)" if username.length < 3
    raise ArgumentError, "Username too long (max 20 chars)" if username.length > 20
    raise ArgumentError, "Username can only contain letters, numbers, and underscores" unless username.match?(/\A[a-zA-Z0-9_]+\z/)
    username.downcase
  end

  def self.validate_password(password)
    raise ArgumentError, "Password is required" if password.nil? || password.empty?
    raise ArgumentError, "Password too short (min 8 chars)" if password.length < 8
    issues = []
    issues << "missing uppercase letter" unless password.match?(/[A-Z]/)
    issues << "missing lowercase letter" unless password.match?(/[a-z]/)
    issues << "missing digit" unless password.match?(/[0-9]/)
    issues << "missing special character" unless password.match?(/[^a-zA-Z0-9]/)
    raise ArgumentError, "Password weak: #{issues.join(", ")}" unless issues.empty?
    password
  end
end
