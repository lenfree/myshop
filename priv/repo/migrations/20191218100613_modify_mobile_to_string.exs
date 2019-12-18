defmodule Myshop.Repo.Migrations.ModifyMobileToString do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :mobile, :string
    end
  end
end
