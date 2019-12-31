defmodule Myshop.Products.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "categories" do
    field :description, :string
    field :name, :string

    has_many :product, Myshop.Products.Product


    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end

  def alphabetical(query) do
    from c in query, order_by: c.name
  end
end
