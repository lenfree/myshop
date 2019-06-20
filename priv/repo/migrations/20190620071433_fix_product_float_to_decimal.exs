defmodule Myshop.Repo.Migrations.FixProductFloatToDecimal do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :buy_price, :decimal, precision: 5, scale: 3
      modify :sell_price, :decimal, precision: 5, scale: 3
    end
  end
end
