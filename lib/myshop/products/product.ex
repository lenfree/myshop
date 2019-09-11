defmodule Myshop.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :brand, :string
    field :price, :decimal
    field :description, :string
    field :name, :string
    field :notes, :string
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
      :price,
      :category_id
    ])
    |> validate_required([:name, :url, :brand, :description, :price])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:category_id)
    |> assoc_constraint(:category)
    |> price_to_cents(:price)
  end

  def price_to_cents(changeset, attr) do
    case changeset.changes == %{} do
      false ->
        changeset
        |> put_change(attr, to_cents(get_field(changeset, attr)))

      true ->
        changeset
    end
  end

  def to_cents(value) do
    Decimal.div(Decimal.new(value), Decimal.new(100))
  end
end
