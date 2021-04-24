defmodule FakebustersWeb.LiveComponents.BoardMsg do
  @moduledoc false

  use Phoenix.LiveComponent
  alias Fakebusters.Boards.JoinRequest

  def render(
        %{
          message: %JoinRequest{} = message,
          is_author: is_author
        } = assigns
      ) do
    preferred_role = human_readable_role(message.preferred_role)

    ~L"""
      <div class="<%= message_styles(is_author) %>">
        <p class="<%= author_styles(is_author) %>">
          <%= NaiveDateTime.to_string(message.inserted_at) %>
          ▶ <%= message_author(message.author, human_readable_role(message.author_role)) %>
        </p>
        <h1 class="text-xl my-2">Join request</h1>
        <h2 class="
          <%= if is_author do 'mr-4' else 'ml-4' end%>
          text-lg text-yellow-300
        ">
          Motivation
        </h2>
        <p class="<%= if is_author do 'mr-4' else 'ml-4' end%> mb-2">
          <%= message.motivation %>
        </p>
        <h2 class="
          <%= if is_author do 'mr-4' else 'ml-4' end%>
          text-lg text-yellow-300
        ">
          Preferred role
        </h2>
        <p class="<%= if is_author do 'mr-4' else 'ml-4' end%>">
          <%= preferred_role %>
        </p>
        <div class="bg-gray-800">
        </div>
      </div>
    """
  end

  def render(assigns) do
    ~L"""
      <h1 class="<%= message_styles(true) %> text-red-300">Unsupported message type</h1>
    """
  end

  defp message_author(author, author_role) do
    """
     #{author.username} #{author.emoji} [#{author_role}]
    """
  end

  defp author_styles(is_author) do
    """
    text-yellow-300 text-xs pb-1
    max-w-full
    """
  end

  defp message_styles(is_author) do
    common = """
      px-6 py-4
      mb-4
      rounded-xl
      w-max
      max-w-full
    """

    common <>
      if is_author do
        """
          self-end
          rounded-tr-none
          bg-indigo-600
        """
      else
        """
          rounded-tl-none
          bg-indigo-800
        """
      end
  end

  defp human_readable_role(role) do
    case role do
      0 -> "judge"
      1 -> "truthy side's advocate"
      2 -> "falsy side's advocate"
      3 -> "truthy side's defender"
      4 -> "falsy side's defender"
      nil -> "outsider"
    end
  end
end
