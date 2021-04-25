defmodule FakebustersWeb.BoardLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Accounts
  alias Fakebusters.Boards
  alias Fakebusters.Boards.{JoinRequest, Channels, BoardMember}

  @impl true
  def mount(params, %{"board" => board} = session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    role = Boards.role(board, user)
    channels = Channels.role_channels(role)

    Boards.subscribe_to_board_channel(board.id, :events)

    socket =
      socket
      |> assign(:board, board)
      |> assign(:judge, Boards.judge(board))
      |> assign(:current_user, user)
      |> assign(:channels, channels)
      |> assign(:current_channel, List.last(channels))
      |> assign(:role, role)

    {:ok, socket}
  end

  def handle_event("previous_channel", _, socket) do
    {:noreply, shift_channel(socket, -1)}
  end

  def handle_event("next_channel", _, socket) do
    {:noreply, shift_channel(socket, 1)}
  end

  @impl true
  def handle_info({Boards, :new, %BoardMember{user_id: user_id, role: role}}, socket) do
    if user_id == socket.assigns[:current_user].id do
      {:noreply, assign(socket, :role, role)}
    else
      {:noreply, socket}
    end
  end

  defp shift_channel(socket, shift) do
    current_index =
      Enum.find_index(socket.assigns[:channels], &(&1 == socket.assigns[:current_channel]))

    new_index = rem(current_index + shift, Enum.count(socket.assigns[:channels]))

    assign(socket, :current_channel, Enum.at(socket.assigns[:channels], new_index))
  end
end
