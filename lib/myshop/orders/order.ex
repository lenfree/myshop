defmodule Myshop.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :notes, :string
    field :paid, :boolean, default: false
    field :active, :boolean, default: false
    belongs_to :user, Myshop.Accounts.User
    belongs_to :product, Myshop.Products.Product
    # , foreign_key: :id
    timestamps()
  end

  #  belongs_to :parent, Comment, foreign_key: :id, references: :parent_id, define_field: false
  #  has_many :children, Comment, foreign_key: :parent_id, references: :id
  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:paid, :notes, :user_id, :product_id])
    |> validate_required([:paid, :notes, :user_id, :product_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:product)
  end
end
