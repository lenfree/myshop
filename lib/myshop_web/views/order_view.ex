defmodule MyshopWeb.OrderView do
  use MyshopWeb, :view

  def product_select_options(products) do
    for product <- products, do: {product.name, product.id}
  end

  @spec user_select_options(any) :: [any]
  def user_select_options(users) do
    for user <- users, do: {user.first_name <> user.last_name, user.id}
  end

  def show_user_name(user_id) do
    user = Myshop.Accounts.get_user!(user_id)
    "#{user.first_name} #{user.last_name}"
  end

  def show_default_state(order) do
    case order.data.state do
      nil -> ""
    end
  end

  def calculate_total(%{price: price, quantity: quantity}) do
    case quantity > 0 do
      true ->
        Decimal.mult(
          Decimal.from_float(price),
          quantity
        )
      false ->
        Decimal.mult(-1, Decimal.mult(
          Decimal.from_float(price),
          quantity
        )
      )
    end
  end

  def calculate_total(order) do
    Enum.reduce(
      order.product_items,
      Decimal.new(0),
      fn %{quantity: qty, price: price}, acc ->
        case qty > 0 do
          true ->
            Decimal.add(acc, Decimal.mult(qty, price))
          false ->
            Decimal.add(acc,
              Decimal.mult(-1, Decimal.mult(qty, price))
            )
        end
      end
    )
  end

  def datetime_poison_encode(data) do
    data
    |> Enum.reduce(fn x, acc ->
      Map.merge(x, acc, fn _key, map1, map2 ->
        for {k, v1} <- map1, into: %{}, do: {k, v1 + map2[k]}
      end)
    end)
    |> Poison.encode!()
  end

  def parse_order_history(data) do
    data
    |> Enum.map(&add_total_to_history/1)
    |> convert_timestamp_to_datetime
    |> apply_group_by
    |> convert_to_chartkick_format
  end

  def add_total_to_history(%{ordered_at: ordered_at} = data) do
    %{ordered_at: ordered_at, total: calculate_total(data)}
  end

  def convert_timestamp_to_datetime(data) do
    Enum.map(
      data,
      fn %{ordered_at: at, total: total} ->
        {Date.to_string(at), total}
      end
    )
  end

  def apply_group_by(data) do
    data
    |> Enum.group_by(
      fn {date, _value} -> date end,
      fn {_date, value} -> value end
    )
  end

  def convert_to_chartkick_format(data) do
    data
    |> Enum.map(fn {date, a} ->
      {:ok, new_date_format} = Date.from_iso8601(date)

      %{
        new_date_format => Decimal.to_float(sum_order_per_day(a))
      }
    end)
  end

  def sum_order_per_day(data) do
    Enum.reduce(
      data,
      Decimal.new(0),
      fn x, acc -> Decimal.add(x, acc) end
    )
  end

  def summary_group_by_product(data) do
    data
    |> Enum.group_by(& &1.name, & &1.quantity)
    |> Enum.reduce(
      [],
      fn {id, qty}, acc -> [[id, Enum.sum(qty)] | acc] end
    )
  end
end
