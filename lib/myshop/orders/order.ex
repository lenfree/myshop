defmodule Myshop.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :notes, :string
    field :paid, :boolean, default: false
    field :active, :boolean, default: false
    belongs_to :user, Myshop.Accounts.User
    belongs_to :product, Myshop.Products.Product
    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:paid, :notes])
    |> validate_required([:paid, :notes])
  end
end
