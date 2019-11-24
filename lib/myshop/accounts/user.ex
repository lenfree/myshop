defmodule Myshop.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Myshop.Accounts.Credential

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    has_one(:credential, Credential)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
    |> validate_length(:first_name, min: 3, max: 20)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end
end
