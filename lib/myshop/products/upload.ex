defmodule Myshop.Products.Upload do
  use Ecto.Schema
  import Ecto.Changeset

  schema "uploads" do
    field :content_type, :string
    field :filename, :string
    field :hash, :string
    field :size, :integer
    belongs_to(:product, Myshop.Products.Product)
    timestamps()
  end

  @doc false
  def changeset(upload, attrs) do
    IO.inspect(attrs)

    upload
    |> cast(attrs, [:filename, :size, :content_type, :hash, :product_id])
    |> validate_required([:filename, :size, :content_type, :hash])
    # added validations
    # doesn't allow empty files
    |> validate_number(:size, greater_than: 0)
    |> validate_length(:hash, is: 64)
    |> foreign_key_constraint(:product_id)
    |> assoc_constraint(:product)
  end
end
