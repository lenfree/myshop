defmodule Myshop.Repo.Migrations.FixOrderProductRefContraint1 do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :order_id, references(:orders)
    end
  end
end
