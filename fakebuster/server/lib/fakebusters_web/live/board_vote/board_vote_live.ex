defmodule FakebustersWeb.BoardVoteLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Accounts
  alias Fakebusters.Boards
  alias Fakebusters.Boards.BoardVote

  @impl true
  def mount(params, %{"board" => board} = session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    role = Boards.role(board, user)

    vote_changeset = Boards.change_board_vote(%BoardVote{}, %{}, role)

    socket =
      socket
      |> assign(:board, board)
      |> assign(:current_user, user)
      |> assign(:vote_changeset, vote_changeset)
      |> assign(:already_voted, Boards.user_already_has_voted?(user, board))
      |> assign(:role, role)

    {:ok, socket}
  end

  def handle_event("validate", %{"board_vote" => params}, socket) do
    params =
      params
      |> Map.put("board_id", socket.assigns[:board].id)
      |> Map.put("user_id", socket.assigns[:current_user].id)

    changeset =
      %BoardVote{}
      |> Boards.change_board_vote(params, socket.assigns[:role])
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)
    IO.puts(inspect(changeset))

    {:noreply, socket}
  end

  def handle_event("save", %{"board_vote" => params}, socket) do
    params =
      params
      |> Map.put("board_id", socket.assigns[:board].id)
      |> Map.put("user_id", socket.assigns[:current_user].id)

    case Boards.create_board_vote(params, socket.assigns[:role]) do
      {:ok, _bv} ->
        {:noreply,
         socket
         |> assign(:already_voted, true)
         |> put_flash(:info, "Vote casted!")}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
