defmodule MyshopWeb.OrderController do
  use MyshopWeb, :controller

  alias Myshop.Orders
  alias Myshop.Orders.Order
  alias Myshop.Products
  alias Myshop.Accounts
  alias MyshopWeb.Router.Helpers, as: Routes
  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    orders = Orders.list_orders()
    render(conn, "index.html", orders: orders)
  end

  def new(conn, _params) do
    changeset = Orders.change_order(%Order{}, %Accounts.User{}, %Products.Product{})
    users = Accounts.list_users() |> Enum.map(&{&1.credential.email, &1.id})
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"order" => order_params}) do
    case Orders.create_order(order_params, %Accounts.User{}, %Products.Product{}) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: Routes.order_path(conn, :show, order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Orders.get_order!(id)
    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id}) do
        order = Orders.get_order!(id)
        changeset = Orders.change_order(order)
        render(conn, "edit.html", order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
      order = Orders.get_order!(id)

      case Orders.update_order(order, order_params) do
        {:ok, order} ->
          conn
          |> put_flash(:info, "Order updated successfully.")
          |> redirect(to: Routes.order_path(conn, :show, order))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", order: order, changeset: changeset)
      end
  end

  def delete(conn, %{"id" => id}) do
     order = Orders.get_order!(id)
     {:ok, _order} = Orders.delete_order(order)

     conn
     |> put_flash(:info, "Order deleted successfully.")
     |> redirect(to: Routes.order_path(conn, :index))
  end
end
