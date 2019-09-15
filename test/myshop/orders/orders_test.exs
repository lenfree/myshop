defmodule Myshop.OrdersTest do
  use Myshop.DataCase

  alias Myshop.Orders
  alias Myshop.Accounts

  describe "orders" do
    alias Myshop.Orders.Order

    @valid_attrs %{
      notes: "some notes",
      notes: "some notes",
      active: false,
      user_id: 212
    }
    @update_attrs %{
      notes: "some updated notes",
      paid: false,
      active: true
    }
    @invalid_attrs %{notes: nil, paid: true}

    test "list_orders/0 returns all orders" do
      user = user_fixture()
      product = product_fixture()

      attrs =
        put_in(@valid_attrs, [:user_id], user.id)
        |> put_in(
          [:product_items],
          [%{product_item_id: product.id, quantity: 3}]
        )

      order = order_fixture(attrs)
      orders = Orders.list_orders()
      assert 1 == Enum.count(orders)
    end

    test "get_order!/1 returns the order with given id" do
      user = user_fixture()
      product = product_fixture()

      attrs =
        put_in(@valid_attrs, [:user_id], user.id)
        |> put_in(
          [:product_items],
          [%{product_item_id: product.id, quantity: 3}]
        )

      order = order_fixture(attrs)
      assert order = Orders.get_order!(order.id)
    end

    test "create_order/1 with valid data creates a order" do
      user = user_fixture()
      product = product_fixture()

      attrs =
        put_in(@valid_attrs, [:user_id], user.id)
        |> put_in(
          [:product_items],
          [%{product_item_id: product.id, quantity: 3}]
        )

      {:ok, order} = Orders.create_order(attrs)
      assert order.notes == "some notes"
      assert order.paid == true
      assert order.active == false
      assert order.user_id == user.id

      [q] =
        Enum.map(order.product_items, fn x ->
          x.quantity
        end)

      [n] =
        Enum.map(order.product_items, fn x ->
          x.name
        end)

      [p] =
        Enum.map(order.product_items, fn x ->
          x.price
        end)

      assert q == 3
      assert n == product.name
      assert p == product.price
    end

    #
    #    test "create_order/1 with invalid data returns error changeset" do
    #      {:error, changeset} = Orders.create_order(@invalid_attrs)
    #
    #      assert %{
    #               notes: ["can't be blank"],
    #               product_id: ["can't be blank"],
    #               user_id: ["can't be blank"]
    #             } = errors_on(changeset)
    #    end

    #    test "create_order/1 with invalid user id" do
    #      invalid_attrs = put_in(@valid_attrs, [:user_id], 124)
    #      {:error, changeset} = Orders.create_order(invalid_attrs)
    #
    #      assert %{
    #               user: ["does not exist"]
    #             } = errors_on(changeset)
    #    end
    #
    #    test "create_order/1 with invalid product id" do
    #      user = user_fixture()
    #      valid_attrs = put_in(@valid_attrs, [:user_id], user.id)
    #      invalid_attrs = put_in(valid_attrs, [:product_id], 45)
    #      {:error, changeset} = Orders.create_order(invalid_attrs)
    #
    #      assert %{
    #               product: ["does not exist"]
    #             } = errors_on(changeset)
    #    end
    #
    #    test "update_order/2 with valid data updates the order" do
    #      user = user_fixture()
    #      product = product_fixture()
    #      # user, product)
    #      order = order_fixture(@valid_attrs)
    #      assert {:ok, %Order{} = order} = Orders.update_order(order, @update_attrs)
    #      assert order.notes == "some updated notes"
    #      assert order.paid == false
    #    end
    #
    #    test "update_order/2 with invalid data returns error changeset" do
    #      user = user_fixture()
    #      product = product_fixture()
    #      # user, product)
    #      order = order_fixture(@valid_attrs)
    #      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
    #
    #      order =
    #        put_in(
    #          order,
    #          [
    #            Access.key!(:user),
    #            Access.key!(:credential),
    #            Access.key!(:password)
    #          ],
    #          nil
    #        )
    #
    #      assert order == Orders.get_order!(order.id)
    #    end
    #
    #    test "delete_order/1 deletes the order" do
    #      user = user_fixture()
    #      product = product_fixture()
    #      # user, product)
    #      order = order_fixture(@valid_attrs)
    #      assert {:ok, %Order{}} = Orders.delete_order(order)
    #      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    #    end
    #
    #    test "change_order/1 returns a order changeset" do
    #      user = user_fixture()
    #      product = product_fixture()
    #      # user, product)
    #      order = order_fixture(@valid_attrs)
    #      assert %Ecto.Changeset{} = Orders.change_order(order)
    #    end
  end
end
