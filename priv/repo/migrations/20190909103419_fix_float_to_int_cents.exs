defmodule Myshop.Repo.Migrations.FixFloatToIntCents do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :buy_price, :integer
      modify :sell_price, :integer
      modify :name, :string, non_null: true
    end

    create unique_index(:products, [:name])
  end
end
