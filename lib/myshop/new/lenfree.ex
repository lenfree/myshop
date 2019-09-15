defmodule Myshop.New.Lenfree do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lenfrees" do
    field :items, :map
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(lenfree, attrs) do
    lenfree
    |> cast(attrs, [:name, :items])
    |> validate_required([:name, :items])
    |> unique_constraint(:name)
  end
end
