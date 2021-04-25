defmodule FakebustersWeb.LiveComponents.BoardMsg do
  @moduledoc false

  use Phoenix.LiveComponent
  alias Fakebusters.Boards
  alias Fakebusters.Accounts
  alias Fakebusters.Boards.{JoinRequest, BoardMember, BoardMessage}
  import FakebustersWeb.HyperlinksHelpers

  def render(
        %{
          message: %JoinRequest{} = message,
          is_author: is_author
        } = assigns
      ) do
    preferred_role = BoardMember.role_human_readable(message.preferred_role)

    ~L"""
      <h1 class="text-xl my-2">Join request</h1>
      <h2 class="
        <%= if is_author do 'mr-4' else 'ml-4' end%>
        text-lg text-yellow-300
      ">
        Preferred role
      </h2>
      <p class="<%= if is_author do 'mr-4' else 'ml-4' end%> mb-2">
        <%= preferred_role %>
      </p>
      <h2 class="
        <%= if is_author do 'mr-4' else 'ml-4' end%>
        text-lg text-yellow-300
      ">
        Motivation
      </h2>
      <p class="<%= if is_author do 'mr-4' else 'ml-4' end%> mb-4">
        <%= message.motivation %>
      </p>
      <h1 class="text-xl my-2">Assign to a role to accept</h1>
      <div class="flex mt-2 items-center">
        <h2 class="
          mx-1 sm:mx-3
          w-16 sm:w-24
          text-sm sm:text-lg text-blue-400
        ">
          Truthy side
        </h2>
        <button phx-click="assign"
        phx-value-role="1"
        phx-value-user_id="<%= message.user_id %>"
        class="
          <%= button_style() %>
          rounded-r-none
          rounded-bl-none
          text-blue-400
          hover:bg-blue-400
          border-blue-400
        ">
          Advocate
        </button>
        <button phx-click="assign"
        phx-value-role="3"
        phx-value-user_id="<%= message.user_id %>"
        class="
          <%= button_style() %>
          rounded-l-none
          rounded-br-none
          text-blue-400
          hover:bg-blue-400
          border-blue-400
        ">
          Defender
        </button>
      </div>
      <div class="flex mt-2 items-center">
        <h2 class="
          mx-1 sm:mx-3
          w-16 sm:w-24
          text-sm sm:text-lg text-pink-400
        ">
          Falsy side
        </h2>
        <button phx-click="assign"
        phx-value-role="2"
        phx-value-user_id="<%= message.user_id %>"
        class="
          <%= button_style() %>
          rounded-r-none
          rounded-tl-none
          text-pink-400
          hover:bg-pink-400
          border-pink-400
        ">
          Advocate
        </button>
        <button phx-click="assign"
        phx-value-role="4"
        phx-value-user_id="<%= message.user_id %>"
        class="
          <%= button_style() %>
          rounded-l-none
          rounded-tr-none
          text-pink-400
          hover:bg-pink-400
          border-pink-400
        ">
          Defender
        </button>
      </div>
    """
  end

  def render(
        %{
          message: %BoardMember{} = message,
          is_author: is_author
        } = assigns
      ) do
    user = Accounts.get_user!(message.user_id)
    role_hr = BoardMember.role_human_readable(message.role)

    ~L"""
      <p class="<%= if is_author do 'mr-4' else 'ml-4' end%> mt-2">
        <%= user.username %> <%= user.emoji %>
        <span class="text-yellow-300">just joined as a</span>
        <%= role_hr %>
      </p>
    """
  end

  def render(
        %{
          message: %BoardMessage{} = message,
          is_author: is_author
        } = assigns
      ) do
    ~L"""
      <p class="<%= if is_author do 'mr-4' else 'ml-4' end%> mt-2">
        <%= for el <- Enum.reverse(wrap_hyperlinks(message.body)) do %>
          <%= case el do %>
            <% {:link, %{href: href, host: host, path: path}} -> %>
              <a href="<%= href %>" target="_blank" class="<%= message_links_style() %>"><%= host %><%= path %></a>
            <% {:word, word} -> %>
              <%= word %>
          <% end %>
        <% end %>
      </p>
    """
  end

  def render(assigns) do
    ~L"""
      Unsupported message type
    """
  end

  def message_links_style() do
    "
    text-yellow-300
    underline
    "
  end

  def button_style() do
    "
    text-center
    text-sm hover:font-bold
    px-2 py-1
    mx-1
    flex-grow
    border-2
    rounded-xl
    hover:text-indigo-800
    "
  end
end
