defmodule MyshopWeb.OrderLive.New do
  use Phoenix.LiveView
  alias Myshop.Orders
  alias Myshop.Orders.Order
  alias MyshopWeb.OrderView
  alias Myshop.Accounts
  alias Myshop.Products
  require IEx
  alias MyshopWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    # changeset = Orders.change_order(%Order{})
    # {:ok, assign(socket, %{changeset: changeset})}
    {:ok,
     assign(socket, %{
       changeset: Orders.change_order(%Order{}),
       query: nil,
       item: nil,
       loading: false,
       loading_item: false,
       matches: [],
       item_matches: [],
       items: [],
       products: Myshop.Products.list_products(),
       load_items: nil,
       show_products: true,
       checkout: false,
       checkout_button: false
     })}
  end

  def render(assigns) do
    OrderView.render("new.html", assigns)
  end

  def handle_event("suggest", params, socket) do
    case Map.fetch!(params, "_target") do
      ["item"] ->
        items = manage_items(params)
        {:noreply, assign(socket, item_matches: items)}

      ["user"] ->
        users = manage_users(params)
        {:noreply, assign(socket, matches: users)}

      _ ->
        {:noreply, assign(socket, matches: [], item_matches: [])}
    end
  end

  def handle_event("place", params, %{assigns: assigns} = socket) do
    data =
      case Map.fetch(assigns.changeset.data, :product_items) do
        {:ok, items} ->
          Map.put(assigns.changeset.data, :product_items, [
            %{product_item_id: params, quantity: nil} | items
          ])

        :error ->
          Map.put(assigns.changeset.data, :product_items, [
            %{product_item_id: params, quantity: nil}
          ])
      end

    changeset = Map.put(assigns.changeset, :data, data)
    {:noreply, assign(socket, checkout_button: true, changeset: changeset)}
  end

  def handle_event("checkout-page", _params, socket) do
    {:noreply, assign(socket, checkout: true, show_products: false, checkout_button: false)}
  end

  def handle_event("delete_item", params, %{assigns: assigns} = socket) do
    new_items =
      Enum.reject(
        assigns.changeset.data.product_items,
        fn item -> item.product_item_id == params["value"] end
      )

    changeset_data = Map.put(assigns.changeset.data, :product_items, new_items)
    new_changeset = Map.put(assigns.changeset, :data, changeset_data)
    {:noreply, assign(socket, changeset: new_changeset)}
  end

  def handle_event("search", params, socket) do
    user = Accounts.get_user_by_email(params["user"])

    data = Map.put(socket.assigns.changeset.data, :user_id, user.id)

    items =
      params["orders"]["product_items"]
      |> Enum.map(fn {key, val} -> Map.put(val, "product_item_id", key) end)

    new_items =
      Enum.map(items, fn x -> for {key, val} <- x, into: %{}, do: {String.to_atom(key), val} end)

    new_data = Map.put(data, :product_items, new_items)

    case Map.from_struct(new_data) |> Myshop.Orders.create_order() do
      {:ok, order} ->
        {:stop,
         socket
         |> put_flash(:info, "order created")
         |> redirect(to: Routes.order_path(MyshopWeb.Endpoint, :index, order: order))}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_info(params, socket) do
    require IEx
    IEx.pry()
    {:noreply, assign(socket, loading_item: false, item_matches: [])}
  end

  # move this somewhere else
  def manage_items(%{"item" => item}) do
    Products.search_product_by_name(item)
  end

  def manage_users(%{"user" => user}) do
    Accounts.search_user_by_name(user)
  end
end
