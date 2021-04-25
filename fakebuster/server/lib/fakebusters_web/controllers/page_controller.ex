defmodule FakebustersWeb.PageController do
  use FakebustersWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn.assigns)

    conn
    |> assign(:logged_in, conn.assigns[:current_user] != nil)
    |> render("index.html")
  end
end
