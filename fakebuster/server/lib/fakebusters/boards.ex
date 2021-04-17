defmodule Fakebusters.Boards do
  @moduledoc """
  The Boards context.
  """

  import Ecto.Query, warn: false
  alias Fakebusters.Repo

  alias Fakebusters.Boards.Board

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
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
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
    board
    |> Board.changeset(attrs)
    |> Repo.update()
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
    Repo.delete(board)
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

  alias Fakebusters.Boards.BoardTopic

  @doc """
  Returns the list of board_topics.

  ## Examples

      iex> list_board_topics()
      [%BoardTopic{}, ...]

  """
  def list_board_topics do
    Repo.all(BoardTopic)
  end

  @doc """
  Gets a single board_topic.

  Raises `Ecto.NoResultsError` if the Board topic does not exist.

  ## Examples

      iex> get_board_topic!(123)
      %BoardTopic{}

      iex> get_board_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_topic!(id), do: Repo.get!(BoardTopic, id)

  @doc """
  Creates a board_topic.

  ## Examples

      iex> create_board_topic(%{field: value})
      {:ok, %BoardTopic{}}

      iex> create_board_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board_topic(attrs \\ %{}) do
    %BoardTopic{}
    |> BoardTopic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board_topic.

  ## Examples

      iex> update_board_topic(board_topic, %{field: new_value})
      {:ok, %BoardTopic{}}

      iex> update_board_topic(board_topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board_topic(%BoardTopic{} = board_topic, attrs) do
    board_topic
    |> BoardTopic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board_topic.

  ## Examples

      iex> delete_board_topic(board_topic)
      {:ok, %BoardTopic{}}

      iex> delete_board_topic(board_topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board_topic(%BoardTopic{} = board_topic) do
    Repo.delete(board_topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board_topic changes.

  ## Examples

      iex> change_board_topic(board_topic)
      %Ecto.Changeset{data: %BoardTopic{}}

  """
  def change_board_topic(%BoardTopic{} = board_topic, attrs \\ %{}) do
    BoardTopic.changeset(board_topic, attrs)
  end

  alias Fakebusters.Boards.BoardMessage

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
    %BoardMessage{}
    |> BoardMessage.changeset(attrs)
    |> Repo.insert()
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

  alias Fakebusters.Boards.BoardMember

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

  alias Fakebusters.Boards.BoardResource

  @doc """
  Returns the list of board_resources.

  ## Examples

      iex> list_board_resources()
      [%BoardResource{}, ...]

  """
  def list_board_resources do
    Repo.all(BoardResource)
  end

  @doc """
  Gets a single board_resource.

  Raises `Ecto.NoResultsError` if the Board resource does not exist.

  ## Examples

      iex> get_board_resource!(123)
      %BoardResource{}

      iex> get_board_resource!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board_resource!(id), do: Repo.get!(BoardResource, id)

  @doc """
  Creates a board_resource.

  ## Examples

      iex> create_board_resource(%{field: value})
      {:ok, %BoardResource{}}

      iex> create_board_resource(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board_resource(attrs \\ %{}) do
    %BoardResource{}
    |> BoardResource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board_resource.

  ## Examples

      iex> update_board_resource(board_resource, %{field: new_value})
      {:ok, %BoardResource{}}

      iex> update_board_resource(board_resource, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board_resource(%BoardResource{} = board_resource, attrs) do
    board_resource
    |> BoardResource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board_resource.

  ## Examples

      iex> delete_board_resource(board_resource)
      {:ok, %BoardResource{}}

      iex> delete_board_resource(board_resource)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board_resource(%BoardResource{} = board_resource) do
    Repo.delete(board_resource)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board_resource changes.

  ## Examples

      iex> change_board_resource(board_resource)
      %Ecto.Changeset{data: %BoardResource{}}

  """
  def change_board_resource(%BoardResource{} = board_resource, attrs \\ %{}) do
    BoardResource.changeset(board_resource, attrs)
  end
end
