defmodule FakebustersWeb.BoardCreationLive do
  use FakebustersWeb, :live_view
  use Phoenix.HTML
  import FakebustersWeb.TimeHelpers
  alias Fakebusters.Boards
  alias Fakebusters.Boards.Board
  alias Fakebusters.Topics
  alias FakebustersWeb.LiveComponents, as: LC

  @duration_min 9

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
      |> assign(:duration_min, @duration_min)
      |> assign(
        :topics,
        Enum.map(Topics.list_topics_sort_names_asc(), &{&1.name, &1.id})
      )
      |> assign(:human_readable_time, human_readable_time(calculate_duration(@duration_min)))
      |> assign(:changeset, Boards.change_board(%Board{}, %{}))

    {:ok, socket}
  end

  def handle_event("show_form", _, socket), do: {:noreply, assign(socket, :show_form, true)}

  def handle_event("show_form_explanation", _, socket),
    do:
      {:noreply,
       assign(socket, :show_form_explanation, not socket.assigns[:show_form_explanation])}

  def handle_event("validate", %{"board" => params}, socket) do
    params = fix_duration(params)

    changeset =
      %Board{}
      |> Boards.change_board(params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)

    socket =
      if Map.has_key?(params, "duration_sec") do
        hrt = human_readable_time(params["duration_sec"])

        assign(
          socket,
          human_readable_time: hrt
        )
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event("save", %{"board" => params}, socket) do
    params = fix_duration(params)

    case Boards.create_board(params) do
      {:ok, board} ->
        {:noreply,
         socket
         |> put_flash(:info, "Investigation created")
         |> assign(:show_form, false)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp fix_duration(board) do
    case Map.pop(board, "duration_sec") do
      {nil, new_board} ->
        new_board

      {number, new_board} ->
        {number, _} = Integer.parse(number)
        number = calculate_duration(number)

        Map.put(new_board, "duration_sec", number)
    end
  end

  defp calculate_duration(duration) do
    (trunc(Math.exp((duration - 5) / 10)) * 600 - 5)
    |> if_sup_chunk_by(60)
    |> if_sup_chunk_by(120)
    |> if_sup_chunk_by(600)
    |> if_sup_chunk_by(3600)
    |> if_sup_chunk_by(3600 * 24)
  end
end
