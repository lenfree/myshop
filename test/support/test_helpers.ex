defmodule Myshop.TestHelpers do
  alias Myshop.{
    Accounts,
    Products,
    Orders
  }

  def user_fixture(attrs \\ %{}) do
    username = "user#{System.unique_integer([:positive])}"
    first_name = "first#{System.unique_integer([:positive])}"
    last_name = "last#{System.unique_integer([:positive])}"

    {:ok, user} =
      attrs
      |> Enum.into(%{
        first_name: first_name,
        last_name: last_name,
        credential: %{
          email: attrs[:email] || "#{username}@example.com",
          password: attrs[:password] || "supersecret"
        }
      })
      |> Accounts.register_user()

    user
  end

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        brand: attrs[:brand] || "Apple",
        buy_price: attrs[:buy_price] || 5.6,
        description: attrs[:description] || "iPhone 6",
        name: attrs[:name] || "Apple iPhone 6",
        notes: attrs[:notes] || "brand new",
        sell_price: attrs[:sell_price] || 5.9,
        url: attrs[:url] || "http://apple.com/au/iphone6"
      })
      |> Products.create_product()

    product
  end

  def order_fixture(%Accounts.User{} = user, %Products.Product{} = product, attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        notes: attrs[:notes] || "this is a note",
        paid: attrs[:paid] || false
      })
      |> Orders.create_order(user, product)

    order
  end
end
