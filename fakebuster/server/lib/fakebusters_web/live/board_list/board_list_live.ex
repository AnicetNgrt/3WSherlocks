defmodule FakebustersWeb.BoardListLive do
  use FakebustersWeb, :live_view
  use Phoenix.HTML
  import FakebustersWeb.TimeHelpers
  alias Fakebusters.Boards
  alias Fakebusters.Boards.Board
  alias FakebustersWeb.LiveComponents.BoardPreview

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> refresh_list()

    Boards.subscribe_globally()

    {:ok, socket}
  end

  @impl true
  def handle_info({Boards, _, _}, socket) do
    {:noreply, refresh_list(socket)}
  end

  defp refresh_list(socket) do
    assign(socket, :boards, Boards.list_boards())
  end
end
