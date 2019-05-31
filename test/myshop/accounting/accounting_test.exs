defmodule Myshop.AccountingTest do
  use Myshop.DataCase

  alias Myshop.Accounting

  describe "payments" do
    alias Myshop.Accounting.Payment

    @valid_attrs %{balance: 42, credit: 42, notes: "some notes"}
    @update_attrs %{balance: 43, credit: 43, notes: "some updated notes"}
    @invalid_attrs %{balance: nil, credit: nil, notes: nil}

    def payment_fixture(attrs \\ %{}) do
      {:ok, payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounting.create_payment()

      payment
    end

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Accounting.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Accounting.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      assert {:ok, %Payment{} = payment} = Accounting.create_payment(@valid_attrs)
      assert payment.balance == 42
      assert payment.credit == 42
      assert payment.notes == "some notes"
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounting.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{} = payment} = Accounting.update_payment(payment, @update_attrs)
      assert payment.balance == 43
      assert payment.credit == 43
      assert payment.notes == "some updated notes"
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounting.update_payment(payment, @invalid_attrs)
      assert payment == Accounting.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Accounting.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Accounting.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Accounting.change_payment(payment)
    end
  end
end
