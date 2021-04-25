defmodule FakebustersWeb.BoardMsgFeedLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Accounts
  alias Fakebusters.Boards
  alias FakebustersWeb.LiveComponents.BoardMsg
  alias Fakebusters.Boards.{BoardMember, Channels}

  @impl true
  def mount(
        params,
        %{"board" => board, "role" => role, "user" => user, "channel" => channel} = session,
        socket
      ) do
    Boards.subscribe_to_board_channel(board.id, channel)
    messages = fetch_messages(board.id, channel)

    socket =
      socket
      |> assign(:board, board)
      |> assign(:current_user, user)
      |> assign(:role, role)
      |> assign(:textable, Channels.textable_channel?(channel))
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

  def handle_event("assign", %{"role" => role, "user_id" => user_id}, socket) do
    role = case role do
      "1" -> 1
      "2" -> 2
      "3" -> 3
      "4" -> 4
      _ -> nil
    end

    Boards.add_board_member_delete_request(%{
      user_id: user_id,
      board_id: socket.assigns.board.id,
      role: role
    })

    {:noreply, socket}
  end

  @impl true
  def handle_info({Boards, :new, message}, socket) do
    {:noreply,
      assign(socket, [message | socket.assigns[:messages]])}
  end

  @impl true
  def handle_info({Boards, :delete, message}, socket) do
    {:noreply,
      assign(socket, List.delete(socket.assigns[:messages], message))}
  end

  defp fetch_messages(board_id, channel) when is_atom(channel) do
    Boards.board_channel_messages(board_id, channel)
  end

  defp fetch_messages(_, _, _) do
    []
  end

  defp message_header(date, author, author_role, false = _is_author) do
    """
    #{date} ▶ #{author.username} #{author.emoji} [#{author_role}]
    """
  end

  defp message_header(date, author, author_role, true = _is_author) do
    """
    [#{author_role}] #{author.emoji} #{author.username} ◀ #{date}
    """
  end

  defp author_styles(is_author) do
    """
    text-yellow-300 text-xs pb-1
    max-w-full
    """ <>
      if is_author do
        """
          self-end
        """
      else
        """
          self-start
        """
      end
  end

  defp message_styles(is_author) do
    """
      flex
      flex-col
      px-6 py-4
      mb-4
      rounded-xl
      w-max
      max-w-full
    """ <>
      if is_author do
        """
          self-end
          rounded-tr-none
          bg-indigo-600
        """
      else
        """
          rounded-tl-none
          bg-indigo-800
        """
      end
  end

  defp message_input_styles() do
    "
    appearance-none
    text-md
    w-full h-32
    px-3 py-2
    focus:outline-none focus:ring-2 ring-offset-2 ring-black
    rounded-md rounded-r-none
    border-2 border-r-0 border-indigo-800
    bg-transparent
    scrollbar scrollbar-thumb-indigo-600 scrollbar-track-indigo-900
    resize-none
    "
  end
end
