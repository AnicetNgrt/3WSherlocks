defmodule FakeNewsSearchEngine.Repo do
  use Ecto.Repo,
    otp_app: :fake_news_search_engine,
    adapter: Ecto.Adapters.Postgres
end
