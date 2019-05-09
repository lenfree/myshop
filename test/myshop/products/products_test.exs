defmodule Myshop.ProductsTest do
  use Myshop.DataCase

  alias Myshop.Products

  describe "products" do
    alias Myshop.Products.Product

    @valid_attrs %{
      brand: "some brand",
      buy_price: 120.5,
      description: "some description",
      name: "some name",
      notes: "some notes",
      sell_price: 120.5,
      url: "some url"
    }
    @update_attrs %{
      brand: "some updated brand",
      buy_price: 456.7,
      description: "some updated description",
      name: "some updated name",
      notes: "some updated notes",
      sell_price: 456.7,
      url: "some updated url"
    }
    @invalid_attrs %{
      brand: nil,
      buy_price: nil,
      description: nil,
      name: nil,
      notes: nil,
      sell_price: nil,
      url: nil
    }

    def product_fixture(attrs \\ %{}) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_product()

      product
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.brand == "some brand"
      assert product.buy_price == 120.5
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.notes == "some notes"
      assert product.sell_price == 120.5
      assert product.url == "some url"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, %Product{} = product} = Products.update_product(product, @update_attrs)
      assert product.brand == "some updated brand"
      assert product.buy_price == 456.7
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.notes == "some updated notes"
      assert product.sell_price == 456.7
      assert product.url == "some updated url"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
