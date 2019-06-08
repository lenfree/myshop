defmodule MyshopWeb.PaymentView do
  use MyshopWeb, :view

  def parse_user(user), do: parse_name(user)

  defp parse_name([%{user: user} | _tail]), do: parse_name(user)

  defp parse_name(input) do
    Enum.into(%{}, %{id: input.id, name: "#{input.first_name} #{input.last_name}"})
  end

  def calculate_balance(payments), do: calculate_balance(payments, 0)

  defp calculate_balance([], acc), do: acc

  defp calculate_balance([head | tail], acc) do
    calculate_balance(tail, diff_balance_and_credits(head) + acc)
  end

  defp sum_of_paid_and_credit(data), do: data.paid + data.additional_credit

  defp diff_balance_and_credits(data), do: data.total - sum_of_paid_and_credit(data)
end
