defmodule Myshop.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :notes, :string
    field :paid, :boolean, default: false
    field :active, :boolean, default: false
    field :ordered_at, :utc_datetime, read_after_writes: true
    field :state, :string, read_after_writes: true
    belongs_to :user, Myshop.Accounts.User
    embeds_many :product_items, Myshop.Orders.Item

    timestamps()
  end

  #  belongs_to :parent, Comment, foreign_key: :id, references: :parent_id, define_field: false
  #  has_many :children, Comment, foreign_key: :parent_id, references: :id
  @doc false
  def changeset(order, attrs) do
    IO.inspect(attrs)

    order
    |> cast(attrs, [:paid, :notes, :user_id, :state, :ordered_at])
    |> cast_embed(:product_items)
    |> assoc_constraint(:user)
    |> foreign_key_constraint(:user)
  end
end
