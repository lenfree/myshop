defmodule Myshop.ProductsTest do
  use Myshop.DataCase

  alias Myshop.Products
  alias Myshop.Products.Product

  describe "products" do
    @valid_attrs %{
      brand: "brand A",
      buy_price: 5.6,
      description: "brand 6",
      name: "brand 6",
      notes: "new",
      sell_price: 5.9,
      url: "a"
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
    test "list_asc_products/0" do
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

    test "list_products/0 return all products" do
      %Product{id: id} = product_fixture()
      assert [%Product{id: ^id}] = Products.list_products()
    end

    test "get_product/1 return a product" do
      %Product{id: id} = product_fixture()
      assert %Product{id: ^id} = Products.get_product!(id)
    end

    test "create product/1 with valid data creates a product" do
      assert {:ok, %Product{} = product} = Products.create_product(@valid_attrs)
      assert product.brand == "brand A"
      assert product.buy_price == 5.6
      assert product.description == "brand 6"
      assert product.name == "brand 6"
      assert product.notes == "new"
      assert product.sell_price == 5.9
      assert product.url == "a"
    end

    test "create_product/1 with invalid data returns changeset error" do
      {:error, changeset} = Products.create_product(@invalid_attrs)

      assert %{
               brand: ["can't be blank"],
               buy_price: ["can't be blank"],
               description: ["can't be blank"],
               name: ["can't be blank"],
               url: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "update_product/1 with valid data updates" do
      product = product_fixture()
      assert {:ok, product} = Products.update_product(product, %{brand: "puma"})
      assert %Product{} = product
      assert product.brand == "puma"
    end

    test "update_product/1 with invalid data updates" do
      %Product{id: id} = product = product_fixture()
      assert {:error, changeset} = Products.update_product(product, @invalid_attrs)

      assert %{
               brand: ["can't be blank"],
               buy_price: ["can't be blank"],
               description: ["can't be blank"],
               name: ["can't be blank"],
               url: ["can't be blank"]
             } = errors_on(changeset)

      assert %Product{id: ^id} = Products.get_product!(id)
    end

    test "delete_product/1 deletes a product" do
      product = product_fixture()

      assert {:ok, product} = Products.delete_product(product)
      assert Products.list_products() == []
    end

    test "change_product/2 returns a changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  describe "categories" do
    alias Myshop.Products.Category

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Products.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Products.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Products.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Products.create_category(@valid_attrs)
      assert category.description == "some description"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Products.update_category(category, @update_attrs)
      assert category.description == "some updated description"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_category(category, @invalid_attrs)
      assert category == Products.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Products.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Products.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Products.change_category(category)
    end
  end
end
