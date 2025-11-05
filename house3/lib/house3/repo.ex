defmodule House3.Repo do
  use Ecto.Repo,
    otp_app: :house3,
    adapter: Ecto.Adapters.Postgres
end
