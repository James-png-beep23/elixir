defmodule House2.Repo do
  use Ecto.Repo,
    otp_app: :house2,
    adapter: Ecto.Adapters.Postgres
end
