defmodule MyshopWeb.ProductController do
  use MyshopWeb, :controller

  alias Myshop.Products
  alias Myshop.Products.Product
  alias Myshop.Products.Upload

  alias MyshopWeb.Router.Helpers, as: Routes
  #  plug :authenticate_user when action in [:index, :show]
  plug :load_categories when action in [:new, :create, :edit, :update]

  def index(conn, _params) do
    products = Products.list_products()
    render(conn, "index.html", products: products)
  end

  def new(conn, _params) do
    upload = Products.change_upload(%Products.Upload{})
    changeset = Products.change_product(%Product{upload: [upload]})
    IO.inspect(changeset.data)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params = %{"product" => product_params}) do
    with {:ok, product} <- create_product(product_params),
         {:ok, upload} <- upload_product_thumbnails(product_params, product.id) do
      conn
      |> put_flash(:info, "Product created successfully.")
      |> redirect(to: Routes.product_path(conn, :show, product.id))
    else
      {:error, changeset} ->
        require IEx

        changeset = changeset |> Ecto.Changeset.cast_assoc(:upload)

        conn
        |> put_flash(:error, "error upload file: #{inspect(changeset)}")
        |> render("new.html", changeset: changeset)
    end
  end

  def create_product(product_params) do
    Products.create_product(product_params)
  end

  def upload_product_thumbnails(%{"upload" => uploads}, product_id) do
    files =
      Enum.map(
        uploads,
        fn {_, y} -> y end
      )
      |> Enum.map(&upload_product_thumbnail(&1, product_id))
      |> List.first()
  end

  def upload_product_thumbnail(%{"upload" => %Plug.Upload{} = upload}, product_id) do
    Products.create_upload_from_plug_upload(upload, product_id)
  end

  def show(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    render(conn, "show.html", product: product)
  end

  def edit(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    changeset = Products.change_product(product)
    render(conn, "edit.html", product: product, changeset: changeset)
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    product = Products.get_product!(id)

    case Products.update_product(product, product_params) do
      {:ok, product} ->
        conn
        |> put_flash(:info, "Product updated successfully.")
        |> redirect(to: Routes.product_path(conn, :show, product))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: product, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Products.get_product!(id)
    {:ok, _product} = Products.delete_product(product)

    conn
    |> put_flash(:info, "Product deleted successfully.")
    |> redirect(to: Routes.product_path(conn, :index))
  end

  defp load_categories(conn, _) do
    assign(conn, :categories, Products.list_categories())
  end
end
