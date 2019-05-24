defmodule MyshopWeb.RoomChannel do
  use Phoenix.Channel

  alias Myshop.Orders.Order
  alias Myshop.Orders
  alias Myshop.Accounts

  def join("room:user-order" = channel, _message, socket) do
    {:ok, %{channel: channel}, socket}
  end

  def join("room:product-order" = channel, _message, socket) do
    {:ok, %{channel: channel}, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("get_user_order_info", _params, socket) do
    users = Accounts.list_users() |> Enum.map(&{&1.credential.email, &1.id})

    html =
      Phoenix.View.render_to_string(MyshopWeb.ManageorderView, "user_form.html", users: users)

    broadcast!(socket, "user_order_info", %{html: html})
    {:noreply, socket}
  end

  def handle_in(
        "add_product",
        %{"product_id" => _product_id, "user_id" => user_id} = attrs,
        socket
      ) do
    case Orders.create_order(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}

      %Order{} ->
        broadcast!(socket, "add_product", %{info: "successful"})
        #  response = MyshopWeb.PageView.render("index.html", product: %Products.Product{})
        #        html =
        #          Phoenix.View.render_to_string(MyshopWeb.ManageorderView, "red.html", products: products)

        broadcast!(socket, "add_product_to_cart_successful", %{user_id: user_id})
        {:noreply, socket}
    end
  end
end
