defmodule FakebustersWeb.DashboardLive do
  use FakebustersWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: %{}, query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    # case search(query) do
    #   %{^query => vsn} ->
    #     {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

    #   _ ->
    #     {:noreply,
    #      socket
    #      |> put_flash(:error, "No dependencies found matching \"#{query}\"")
    #      |> assign(results: %{}, query: query)}
    # end
  end
end
