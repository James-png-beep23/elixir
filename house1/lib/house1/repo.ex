defmodule House1.Repo do
  use Ecto.Repo,
    otp_app: :house1,
    adapter: Ecto.Adapters.Postgres
end
