defmodule Myshop.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :brand, :string
    field :buy_price, :decimal
    field :description, :string
    field :name, :string
    field :notes, :string
    field :sell_price, :decimal
    field :url, :string

    timestamps()
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :url, :notes, :brand, :description, :buy_price, :sell_price])
    |> validate_required([:name, :url, :brand, :description, :buy_price, :sell_price])
    |> unique_constraint(:name)
  end
end
