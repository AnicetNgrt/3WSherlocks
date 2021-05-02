defmodule FakebustersWeb.BoardListLive do
  @moduledoc false

  use FakebustersWeb, :live_view
  use Phoenix.HTML
  alias Fakebusters.Boards
  alias Fakebusters.Topics
  alias Fakebusters.Accounts
  alias FakebustersWeb.LiveComponents.BoardPreview

  @impl true
  def mount(_params, session, socket) do
    user =
      if Map.has_key?(session, "user_token") do
        Accounts.get_user_by_session_token(session["user_token"])
      else
        nil
      end

    socket =
      socket
      |> assign(:filter_search, "")
      |> assign(:filter_membership, "any")
      |> assign(:filter_topic_id, nil)
      |> assign(:filter_state, "any")
      |> assign(:current_user, user)
      |> assign(
        :topics,
        Enum.map(Topics.list_topics_sort_names_asc(), &{&1.name, &1.id})
      )
      |> refresh_list()

    Boards.subscribe_globally()

    {:ok, socket}
  end

  @impl true
  def handle_info({Boards, _, _}, socket) do
    {:noreply, refresh_list(socket)}
  end

  @impl true
  def handle_event(
        "filter",
        %{
          "filter" =>
            %{
              "search_phrase" => search,
              "state" => state,
              "topic_id" => topic_id
            } = filter
        },
        socket
      ) do
    membership =
      if Map.has_key?(filter, "membership") do
        filter["membership"]
      else
        "any"
      end

    topic_id =
      case Integer.parse(topic_id, 10) do
        {id, _} -> id
        _ -> nil
      end

    socket =
      socket
      |> assign(:filter_search, search)
      |> assign(:filter_membership, membership)
      |> assign(:filter_topic_id, topic_id)
      |> assign(:filter_state, state)
      |> refresh_list()

    {:noreply, socket}
  end

  defp refresh_list(socket) do
    boards = search_boards(socket)
    |> augment_and_filter_list(socket)

    assign(socket, :boards, boards)
  end

  defp search_boards(socket) do
    search = socket.assigns[:filter_search]

    if String.length(search) > 1 do
      Boards.search_boards(search)
    else
      Boards.list_boards()
    end
  end

  defp augment_and_filter_list(list, socket) do
    user = socket.assigns[:current_user]
    membership = socket.assigns[:filter_membership]
    topic_id = socket.assigns[:filter_topic_id]
    state = socket.assigns[:filter_state]

    list
    |> Enum.map(&Map.put(&1, :members_count, Boards.members_count(&1)))
    |> Enum.map(&Map.put(&1, :topic_name, Topics.get_topic!(&1.topic_id).name))
    |> Enum.map(&Map.put(&1, :is_member, Boards.is_member?(&1, user)))
    |> Enum.map(&Map.put(&1, :judge, Boards.judge(&1)))
    |> Enum.filter(&(topic_id == nil or &1.topic_id == topic_id))
    |> Enum.filter(&filter_membership(&1, membership))
    |> Enum.filter(&filter_state(&1, state))
  end

  defp filter_membership(el, membership),
    do:
      (membership == "member" and el.is_member) or
        (membership == "outsider" and not el.is_member) or
        membership == "any"

  defp filter_state(el, state),
    do:
      (state == "finished" and el.finished) or
        (state == "ongoing" and not el.finished) or
        state == "any"
end
