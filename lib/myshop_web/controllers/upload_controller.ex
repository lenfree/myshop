defmodule MyshopWeb.UploadController do
  use MyshopWeb, :controller
  alias Myshop.Products
  alias Myshop.Products.Upload

  plug :load_products when action in [:new, :create, :edit, :update]

  defp load_products(conn, _) do
    assign(conn, :products, Products.list_products())
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Products.change_upload(%Upload{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"upload" => %Plug.Upload{} = upload, "product_id" => product_id}) do
    case Products.create_upload_from_plug_upload(upload, product_id) do
      {:ok, upload} ->
        put_flash(conn, :info, "file uploaded correctly")
        |> redirect(to: Routes.product_path(conn, :show, upload.product_id))

      {:error, reason} ->
        put_flash(conn, :error, "error upload file: #{inspect(reason)}")
        render(conn, "new.html")
    end
  end

  def index(conn, _params) do
    uploads = Products.list_uploads()
    render(conn, "index.html", uploads: uploads)
  end

  def show(conn, %{"id" => id}) do
    upload = Products.get_upload!(id)
    render(conn, "show.html", upload: upload)
  end

  def edit(conn, %{"id" => id}) do
    upload = Products.get_upload!(id)
    changeset = Products.change_upload(upload)
    render(conn, "edit.html", upload: upload, changeset: changeset)
  end

  def update(conn, %{"id" => id, "upload" => product_params}) do
    upload = Products.get_upload!(id)

    case Products.update_upload(upload, product_params) do
      {:ok, upload} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: Routes.upload_path(conn, :show, upload))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", product: upload, changeset: changeset)
    end
  end

  def thumbnail(conn, %{"upload_id" => id}) do
    thumb_path = Products.thumbnail_path(id)

    conn
    |> put_resp_content_type("image/jpeg")
    |> send_file(200, thumb_path)
  end
end
