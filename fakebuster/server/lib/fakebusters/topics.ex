defmodule Fakebusters.Topics do
  @moduledoc """
  The Topics context.
  """

  import Ecto.Query, warn: false
  alias Fakebusters.Repo

  alias Fakebusters.Topics.Topic

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Repo.all(Topic)
  end

  @doc """
  Gets a single topic.

  Raises `Ecto.NoResultsError` if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

      iex> get_topic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Ecto.Changeset{data: %Topic{}}

  """
  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end

  alias Fakebusters.Topics.TopicResource

  @doc """
  Returns the list of topic_resources.

  ## Examples

      iex> list_topic_resources()
      [%TopicResource{}, ...]

  """
  def list_topic_resources do
    Repo.all(TopicResource)
  end

  @doc """
  Gets a single topic_resource.

  Raises `Ecto.NoResultsError` if the Topic resource does not exist.

  ## Examples

      iex> get_topic_resource!(123)
      %TopicResource{}

      iex> get_topic_resource!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic_resource!(id), do: Repo.get!(TopicResource, id)

  @doc """
  Creates a topic_resource.

  ## Examples

      iex> create_topic_resource(%{field: value})
      {:ok, %TopicResource{}}

      iex> create_topic_resource(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic_resource(attrs \\ %{}) do
    %TopicResource{}
    |> TopicResource.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic_resource.

  ## Examples

      iex> update_topic_resource(topic_resource, %{field: new_value})
      {:ok, %TopicResource{}}

      iex> update_topic_resource(topic_resource, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic_resource(%TopicResource{} = topic_resource, attrs) do
    topic_resource
    |> TopicResource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic_resource.

  ## Examples

      iex> delete_topic_resource(topic_resource)
      {:ok, %TopicResource{}}

      iex> delete_topic_resource(topic_resource)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic_resource(%TopicResource{} = topic_resource) do
    Repo.delete(topic_resource)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic_resource changes.

  ## Examples

      iex> change_topic_resource(topic_resource)
      %Ecto.Changeset{data: %TopicResource{}}

  """
  def change_topic_resource(%TopicResource{} = topic_resource, attrs \\ %{}) do
    TopicResource.changeset(topic_resource, attrs)
  end

  alias Fakebusters.Topics.TopicExpert

  @doc """
  Returns the list of topic_experts.

  ## Examples

      iex> list_topic_experts()
      [%TopicExpert{}, ...]

  """
  def list_topic_experts do
    Repo.all(TopicExpert)
  end

  @doc """
  Gets a single topic_expert.

  Raises `Ecto.NoResultsError` if the Topic expert does not exist.

  ## Examples

      iex> get_topic_expert!(123)
      %TopicExpert{}

      iex> get_topic_expert!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic_expert!(id), do: Repo.get!(TopicExpert, id)

  @doc """
  Creates a topic_expert.

  ## Examples

      iex> create_topic_expert(%{field: value})
      {:ok, %TopicExpert{}}

      iex> create_topic_expert(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topic_expert(attrs \\ %{}) do
    %TopicExpert{}
    |> TopicExpert.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a topic_expert.

  ## Examples

      iex> update_topic_expert(topic_expert, %{field: new_value})
      {:ok, %TopicExpert{}}

      iex> update_topic_expert(topic_expert, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topic_expert(%TopicExpert{} = topic_expert, attrs) do
    topic_expert
    |> TopicExpert.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a topic_expert.

  ## Examples

      iex> delete_topic_expert(topic_expert)
      {:ok, %TopicExpert{}}

      iex> delete_topic_expert(topic_expert)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topic_expert(%TopicExpert{} = topic_expert) do
    Repo.delete(topic_expert)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topic_expert changes.

  ## Examples

      iex> change_topic_expert(topic_expert)
      %Ecto.Changeset{data: %TopicExpert{}}

  """
  def change_topic_expert(%TopicExpert{} = topic_expert, attrs \\ %{}) do
    TopicExpert.changeset(topic_expert, attrs)
  end
end
