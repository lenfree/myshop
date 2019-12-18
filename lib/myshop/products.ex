defmodule Myshop.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Myshop.Repo
  alias Myshop.Products.{Product, Category, Upload}

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Product
    |> order_by(asc: :name)
    |> Repo.all()
    |> Repo.preload(:category)
    |> Repo.preload(:upload)
  end

  def list_products(category_id) when category_id == "" do
    from(p in Product,
      order_by: p.name,
      preload: [:category, :upload]
    )
    |> Repo.all()
  end

  def list_products(category_id) do
    from(p in Product,
      where: p.category_id == ^category_id,
      order_by: p.name,
      preload: [:category, :upload]
    )
    |> Repo.all()
  end

  def list_asc_products do
    # TODO: create an interface for join or complicated queries
    query =
      from q in Product,
        order_by: [asc: q.name]

    Repo.all(query)
  end

  def search_product_by_name(param) do
    query =
      from p in Product,
        where: like(p.name, ^"%#{param}%")

    Repo.all(query)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_by_name!(name) do
    Repo.get!(Product, name) |> Repo.preload(:category)
  end

  def get_product!(id) do
    Repo.get!(Product, id)
    |> Repo.preload(:category)
    |> Repo.preload(:upload)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    # this is to remind how to update attribute in the future
    # attrs = Map.update(attrs, "price", nil, &to_cents/1)

    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  # this is to remind how to update attribute in the future
  # def to_cents(value) do
  #  Decimal.div(Decimal.new(value), Decimal.new(100))
  # end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product, params) do
    Product.changeset(product, params)
  end

  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end

  alias Myshop.Products.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Category
    |> Category.alphabetical()
    |> Repo.all()
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  def to_price(value) do
    Decimal.mult(Decimal.new(value), Decimal.new(100)) |> Decimal.round(2)
  end

  # Uploads

  def create_upload_from_plug_upload(
        %Plug.Upload{
          filename: filename,
          path: tmp_path,
          content_type: content_type
        },
        product_id
      ) do
    hash =
      File.stream!(tmp_path, [], 2048)
      |> sha256()

    with {:ok, %File.Stat{size: size}} <- File.stat(tmp_path),
         {:ok, upload} <-
           %Upload{}
           |> Upload.changeset(%{
             filename: "#{filename}_#{Ecto.UUID.generate()}",
             content_type: content_type,
             hash: hash,
             size: size,
             product_id: product_id
           })
           |> Repo.insert(),
         :ok <-
           File.cp(
             tmp_path,
             local_path(upload)
           ),
         {:ok, upload} <- create_thumbnail(upload) do
      {:ok, upload}
    end
  end

  def list_uploads do
    Repo.all(Upload)
    |> Repo.preload(:product)
  end

  def delete_uploads(upload = %Upload{}) do
    Repo.delete(upload)
  end

  def get_upload!(id) do
    Repo.get!(Upload, id) |> Repo.preload(:product)
  end

  def change_upload(%Upload{} = upload) do
    Upload.changeset(upload, %{})
  end

  def update_upload(%Upload{} = upload, attrs) do
    upload
    |> Upload.changeset(attrs)
    |> Repo.update()
  end

  def create_thumbnail(%Upload{} = upload) do
    original_path = local_path(upload)
    thumb_path = thumbnail_path(upload)
    _result = mogrify_thumbnail(original_path, thumb_path)
    # Investigate how to catch failure!
    {:ok, upload}
  end

  @upload_directory Application.get_env(:myshop, :uploads_directory)

  def local_path(%{id: id, filename: filename}) do
    [@upload_directory, "#{id}-#{filename}"]
    |> Path.join()
  end

  def create_local_path_directory(path, %{id: id, filename: filename}) do
    File.mkdir("#{path}/#{id}-#{filename}")
  end

  def thumbnail_path(%{id: id}) do
    [@upload_directory, "thumb-#{id}.jpg"]
    |> Path.join()
  end

  def thumbnail_path(id) do
    [@upload_directory, "thumb-#{id}.jpg"]
    |> Path.join()
  end

  def sha256(chunks_enum) do
    chunks_enum
    |> Enum.reduce(
      :crypto.hash_init(:sha256),
      &:crypto.hash_update(&2, &1)
    )
    |> :crypto.hash_final()
    |> Base.encode16()
    |> String.downcase()
  end

  def mogrify_thumbnail(src, dst) do
    Mogrify.open(src)
    |> Mogrify.resize_to_limit("200x200")
    |> Mogrify.save(path: dst)
  end
end
