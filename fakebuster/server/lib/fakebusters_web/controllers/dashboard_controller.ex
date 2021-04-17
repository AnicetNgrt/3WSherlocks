defmodule FakebustersWeb.DashboardController do
  use FakebustersWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:in_dashboard, true)
    |> render("index.html")
  end
end
