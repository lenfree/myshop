defmodule Myshop.Repo.Migrations.FixOrderProductRefContraint do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :order_id, references(:orders)
    end
  end
end
