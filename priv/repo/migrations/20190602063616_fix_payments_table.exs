defmodule Myshop.Repo.Migrations.FixPaymentsTable do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      add :paid, :float
      add :order_id, references(:orders)
    end
  end
end
