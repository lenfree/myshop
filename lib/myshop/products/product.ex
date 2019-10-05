defmodule Myshop.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :brand, :string
    field :name, :string
    field :price, :decimal
    field :description, :string
    field :notes, :string
    field :url, :string
    belongs_to(:category, Myshop.Products.Category)
    has_many(:upload, Myshop.Products.Upload)

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :name,
      :url,
      :notes,
      :brand,
      :description,
      :price,
      :category_id
    ])
    |> validate_required([:name, :url, :brand, :description, :price])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:category_id)
    |> assoc_constraint(:category)
  end
end
