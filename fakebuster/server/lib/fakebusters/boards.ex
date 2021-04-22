defmodule Fakebusters.Boards do
  @moduledoc """
  The Boards context.
  """

  import Ecto.Query, warn: false
  alias Fakebusters.Repo

  alias Fakebusters.Accounts.User

  alias Fakebusters.Boards.Board
  alias Fakebusters.Boards.BoardMember

  @topic inspect(__MODULE__)

  def subscribe_globally() do
    Phoenix.PubSub.subscribe(Fakebusters.PubSub, @topic)
  end

  def notify_global_subscribers(payload, event) do
    Phoenix.PubSub.broadcast(
      Fakebusters.PubSub,
      @topic,
      {__MODULE__, event, payload}
    )
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
    query = from bm in "board_members",
      where: bm.board_id == ^id

    Repo.aggregate(query, :count)
  end

  def is_member?(%Board{id: board_id} = _board, %User{id: user_id} = _user) do
    query = from bm in "board_members",
      where: [user_id: ^user_id, board_id: ^board_id]

    Repo.aggregate(query, :count) > 0
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

  def create_board_with_judge(attrs, %User{id: id} = _judge) do
    res = Repo.transaction(fn ->
      board = Repo.insert!(change_board(%Board{}, attrs))
      Repo.insert!(change_board_member(%BoardMember{}, %{
        role: BoardMember.role(:judge),
        user_id: id,
        board_id: board.id
      }))

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
    %BoardMember{}
    |> BoardMember.changeset(attrs)
    |> Repo.insert()
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
end
