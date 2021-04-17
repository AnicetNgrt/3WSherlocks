defmodule Fakebusters.TopicsTest do
  use Fakebusters.DataCase

  alias Fakebusters.Topics

  describe "topics" do
    alias Fakebusters.Topics.Topic

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Topics.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Topics.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Topics.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Topics.create_topic(@valid_attrs)
      assert topic.name == "some name"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{} = topic} = Topics.update_topic(topic, @update_attrs)
      assert topic.name == "some updated name"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_topic(topic, @invalid_attrs)
      assert topic == Topics.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Topics.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Topics.change_topic(topic)
    end
  end

  describe "topic_resources" do
    alias Fakebusters.Topics.TopicResource

    @valid_attrs %{link: "some link", name: "some name"}
    @update_attrs %{link: "some updated link", name: "some updated name"}
    @invalid_attrs %{link: nil, name: nil}

    def topic_resource_fixture(attrs \\ %{}) do
      {:ok, topic_resource} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Topics.create_topic_resource()

      topic_resource
    end

    test "list_topic_resources/0 returns all topic_resources" do
      topic_resource = topic_resource_fixture()
      assert Topics.list_topic_resources() == [topic_resource]
    end

    test "get_topic_resource!/1 returns the topic_resource with given id" do
      topic_resource = topic_resource_fixture()
      assert Topics.get_topic_resource!(topic_resource.id) == topic_resource
    end

    test "create_topic_resource/1 with valid data creates a topic_resource" do
      assert {:ok, %TopicResource{} = topic_resource} = Topics.create_topic_resource(@valid_attrs)
      assert topic_resource.link == "some link"
      assert topic_resource.name == "some name"
    end

    test "create_topic_resource/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic_resource(@invalid_attrs)
    end

    test "update_topic_resource/2 with valid data updates the topic_resource" do
      topic_resource = topic_resource_fixture()
      assert {:ok, %TopicResource{} = topic_resource} = Topics.update_topic_resource(topic_resource, @update_attrs)
      assert topic_resource.link == "some updated link"
      assert topic_resource.name == "some updated name"
    end

    test "update_topic_resource/2 with invalid data returns error changeset" do
      topic_resource = topic_resource_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_topic_resource(topic_resource, @invalid_attrs)
      assert topic_resource == Topics.get_topic_resource!(topic_resource.id)
    end

    test "delete_topic_resource/1 deletes the topic_resource" do
      topic_resource = topic_resource_fixture()
      assert {:ok, %TopicResource{}} = Topics.delete_topic_resource(topic_resource)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_topic_resource!(topic_resource.id) end
    end

    test "change_topic_resource/1 returns a topic_resource changeset" do
      topic_resource = topic_resource_fixture()
      assert %Ecto.Changeset{} = Topics.change_topic_resource(topic_resource)
    end
  end

  describe "topic_experts" do
    alias Fakebusters.Topics.TopicExpert

    @valid_attrs %{description: "some description", grade: 42}
    @update_attrs %{description: "some updated description", grade: 43}
    @invalid_attrs %{description: nil, grade: nil}

    def topic_expert_fixture(attrs \\ %{}) do
      {:ok, topic_expert} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Topics.create_topic_expert()

      topic_expert
    end

    test "list_topic_experts/0 returns all topic_experts" do
      topic_expert = topic_expert_fixture()
      assert Topics.list_topic_experts() == [topic_expert]
    end

    test "get_topic_expert!/1 returns the topic_expert with given id" do
      topic_expert = topic_expert_fixture()
      assert Topics.get_topic_expert!(topic_expert.id) == topic_expert
    end

    test "create_topic_expert/1 with valid data creates a topic_expert" do
      assert {:ok, %TopicExpert{} = topic_expert} = Topics.create_topic_expert(@valid_attrs)
      assert topic_expert.description == "some description"
      assert topic_expert.grade == 42
    end

    test "create_topic_expert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Topics.create_topic_expert(@invalid_attrs)
    end

    test "update_topic_expert/2 with valid data updates the topic_expert" do
      topic_expert = topic_expert_fixture()
      assert {:ok, %TopicExpert{} = topic_expert} = Topics.update_topic_expert(topic_expert, @update_attrs)
      assert topic_expert.description == "some updated description"
      assert topic_expert.grade == 43
    end

    test "update_topic_expert/2 with invalid data returns error changeset" do
      topic_expert = topic_expert_fixture()
      assert {:error, %Ecto.Changeset{}} = Topics.update_topic_expert(topic_expert, @invalid_attrs)
      assert topic_expert == Topics.get_topic_expert!(topic_expert.id)
    end

    test "delete_topic_expert/1 deletes the topic_expert" do
      topic_expert = topic_expert_fixture()
      assert {:ok, %TopicExpert{}} = Topics.delete_topic_expert(topic_expert)
      assert_raise Ecto.NoResultsError, fn -> Topics.get_topic_expert!(topic_expert.id) end
    end

    test "change_topic_expert/1 returns a topic_expert changeset" do
      topic_expert = topic_expert_fixture()
      assert %Ecto.Changeset{} = Topics.change_topic_expert(topic_expert)
    end
  end
end
