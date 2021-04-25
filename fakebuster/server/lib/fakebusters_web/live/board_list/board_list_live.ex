defmodule FakebustersWeb.BoardListLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Boards
  alias Fakebusters.Topics
  alias Fakebusters.Accounts
  alias FakebustersWeb.LiveComponents.BoardPreview

  @impl true
  def mount(_params, %{"mode" => mode} = session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    socket =
      socket
      |> assign(:mode, mode)
      |> assign(:current_user, user)
      |> refresh_list(mode)

    Boards.subscribe_globally()

    {:ok, socket}
  end

  @impl true
  def handle_info({Boards, _, _}, socket) do
    {:noreply, refresh_list(socket, socket.assigns[:mode])}
  end

  defp refresh_list(socket, _) do
    user = socket.assigns[:current_user]

    boards =
      Boards.list_boards()
      |> Enum.map(&Map.put(&1, :members_count, Boards.members_count(&1)))
      |> Enum.map(&Map.put(&1, :topic_name, Topics.get_topic!(&1.topic_id).name))
      |> Enum.map(&Map.put(&1, :is_member, Boards.is_member?(&1, user)))
      |> Enum.map(&Map.put(&1, :judge, Boards.judge(&1)))

    assign(socket, :boards, boards)
  end
end
