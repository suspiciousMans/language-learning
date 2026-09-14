# A repository interface (in real code, this would talk to a database)
class UserRepository
  def find_by_id(id)
    raise NotImplementedError, "Subclass must implement"
  end

  def save(user)
    raise NotImplementedError, "Subclass must implement"
  end

  def delete(id)
    raise NotImplementedError, "Subclass must implement"
  end
end

# A user model
class User
  attr_reader :id, :name, :email

  def initialize(id, name, email)
    @id = id
    @name = name
    @email = email
  end

  def valid?
    !name.nil? && !name.strip.empty? && email&.include?("@")
  end
end

# A service that uses the repository — this is what we'll test
class UserService
  def initialize(repo)
    @repo = repo
  end

  def get_user(id)
    @repo.find_by_id(id)
  end

  def create_user(name, email)
    user = User.new(0, name, email)
    unless user.valid?
      raise ArgumentError, "Invalid user: name and valid email required"
    end
    saved = @repo.save(user)
    saved
  end

  def delete_user(id)
    @repo.delete(id)
  end

  def find_or_create(id, name, email)
    user = @repo.find_by_id(id)
    return user if user
    create_user(name, email)
  end
end
