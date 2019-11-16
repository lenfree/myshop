defmodule Myshop.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias Myshop.Repo
  alias Myshop.Accounts
  alias Myshop.Products
  alias Myshop.Orders.OrderItems
  alias Myshop.Orders.Order
  alias Timex
  require IEx

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(
      from o in Order,
        preload: [{:user, :credential}]
    )
  end

  # TODO: parametise this, make it re-usable
  def list_by_day_customer_count do
    OrderItems
    |> where([e], e.ordered_at >= ^Timex.beginning_of_day(Timex.shift(Timex.now(), days: -7)))
    |> where([e], e.ordered_at <= ^Timex.end_of_day(Timex.now()))
    |> group_by([e], fragment("date(?)", e.updated_at))
    |> select([e], %{fragment("date(?)", e.updated_at) => count(e.id)})
    |> order_by([e], asc: fragment("date(?)", e.updated_at))
    |> Repo.all()
  end

  def list_orders_history do
    OrderItems
    |> where([e], e.ordered_at >= ^Timex.beginning_of_day(Timex.shift(Timex.now(), days: -7)))
    |> where([e], e.ordered_at <= ^Timex.end_of_day(Timex.now()))
    |> preload([{:user, :credential}])
    |> Repo.all()
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
        preload: [{:user, :credential}]
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
    attrs = Map.update(attrs, :product_items, [], &build_items/1)
    attrs = Map.put(attrs, :user_id, get_user_id_from_email(attrs))

    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  defp get_user_id_from_email(param) do
    case Accounts.get_user_by_email(param.email) do
      nil ->
        nil

      user ->
        user.id
    end
  end

  defp build_items(items) when items == [] do
    nil
  end

  defp build_items(items) do
    for item <- items do
      case is_integer(item.product_item_id) do
        true ->
          product_item = Myshop.Products.get_product!(item.product_item_id)
          %{name: product_item.name, price: product_item.price, quantity: item.quantity}

        false ->
          product_item = Myshop.Products.get_product!(String.to_integer(item.product_item_id))
          %{name: product_item.name, price: product_item.price, quantity: item.quantity}
      end
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

  def compute_price(item_id, quantity) do
    item = Products.get_product!(item_id)
    Decimal.mult(item.price, Decimal.new(quantity))
  end

  def compute_subtotal(items) do
    Enum.map(
      items,
      fn %{product_item_id: id, quantity: qty} ->
        Myshop.Orders.compute_price(id, qty)
      end
    )
    |> Enum.reduce(fn total, subtotal -> Decimal.add(total, Decimal.new(subtotal)) end)
  end

  #  alias Myshop.Orders.Summary
  #
  #  @doc """
  #  Returns the list of summaries.
  #
  #  ## Examples
  #
  #      iex> list_summaries()
  #      [%Summary{}, ...]
  #
  #  """
  #  def list_summaries do
  #    raise "TODO"
  #  end
  #
  #  @doc """
  #  Gets a single summary.
  #
  #  Raises if the Summary does not exist.
  #
  #  ## Examples
  #
  #      iex> get_summary!(123)
  #      %Summary{}
  #
  #  """
  #  def get_summary!(id) do
  #    #    query =
  #    #      from o in "orders",
  #    #        where: o.inserted_at > 900,
  #    #        select: [t.id, t.title, a.title]
  #    #
  #    #    Repo.query(queryi
  #    #    from p in Post, where: p.published_at >
  #    #    datetime_add(^Ecto.DateTime.utc, -1, "month")
  #    #    https://github.com/elixir-ecto/ecto/issues/1071
  #  end
  #
  #  @doc """
  #  Creates a summary.
  #
  #  ## Examples
  #
  #      iex> create_summary(%{field: value})
  #      {:ok, %Summary{}}
  #
  #      iex> create_summary(%{field: bad_value})
  #      {:error, ...}
  #
  #  """
  #  def create_summary(attrs \\ %{}) do
  #    raise "TODO"
  #  end
  #
  #  @doc """
  #  Updates a summary.
  #
  #  ## Examples
  #
  #      iex> update_summary(summary, %{field: new_value})
  #      {:ok, %Summary{}}
  #
  #      iex> update_summary(summary, %{field: bad_value})
  #      {:error, ...}
  #
  #  """
  #  def update_summary(%Summary{} = summary, attrs) do
  #    raise "TODO"
  #  end
  #
  #  @doc """
  #  Deletes a Summary.
  #
  #  ## Examples
  #
  #      iex> delete_summary(summary)
  #      {:ok, %Summary{}}
  #
  #      iex> delete_summary(summary)
  #      {:error, ...}
  #
  #  """
  #  def delete_summary(%Summary{} = summary) do
  #    raise "TODO"
  #  end
  #
  #  @doc """
  #  Returns a data structure for tracking summary changes.
  #
  #  ## Examples
  #
  #      iex> change_summary(summary)
  #      %Todo{...}
  #
  #  """
  #  def change_summary(%Summary{} = summary) do
  #    raise "TODO"
  #  end
end
