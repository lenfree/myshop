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
       products: list_products(),
       categories: category_select_options(),
       load_items: nil,
       show_products: true,
       show_add_products: false,
       checkout: false,
       checkout_button: false,
       qty: 1,
       show_product_item_search: false
     })}
  end

  def list_products(%{"order" => %{"category_id" => category_id}}) do
    Myshop.Products.list_products(category_id)
  end

  def list_products() do
    Myshop.Products.list_products()
  end

  def render(assigns) do
    OrderView.render("new.html", assigns)
  end

  def handle_event("suggest", params, %{assigns: assigns} = socket) do
    case Map.fetch!(params, "_target") do
      ["item"] ->
        items = manage_items(params)
        {:noreply, assign(socket, item_matches: items)}

      ["user"] ->
        users = manage_users(params)
        {:noreply, assign(socket, matches: users)}

      ["order", "category_id"] ->
        {:noreply, assign(socket, products: list_products(params))}

      ["orders", "product_items", item_id, "quantity"] ->
        {:ok, items} = Map.fetch(assigns.changeset.data, :product_items)
        new_qty = get_in(params, ["orders", "product_items", item_id, "quantity"])

        case Integer.parse(new_qty) do
          :error ->
            {:noreply, socket}

          _ ->
            new_items =
              Enum.map(items, fn %{product_item_id: id, quantity: qty} ->
                case id == item_id do
                  false -> %{product_item_id: id, quantity: qty}
                  true -> %{product_item_id: item_id, quantity: new_qty}
                end
              end)

            updated_changeset_data = Map.put(assigns.changeset.data, :product_items, new_items)
            updated_changeset = Map.put(assigns.changeset, :data, updated_changeset_data)
            {:noreply, assign(socket, changeset: updated_changeset)}
        end

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event("place", params, %{assigns: assigns} = socket) do
    data =
      case Map.fetch(assigns.changeset.data, :product_items) do
        {:ok, items} ->
          Map.put(assigns.changeset.data, :product_items, [
            %{product_item_id: params, quantity: 1} | items
          ])

        :error ->
          Map.put(assigns.changeset.data, :product_items, [
            %{product_item_id: params, quantity: nil}
          ])
      end

    changeset = Map.put(assigns.changeset, :data, data)
    changeset = changeset.data |> Orders.change_order()
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

  def handle_event("start_again", _params, %{assigns: _assigns} = socket) do
    {:stop,
     socket
     |> redirect(to: Routes.order_path(MyshopWeb.Endpoint, :new, order: nil))}
  end

  def handle_event("search", params, socket) do
    customer_name = String.split(params["user"])

    first_name = List.first(customer_name)
    last_name = List.last(customer_name)
    user = Myshop.Accounts.search_user_by_name(first_name, last_name)

    data = Map.put(socket.assigns.changeset.data, :user_id, user.id)

    new_items =
      case params["orders"]["product_items"] != nil do
        true ->
          params["orders"]["product_items"]
          |> Enum.map(fn {key, val} -> Map.put(val, "product_item_id", key) end)
          |> Enum.map(fn x -> for {key, val} <- x, into: %{}, do: {String.to_atom(key), val} end)

        false ->
          []
      end

    new_data = Map.put(data, :product_items, new_items)

    case Map.from_struct(new_data) |> Myshop.Orders.create_order() do
      {:ok, order} ->
        {:stop,
         socket
         |> put_flash(:info, "order created")
         |> redirect(to: Routes.order_path(MyshopWeb.Endpoint, :index, order: order))}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        changeset = %{changeset | data: new_data}

        case changeset.errors do
          [user_id: _] ->
            {:noreply,
             assign(socket,
               changeset: changeset
             )}

          [product_items: _] ->
            {:noreply,
             assign(socket,
               changeset: changeset,
               query: Accounts.get_user(changeset.changes.user_id).first_name
             )}

          _ ->
            {:noreply,
             assign(socket,
               changeset: changeset
             )}
        end
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

  # TODO: fix duplicate function
  def category_select_options do
    for category <- Myshop.Products.list_categories(), do: {category.name, category.id}
  end
end
