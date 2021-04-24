defmodule FakebustersWeb.JoinRequestLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Accounts
  alias Fakebusters.Boards
  alias Fakebusters.Boards.JoinRequest

  @impl true
  def mount(params, %{"board" => board} = session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])

    socket =
      socket
      |> assign(:board, board)
      |> assign(
        :changeset,
        Boards.change_join_request(%JoinRequest{})
      )
      |> assign(:current_user, user)

    {:ok, socket}
  end

  def handle_event("validate", %{"join_request" => params}, socket) do
    changeset =
      %JoinRequest{}
      |> Boards.change_join_request(params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)

    {:noreply, socket}
  end

  def handle_event("save", %{"join_request" => params}, socket) do
    case Boards.create_join_request(params) do
      {:ok, _jr} ->
        {:noreply,
         socket
         |> put_flash(:info, "Join request sent")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
