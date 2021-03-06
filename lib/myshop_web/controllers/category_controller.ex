defmodule MyshopWeb.CategoryController do
  use MyshopWeb, :controller

  alias Myshop.Products
  alias Myshop.Products.Category
  alias MyshopWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    categories = Products.list_categories()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Products.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case Products.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Products.get_category!(id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Products.get_category!(id)
    changeset = Products.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Products.get_category!(id)

    case Products.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Products.get_category!(id)
    {:ok, _category} = Products.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end
end
