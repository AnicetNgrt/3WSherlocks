defmodule FakebustersWeb.PageController do
  use FakebustersWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:logged_in, conn.assigns[:current_user] != nil)
    |> assign(:in_main_page, true)
    |> render("index.html")
  end
end
