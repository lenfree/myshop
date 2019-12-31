defmodule Myshop.OrdersTest do
  use Myshop.DataCase

  alias Myshop.Orders

  describe "refunds" do
    alias Myshop.Orders.Refund

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def refund_fixture(attrs \\ %{}) do
      {:ok, refund} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orders.create_refund()

      refund
    end

    test "list_refunds/0 returns all refunds" do
      refund = refund_fixture()
      assert Orders.list_refunds() == [refund]
    end

    test "get_refund!/1 returns the refund with given id" do
      refund = refund_fixture()
      assert Orders.get_refund!(refund.id) == refund
    end

    test "create_refund/1 with valid data creates a refund" do
      assert {:ok, %Refund{} = refund} = Orders.create_refund(@valid_attrs)
    end

    test "create_refund/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_refund(@invalid_attrs)
    end

    test "update_refund/2 with valid data updates the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{} = refund} = Orders.update_refund(refund, @update_attrs)
    end

    test "update_refund/2 with invalid data returns error changeset" do
      refund = refund_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_refund(refund, @invalid_attrs)
      assert refund == Orders.get_refund!(refund.id)
    end

    test "delete_refund/1 deletes the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{}} = Orders.delete_refund(refund)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_refund!(refund.id) end
    end

    test "change_refund/1 returns a refund changeset" do
      refund = refund_fixture()
      assert %Ecto.Changeset{} = Orders.change_refund(refund)
    end
  end
end
