defmodule MyshopWeb.ManageorderView do
  use MyshopWeb, :view

  def compute_balance(balance, credit), do: balance - credit
  def compute_total(list), do: sum(list, 0)
  defp sum([], acc), do: acc

  defp sum([head | tail], acc) do
    sum(tail, head.product.sell_price + acc)
  end
end
