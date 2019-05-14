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

  # def order_fixture(%Accounts.User{} = user, %Products.Product{} = product, attrs \\ %{}) do
  #   {:ok, order} =
  #     attrs
  #     |> Enum.into(%{
  #       notes: attrs[:notes] || "this is a note",
  #       paid: attrs[:paid] || "false"
  #     })
  #     |> Orders.create_order(user, product)

  #   order
  #   # product_id: 1,
  #   # updated_at: ~N[2019-05-13 11:20:22],
  #   # user: %Myshop.Accounts.User{
  #   #  __meta__: #Ecto.Schema.Metadata<:loaded, "users">,
  #   #  credential: %Myshop.Accounts.Credential{
  #   #    __meta__: #Ecto.Schema.Metadata<:loaded, "credentials">,
  #   #    email: "me@a.com",
  #   #    id: 5,
  #   #    inserted_at: ~N[2019-03-16 08:31:46],
  #   #    password: nil,
  #   #    password_confirmation: nil,
  #   #    password_hash: "$pbkdf2-sha512$160000$AoIUYsTK./2qs1qap/HmcQ$sgffY8Rrt1kkxzQSGoJFeDCWK3D2anstqYlZGdEyjOT43wcDEzIVHggJX.HOzA.ElGxCERX.iO78FvIrbrvUsA",
  #   #    updated_at: ~N[2019-03-16 08:38:49],
  #   #    user: #Ecto.Association.NotLoaded<association :user is not loaded>,
  #   #    user_id: 5
  #   #  },
  #   #  first_name: "mememe",
  #   #  id: 5,
  #   #  inserted_at: ~N[2019-03-16 08:31:46],
  #   #  last_name: "mememe",
  #   #  updated_at: ~N[2019-03-16 08:35:52]
  #   # },
  #   # user_id: 5
  # end
end
