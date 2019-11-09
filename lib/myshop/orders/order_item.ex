defmodule Myshop.Orders.OrderItems do
  use Ecto.Schema

  @primary_key false

  schema "order_items" do
    field :ordered_at, :utc_datetime
    field :updated_at, :utc_datetime
    field :name, :string
    field :quantity, :integer
    field :price, :float
    field :order_id, :integer
    field :id, :string
    belongs_to :user, Myshop.Accounts.User
    field :paid, :boolean
    field :notes, :string
    field :state, :string
  end
end
