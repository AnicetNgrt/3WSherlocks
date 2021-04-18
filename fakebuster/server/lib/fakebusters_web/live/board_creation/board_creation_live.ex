defmodule FakebustersWeb.BoardCreationLive do
  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Boards
  alias Fakebusters.Boards.Board
  alias FakebustersWeb.LiveComponents, as: LC

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        :changeset,
        Fakebusters.Accounts.change_user_registration(%Fakebusters.Accounts.User{})
      )
      |> assign(:show_form, false)
      |> assign(:show_form_explanation, false)
      |> assign(:changeset, Boards.change_board(%Board{}, %{}))

    {:ok, socket}
  end

  def handle_event("show_form", _, socket), do: {:noreply, assign(socket, :show_form, true)}

  def handle_event("show_form_explanation", _, socket),
    do: {:noreply, assign(socket, :show_form_explanation, not socket.assigns[:show_form_explanation])}

  def handle_event("validate", %{"board" => params}, socket) do
    changeset =
      %Board{}
      |> Boards.change_board(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"board" => params}, socket) do
    case Boards.create_board(params) do
      {:ok, board} ->
        {:noreply,
         socket
         |> put_flash(:info, "board created")
         |> assign(:show_form, false)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
