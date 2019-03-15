defmodule Myshop.Repo do
  use Ecto.Repo,
    otp_app: :myshop,
    adapter: Ecto.Adapters.Postgres
end
