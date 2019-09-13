defmodule MyshopWeb.OrderLive.Index do
  use Phoenix.LiveView
  alias Myshop.Orders
  alias MyshopWeb.OrderView

  def mount(_session, socket) do
    orders = Orders.list_orders()
    {:ok, assign(socket, orders: orders)}
  end

  def render(assigns) do
    OrderView.render("index.html", assigns)
  end
end
