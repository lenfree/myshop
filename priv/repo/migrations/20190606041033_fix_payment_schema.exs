defmodule Myshop.Repo.Migrations.FixPaymentSchema do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      add :additional_credit, :float
      remove :credit
    end
  end
end
