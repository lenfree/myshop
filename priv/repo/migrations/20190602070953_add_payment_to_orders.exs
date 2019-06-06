defmodule Myshop.Repo.Migrations.AddPaymentToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :payment_id, references(:payments)
    end
  end
end
