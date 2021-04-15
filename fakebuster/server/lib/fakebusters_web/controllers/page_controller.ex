defmodule FakebustersWeb.PageController do
  use FakebustersWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:excluded_nav, ["/"])
    |> render("index.html")
  end
end
