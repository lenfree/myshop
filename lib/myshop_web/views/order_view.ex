defmodule MyshopWeb.OrderView do
  use MyshopWeb, :view

  def product_select_options(products) do
    for product <- products, do: {product.name, product.id}
  end

  def user_select_options(users) do
    for user <- users, do: {user.first_name <> user.last_name, user.id}
  end
end
