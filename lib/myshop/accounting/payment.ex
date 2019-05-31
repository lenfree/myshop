defmodule Myshop.Accounting.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :balance, :float
    field :credit, :float
    field :notes, :string
    belongs_to :user, Myshop.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:balance, :credit, :notes, :user_id])
    |> validate_required([:balance, :credit])
    |> assoc_constraint(:user)
  end
end
