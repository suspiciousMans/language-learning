require_relative "validation"

RSpec.describe Validation do
  describe ".validate_email" do
    it "returns a normalized email for valid input" do
      expect(Validation.validate_email("Alice@Example.COM")).to eq("alice@example.com")
    end

    it "raises ArgumentError for nil" do
      expect { Validation.validate_email(nil) }
        .to raise_error(ArgumentError, "Email is nil")
    end

    it "raises ArgumentError for empty string" do
      expect { Validation.validate_email("   ") }
        .to raise_error(ArgumentError, "Email is empty")
    end

    it "raises ArgumentError for missing @" do
      expect { Validation.validate_email("alice.example.com") }
        .to raise_error(ArgumentError, "Email must contain @")
    end

    it "raises ArgumentError for missing domain" do
      expect { Validation.validate_email("alice@") }
        .to raise_error(ArgumentError, "Email must contain a domain")
    end

    it "accepts emails with subdomains" do
      expect(Validation.validate_email("alice@mail.example.com")).to eq("alice@mail.example.com")
    end
  end

  describe ".validate_age" do
    it "returns the age for valid input" do
      expect(Validation.validate_age(25)).to eq(25)
    end

    it "raises ArgumentError for nil" do
      expect { Validation.validate_age(nil) }
        .to raise_error(ArgumentError, "Age is nil")
    end

    it "raises ArgumentError for non-integer" do
      expect { Validation.validate_age("25") }
        .to raise_error(ArgumentError, "Age must be an integer")
      expect { Validation.validate_age(25.5) }
        .to raise_error(ArgumentError, "Age must be an integer")
    end

    it "raises ArgumentError for negative age" do
      expect { Validation.validate_age(-1) }
        .to raise_error(ArgumentError, "Age must be positive")
    end

    it "raises ArgumentError for unrealistic age" do
      expect { Validation.validate_age(200) }
        .to raise_error(ArgumentError, "Age seems unrealistic")
    end

    it "accepts age 0 and 150 (boundary values)" do
      expect(Validation.validate_age(0)).to eq(0)
      expect(Validation.validate_age(150)).to eq(150)
    end
  end

  describe ".validate_username" do
    it "returns a normalized username" do
      expect(Validation.validate_username("Alice_123")).to eq("alice_123")
    end

    it "raises ArgumentError for nil or empty" do
      expect { Validation.validate_username(nil) }
        .to raise_error(ArgumentError, "Username is required")
      expect { Validation.validate_username("") }
        .to raise_error(ArgumentError, "Username is required")
    end

    it "raises ArgumentError for too short" do
      expect { Validation.validate_username("Ab") }
        .to raise_error(ArgumentError, /too short/)
    end

    it "raises ArgumentError for too long" do
      long_name = "a" * 21
      expect { Validation.validate_username(long_name) }
        .to raise_error(ArgumentError, /too long/)
    end

    it "raises ArgumentError for invalid characters" do
      expect { Validation.validate_username("alice@bob") }
        .to raise_error(ArgumentError, /can only contain/)
      expect { Validation.validate_username("alice bob") }
        .to raise_error(ArgumentError, /can only contain/)
    end

    it "accepts underscores" do
      expect(Validation.validate_username("alice_bob_123")).to eq("alice_bob_123")
    end
  end

  describe ".validate_password" do
    it "accepts a strong password" do
      expect(Validation.validate_password("Str0ng!Pass")).to eq("Str0ng!Pass")
    end

    it "raises ArgumentError for too short" do
      expect { Validation.validate_password("Short1!") }
        .to raise_error(ArgumentError, /too short/)
    end

    it "raises ArgumentError for missing uppercase" do
      expect { Validation.validate_password("strong!pass1") }
        .to raise_error(ArgumentError, /missing uppercase/)
    end

    it "raises ArgumentError for missing lowercase" do
      expect { Validation.validate_password("STR0NG!PASS") }
        .to raise_error(ArgumentError, /missing lowercase/)
    end

    it "raises ArgumentError for missing digit" do
      expect { Validation.validate_password("Strong!Pass") }
        .to raise_error(ArgumentError, /missing digit/)
    end

    it "raises ArgumentError for missing special character" do
      expect { Validation.validate_password("StrongPass1") }
        .to raise_error(ArgumentError, /missing special/)
    end

    it "raises ArgumentError with all issues listed" do
      expect { Validation.validate_password("weak") }
        .to raise_error(ArgumentError, /missing uppercase/, /missing digit/, /missing special/)
    end
  end
end
