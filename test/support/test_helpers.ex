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
        price: attrs[:price] || 5.6,
        description: attrs[:description] || "iPhone 6",
        name: attrs[:name] || "Apple iPhone 6",
        notes: attrs[:notes] || "brand new",
        url: attrs[:url] || "http://apple.com/au/iphone6",
        category_id: attrs[:category_id] || category_fixture().id
      })
      |> Products.create_product()

    product
  end

  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        description: attrs[:description] || "all shoes",
        name: attrs[:name] || "shoes"
      })
      |> Products.create_category()

    category
  end

  # def order_fixture(%Accounts.User{} = user, %Products.Product{} = product, attrs \\ %{}) do
  def order_fixture(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      notes: attrs[:notes] || "this is a note",
      paid: attrs[:paid] || false,
      user_id: attrs.user_id,
      state: "ordered",
      product_items:
        attrs.product_items ||
          [
            %{product_id: attrs.product.id, quantity: 2}
          ]
    })
    |> Orders.create_order()
  end
end
