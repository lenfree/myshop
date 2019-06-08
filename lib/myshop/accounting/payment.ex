defmodule Myshop.Accounting.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :balance, :float
    field :paid, :float
    # this is an additional payment made after purchase for paying debt.
    field :additional_credit, :float
    field :total, :float
    field :notes, :string
    belongs_to :user, Myshop.Accounts.User
    has_many :order, Myshop.Orders.Order

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    # TODO: add custom validation for balance and credit <= total.
    payment
    |> cast(attrs, [:balance, :additional_credit, :notes, :user_id, :total, :paid])
    |> validate_required([:balance, :paid, :total])
    |> assoc_constraint(:user)
  end
end
