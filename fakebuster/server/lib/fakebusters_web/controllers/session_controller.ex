defmodule FakebustersWeb.SessionController do
  use FakebustersWeb, :controller

  def new(conn, _) do
    render(conn, "new.html")
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:success, "Successfuly signed out")
    |> redirect(to: "/")
  end

  def create(conn, %{"user" => %{"name" => _name, "password" => _password} = form}) do
    case Fakebusters.Accounts.authenticate(form) do
      {:ok, user_id} ->
        conn
        |> put_session(:user_id, user_id)
        |> configure_session(renew: true)
        |> redirect(to: "/dashboard")

      _ ->
        conn
        |> put_flash(:error, "Bad name/password combination")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end
