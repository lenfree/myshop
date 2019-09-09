defmodule Myshop.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  import Myshop.Products.Category

  schema "products" do
    field :brand, :string
    field :buy_price, :integer
    field :description, :string
    field :name, :string
    field :notes, :string
    field :sell_price, :integer
    field :url, :string
    belongs_to(:category, Myshop.Products.Category)

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
      :buy_price,
      :sell_price,
      :category_id
    ])
    |> validate_required([:name, :url, :brand, :description, :buy_price, :sell_price])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:category_id)
  end
end
