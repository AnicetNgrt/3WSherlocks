defmodule FakebustersWeb.RoomCreationLive do
  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias FakebustersWeb.LiveComponents, as: LC

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:changeset, Fakebusters.Accounts.change_user_registration(%Fakebusters.Accounts.User{}))
    |> assign(:show_form, false)
    {:ok, socket}
  end

  def handle_event("show_form", _, socket) do
    {:noreply, assign(socket, :show_form, true)}
  end
end
