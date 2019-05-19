defmodule MyshopWeb.RoomChannel do
  use Phoenix.Channel

  alias Myshop.Orders.Order
  alias Myshop.Orders
  alias Myshop.Products
  alias Myshop.Accounts
  alias Myshop.Repo

  def join("room:lobby" = channel, _message, socket) do
    {:ok, %{channel: channel}, socket}
  end

  def join("room:test" = channel, _message, socket) do
    {:ok, %{channel: channel}, socket}
  end

  def join("room:product-order" = channel, _message, socket) do
    {:ok, %{channel: channel}, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{body: body})
    {:noreply, socket}
  end

  def handle_in("add_product", %{"product_id" => _product_id} = body, socket) do
    attrs = put_in(body, ["user_id"], 2)
    attrs = put_in(attrs, ["notes"], "test123")

    case Orders.create_order(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        broadcast!(socket, "add_product", %{info: "error", message: changeset})
        #        {:reply, {:error, %{errors: changeset}}, socket}
        {:reply, :error, socket}

      order ->
        broadcast!(socket, "add_product", %{info: "successful"})
        {:reply, {:ok, order}, socket}
    end
  end

  def handle_in("new_msg_test", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg_test", %{body: body})
    {:noreply, socket}
  end

  def handle_out("new_msg", payload, socket) do
    push(socket, "new_msg", payload)
    {:noreply, socket}
  end

  def handle_out("new_msg_test", payload, socket) do
    push(socket, "new_msg_test", payload)
    {:noreply, socket}
  end

  # https://hexdocs.pm/phoenix/Phoenix.Channel.html#module-broadcasting-to-an-external-topic
  #  def handle_out("add_product", payload, socket) do
  #    push(socket, "add_product", payload)
  #    {:noreply, socket}
  #  end
end
