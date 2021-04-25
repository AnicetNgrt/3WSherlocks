defmodule FakebustersWeb.BoardVotesResultsLive do
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

    Boards.subscribe_to_board_channel(board.id, :votes)

    votes = Boards.get_votes_for_board(board.id)

    {:ok, apply_votes(socket, votes)}
  end

  @impl true
  def handle_info({Boards, :new, %BoardVote{side: side, value: value}} = vote, socket) do
    votes = [vote | socket.assigns[:votes]]

    {:noreply, apply_votes(socket, votes)}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp calculate_value(votes, side) do
    Enum.filter(votes, &(&1.side == side))
    |> Enum.reduce(0, &(&1.value + &2))
  end

  defp apply_votes(socket, votes) do
    socket
    |> assign(:votes, votes)
    |> assign(:value_truthy, calculate_value(votes, 0))
    |> assign(:value_false, calculate_value(votes, 1))
    |> assign(:percent_truthy, calculate_percentage(votes, 0))
    |> assign(:percent_false, calculate_percentage(votes, 1))
  end

  defp calculate_percentage(votes, side) do
    {count_side, count_others} =
      Enum.reduce(votes, {0, 0}, fn (el, {count_side, count_others}) ->
        if el.side == side do
          {count_side + 1, count_others}
        else
          {count_side, count_others + 1}
        end
      end)

    if count_side != 0 do
      ((count_side + count_others) / count_side) * 100
    else
      0
    end
  end
end
