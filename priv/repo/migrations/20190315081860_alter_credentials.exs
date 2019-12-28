defmodule Myshop.Repo.Migrations.AlterCredentials do
  use Ecto.Migration

  def change do
    alter table(:credentials) do
      add :user_id, references(:users, on_delete: :delete_all), null: false

    end
  end
end
