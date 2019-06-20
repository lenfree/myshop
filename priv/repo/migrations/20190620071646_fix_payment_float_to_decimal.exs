defmodule Myshop.Repo.Migrations.FixPaymentFloatToDecimal do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      modify :balance, :decimal, precision: 5, scale: 3
      modify :paid, :decimal, precision: 5, scale: 3
      modify :additional_credit, :decimal, precision: 5, scale: 3
      modify :total, :decimal, precision: 5, scale: 3
    end
  end
end
