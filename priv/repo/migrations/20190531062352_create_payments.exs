defmodule Myshop.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :balance, :integer
      add :credit, :integer
      add :notes, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:payments, [:user_id])
  end
end
