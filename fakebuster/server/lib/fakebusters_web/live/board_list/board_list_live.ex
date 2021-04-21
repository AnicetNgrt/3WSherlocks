defmodule FakebustersWeb.BoardListLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Boards
  alias FakebustersWeb.LiveComponents.BoardPreview

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
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
