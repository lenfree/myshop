defmodule MyshopWeb.ManageorderController do
  use MyshopWeb, :controller

  alias Myshop.Products
  alias Myshop.Products.Product
  alias MyshopWeb.Router.Helpers, as: Routes
  plug :authenticate_user when action in [:index]

  def index(conn, _params) do
    products = Products.list_products()
    render(conn, "index.html", products: products)
  end

  #  def index(conn, _params) do
  #    render(conn, "index.html")
  #  end
end
