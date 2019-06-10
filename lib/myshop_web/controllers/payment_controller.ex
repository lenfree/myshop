defmodule MyshopWeb.PaymentController do
  use MyshopWeb, :controller

  alias Myshop.Accounting
  alias Myshop.Accounting.Payment
  alias Myshop.Orders
  alias Myshop.Accounts

  def index(conn, %{"user_id" => user_id}) do
    user = Accounts.get_user!(user_id)
    payments = Accounting.list_payments(user_id)

    case length(payments) > 0 do
      true ->
        render(conn, "index_user.html", %{payments: payments, user: user})

      _ ->
        redirect(conn, to: Routes.manageorder_path(conn, :show, user.id))
    end
  end

  def index(conn, _params) do
    payments = Accounting.list_payments()
    render(conn, "index.html", payments: payments)
  end

  def new(conn, %{"user_id" => user_id}) do
    payments = Accounting.list_payments(user_id)
    changeset = Accounting.change_payment(%Payment{})
    data = %{changeset: changeset, payments: payments}
    render(conn, "new.html", data)
  end

  def create(conn, %{"payment" => payment_params}) do
    payment_params =
      payment_params
      |> Enum.into(%{
        "additional_credit" => check_additional_credit(payment_params, "additional_credit"),
        "paid" => check_additional_credit(payment_params, "paid"),
        "total" => check_additional_credit(payment_params, "total")
      })

    case Accounting.create_payment(payment_params) do
      {:ok, payment} ->
        Orders.update_order_item_to_paid!(%{
          user_id: payment_params["user_id"],
          payment_id: payment.id
        })

        conn
        |> put_flash(:info, "Payment created successfully.")
        |> redirect(to: Routes.payment_path(conn, :show, payment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def check_additional_credit(params, param_name) do
    case Map.has_key?(params, param_name) do
      true ->
        params["#{param_name}"]

      false ->
        0
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Accounting.get_payment!(id)
    render(conn, "show.html", payment: payment)
  end

  def edit(conn, %{"id" => id}) do
    payment = Accounting.get_payment!(id)
    changeset = Accounting.change_payment(payment)
    render(conn, "edit.html", payment: payment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Accounting.get_payment!(id)

    case Accounting.update_payment(payment, payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment updated successfully.")
        |> redirect(to: Routes.payment_path(conn, :show, payment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", payment: payment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Accounting.get_payment!(id)
    {:ok, _payment} = Accounting.delete_payment(payment)

    conn
    |> put_flash(:info, "Payment deleted successfully.")
    |> redirect(to: Routes.payment_path(conn, :index))
  end
end
