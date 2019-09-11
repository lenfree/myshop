defmodule Myshop.Repo.Migrations.ModifyProductPriceOnly do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :price, :decimal, non_null: true
      remove :sell_price
      remove :buy_price
    end
  end
end
