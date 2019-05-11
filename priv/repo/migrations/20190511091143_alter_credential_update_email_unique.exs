defmodule Myshop.Repo.Migrations.AlterCredentialUpdateEmailUnique do
  use Ecto.Migration

  def change do
    create unique_index(:credentials, [:email])
  end
end
