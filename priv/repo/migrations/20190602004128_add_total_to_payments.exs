defmodule Myshop.Repo.Migrations.AddTotalToPayments do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      add :total, :float
    end
  end
end
