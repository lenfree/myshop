defmodule MyshopWeb.UploadView do
  use MyshopWeb, :view

  def product_select_options(products) do
    for product <- products, do: {product.name, product.id}
  end
end
