defmodule Fakebusters.Boards do
  @moduledoc """
  The Boards context.
  """

  import Ecto.Query, warn: false
  alias Fakebusters.Repo

  alias Fakebusters.Boards.Board

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
end
