defmodule FakebustersWeb.BoardLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Accounts
  alias Fakebusters.Boards
  alias Fakebusters.Boards.{JoinRequest, BoardMember}

  @impl true
  def mount(params, %{"board" => board} = session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    socket =
      socket
      |> assign(:board, board)
      |> assign(:current_user, user)
      |> assign(:channels, [:events])
      |> assign(:current_channel, :events)
      |> assign(:role, BoardMember.role_to_atom(Boards.role(board, user)))

    {:ok, socket}
  end
end
