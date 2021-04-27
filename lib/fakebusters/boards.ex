defmodule Fakebusters.Boards do
  @moduledoc """
  The Boards context.
  """

  import Ecto.Query, warn: false
  alias Fakebusters.Repo

  alias Fakebusters.Accounts.User

  alias Fakebusters.Boards.Board
  alias Fakebusters.Boards.BoardMember
  alias Fakebusters.Boards.JoinRequest
  alias Fakebusters.Boards.Channels
  alias Fakebusters.Boards.BoardMessage

  @topic inspect(__MODULE__)

  def subscribe_globally() do
    Phoenix.PubSub.subscribe(Fakebusters.PubSub, @topic)
  end

  def subscribe_to_board_channel(board_id, channel) do
    Phoenix.PubSub.subscribe(Fakebusters.PubSub, "#{@topic}:B#{board_id}/#{channel}")
  end

  def notify_global_subscribers(payload, event) do
    Phoenix.PubSub.broadcast(
      Fakebusters.PubSub,
      @topic,
      {__MODULE__, event, payload}
    )
  end

  def notify_board_channel_subscribers(board_id, channel, event, payload) do
    Phoenix.PubSub.broadcast(
      Fakebusters.PubSub,
      "#{@topic}:B#{board_id}/#{channel}",
      {__MODULE__, event, payload}
    )
  end

  def board_channel_messages(board_id, :events) do
    Enum.sort(
      board_join_requests(board_id),
      &(&1.inserted_at > &2.inserted_at)
    )
  end

  def board_channel_messages(board_id, :members) do
    Enum.sort(
      board_members(board_id),
      &(&1.inserted_at > &2.inserted_at)
    )
  end

  def board_channel_messages(board_id, :votes) do
    get_votes_for_board(board_id)
  end

  def board_channel_messages(board_id, channel_name) do
    num = Channels.channel_to_num(channel_name)
    textable = Channels.textable_channel?(num)

    if textable do
      query =
        from mc in BoardMessage,
          where: [board_id: ^board_id, channel: ^num]

      Repo.all(query)
    else
      []
    end
  end

  @doc """
  Returns the list of boards.

  ## Examples

      iex> list_boards()
      [%Board{}, ...]

  """
  def list_boards do
    Repo.all(Board)
  end

  def members_count(%Board{id: id} = _board) do
    query =
      from bm in BoardMember,
        where: bm.board_id == ^id

    Repo.aggregate(query, :count)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id), do: Repo.get!(Board, id)

  @doc """
  Gets a single board safely.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      nil

  """
  def get_board(id), do: Repo.get(Board, id)

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    res =
      %Board{}
      |> Board.changeset(attrs)
      |> Repo.insert()

    case res do
      {:ok, %Board{} = board} ->
        notify_global_subscribers(board, :board_created)

      _ ->
        nil
    end

    res
  end

  def seconds_left(%Board{duration_sec: ds, inserted_at: inserted_at}) do
    now_ndt = NaiveDateTime.utc_now()

    NaiveDateTime.add(inserted_at, ds, :second)
    |> NaiveDateTime.diff(now_ndt, :second)
  end

  def create_board_with_judge(attrs, %User{id: id} = _judge) do
    res =
      Repo.transaction(fn ->
        board = Repo.insert!(change_board(%Board{}, attrs))

        Repo.insert!(
          change_board_member(%BoardMember{}, %{
            role: 0,
            user_id: id,
            board_id: board.id
          })
        )

        board
      end)

    case res do
      {:ok, %Board{} = board} ->
        notify_global_subscribers(board, :board_created)

      _ ->
        nil
    end

    res
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    res =
      board
      |> Board.changeset(attrs)
      |> Repo.update()

    case res do
      {:ok, %Board{} = new_board} ->
        notify_global_subscribers(new_board, :board_updated)

      _ ->
        nil
    end

    res
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    res = Repo.delete(board)

    case res do
      {:ok, %Board{} = board} ->
        notify_global_subscribers(board, :board_deleted)

      _ ->
        nil
    end

    res
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end

  @doc """
  Returns the list of board_members.

  ## Examples

      iex> list_board_members()
      [%BoardMember{}, ...]

  """
  def list_board_members do
    Repo.all(BoardMember)
  end

  def judge(%Board{id: id} = _board) do
    members = from bm in BoardMember, where: [board_id: ^id, role: 0]

    users = from u in User, join: bm in ^members, on: [user_id: u.id], select: u

    Repo.one(users)
  end

  def is_member?(%Board{id: board_id} = _board, %User{id: user_id} = _user) do
    query =
      from bm in "board_members",
        where: [user_id: ^user_id, board_id: ^board_id]

    Repo.aggregate(query, :count) > 0
  end

  def is_member?(_, _), do: false

  def role(%Board{id: board_id}, %User{id: user_id}) do
    query =
      from bm in BoardMember,
        where: [user_id: ^user_id, board_id: ^board_id]

    case Repo.one(query) do
      %BoardMember{role: role} -> role
      _ -> nil
    end
  end

  def add_board_member_delete_request(
        %{
          user_id: user_id,
          board_id: board_id
        } = attrs
      ) do
    {:ok, _} =
      Repo.transaction(fn ->
        %BoardMember{} = Repo.insert!(change_board_member(%BoardMember{}, attrs))

        query =
          from jr in JoinRequest,
            where: [board_id: ^board_id, user_id: ^user_id]

        jr = Repo.one(query)

        {:ok, %JoinRequest{}} = delete_join_request(jr)

        jr
      end)
  end

  @doc """
  Gets a single board_member.

  Raises `Ecto.NoResultsError` if the Board member does not exist.

  ## Examples

      iex> get_board_member!(123)
      %BoardMember{}

      iex> get_board_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_member!(id), do: Repo.get!(BoardMember, id)

  @doc """
  Creates a board_member.

  ## Examples

      iex> create_board_member(%{field: value})
      {:ok, %BoardMember{}}

      iex> create_board_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board_member(attrs \\ %{}) do
    res = %BoardMember{}
    |> BoardMember.changeset(attrs)
    |> Repo.insert()

    case res do
      {:ok, bm} ->
        notify_board_channel_subscribers(bm.board_id, :members, :new, bm)
        res

      _ ->
        res
    end
  end

  def board_members(board_id) do
    query =
      from bm in BoardMember,
        where: [board_id: ^board_id]

    Repo.all(query)
  end

  @doc """
  Updates a board_member.

  ## Examples

      iex> update_board_member(board_member, %{field: new_value})
      {:ok, %BoardMember{}}

      iex> update_board_member(board_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board_member(%BoardMember{} = board_member, attrs) do
    board_member
    |> BoardMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board_member.

  ## Examples

      iex> delete_board_member(board_member)
      {:ok, %BoardMember{}}

      iex> delete_board_member(board_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board_member(%BoardMember{} = board_member) do
    Repo.delete(board_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board_member changes.

  ## Examples

      iex> change_board_member(board_member)
      %Ecto.Changeset{data: %BoardMember{}}

  """
  def change_board_member(%BoardMember{} = board_member, attrs \\ %{}) do
    BoardMember.changeset(board_member, attrs)
  end

  @doc """
  Returns the list of join_requests.

  ## Examples

      iex> list_join_requests()
      [%JoinRequest{}, ...]

  """
  def list_join_requests do
    Repo.all(JoinRequest)
  end

  @doc """
  Gets a single join_request.

  Raises `Ecto.NoResultsError` if the Join request does not exist.

  ## Examples

      iex> get_join_request!(123)
      %JoinRequest{}

      iex> get_join_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_join_request!(id), do: Repo.get!(JoinRequest, id)

  def user_already_has_requested?(%User{id: user_id}, %Board{id: board_id}) do
    query =
      from jr in JoinRequest,
        where: [user_id: ^user_id, board_id: ^board_id]

    Repo.aggregate(query, :count) > 0
  end

  def board_join_requests(board_id) do
    query =
      from jr in JoinRequest,
        where: [board_id: ^board_id]

    Repo.all(query)
  end

  @doc """
  Creates a join_request.

  ## Examples

      iex> create_join_request(%{field: value})
      {:ok, %JoinRequest{}}

      iex> create_join_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_join_request(attrs \\ %{}) do
    res =
      %JoinRequest{}
      |> JoinRequest.changeset(attrs)
      |> Repo.insert()

    case res do
      {:ok, jr} ->
        notify_board_channel_subscribers(jr.board_id, :events, :new, jr)
        res

      _ ->
        res
    end
  end

  @doc """
  Updates a join_request.

  ## Examples

      iex> update_join_request(join_request, %{field: new_value})
      {:ok, %JoinRequest{}}

      iex> update_join_request(join_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_join_request(%JoinRequest{} = join_request, attrs) do
    join_request
    |> JoinRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a join_request.

  ## Examples

      iex> delete_join_request(join_request)
      {:ok, %JoinRequest{}}

      iex> delete_join_request(join_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_join_request(%JoinRequest{} = join_request) do
    res = Repo.delete(join_request)

    case res do
      {:ok, jr} ->
        notify_board_channel_subscribers(jr.board_id, :events, :delete, jr)
        res

      _ ->
        res
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking join_request changes.

  ## Examples

      iex> change_join_request(join_request)
      %Ecto.Changeset{data: %JoinRequest{}}

  """
  def change_join_request(%JoinRequest{} = join_request, attrs \\ %{}) do
    JoinRequest.changeset(join_request, attrs)
  end

  @doc """
  Returns the list of board_messages.

  ## Examples

      iex> list_board_messages()
      [%BoardMessage{}, ...]

  """
  def list_board_messages do
    Repo.all(BoardMessage)
  end

  @doc """
  Gets a single board_message.

  Raises `Ecto.NoResultsError` if the Board message does not exist.

  ## Examples

      iex> get_board_message!(123)
      %BoardMessage{}

      iex> get_board_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_message!(id), do: Repo.get!(BoardMessage, id)

  @doc """
  Creates a board_message.

  ## Examples

      iex> create_board_message(%{field: value})
      {:ok, %BoardMessage{}}

      iex> create_board_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board_message(attrs \\ %{}) do
    res =
      %BoardMessage{}
      |> BoardMessage.changeset(attrs)
      |> Repo.insert()

    case res do
      {:ok, bm} ->
        notify_board_channel_subscribers(
          bm.board_id,
          Channels.num_to_channel(bm.channel),
          :new,
          bm
        )

        res

      _ ->
        res
    end
  end

  @doc """
  Updates a board_message.

  ## Examples

      iex> update_board_message(board_message, %{field: new_value})
      {:ok, %BoardMessage{}}

      iex> update_board_message(board_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board_message(%BoardMessage{} = board_message, attrs) do
    board_message
    |> BoardMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board_message.

  ## Examples

      iex> delete_board_message(board_message)
      {:ok, %BoardMessage{}}

      iex> delete_board_message(board_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board_message(%BoardMessage{} = board_message) do
    Repo.delete(board_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board_message changes.

  ## Examples

      iex> change_board_message(board_message)
      %Ecto.Changeset{data: %BoardMessage{}}

  """
  def change_board_message(%BoardMessage{} = board_message, attrs \\ %{}) do
    BoardMessage.changeset(board_message, attrs)
  end

  alias Fakebusters.Boards.BoardVote

  @doc """
  Returns the list of board_votes.

  ## Examples

      iex> list_board_votes()
      [%BoardVote{}, ...]

  """
  def list_board_votes do
    Repo.all(BoardVote)
  end

  def get_votes_for_board(board_id) do
    query =
      from jr in BoardVote,
        where: [board_id: ^board_id]

    Repo.all(query)
  end

  def user_already_has_voted?(%User{id: user_id}, %Board{id: board_id}) do
    query =
      from jr in BoardVote,
        where: [user_id: ^user_id, board_id: ^board_id]

    Repo.aggregate(query, :count) > 0
  end

  @doc """
  Gets a single board_vote.

  Raises `Ecto.NoResultsError` if the Board vote does not exist.

  ## Examples

      iex> get_board_vote!(123)
      %BoardVote{}

      iex> get_board_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_vote!(id), do: Repo.get!(BoardVote, id)

  @doc """
  Creates a board_vote.

  ## Examples

      iex> create_board_vote(%{field: value})
      {:ok, %BoardVote{}}

      iex> create_board_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board_vote(attrs, voter_role) do
    res =
      %BoardVote{}
      |> BoardVote.changeset(attrs, voter_role)
      |> Repo.insert()

    case res do
      {:ok, bv} ->
        notify_board_channel_subscribers(bv.board_id, :votes, :new, bv)
        res

      _ ->
        res
    end
  end

  @doc """
  Updates a board_vote.

  ## Examples

      iex> update_board_vote(board_vote, %{field: new_value})
      {:ok, %BoardVote{}}

      iex> update_board_vote(board_vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board_vote(%BoardVote{} = board_vote, attrs, voter_role) do
    board_vote
    |> BoardVote.changeset(attrs, voter_role)
    |> Repo.update()
  end

  @doc """
  Deletes a board_vote.

  ## Examples

      iex> delete_board_vote(board_vote)
      {:ok, %BoardVote{}}

      iex> delete_board_vote(board_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board_vote(%BoardVote{} = board_vote) do
    Repo.delete(board_vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board_vote changes.

  ## Examples

      iex> change_board_vote(board_vote)
      %Ecto.Changeset{data: %BoardVote{}}

  """
  def change_board_vote(%BoardVote{} = board_vote, attrs, voter_role) do
    BoardVote.changeset(board_vote, attrs, voter_role)
  end
end
