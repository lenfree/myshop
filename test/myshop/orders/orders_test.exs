defmodule Myshop.OrdersTest do
  use Myshop.DataCase

  alias Myshop.Orders

  describe "orders" do
    alias Myshop.Orders.Order

    @valid_attrs %{
      notes: "some notes",
      paid: true,
      active: false,
      user_id: 212,
      product_id: 456
    }
    @update_attrs %{
      notes: "some updated notes",
      paid: false,
      active: true
    }
    @invalid_attrs %{notes: nil, paid: true}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orders.create_order()

      order
    end

    test "list_orders/0 returns all orders" do
      order = order_fixture(user_fixture(), product_fixture())

      order =
        put_in(
          order,
          [
            Access.key!(:user),
            Access.key!(:credential),
            Access.key!(:password)
          ],
          nil
        )

      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      user = user_fixture()
      product = product_fixture()

      order = order_fixture(user, product)
      order_new = Orders.get_order!(order.id)

      order =
        put_in(
          order,
          [
            Access.key!(:user),
            Access.key!(:credential),
            Access.key!(:password)
          ],
          nil
        )

      assert Orders.get_order!(order.id) == order_new
    end

    test "create_order/1 with valid data creates a order" do
      user = user_fixture()
      product = product_fixture()
      attrs = put_in(@valid_attrs, [:user_id], user.id)
      attrs = put_in(attrs, [:product_id], product.id)

      order = Orders.create_order(attrs)

      assert order.notes == "some notes"
      assert order.paid == true
      assert order.active == false
      assert order.product.brand == product.brand
      assert order.product.name == product.name
      assert order.product.buy_price == product.buy_price
      assert order.product.sell_price == product.sell_price
      assert order.user.first_name == user.first_name
      assert order.user.credential.email == user.credential.email
    end

    test "create_order/1 with invalid data returns error changeset" do
      {:error, changeset} = Orders.create_order(@invalid_attrs)

      assert %{
               notes: ["can't be blank"],
               product_id: ["can't be blank"],
               user_id: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "create_order/1 with invalid user id" do
      invalid_attrs = put_in(@valid_attrs, [:user_id], 124)
      {:error, changeset} = Orders.create_order(invalid_attrs)

      assert %{
               user: ["does not exist"]
             } = errors_on(changeset)
    end

    test "create_order/1 with invalid product id" do
      user = user_fixture()
      valid_attrs = put_in(@valid_attrs, [:user_id], user.id)
      invalid_attrs = put_in(valid_attrs, [:product_id], 45)
      {:error, changeset} = Orders.create_order(invalid_attrs)

      assert %{
               product: ["does not exist"]
             } = errors_on(changeset)
    end

    test "update_order/2 with valid data updates the order" do
      user = user_fixture()
      product = product_fixture()
      order = order_fixture(user, product)
      assert {:ok, %Order{} = order} = Orders.update_order(order, @update_attrs)
      assert order.notes == "some updated notes"
      assert order.paid == false
    end

    test "update_order/2 with invalid data returns error changeset" do
      user = user_fixture()
      product = product_fixture()
      order = order_fixture(user, product)
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)

      order =
        put_in(
          order,
          [
            Access.key!(:user),
            Access.key!(:credential),
            Access.key!(:password)
          ],
          nil
        )

      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      user = user_fixture()
      product = product_fixture()
      order = order_fixture(user, product)
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      user = user_fixture()
      product = product_fixture()
      order = order_fixture(user, product)
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
