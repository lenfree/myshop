defmodule Myshop.Repo.Migrations.FixPaymentType do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      modify :balance, :numeric
      modify :credit, :numeric
    end
  end
end
