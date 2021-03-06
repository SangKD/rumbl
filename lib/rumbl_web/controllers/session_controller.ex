defmodule RumblWeb.SessionController do
   @moduledoc """
  This module contains the controller actions. [delete, create]
  """
  use RumblWeb, :controller

  @doc """
  The new action renders a login form
  """
  def new(conn, _) do
    render(conn, "new.html")
  end

  @doc """
  The create action handles form submission.
  """
  def create(
    conn,
    %{"session" => %{"username" => username, "password" => pass}}
  ) do
    case Rumbl.Accounts.authenticate_by_username_and_pass(username, pass) do
      {:ok, user} ->
        conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password combination.")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> RumblWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
