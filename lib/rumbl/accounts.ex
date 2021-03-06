defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Rumbl.Repo
  alias Rumbl.Accounts.User

  @doc """
  The `get_user/1` function fetches a single user from the system
  matching an ID.
  """
  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Similar to `get_user/1` but raises an error if no results are found.
  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @doc """
  The `get_user_by/1` function fetches a single user from
  the system matching a list of attributes.
  """
  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  @doc """
  The `list_users/0` function returns a list of all user structs in our db.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Calls user changeset.
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  The `create_user/1` function inserts new users into our db.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  A function that authenticates a given username and password.
  """
  def authenticate_by_username_and_pass(username, given_pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
