defmodule MyshopWeb.ManageorderController do
  use MyshopWeb, :controller

  alias Myshop.Products
  alias Myshop.Products.Product
  alias Myshop.Orders
  alias Myshop.Orders.Order
  alias Myshop.Accounts
  alias MyshopWeb.Router.Helpers, as: Routes
  plug :authenticate_user when action in [:index]

  def index(conn, _params) do
    products = Products.list_products()
    # |> Enum.map(&{&1.credential.email, &1.id})
    users = Accounts.list_users()
    render(conn, "index.html", products: products, users: users)
  end

  def show(conn, %{"id" => user_id}) do
    orders = Orders.get_all_orders_from_user(user_id)
    %Order{user: %Accounts.User{} = user} = orders |> hd
    render(conn, "checkout.html", %{data: %{orders: orders, user: user}})
  end
end
