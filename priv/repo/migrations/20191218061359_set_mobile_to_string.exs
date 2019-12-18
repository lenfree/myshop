defmodule Myshop.Repo.Migrations.SetMobileToString do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :mobile, :string
    end
  end
end
