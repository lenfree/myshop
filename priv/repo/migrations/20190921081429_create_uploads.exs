defmodule Myshop.Repo.Migrations.CreateUploads do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :filename, :string
      add :size, :bigint
      add :content_type, :string
      add :hash, :string, size: 64

      timestamps()
    end

    create unique_index(:uploads, [:filename])
    create index(:uploads, [:hash])
  end
end
