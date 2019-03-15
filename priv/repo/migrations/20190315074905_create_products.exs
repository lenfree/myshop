defmodule Myshop.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :text
      add :url, :string
      add :notes, :text
      add :brand, :text
      add :description, :text
      add :buy_price, :float
      add :sell_price, :float

      timestamps()
    end

  end
end
