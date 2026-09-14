require_relative "user_repository"
require_relative "user"

RSpec.describe UserService do
  let(:repo) { double("UserRepository") }
  subject(:service) { described_class.new(repo) }

  describe "#get_user" do
    it "returns the user when found" do
      alice = User.new(1, "Alice", "alice@example.com")
      allow(repo).to receive(:find_by_id).with(1).and_return(alice)

      result = service.get_user(1)

      expect(result).to eq(alice)
      expect(result.name).to eq("Alice")
    end

    it "returns nil when user not found" do
      allow(repo).to receive(:find_by_id).with(999).and_return(nil)

      result = service.get_user(999)

      expect(result).to be_nil
    end

    it "delegates to the repository" do
      expect(repo).to receive(:find_by_id).with(42)
      service.get_user(42)
    end
  end

  describe "#create_user" do
    it "saves and returns a valid user" do
      saved_user = User.new(1, "Bob", "bob@example.com")
      allow(repo).to receive(:save).and_return(saved_user)

      result = service.create_user("Bob", "bob@example.com")

      expect(result).to eq(saved_user)
      expect(result.name).to eq("Bob")
      expect(repo).to have_received(:save)
    end

    it "raises ArgumentError for invalid user (empty name)" do
      expect { service.create_user("", "bob@example.com") }
        .to raise_error(ArgumentError, /Invalid user/)
    end

    it "raises ArgumentError for invalid email" do
      expect { service.create_user("Bob", "not-an-email") }
        .to raise_error(ArgumentError, /Invalid user/)
    end
  end

  describe "#find_or_create" do
    it "returns existing user when found" do
      existing = User.new(1, "Alice", "alice@example.com")
      allow(repo).to receive(:find_by_id).with(1).and_return(existing)

      result = service.find_or_create(1, "New", "new@example.com")

      expect(result).to eq(existing)
      expect(repo).not_to have_received(:save)
    end

    it "creates a new user when not found" do
      allow(repo).to receive(:find_by_id).and_return(nil)
      new_user = User.new(2, "Charlie", "charlie@example.com")
      allow(repo).to receive(:save).and_return(new_user)

      result = service.find_or_create(2, "Charlie", "charlie@example.com")

      expect(result).to eq(new_user)
      expect(repo).to have_received(:save)
    end
  end

  describe "integration-style test with a fake repository" do
    class FakeRepo
      def initialize
        @users = {}
      end

      def find_by_id(id)
        @users[id]
      end

      def save(user)
        @users[user.id] = user
        user
      end

      def delete(id)
        @users.delete(id)
      end
    end

    let(:fake_repo) { FakeRepo.new }
    subject(:service) { described_class.new(fake_repo) }

    it "works end-to-end: create, find, delete" do
      user = service.create_user("Dave", "dave@example.com")
      expect(user.name).to eq("Dave")

      found = service.get_user(user.id)
      expect(found).to eq(user)

      result = service.delete_user(user.id)
      expect(service.get_user(user.id)).to be_nil
    end
  end
end
