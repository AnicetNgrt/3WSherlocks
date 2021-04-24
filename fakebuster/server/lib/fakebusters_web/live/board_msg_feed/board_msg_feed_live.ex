defmodule FakebustersWeb.BoardMsgFeedLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Accounts
  alias Fakebusters.Boards
  alias FakebustersWeb.LiveComponents.BoardMsg

  @impl true
  def mount(params, %{"board" => board, "role" => role, "user" => user} = session, socket) do
    messages = Boards.board_messages(board, role)
    IO.inspect(role)
    IO.inspect(messages)

    socket =
      socket
      |> assign(:board, board)
      |> assign(:current_user, user)
      |> assign(:role, role)
      |> assign(
        :messages,
        Enum.map(messages, fn msg ->
          author = Accounts.get_user!(msg.user_id)

          msg
          |> Map.put(:author, author)
          |> Map.put(:author_role, Boards.role(board, author))
        end)
      )

    {:ok, socket}
  end
end
