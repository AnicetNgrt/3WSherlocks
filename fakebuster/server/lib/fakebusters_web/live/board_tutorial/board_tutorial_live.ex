defmodule FakebustersWeb.BoardTutorialLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML

  @impl true
  def mount(params, _session, socket) do
    socket = socket
    |> assign(:show_tutorial, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("show_tutorial", _, socket) do
    {:noreply,
      assign(
        socket,
        :show_tutorial,
        not socket.assigns[:show_tutorial]
      )}
  end
end
