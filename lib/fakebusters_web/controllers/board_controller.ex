defmodule FakebustersWeb.BoardController do
  use FakebustersWeb, :controller
  alias Fakebusters.Boards
  alias Fakebusters.Boards.Board

  def index(conn, %{"id" => id}) do
    case Boards.get_board(id) do
      %Board{} = board ->
        conn
        |> assign(:board, board)
        |> render("index.html")

      nil ->
        conn
        |> put_flash(:error, "Investigation link is invalid or has expired.")
        |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    end
  end
end
