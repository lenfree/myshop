defmodule MyshopWeb.RefundController do
  use MyshopWeb, :controller

  alias Myshop.Orders
  alias Myshop.Orders.Order

  def index(conn, _params) do
    refunds = Orders.list_refunds()
    render(conn, "index.html", refunds: refunds)
  end

  def new(conn, _params) do
    changeset = Orders.change_refund(%Order{})
    products = Myshop.Products.list_products()
    users = Myshop.Accounts.list_users()
    render(conn, "new.html", changeset: changeset, products: products, users: users)
  end

  def create(conn, %{"order" => refund_params}) do
    ## TODO: FIX THIS SHIT!
    params = %{
      product_items: [%{
        product_item_id: refund_params["product_id"],
        quantity: String.to_integer(refund_params["quantity"]) * -1,
        price: String.to_float(refund_params["price"]) * -1,
        srp: refund_params["price"],
        wholesale: refund_params["price"],
      }],
      user_id: String.to_integer(refund_params["customer_id"]),
      notes: refund_params["notes"],
      state: "refunded"
    }

    case Orders.create_order(params) do
      {:ok, refund} ->
        conn
        |> put_flash(:info, "Refund created successfully.")
        |> redirect(to: Routes.order_path(conn, :index, %{}))

      {:error, %Ecto.Changeset{} = changeset} ->
    products = Myshop.Products.list_products()
    users = Myshop.Accounts.list_users()
    render(conn, "new.html", changeset: changeset, products: products, users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    refund = Orders.get_refund!(id)
    render(conn, "show.html", refund: refund)
  end

  def edit(conn, %{"id" => id}) do
    refund = Orders.get_refund!(id)
    changeset = Orders.change_refund(refund)
    render(conn, "edit.html", refund: refund, changeset: changeset)
  end

  def update(conn, %{"id" => id, "refund" => refund_params}) do
    refund = Orders.get_refund!(id)

    case Orders.update_refund(refund, refund_params) do
      {:ok, refund} ->
        conn
        |> put_flash(:info, "Refund updated successfully.")
        |> redirect(to: Routes.refund_path(conn, :show, refund))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", refund: refund, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    refund = Orders.get_refund!(id)
    {:ok, _refund} = Orders.delete_refund(refund)

    conn
    |> put_flash(:info, "Refund deleted successfully.")
    |> redirect(to: Routes.refund_path(conn, :index))
  end
end
