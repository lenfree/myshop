defmodule Myshop.Repo.Migrations.FixPaymentType do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      modify :balance, :float
      modify :credit, :float
    end
  end
end
