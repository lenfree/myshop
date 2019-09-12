defmodule Myshop.ProductsTest do
  use Myshop.DataCase, aync: true

  alias Myshop.Products
  alias Myshop.Products.{Product, Category}

  describe "products" do
    @valid_attrs %{
      brand: "brand A",
      price: 5.6,
      description: "brand 6",
      name: "brand 6",
      notes: "new",
      url: "a"
    }

    @invalid_attrs %{
      brand: nil,
      price: 1,
      description: nil,
      name: nil,
      notes: nil,
      url: nil
    }

    test "list_asc_products/0" do
      %Category{id: id} = category = category_fixture()

      attrs = put_in(@valid_attrs, [:category_id], category.id)

      ~w(nike adidas puma)
      |> Enum.map(fn product ->
        Products.create_product(put_in(attrs, [:name], product))
      end)

      list_products =
        Products.list_asc_products()
        |> Enum.map(fn %Product{name: name} ->
          name
        end)

      assert list_products == ~w(adidas nike puma)
    end

    test "list_products/0 return all products" do
      category = category_fixture()
      attrs = put_in(@valid_attrs, [:category_id], category.id)

      %Product{id: id} = product_fixture(attrs)
      assert [%Product{id: ^id}] = Products.list_products()
    end

    test "get_product/1 return a product" do
      category = category_fixture()
      attrs = put_in(@valid_attrs, [:category_id], category.id)

      %Product{id: id} = product_fixture(attrs)
      assert %Product{id: ^id} = Products.get_product!(id)
    end

    test "create product/1 with valid data creates a product" do
      category = category_fixture()
      attrs = put_in(@valid_attrs, [:category_id], category.id)

      assert {:ok, %Product{} = product} = Products.create_product(attrs)
      assert product.brand == "brand A"
      assert product.price == Decimal.from_float(5.6)
      assert product.description == "brand 6"
      assert product.name == "brand 6"
      assert product.notes == "new"
      assert product.url == "a"
    end

    test "create_product/1 with invalid data returns changeset error" do
      {:error, changeset} = Products.create_product(@invalid_attrs)

      assert %{
               brand: ["can't be blank"],
               description: ["can't be blank"],
               name: ["can't be blank"],
               url: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "update_product/1 with valid data updates" do
      category = category_fixture()
      attrs = put_in(@valid_attrs, [:category_id], category.id)

      product = product_fixture(attrs)

      assert {:ok, product} = Products.update_product(product, %{brand: "puma"})
      assert %Product{} = product
      assert product.brand == "puma"
    end

    test "update_product/1 with invalid data updates" do
      category = category_fixture()
      attrs = put_in(@valid_attrs, [:category_id], category.id)

      %Product{id: id} = product = product_fixture(attrs)

      assert {:error, changeset} = Products.update_product(product, @invalid_attrs)

      assert %{
               brand: ["can't be blank"],
               description: ["can't be blank"],
               name: ["can't be blank"],
               url: ["can't be blank"]
             } = errors_on(changeset)

      assert %Product{id: ^id} = Products.get_product!(id)
    end

    test "delete_product/1 deletes a product" do
      category = category_fixture()
      attrs = put_in(@valid_attrs, [:category_id], category.id)

      product = product_fixture(attrs)

      assert {:ok, product} = Products.delete_product(product)
      assert Products.list_products() == []
    end

    test "change_product/2 returns a changeset" do
      category = category_fixture()
      attrs = put_in(@valid_attrs, [:category_id], category.id)

      product = product_fixture(attrs)
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end

  describe "categories" do
    alias Myshop.Products.Category

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

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
