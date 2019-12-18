defmodule Myshop.Orders.Item do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :price, :decimal
    field :srp, :decimal
    field :wholesale, :decimal
    field :name, :string
    field :quantity, :integer
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:price, :name, :quantity, :srp, :wholesale])
    |> validate_required([:price, :name, :quantity, :srp, :wholesale])
  end
end
