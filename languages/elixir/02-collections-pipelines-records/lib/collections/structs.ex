defmodule Collections.User do
  @moduledoc """
  A struct representing a user — exercise in defining and using structs.
  """
  defstruct [:id, :name, :email, :role, :level, :active]

  @doc """
  Create a new user with sensible defaults.
  """
  def new(id, name, email, role \\ :viewer, level \\ 1, active \\ true) do
    %Collections.User{
      id: id,
      name: name,
      email: email,
      role: role,
      level: level,
      active: active
    }
  end

  @doc """
  Promote a user by one level, returning a new struct.
  Structs are immutable — this returns a new one.
  """
  def promote(%Collections.User{} = user) do
    %{user | level: user.level + 1}
  end

  @doc """
  Check if a user has access to a resource requiring a minimum level.
  """
  def can_access?(%Collections.User{level: level, active: active}, required_level)
      when active and level >= required_level,
      do: true

  def can_access?(_, _), do: false

  @doc """
  List of users filtered by role, sorted by name.
  """
  def list_by_role(users, role) when is_list(users) do
    users
    |> Enum.filter(&(&1.role == role))
    |> Enum.sort_by(& &1.name)
  end
end

defmodule Collections.Structs do
  @moduledoc """
  Exercises using structs — typed records with defaults.
  """

  @doc """
  Build a team from a list of user specs (maps) and return
  only active members sorted by level descending.
  """
  def active_team_sorted(user_specs) when is_list(user_specs) do
    user_specs
    |> Enum.map(&Collections.User.new/1)
    |> Enum.filter(& &1.active)
    |> Enum.sort_by(& &1.level, :desc)
  end

  @doc """
  Promote all users in a list whose level is below a cap.
  Returns a new list of promoted structs.
  """
  def promote_below(users, cap) when is_list(users) do
    Enum.map(users, fn user ->
      if user.level < cap do
        Collections.User.promote(user)
      else
        user
      end
    end)
  end
end
