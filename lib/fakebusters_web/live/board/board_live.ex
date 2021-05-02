defmodule FakebustersWeb.BoardLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Countdown
  alias Fakebusters.Accounts
  alias Fakebusters.Boards
  alias Fakebusters.Boards.{Channels, BoardMember}
  alias FakebustersWeb.TimeHelpers

  @impl true
  def mount(_params, %{"board" => board} = session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    role = Boards.role(board, user)
    seconds_left = Boards.seconds_left(board)

    countdown_id = :crypto.rand_uniform(0, 9_999_999)
    {:ok, _} = Countdown.spawn_and_subscribe(countdown_id, seconds_left)

    if role == nil do
      Boards.subscribe_to_board_channel(board.id, :members)
    end

    socket =
      socket
      |> assign(:board, board)
      |> assign(:judge, Boards.judge(board))
      |> assign(:current_user, user)
      |> assign(:seconds_left, seconds_left)
      |> update_role(role)

    {:ok, socket}
  end

  @impl true
  def handle_event("previous_channel", _, socket) do
    {:noreply, shift_channel(socket, -1)}
  end

  def handle_event("next_channel", _, socket) do
    {:noreply, shift_channel(socket, 1)}
  end

  @impl true
  def handle_info({Countdown, :countdown, seconds_left}, socket) do
    if socket.assigns[:board].finished == false and seconds_left < 1 do
      {:ok, board} = Boards.update_board(socket.assigns[:board], %{"finished" => true})

      socket =
        socket
        |> assign(:board, board)
        |> assign(:seconds_left, seconds_left)

      {:noreply, socket}
    else
      {:noreply, assign(socket, :seconds_left, seconds_left)}
    end
  end

  @impl true
  def handle_info({Boards, :new, %BoardMember{user_id: user_id, role: role}}, socket) do
    if user_id == socket.assigns[:current_user].id do
      {:noreply, update_role(socket, role)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(_data, socket) do
    {:noreply, socket}
  end

  defp update_role(socket, role) do
    channels = Channels.role_channels(role)

    socket
    |> assign(:role, role)
    |> assign(:channels, channels)
    |> assign(:current_channel, List.last(channels))
  end

  defp shift_channel(socket, shift) do
    current_index =
      Enum.find_index(socket.assigns[:channels], &(&1 == socket.assigns[:current_channel]))

    new_index = rem(current_index + shift, Enum.count(socket.assigns[:channels]))

    assign(socket, :current_channel, Enum.at(socket.assigns[:channels], new_index))
  end
end
