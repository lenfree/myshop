defmodule Myshop.Repo.Migrations.AddMobileAddressTypeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :mobile, :integer
      add :address, :string
      add :type, :string
    end
  end
end
