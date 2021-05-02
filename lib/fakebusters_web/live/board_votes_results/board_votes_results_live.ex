defmodule FakebustersWeb.BoardVotesResultsLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Boards
  alias Fakebusters.Boards.BoardVote

  @impl true
  def mount(_params, %{"board" => board} = _session, socket) do
    Boards.subscribe_to_board_channel(board.id, :votes)

    votes = Boards.get_votes_for_board(board.id)

    {:ok, apply_votes(socket, votes)}
  end

  @impl true
  def handle_info({Boards, :new, %BoardVote{} = vote}, socket) do
    votes = [vote | socket.assigns[:votes]]

    {:noreply, apply_votes(socket, votes)}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp apply_votes(socket, votes) do
    {value_t, value_f} = calculate_values(votes)
    {perc_t, perc_f} = calculate_percentages(value_t, value_f)

    socket
    |> assign(:votes, votes)
    |> assign(:value_truthy, value_t)
    |> assign(:value_false, value_f)
    |> assign(:percent_truthy, round(perc_t))
    |> assign(:percent_false, round(perc_f))
  end

  defp calculate_values(votes) do
    Enum.reduce(votes, {0, 0}, fn v, {value_t, value_f} ->
      if v.side == 0 do
        {value_t + v.value, value_f}
      else
        {value_t, value_f + v.value}
      end
    end)
  end

  defp calculate_percentages(value_t, value_f) do
    total = value_t + value_f
    fper = &(&1 / total * 100)

    if total != 0 do
      {fper.(value_t), fper.(value_f)}
    else
      {0, 0}
    end
  end
end
