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

  #  def new(conn, _params) do
  #    changeset = Orders.change_order(%Order{}, %Accounts.User{}, %Products.Product{})
  #    users = Accounts.list_users() |> Enum.map(&{&1.credential.email, &1.id})
  #    render(conn, "index.html", changeset: changeset, users: users)
  #  end
end
