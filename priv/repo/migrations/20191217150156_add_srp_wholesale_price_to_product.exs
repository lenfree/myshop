defmodule Myshop.Repo.Migrations.AddSRPWholesalePriceToProduct do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :srp, :decimal, default: 0
      add :wholesale, :decimal, default: 0
    end
  end
end
