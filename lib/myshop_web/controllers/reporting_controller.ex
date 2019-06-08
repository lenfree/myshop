defmodule MyshopWeb.ReportingController do
  use MyshopWeb, :controller

  alias Myshop.Orders

  def index(conn, _params) do
    orders = Orders.order_summary()
    render(conn, "index.html", orders: orders)
  end

  def show(conn, %{"id" => id}) do
    order = Orders.get_order!(id)
    render(conn, "show.html", order: order)
  end
end
