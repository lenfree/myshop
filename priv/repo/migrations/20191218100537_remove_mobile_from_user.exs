defmodule Myshop.Repo.Migrations.RemoveMobileFromUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :mobile
    end
  end
end
