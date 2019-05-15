defmodule Myshop.Repo.Migrations.FixProductOrderRef do
  use Ecto.Migration

  def change do
    alter table(:products) do
      remove :order_id, references(:orders)
    end
  end
end
