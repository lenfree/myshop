defmodule Myshop.ProductsTest do
  use Myshop.DataCase

  alias Myshop.Products
  alias Myshop.Products.Product

  describe "products" do
    @valid_attrs %{
      brand: "brand A",
      buy_price: "5.6",
      description: "brand 6",
      name: "brand 6",
      notes: "new",
      sell_price: "5.9",
      url: "a"
    }
    test "list_alphabetical_products/0" do
      ~w(nike puma adidas)
      |> Enum.each(fn product ->
        Products.create_product(put_in(@valid_attrs, [:brand], product))
      end)

      list_product_brands =
        Products.list_asc_products()
        |> Enum.map(fn %Product{brand: brand} ->
          brand
        end)

      assert list_product_brands == ~w(adidas nike puma)
    end
  end
end
