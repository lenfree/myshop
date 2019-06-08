defmodule MyshopWeb.PaymentView do
  use MyshopWeb, :view

  def get_name(user), do: parse_name(user)

  def get_user_id(user), do: user.id

  def parse_name(input), do: "#{input.first_name} #{input.last_name}"

  def calculate_balance(payments), do: calculate_balance(payments, 0)

  defp calculate_balance([], acc), do: acc

  defp calculate_balance([head | tail], acc) do
    calculate_balance(tail, diff_balance_and_credits(head) + acc)
  end

  defp sum_of_paid_and_credit(data), do: data.paid + data.additional_credit

  defp diff_balance_and_credits(data), do: data.total - sum_of_paid_and_credit(data)
end
