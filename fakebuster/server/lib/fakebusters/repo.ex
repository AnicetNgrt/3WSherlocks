defmodule Fakebusters.Repo do
  use Ecto.Repo,
    otp_app: :fakebusters,
    adapter: Ecto.Adapters.Postgres
end
