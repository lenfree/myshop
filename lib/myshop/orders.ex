defmodule Myshop.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Myshop.Repo
  alias Myshop.Accounts
  alias Myshop.Products

  alias Myshop.Orders.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(
      from o in Order,
        preload: [{:user, :credential}, :product]
    )
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id) do
    Repo.one(
      from o in Order,
        where: o.id == ^id,
        preload: [{:user, :credential}, :product]
    )
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(%Accounts.User{} = user, %Products.Product{} = product, attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> put_user(user)
    |> put_product(product)
    |> Repo.insert()
  end

  defp put_user(changeset, user) do
    changeset |> Ecto.Changeset.put_assoc(:user, user)
  end

  defp put_product(changeset, product) do
    changeset |> Ecto.Changeset.put_assoc(:product, product)
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Accounts.User{} = user, %Products.Product{} = product, %Order{} = order) do
    order |> Order.changeset(%{}) |> put_user(user) |> put_product(product)
  end
end
