defmodule Myshop.Repo.Migrations.UseDecimalForPrice do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :buy_price, :decimal
      modify :sell_price, :decimal
    end
  end
end
