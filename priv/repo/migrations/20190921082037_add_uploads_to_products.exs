defmodule Myshop.Repo.Migrations.AddUploadsToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :upload_items, :map
    end
  end
end
