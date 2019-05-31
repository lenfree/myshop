defmodule MyshopWeb.PaymentController do
  use MyshopWeb, :controller

  alias Myshop.Accounting
  alias Myshop.Accounting.Payment
  alias Myshop.Accounts

  def index(conn, _params) do
    payments = Accounting.list_payments()
    render(conn, "index.html", payments: payments)
  end

  def new(conn, _params) do
    changeset = Accounting.change_payment(%Payment{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"payment" => payment_params}) do
    case Accounting.create_payment(payment_params) do
      {:ok, payment} ->
        conn
        |> put_flash(:info, "Payment created successfully.")
        |> redirect(to: Routes.payment_path(conn, :show, payment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
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
