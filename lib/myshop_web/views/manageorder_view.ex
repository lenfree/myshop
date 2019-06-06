defmodule MyshopWeb.ManageorderView do
  use MyshopWeb, :view

  def compute_balance(balance, credit), do: balance - credit
  def compute_total(list), do: sum(list, 0)
  defp sum([], acc), do: acc

  defp sum([head | tail], acc) do
    sum(tail, head.product.sell_price + acc)
  end

  def get_name(data), do: parse_name(data)
  defp parse_name(input), do: input.user.first_name <> " " <> input.user.last_name
end
