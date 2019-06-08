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
    Repo.one!(
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
  def create_order(attrs \\ %{}) do
    changeset =
      %Order{}
      |> Order.changeset(attrs)

    #    comment = Products.change_product(%Products.Product{}, %{id: attrs[:product_id]})
    #    post = Ecto.Changeset.put_assoc(changeset, :product, [comment])
    #    case changeset do
    #      {:error, message} ->
    #        {:error, message}
    #
    #      _ ->
    case Repo.insert(changeset) do
      {:ok, repo} ->
        Repo.preload(repo, [{:user, :credential}, :product])

      {:error, changeset} ->
        {:error, changeset}
    end
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
  def change_order(%Order{} = order, %Accounts.User{} = user, %Products.Product{} = product) do
    order |> Order.changeset(%{}) |> put_user(user) |> put_product(product)
  end

  def change_order(%Order{} = order) do
    order |> Order.changeset(%{})
  end

  defp put_user(changeset, user) do
    changeset |> Ecto.Changeset.put_assoc(:user, user)
  end

  defp put_product(changeset, product) do
    changeset |> Ecto.Changeset.put_assoc(:product, product)
  end

  def get_all_orders_from_user(user_id) do
    query =
      from o in Order,
        where: o.user_id == ^user_id,
        where: o.paid == false,
        order_by: o.updated_at,
        preload: [{:user, :credential}, :product]

    Repo.all(query)
  end

  def update_order_item_to_paid!(%{user_id: user_id, payment_id: payment_id}) do
    from(o in Order,
      where: o.user_id == ^user_id,
      where: o.paid == false
    )
    |> Repo.update_all(set: [paid: true, payment_id: payment_id])
  end
end
