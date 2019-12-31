defmodule Myshop.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Myshop.Accounts.Credential

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :mobile, :string
    field :address, :string
    field :type, :string
    has_one(:credential, Credential)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :mobile, :address, :type])
    |> validate_required([:first_name, :last_name, :mobile])
    |> validate_length(:first_name, min: 3, max: 20)
    |> validate_length(:last_name, min: 3, max: 20)
    |> upcase_value
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def upcase_value(changeset) do
    changeset = update_change(changeset, :first_name, &String.upcase/1)
    update_change(changeset, :last_name, &String.upcase/1)
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end
end
