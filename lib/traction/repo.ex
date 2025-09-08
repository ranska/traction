defmodule Traction.Repo do
  use Ecto.Repo,
    otp_app: :traction,
    adapter: Ecto.Adapters.Postgres
end
