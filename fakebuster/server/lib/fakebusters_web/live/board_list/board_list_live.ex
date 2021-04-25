defmodule FakebustersWeb.BoardListLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Boards
  alias Fakebusters.Topics
  alias Fakebusters.Accounts
  alias FakebustersWeb.LiveComponents.BoardPreview

  @impl true
  def mount(_params, %{"modes" => modes} = session, socket) do
    user = if Map.has_key?(session, "user_token") do
      Accounts.get_user_by_session_token(session["user_token"])
    else
      nil
    end

    socket =
      socket
      |> assign(:modes, modes)
      |> assign(:current_user, user)
      |> refresh_list()

    Boards.subscribe_globally()

    {:ok, socket}
  end

  @impl true
  def handle_info({Boards, _, _}, socket) do
    {:noreply, refresh_list(socket)}
  end

  defp refresh_list(socket) do
    user = socket.assigns[:current_user]

    boards =
      Boards.list_boards()
      |> filter(socket)
      |> Enum.map(&Map.put(&1, :members_count, Boards.members_count(&1)))
      |> Enum.map(&Map.put(&1, :topic_name, Topics.get_topic!(&1.topic_id).name))
      |> Enum.map(&Map.put(&1, :is_member, Boards.is_member?(&1, user)))
      |> Enum.map(&Map.put(&1, :judge, Boards.judge(&1)))

    assign(socket, :boards, boards)
  end

  defp filter(boards, socket) do
    Enum.reduce(socket.assigns[:modes], boards, fn (mode, boards) ->
      case mode do
        :user ->
          Enum.filter(boards, &Boards.is_member?(&1, socket.assigns[:current_user]))

        :ongoing ->
          Enum.filter(boards, &(not &1.finished))

        :finished ->
          Enum.filter(boards, &(&1.finished))
      end
    end)
  end
end
