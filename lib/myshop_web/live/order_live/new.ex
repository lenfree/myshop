defmodule MyshopWeb.OrderLive.New do
  use Phoenix.LiveView
  alias Myshop.Orders
  alias Myshop.Orders.Order
  alias MyshopWeb.OrderView
  alias Myshop.Accounts
  alias Myshop.Products

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
       items: []
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

  def handle_event("search", %{"user" => user, "item" => item}, socket)
      when byte_size(user) <= 100 do
    # TODO: clean this up, atm I want to leave it for future reference
    send(self(), {:search, item})
    # {:noreply, assign(socket, query: user, result: "…", loading: true, matches: [])}
    {:noreply, assign(socket, query: user, item: item, loading: true, matches: [], nil: ".....")}
  end

  def handle_event("add", _, socket) do
    require IEx
    item = socket.assigns.item_matches
    new_item = Enum.map(item, &IO.inspect(&1.name))
    {:noreply, update(socket, :items, fn list -> [new_item | list] end)}
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
