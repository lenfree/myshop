defmodule MyshopWeb.OrderLive.New do
  use Phoenix.LiveView
  alias Myshop.Orders
  alias Myshop.Orders.Order
  alias MyshopWeb.OrderView
  alias Myshop.Accounts
  alias Myshop.Products
  require IEx
  alias Phoenix.HTML.FormData
  alias MyshopWeb.Router.Helpers, as: Routes

  def mount(_session, socket) do
    # changeset = Orders.change_order(%Order{})
    # {:ok, assign(socket, %{changeset: changeset})}
    {:ok,
     assign(socket, %{
       changeset: Orders.change_order(%Order{}),
       query: nil,
       item: nil,
       result: nil,
       loading: false,
       loading_item: false,
       matches: [],
       item_matches: [],
       items: [],
       products: Myshop.Products.list_products(),
       qty: nil,
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

      # ["qty"] ->
      # qty = socket.assigns.item_matches
      # IEx.pry()
      #
      #        changeset =
      #          Map.put(socket.assigns.changeset.data, [:product_items], [
      #            %{product_item_id: qty}
      #          ])
      #
      #   {:noreply, update(socket, :items, fn list -> [{new_item | list] end)}

      _ ->
        {:noreply, assign(socket, matches: [], item_matches: [])}
    end
  end

  def handle_event("place", params, %{assigns: assigns} = socket) do
    #    send(self(), {:search, item})
    # new_state = State.place(assigns.checkout_button, true)
    list_items = socket.assigns.items
    IO.inspect([params | list_items])

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

    # existing_items =  Map.put(assigns.changeset.data, :product_items, [%{product_item_id: [params|}])
    # changeset = Map.put(assigns.changeset.data, :product_items, [%{product_item_id: [params|}])
    {:noreply, assign(socket, checkout_button: true, changeset: changeset)}

    #    {:noreply, assign(socket, query: nil, item: nil, loading: true, matches: [], nil: "....."), checkout: true, checkout_button: true}
  end

  def handle_event("checkout-page", params, %{assigns: assigns} = socket) do
    # send(self(), {:search, assigns})
    # new_state = State.place(assigns.checkout_button, true)
    {:noreply, assign(socket, checkout: true, show_products: false)}

    #    {:noreply, assign(socket, query: nil, item: nil, loading: true, matches: [], nil: "....."), checkout: true, checkout_button: true}
  end

  def handle_event("search", %{"user" => user, "item" => item} = params, socket)
      when byte_size(user) <= 100 do
    IEx.pry()
    #

    send(self(), {:search, item})

    # Map.put(assigns.changeset.data, :product_items, [%{product_item_id: 11}]) |> Myshop.Orders.create_order
    {:noreply, assign(socket, query: user, item: item, loading: true, matches: [], nil: "....."),
     checkout: true}
  end

  def handle_event("search", params, socket) do
    #    send(self(), {:search, item})
    user = Myshop.Accounts.get_user_by_email(params["user"])
    data = Map.put(socket.assigns.changeset.data, :user_id, user.id)

    items =
      params["orders"]["product_items"]
      |> Enum.map(fn {key, val} -> Map.put(val, "product_item_id", key) end)

    items2 =
      Enum.map(items, fn x -> for {key, val} <- x, into: %{}, do: {String.to_atom(key), val} end)

    data2 = Map.put(data, :product_items, items2)

    case Map.from_struct(data2) |> Myshop.Orders.create_order() do
      {:ok, order} ->
        {:stop,
         socket
         |> put_flash(:info, "order created")
         |> redirect(to: Routes.product_path(MyshopWeb.Endpoint, :index, product: nil))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("list-changeset", params, %{assigns: assigns} = socket) do
    IEx.pry()
    #    send(self(), {:search, item})
    {:noreply, assign(socket, query: nil, loading: true, matches: [])}
  end

  #  def handle_event("update_qty", params, %{assigns: assigns} = socket) do
  #    IEx.pry()
  #    #    send(self(), {:search, item})
  #    {:noreply, assign(socket, query: nil, loading: true, matches: [])}
  #  end

  def handle_event("add", params, %{assign: assigns} = socket) do
    item = socket.assigns.item_matches
    new_item = Enum.map(item, &IO.inspect(&1.name))
    new_item_id = Enum.map(item, &IO.inspect(&1.name))
    #    changeset =
    #      Map.put(socket.assigns.changeset.data, [:product_items], [
    #        %{product_item_id: new_item_id}
    #      ])

    a = [new_item | item]
    #    {:noreply, update(socket, :items, fn list -> [new_item | item] end)}
    {:noreply,
     assign(socket,
       item: item,
       loading: true,
       matches: [],
       item_matches: [],
       load_items: true
     )}
  end

  def handle_event("save", params, socket) do
    IEx.pry()
    {:noreply, assign(socket, loading_item: nil)}
    # album_id = String.to_integer(album_id)
    # album = Enum.find(socket.assigns.albums, &(&1.id == album_id))
    # case Recordings.update_album(album, album_params) do
    #  {:ok, _album} ->
    #    {:stop,
    #      socket
    #      |> put_flash(:info, "Album updated successfully")
    #      |> redirect(to: Routes.album_path(socket, :index))}
    #  {:error, changeset} ->
    #    {:noreply, assign(socket, changeset: changeset)}
    # end
  end

  # def handle_info({:changeset, changeset}, socket) do
  #   {:noreply, update(socket, changeset: changeset)}
  # end

  def handle_info({:search, changeset}) do
  end

  def handle_info(params, socket) do
    require IEx
    IEx.pry()

    #    result = Products.get_product!(query)
    result = []
    #    result =
    #      Products.list_products()
    #      |> Enum.map(&IO.inspect(&1.name))
    #    {result, _} = System.cmd("dict", ["#{query}"], stderr_to_stdout: true)
    {:noreply, assign(socket, loading_item: false, result: result, item_matches: [])}
  end

  # move this somewhere else
  def manage_items(%{"item" => item}) do
    Products.search_product_by_name(item)
  end

  def manage_users(%{"user" => user}) do
    Accounts.search_user_by_name(user)
  end
end
