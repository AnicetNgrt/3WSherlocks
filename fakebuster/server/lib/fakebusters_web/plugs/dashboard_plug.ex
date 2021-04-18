defmodule FakebustersWeb.DashboardPlug do
  import Plug.Conn

  def put_dashboard_assigns(conn, _opts) do
    assign(conn, :in_dashboard, true)
  end
end
