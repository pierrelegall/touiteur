defmodule Touiteur.Repo do
  use Ecto.Repo,
    otp_app: :touiteur,
    adapter: Ecto.Adapters.Postgres
end
