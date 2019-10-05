defmodule Myshop.Repo.Migrations.AddProductToUpload do
  use Ecto.Migration

  def change do
    alter table(:uploads) do
      add :product_id, references(:products)
    end
  end
end
